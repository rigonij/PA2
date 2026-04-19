package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

func GetProviderPlanning(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var validationStatus int
		err = database.QueryRow(`SELECT Validation_Status FROM provider WHERE Id_USER = ? LIMIT 1`, userID).Scan(&validationStatus)
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé – prestataire requis"})
			return
		}
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
			return
		}

		if validationStatus != 1 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Compte prestataire non validé"})
			return
		}

		rows, err := database.Query(`
			SELECT i.Id_INTERVENTION,
			       COALESCE(CAST(i.Date_Start AS CHAR), ''),
			       COALESCE(CAST(i.Date_End AS CHAR), ''),
			       COALESCE(i.Status,''),
			       COALESCE(i.Senior_Comment,''),
			       COALESCE(st.Name,''),
			       COALESCE(u.Email,''),
			       COALESCE(u.Address_City,'')
			FROM intervention i
			LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
			LEFT JOIN user u ON u.Id_USER = i.Id_SENIOR
			WHERE i.Id_PROVIDER = ?
			ORDER BY i.Date_Start DESC
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		items := []map[string]any{}

		for rows.Next() {
			var id int
			var startStr, endStr, status, comment, serviceName, seniorEmail, city string

			if err := rows.Scan(&id, &startStr, &endStr, &status, &comment, &serviceName, &seniorEmail, &city); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			startPretty := startStr
			if t, err := time.Parse("2006-01-02 15:04:05", startStr); err == nil {
				startPretty = t.Format("2006-01-02 15:04")
			}

			items = append(items, map[string]any{
				"id":           id,
				"start_at":     startStr,
				"end_at":       endStr,
				"start_pretty": startPretty,
				"status":       status,
				"comment":      comment,
				"service_name": serviceName,
				"senior_email": seniorEmail,
				"city":         city,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
	}
}
