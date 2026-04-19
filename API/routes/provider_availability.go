package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/PA_2i2/api/lib"
)

func requireProviderValidated(database *sql.DB, w http.ResponseWriter, r *http.Request) (int, bool) {
	token := r.Header.Get("X-Token")
	userID, err := lib.GetUserIDFromToken(database, token)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
		return 0, false
	}

	var status int
	err = database.QueryRow(`SELECT Validation_Status FROM provider WHERE Id_USER = ? LIMIT 1`, userID).Scan(&status)
	if err == sql.ErrNoRows {
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé – prestataire requis"})
		return 0, false
	}
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
		return 0, false
	}
	if status != 1 {
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Compte prestataire non validé"})
		return 0, false
	}

	return userID, true
}

func ProviderSchedule(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		providerID, ok := requireProviderValidated(database, w, r)
		if !ok {
			return
		}

		switch r.Method {

		case http.MethodGet:
			rows, err := database.Query(`
				SELECT Id_SCHEDULE, Day_Of_Week, Start_Time, End_Time
				FROM provider_schedule
				WHERE Id_USER = ?
				ORDER BY Day_Of_Week ASC, Start_Time ASC
			`, providerID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()

			items := []map[string]any{}
			for rows.Next() {
				var id int
				var dow int
				var start, end string
				if err := rows.Scan(&id, &dow, &start, &end); err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
				items = append(items, map[string]any{
					"id":          id,
					"day_of_week": dow,
					"start_time":  start,
					"end_time":    end,
				})
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
			return

		case http.MethodPost:
			var req struct {
				DayOfWeek int    `json:"day_of_week"`
				StartTime string `json:"start_time"`
				EndTime   string `json:"end_time"`
			}

			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
				return
			}

			if req.DayOfWeek < 1 || req.DayOfWeek > 7 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Jour invalide (1-7)"})
				return
			}

			startT, err := time.Parse("15:04", req.StartTime)
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "start_time invalide (HH:MM)"})
				return
			}

			endT, err := time.Parse("15:04", req.EndTime)
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "end_time invalide (HH:MM)"})
				return
			}

			if !endT.After(startT) {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "La fin doit être après le début"})
				return
			}

			startDB := req.StartTime + ":00"
			endDB := req.EndTime + ":00"

			var exists int
			err = database.QueryRow(`
				SELECT COUNT(*)
				FROM provider_schedule
				WHERE Id_USER = ?
				  AND Day_Of_Week = ?
				  AND Start_Time = ?
				  AND End_Time = ?
			`, providerID, req.DayOfWeek, startDB, endDB).Scan(&exists)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			if exists > 0 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Créneau déjà existant"})
				return
			}

			_, err = database.Exec(`
				INSERT INTO provider_schedule (Day_Of_Week, Start_Time, End_Time, Id_USER)
				VALUES (?, ?, ?, ?)
			`, req.DayOfWeek, startDB, endDB, providerID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Créneau ajouté"})
			return

		case http.MethodDelete:
			idStr := strings.TrimPrefix(r.URL.Path, "/api/provider/schedule/")
			idStr = strings.Trim(idStr, "/")

			id, err := strconv.Atoi(idStr)
			if err != nil || id <= 0 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
				return
			}

			tx, err := database.Begin()
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
				return
			}
			defer tx.Rollback()

			_, err = tx.Exec(`
				DELETE FROM provider_service_schedule
				WHERE Id_USER = ? AND Id_SCHEDULE = ?
			`, providerID, id)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			res, err := tx.Exec(`
				DELETE FROM provider_schedule
				WHERE Id_SCHEDULE = ? AND Id_USER = ?
			`, id, providerID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			aff, _ := res.RowsAffected()
			if aff == 0 {
				w.WriteHeader(http.StatusNotFound)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Créneau introuvable"})
				return
			}

			if err := tx.Commit(); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Créneau supprimé"})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
	}
}

func ProviderAbsence(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		providerID, ok := requireProviderValidated(database, w, r)
		if !ok {
			return
		}

		switch r.Method {

		case http.MethodGet:
			rows, err := database.Query(`
				SELECT Id_PROVIDER_ABSENCE, Start_DateTime, End_DateTime
				FROM provider_absence
				WHERE Id_USER = ?
				ORDER BY Start_DateTime DESC
			`, providerID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()

			items := []map[string]any{}
			for rows.Next() {
				var id int
				var start, end string
				if err := rows.Scan(&id, &start, &end); err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
				items = append(items, map[string]any{
					"id":             id,
					"start_datetime": start,
					"end_datetime":   end,
				})
			}

			json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
			return

		case http.MethodPost:
			var req struct {
				StartDateTime string `json:"start_datetime"`
				EndDateTime   string `json:"end_datetime"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
				return
			}

			start, err1 := time.Parse("2006-01-02T15:04", req.StartDateTime)
			end, err2 := time.Parse("2006-01-02T15:04", req.EndDateTime)
			if err1 != nil || err2 != nil {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Format datetime invalide"})
				return
			}
			if !end.After(start) {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "La fin doit être après le début"})
				return
			}

			now := time.Now()
			if start.Before(now) {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{
					"success": false,
					"message": "Impossible d'ajouter une absence dans le passé",
				})
				return
			}

			_, err := database.Exec(`
				INSERT INTO provider_absence (Start_DateTime, End_DateTime, Id_USER)
				VALUES (?, ?, ?)
			`, start.Format("2006-01-02 15:04:05"), end.Format("2006-01-02 15:04:05"), providerID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Absence ajoutée"})
			return

		case http.MethodDelete:
			idStr := strings.TrimPrefix(r.URL.Path, "/api/provider/absence/")
			idStr = strings.Trim(idStr, "/")
			id, err := strconv.Atoi(idStr)
			if err != nil || id <= 0 {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
				return
			}

			res, err := database.Exec(`
				DELETE FROM provider_absence
				WHERE Id_PROVIDER_ABSENCE = ? AND Id_USER = ?
			`, id, providerID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			aff, _ := res.RowsAffected()
			if aff == 0 {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Absence introuvable"})
				return
			}

			json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Absence supprimée"})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}
}
