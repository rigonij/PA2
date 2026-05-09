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
				COALESCE(p.Provider_Description,''),
				COALESCE(rv.avg_rating, 0),
				COALESCE(rv.review_count, 0)
			FROM provider p
			JOIN user u ON u.Id_USER = p.Id_USER
			LEFT JOIN (
				SELECT Id_PROVIDER, AVG(Rating) AS avg_rating, COUNT(*) AS review_count
				FROM review GROUP BY Id_PROVIDER
			) rv ON rv.Id_PROVIDER = p.Id_USER
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
			var id, reviewCount int
			var nom, prenom, email, phone, companyName, description string
			var avgRating float64
			if err := rows.Scan(&id, &nom, &prenom, &email, &phone, &companyName, &description, &avgRating, &reviewCount); err == nil {
				providers = append(providers, map[string]any{
					"id":           id,
					"nom":          nom,
					"prenom":       prenom,
					"email":        email,
					"phone":        phone,
					"company_name": companyName,
					"description":  description,
					"avg_rating":   avgRating,
					"review_count": reviewCount,
				})
			}
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "providers": providers})
	}
}
