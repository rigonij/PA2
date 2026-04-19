package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

type ReserveServiceRequest struct {
	ServiceTypeID int    `json:"service_type_id"`
	ProviderID    int    `json:"provider_id"`
	StartAt       string `json:"start_at"`
	Comment       string `json:"comment"`
}

func ReserveService(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		jsonError := func(status int, msg string) {
			w.WriteHeader(status)
			_ = json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": msg,
			})
		}

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			jsonError(http.StatusUnauthorized, "Non authentifié")
			return
		}

		var req ReserveServiceRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			jsonError(http.StatusBadRequest, "Body invalide")
			return
		}

		if req.ServiceTypeID <= 0 || req.ProviderID <= 0 || req.StartAt == "" {
			jsonError(http.StatusBadRequest, "Champs manquants")
			return
		}

		start, err := time.Parse(time.RFC3339, req.StartAt)
		if err != nil {
			start, err = time.ParseInLocation("2006-01-02T15:04", req.StartAt, time.Local)
			if err != nil {
				jsonError(http.StatusBadRequest, "Date invalide")
				return
			}
		}

		if start.Before(time.Now()) {
			jsonError(http.StatusBadRequest, "Date passée interdite")
			return
		}

		var durationMin int
		err = database.QueryRow(`
			SELECT COALESCE(Slot_Duration_Min, 0)
			FROM qualify
			WHERE Id_USER = ?
			  AND Id_SERVICE_TYPE = ?
			LIMIT 1
		`, req.ProviderID, req.ServiceTypeID).Scan(&durationMin)
		if err != nil || durationMin <= 0 {
			jsonError(http.StatusBadRequest, "Durée service introuvable")
			return
		}

		end := start.Add(time.Duration(durationMin) * time.Minute)

		row := database.QueryRow(`
			SELECT st.Name, p.Company_Name
			FROM qualify q
			JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
			JOIN provider p ON p.Id_USER = q.Id_USER
			WHERE q.Id_SERVICE_TYPE = ?
			  AND q.Id_USER = ?
			  AND p.Validation_Status = 1
			  AND COALESCE(q.Is_Active, 1) = 1
			  AND COALESCE(q.Validation_Status, 0) = 1
			LIMIT 1
		`, req.ServiceTypeID, req.ProviderID)

		var serviceName, companyName string
		if err := row.Scan(&serviceName, &companyName); err != nil {
			jsonError(http.StatusBadRequest, "Service/prestataire invalide")
			return
		}

		dow := int(start.Weekday())
		if dow == 0 {
			dow = 7
		}

		var allowedCount int
		err = database.QueryRow(`
			SELECT COUNT(*)
			FROM provider_service_schedule pss
			JOIN provider_schedule ps ON ps.Id_SCHEDULE = pss.Id_SCHEDULE
			WHERE pss.Id_USER = ?
			  AND pss.Id_SERVICE_TYPE = ?
			  AND ps.Day_Of_Week = ?
			  AND ps.Start_Time <= TIME(?)
			  AND ps.End_Time >= TIME(?)
		`, req.ProviderID, req.ServiceTypeID, dow, start, end).Scan(&allowedCount)

		if err != nil {
			jsonError(http.StatusInternalServerError, "Erreur serveur (vérif créneau)")
			return
		}
		if allowedCount == 0 {
			jsonError(http.StatusForbidden, "Créneau non autorisé pour ce service")
			return
		}

		var absenceCount int
		err = database.QueryRow(`
			SELECT COUNT(*)
			FROM provider_absence
			WHERE Id_USER = ?
			  AND Start_DateTime < ?
			  AND End_DateTime > ?
		`, req.ProviderID, end, start).Scan(&absenceCount)

		if err != nil {
			jsonError(http.StatusInternalServerError, "Erreur serveur (vérif absence)")
			return
		}
		if absenceCount > 0 {
			jsonError(http.StatusForbidden, "Prestataire absent sur ce créneau")
			return
		}

		var conflictCount int
		err = database.QueryRow(`
			SELECT COUNT(*)
			FROM intervention
			WHERE Id_PROVIDER = ?
			  AND Status <> 'Canceled'
			  AND Date_Start < ?
			  AND Date_End > ?
		`, req.ProviderID, end, start).Scan(&conflictCount)

		if err != nil {
			jsonError(http.StatusInternalServerError, "Erreur serveur (vérif conflit)")
			return
		}
		if conflictCount > 0 {
			jsonError(http.StatusConflict, "Créneau déjà réservé")
			return
		}

		res, err := database.Exec(`
			INSERT INTO intervention (Date_Start, Date_End, Status, Senior_Comment, Id_SERVICE_TYPE, Id_PROVIDER, Id_SENIOR)
			VALUES (?, ?, 'Pending', ?, ?, ?, ?)
		`, start, end, req.Comment, req.ServiceTypeID, req.ProviderID, userID)

		if err != nil {
			jsonError(http.StatusInternalServerError, "Erreur serveur (création réservation)")
			return
		}

		newID64, _ := res.LastInsertId()
		newID := int(newID64)

		title := serviceName + " — " + companyName
		_, err = database.Exec(`
			INSERT INTO planning_item (Id_USER, Item_Type, Ref_ID, Title, Start_At, Location, Details)
			VALUES (?, 'service', ?, ?, ?, 'À domicile', ?)
		`, userID, newID, title, start, req.Comment)

		if err != nil {
			jsonError(http.StatusInternalServerError, "Erreur serveur (création planning)")
			return
		}

		seniorName := "Un senior"
		_ = database.QueryRow(`SELECT CONCAT(First_Name,' ',Last_Name) FROM user WHERE Id_USER = ? LIMIT 1`, userID).Scan(&seniorName)
		SendMessageInternal(database, userID, req.ProviderID,
			"Nouvelle réservation de "+seniorName+" pour "+title+" le "+start.Format("02/01/2006 à 15h04")+".")

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":         true,
			"message":         "Réservation créée",
			"intervention_id": newID,
		})
	}
}

type UnreserveServiceRequest struct {
	InterventionID int `json:"intervention_id"`
}

func UnreserveService(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req UnreserveServiceRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.InterventionID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "intervention_id invalide"})
			return
		}

		_, _ = database.Exec(
			`UPDATE intervention
				SET Status = 'Canceled'
				WHERE Id_INTERVENTION = ? AND Id_SENIOR = ?`,
			req.InterventionID,
			userID,
		)
		_, _ = database.Exec(
			`DELETE FROM planning_item
     			WHERE Id_USER = ? AND Item_Type = 'service' AND Ref_ID = ?`,
			userID,
			req.InterventionID,
		)

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"message": "Réservation annulée",
		})
	}
}
