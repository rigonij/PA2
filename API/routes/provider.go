package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

type UpdateProviderMeRequest struct {
	Email         string `json:"email"`
	Nom           string `json:"nom"`
	Prenom        string `json:"prenom"`
	PhoneNumber   string `json:"phone_number"`
	AddressStreet string `json:"address_street"`
	AddressZip    string `json:"address_zip"`
	AddressCity   string `json:"address_city"`
	CompanyName   string `json:"company_name"`
	Siret         string `json:"siret"`
}

func GetProviderMe(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var email, nom, prenom, phoneNumber, addressStreet, addressZip, addressCity string
		err = database.QueryRow(`
			SELECT COALESCE(Email,''), COALESCE(Nom,''), COALESCE(Prenom,''),
			       COALESCE(Phone_Number,''), COALESCE(Address_Street,''),
			       COALESCE(Address_Zip,''), COALESCE(Address_City,'')
			FROM user WHERE Id_USER = ?
		`, userID).Scan(&email, &nom, &prenom, &phoneNumber, &addressStreet, &addressZip, &addressCity)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		var companyName, siret string
		var validationStatus int
		_ = database.QueryRow(`
			SELECT COALESCE(Company_Name,''), COALESCE(SIRET_Number,''), COALESCE(Validation_Status, 0)
			FROM provider WHERE Id_USER = ?
		`, userID).Scan(&companyName, &siret, &validationStatus)

		json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"user": map[string]any{
				"email":             email,
				"nom":               nom,
				"prenom":            prenom,
				"phone_number":      phoneNumber,
				"address_street":    addressStreet,
				"address_zip":       addressZip,
				"address_city":      addressCity,
				"company_name":      companyName,
				"siret":             siret,
				"validation_status": validationStatus,
			},
		})
	}
}

func UpdateProviderMe(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req UpdateProviderMeRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}

		_, err = database.Exec(`
			UPDATE user
			SET Email=?, Nom=?, Prenom=?, Phone_Number=?, Address_Street=?, Address_Zip=?, Address_City=?
			WHERE Id_USER=?
		`, req.Email, req.Nom, req.Prenom, req.PhoneNumber, req.AddressStreet, req.AddressZip, req.AddressCity, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		_, _ = database.Exec(`
			UPDATE provider SET Company_Name=?, SIRET_Number=? WHERE Id_USER=?
		`, req.CompanyName, req.Siret, userID)

		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Profil mis à jour."})
	}
}
