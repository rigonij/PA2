package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

func GetServicesCatalog(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Non authentifié",
			})
			return
		}

		rows, err := database.Query(`
                        SELECT
                                c.Name AS CategoryName,
                                st.Id_SERVICE_TYPE,
                                st.Name AS ServiceName,
                                st.link_img,
                                p.Id_USER AS ProviderID,
                                p.Company_Name
                        FROM provider p
                        JOIN qualify ps ON ps.Id_USER = p.Id_USER
				AND COALESCE(ps.Is_Active, 1) = 1
				AND COALESCE(ps.Validation_Status, 0) = 1
                        JOIN service_type st ON st.Id_SERVICE_TYPE = ps.Id_SERVICE_TYPE
                        JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
                        WHERE p.Validation_Status = 1
                        ORDER BY c.Name, st.Name, p.Company_Name
                `)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Erreur SQL: " + err.Error(),
			})
			return
		}
		defer rows.Close()

		categories := map[string][]map[string]any{}

		for rows.Next() {
			var categoryName string
			var serviceTypeID int
			var serviceName string
			var linkImg string
			var providerID int
			var companyName string

			if err := rows.Scan(
				&categoryName,
				&serviceTypeID,
				&serviceName,
				&linkImg,
				&providerID,
				&companyName,
			); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{
					"success": false,
					"message": "Erreur lecture: " + err.Error(),
				})
				return
			}

			item := map[string]any{
				"Id_USER":         providerID,
				"Company_Name":    companyName,
				"Id_SERVICE_TYPE": serviceTypeID,
				"ServiceName":     serviceName,
				"link_img":        linkImg,
			}

			categories[categoryName] = append(categories[categoryName], item)
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":    true,
			"categories": categories,
		})
	}
}
