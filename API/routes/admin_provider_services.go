package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
)

func AdminProviderServices(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		switch r.Method {

		case http.MethodGet:
			rows, err := database.Query(`
				SELECT
					q.Id_USER,
					COALESCE(p.Company_Name,''),
					q.Id_SERVICE_TYPE,
					COALESCE(st.Name,''),
					COALESCE(q.Custom_Title,''),
					COALESCE(q.Negotiated_Price, 0),
					COALESCE(q.Experience_Years, 0),
					COALESCE(q.Is_Active, 1),
					COALESCE(q.Validation_Status, 0)
				FROM qualify q
				JOIN provider p ON p.Id_USER = q.Id_USER
				JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
				ORDER BY q.Validation_Status ASC, p.Company_Name ASC, st.Name ASC
			`)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()

			items := []map[string]any{}
			for rows.Next() {
				var providerID, serviceTypeID, exp, isActive, vstatus int
				var company, serviceName, customTitle string
				var price float64

				if err := rows.Scan(
					&providerID,
					&company,
					&serviceTypeID,
					&serviceName,
					&customTitle,
					&price,
					&exp,
					&isActive,
					&vstatus,
				); err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}

				items = append(items, map[string]any{
					"provider_id":       providerID,
					"company_name":      company,
					"service_type_id":   serviceTypeID,
					"service_name":      serviceName,
					"custom_title":      customTitle,
					"negotiated_price":  price,
					"experience_years":  exp,
					"is_active":         isActive == 1,
					"validation_status": vstatus,
				})
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
			return

		case http.MethodPut:
			var req struct {
				ProviderID    int `json:"provider_id"`
				ServiceTypeID int `json:"service_type_id"`
				Status        int `json:"status"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
				return
			}
			if req.ProviderID <= 0 || req.ServiceTypeID <= 0 || (req.Status != 0 && req.Status != 1 && req.Status != 2) {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
				return
			}

			res, err := database.Exec(`
				UPDATE qualify
				SET Validation_Status = ?
				WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
			`, req.Status, req.ProviderID, req.ServiceTypeID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			aff, _ := res.RowsAffected()
			if aff == 0 {
				w.WriteHeader(http.StatusNotFound)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service introuvable"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
	}
}
