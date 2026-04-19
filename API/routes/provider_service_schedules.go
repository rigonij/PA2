package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
)

func ProviderServiceSchedules(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}

		idStr := strings.TrimPrefix(r.URL.Path, "/api/provider/service-schedules/")
		idStr = strings.Trim(idStr, "/")
		serviceTypeID, err := strconv.Atoi(idStr)
		if err != nil || serviceTypeID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID service invalide"})
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

			schedules := []map[string]any{}
			for rows.Next() {
				var id, dow int
				var start, end string
				if err := rows.Scan(&id, &dow, &start, &end); err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
				schedules = append(schedules, map[string]any{
					"id":          id,
					"day_of_week": dow,
					"start_time":  start,
					"end_time":    end,
				})
			}

			rows2, err := database.Query(`
				SELECT Id_SCHEDULE
				FROM provider_service_schedule
				WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
			`, providerID, serviceTypeID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows2.Close()

			selected := []int{}
			for rows2.Next() {
				var sid int
				if err := rows2.Scan(&sid); err == nil {
					selected = append(selected, sid)
				}
			}

			_ = json.NewEncoder(w).Encode(map[string]any{
				"success":      true,
				"schedules":    schedules,
				"selected_ids": selected,
			})
			return

		case http.MethodPut:
			var req struct {
				ScheduleIDs []int `json:"schedule_ids"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
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
				WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
			`, providerID, serviceTypeID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			for _, sid := range req.ScheduleIDs {
				if sid <= 0 {
					continue
				}

				var exists int
				err = tx.QueryRow(`
					SELECT COUNT(*) FROM provider_schedule
					WHERE Id_SCHEDULE = ? AND Id_USER = ?
				`, sid, providerID).Scan(&exists)
				if err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
				if exists == 0 {
					w.WriteHeader(http.StatusForbidden)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Créneau invalide"})
					return
				}

				_, err = tx.Exec(`
					INSERT INTO provider_service_schedule (Id_USER, Id_SERVICE_TYPE, Id_SCHEDULE)
					VALUES (?, ?, ?)
				`, providerID, serviceTypeID, sid)
				if err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
			}

			if err := tx.Commit(); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Horaires mis à jour"})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
	}
}
