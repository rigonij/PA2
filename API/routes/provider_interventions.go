package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

func GetProviderInterventions(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
            SELECT
                i.Id_INTERVENTION,
                i.Date_Start,
                i.Date_End,
                i.Status,
                COALESCE(i.Senior_Comment, '')  AS senior_comment,
                i.Admin_Approved,
                i.Provider_Approved,
                COALESCE(st.Name, '')           AS service_name,
                COALESCE(u.Nom, '')             AS senior_nom,
                COALESCE(u.Prenom, '')          AS senior_prenom
            FROM intervention i
            LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            LEFT JOIN user u ON u.Id_USER = i.Id_SENIOR
            WHERE i.Id_PROVIDER = ?
            ORDER BY i.Date_Start DESC
        `, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL"})
			return
		}
		defer rows.Close()

		items := []map[string]any{}

		for rows.Next() {
			var id, adminApproved, providerApproved int
			var status, comment, serviceName, seniorNom, seniorPrenom string
			var dateStart, dateEnd time.Time

			if err := rows.Scan(
				&id, &dateStart, &dateEnd, &status, &comment,
				&adminApproved, &providerApproved,
				&serviceName, &seniorNom, &seniorPrenom,
			); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture"})
				return
			}

			items = append(items, map[string]any{
				"id":                id,
				"date_start":        dateStart.In(time.Local).Format("2006-01-02 15:04"),
				"date_end":          dateEnd.In(time.Local).Format("2006-01-02 15:04"),
				"status":            status,
				"comment":           comment,
				"admin_approved":    adminApproved,
				"provider_approved": providerApproved,
				"service_name":      serviceName,
				"senior_nom":        seniorNom,
				"senior_prenom":     seniorPrenom,
			})
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "interventions": items})
	}
}

type providerApproveReq struct {
	InterventionID int  `json:"intervention_id"`
	Approved       bool `json:"approved"`
}

func ApproveIntervention(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req providerApproveReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.InterventionID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "intervention_id invalide"})
			return
		}

		var count int
		err = database.QueryRow(
			`SELECT COUNT(*) FROM intervention WHERE Id_INTERVENTION = ? AND Id_PROVIDER = ?`,
			req.InterventionID, userID,
		).Scan(&count)
		if err != nil || count == 0 {
			w.WriteHeader(http.StatusForbidden)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Intervention introuvable"})
			return
		}

		providerApproved := 0
		if req.Approved {
			providerApproved = 1
		}

		_, err = database.Exec(
			`UPDATE intervention SET Provider_Approved = ? WHERE Id_INTERVENTION = ? AND Id_PROVIDER = ?`,
			providerApproved, req.InterventionID, userID,
		)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur mise à jour"})
			return
		}

		if !req.Approved {
			_, _ = database.Exec(
				`UPDATE intervention SET Status = 'Refused' WHERE Id_INTERVENTION = ?`,
				req.InterventionID,
			)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
			return
		}

		var adminApproved int
		_ = database.QueryRow(
			`SELECT Admin_Approved FROM intervention WHERE Id_INTERVENTION = ?`,
			req.InterventionID,
		).Scan(&adminApproved)

		if adminApproved == 1 {
			_, _ = database.Exec(
				`UPDATE intervention SET Status = 'Accepted' WHERE Id_INTERVENTION = ?`,
				req.InterventionID,
			)
		}

		var seniorID int
		_ = database.QueryRow(
			`SELECT Id_SENIOR FROM intervention WHERE Id_INTERVENTION = ?`,
			req.InterventionID,
		).Scan(&seniorID)

		if req.Approved {
			SendMessageInternal(database, userID, seniorID,
				"Votre réservation a été acceptée par le prestataire.")
		} else {
			SendMessageInternal(database, userID, seniorID,
				"Votre réservation a été refusée par le prestataire.")
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func AdminApproveIntervention(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req providerApproveReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.InterventionID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "intervention_id invalide"})
			return
		}

		adminApproved := 0
		if req.Approved {
			adminApproved = 1
		}

		_, _ = database.Exec(
			`UPDATE intervention SET Admin_Approved = ? WHERE Id_INTERVENTION = ?`,
			adminApproved, req.InterventionID,
		)

		if !req.Approved {
			_, _ = database.Exec(
				`UPDATE intervention SET Status = 'Refused' WHERE Id_INTERVENTION = ?`,
				req.InterventionID,
			)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
			return
		}

		var providerApproved int
		_ = database.QueryRow(
			`SELECT Provider_Approved FROM intervention WHERE Id_INTERVENTION = ?`,
			req.InterventionID,
		).Scan(&providerApproved)

		if providerApproved == 1 {
			_, _ = database.Exec(
				`UPDATE intervention SET Status = 'Accepted' WHERE Id_INTERVENTION = ?`,
				req.InterventionID,
			)
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func GetAllInterventions(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
            SELECT
                i.Id_INTERVENTION, i.Date_Start, i.Date_End, i.Status,
                COALESCE(i.Senior_Comment, ''), i.Admin_Approved, i.Provider_Approved,
                COALESCE(st.Name, ''), COALESCE(u.Nom, ''), COALESCE(u.Prenom, ''),
                COALESCE(p.Company_Name, '')
            FROM intervention i
            LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            LEFT JOIN user u ON u.Id_USER = i.Id_SENIOR
            LEFT JOIN provider p ON p.Id_USER = i.Id_PROVIDER
            ORDER BY i.Date_Start DESC
        `)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL"})
			return
		}
		defer rows.Close()

		items := []map[string]any{}
		for rows.Next() {
			var id, adminApproved, providerApproved int
			var status, comment, serviceName, seniorNom, seniorPrenom, companyName string
			var dateStart, dateEnd time.Time

			if err := rows.Scan(&id, &dateStart, &dateEnd, &status, &comment,
				&adminApproved, &providerApproved, &serviceName, &seniorNom, &seniorPrenom, &companyName,
			); err != nil {
				continue
			}

			items = append(items, map[string]any{
				"id":                id,
				"date_start":        dateStart.In(time.Local).Format("2006-01-02 15:04"),
				"date_end":          dateEnd.In(time.Local).Format("2006-01-02 15:04"),
				"status":            status,
				"comment":           comment,
				"admin_approved":    adminApproved,
				"provider_approved": providerApproved,
				"service_name":      serviceName,
				"senior_nom":        seniorNom,
				"senior_prenom":     seniorPrenom,
				"company_name":      companyName,
			})
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "interventions": items})
	}
}
