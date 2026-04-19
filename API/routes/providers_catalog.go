package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

func GetProvidersCatalog(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
			SELECT u.Id_USER,
				COALESCE(u.Nom,''),
				COALESCE(u.Prenom,''),
				COALESCE(u.Email,''),
				COALESCE(u.Phone_Number,''),
				COALESCE(p.Company_Name,''),
				COALESCE(p.Provider_Description,'')
			FROM provider p
			JOIN user u ON u.Id_USER = p.Id_USER
			WHERE p.Validation_Status = 1
			ORDER BY p.Company_Name ASC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		providers := []map[string]any{}

		for rows.Next() {
			var id int
			var nom, prenom, email, phone, companyName, description string
			rows.Scan(&id, &nom, &prenom, &email, &phone, &companyName, &description)
			if err := rows.Scan(&id, &nom, &prenom, &email, &phone, &companyName, &description); err == nil {
				providers = append(providers, map[string]any{
					"id":           id,
					"nom":          nom,
					"prenom":       prenom,
					"email":        email,
					"phone":        phone,
					"company_name": companyName,
					"description":  description,
				})
			}
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "providers": providers})
	}
}
