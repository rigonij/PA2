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
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		rows, err := database.Query(`
			SELECT
				q.Id_USER,
				COALESCE(p.Company_Name,''),
				q.Id_SERVICE_TYPE,
				COALESCE(st.Name,''),
				COALESCE(q.Custom_Title,''),
				COALESCE(q.Negotiated_Price, 0),
				COALESCE(q.Experience_Years, 0)
			FROM qualify q
			JOIN provider p ON p.Id_USER = q.Id_USER
			JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
			WHERE q.Validation_Status = 1 AND q.Is_Active = 1
			ORDER BY p.Company_Name ASC, st.Name ASC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		items := []map[string]any{}
		for rows.Next() {
			var providerID, serviceTypeID, exp int
			var company, serviceName, customTitle string
			var price float64
			if err := rows.Scan(&providerID, &company, &serviceTypeID, &serviceName, &customTitle, &price, &exp); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			items = append(items, map[string]any{
				"provider_id":      providerID,
				"company_name":     company,
				"service_type_id":  serviceTypeID,
				"service_name":     serviceName,
				"custom_title":     customTitle,
				"negotiated_price": price,
				"experience_years": exp,
				"is_active":        true,
			})
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
	}
}
