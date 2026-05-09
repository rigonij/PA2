package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/PA_2i2/api/lib"
)

func GetProviderSeniorInfo(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		providerID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		seniorID, err := strconv.Atoi(r.URL.Query().Get("id"))
		if err != nil || seniorID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "id invalide"})
			return
		}

		var hasIntervention int
		err = database.QueryRow(`
			SELECT COUNT(*) FROM intervention
			WHERE Id_PROVIDER = ? AND Id_SENIOR = ?
		`, providerID, seniorID).Scan(&hasIntervention)
		if err != nil || hasIntervention == 0 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé"})
			return
		}

		var prenom, nom, email, phone, street, zip, city string
		err = database.QueryRow(`
			SELECT COALESCE(Prenom,''), COALESCE(Nom,''), COALESCE(Email,''),
			       COALESCE(Phone_Number,''), COALESCE(Address_Street,''),
			       COALESCE(Address_Zip,''), COALESCE(Address_City,'')
			FROM user WHERE Id_USER = ?
		`, seniorID).Scan(&prenom, &nom, &email, &phone, &street, &zip, &city)
		if err != nil {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Senior introuvable"})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"senior": map[string]any{
				"id":             seniorID,
				"prenom":         prenom,
				"nom":            nom,
				"email":          email,
				"phone_number":   phone,
				"address_street": street,
				"address_zip":    zip,
				"address_city":   city,
			},
		})
	}
}
