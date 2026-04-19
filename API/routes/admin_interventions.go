package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"
)

type AdminInterventionStatusReq struct {
	InterventionID int    `json:"intervention_id"`
	Status         string `json:"status"`
}

func isValidInterventionStatus(s string) bool {
	return s == "Pending" || s == "Confirmed" || s == "Canceled"
}

func GetAdminInterventions(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		if !requireAdmin(database, w, r) {
			return
		}

		rows, err := database.Query(`
			SELECT
				i.Id_INTERVENTION,
				i.Date_Start,
				i.Date_End,
				i.Status,
				i.Id_PROVIDER,
				COALESCE(p.Company_Name,''),
				i.Id_SENIOR,
				st.Id_SERVICE_TYPE,
				COALESCE(st.Name,'')
			FROM intervention i
			JOIN provider p ON p.Id_USER = i.Id_PROVIDER
			JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
			ORDER BY i.Date_Start DESC
			LIMIT 300
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()

		pending := []map[string]any{}
		confirmed := []map[string]any{}
		canceled := []map[string]any{}

		for rows.Next() {
			var id int
			var start, end time.Time
			var status string
			var providerID int
			var companyName string
			var seniorID int
			var serviceTypeID int
			var serviceName string

			if err := rows.Scan(&id, &start, &end, &status, &providerID, &companyName, &seniorID, &serviceTypeID, &serviceName); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}

			item := map[string]any{
				"id":              id,
				"status":          status,
				"provider_id":     providerID,
				"company_name":    companyName,
				"senior_id":       seniorID,
				"service_type_id": serviceTypeID,
				"service_name":    serviceName,
				"start_at":        start.In(time.Local).Format("2006-01-02 15:04"),
				"end_at":          end.In(time.Local).Format("2006-01-02 15:04"),
			}

			switch status {
			case "Confirmed", "Accepted":
				confirmed = append(confirmed, item)
			case "Canceled", "Refused":
				canceled = append(canceled, item)
			default:
				pending = append(pending, item)
			}
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":   true,
			"pending":   pending,
			"confirmed": confirmed,
			"canceled":  canceled,
		})
	}
}

func UpdateAdminInterventionStatus(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		var req AdminInterventionStatusReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.InterventionID <= 0 || !isValidInterventionStatus(req.Status) {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		_, err := database.Exec(`UPDATE intervention SET Status = ? WHERE Id_INTERVENTION = ?`, req.Status, req.InterventionID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur update: " + err.Error()})
			return
		}

		if req.Status == "Confirmed" {
			_, _ = database.Exec(`UPDATE intervention SET Admin_Approved = 1 WHERE Id_INTERVENTION = ?`, req.InterventionID)

			var providerApproved int
			_ = database.QueryRow(`SELECT Provider_Approved FROM intervention WHERE Id_INTERVENTION = ?`, req.InterventionID).Scan(&providerApproved)
			if providerApproved == 1 {
				_, _ = database.Exec(`UPDATE intervention SET Status = 'Accepted' WHERE Id_INTERVENTION = ?`, req.InterventionID)
			}
		} else if req.Status == "Canceled" {
			_, _ = database.Exec(`UPDATE intervention SET Admin_Approved = 0 WHERE Id_INTERVENTION = ?`, req.InterventionID)
			_, _ = database.Exec(`DELETE FROM planning_item WHERE Item_Type='service' AND Ref_ID = ?`, req.InterventionID)
		}

		var seniorID int
		_ = database.QueryRow(
			`SELECT Id_SENIOR FROM intervention WHERE Id_INTERVENTION = ?`,
			req.InterventionID,
		).Scan(&seniorID)

		if req.Status == "Confirmed" {
			SendMessageInternal(database, 1, seniorID,
				"Votre réservation a été confirmée par l'administration.")
		} else if req.Status == "Canceled" {
			SendMessageInternal(database, 1, seniorID,
				"Votre réservation a été annulée par l'administration.")
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
