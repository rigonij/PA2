package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/PA_2i2/api/lib"
)

type MedicalCreateRequest struct {
	StartAt           string `json:"start_at"`
	ProviderID        int    `json:"provider_id"`
	Location          string `json:"location"`
	UseAccountAddress bool   `json:"use_account_address"`
	Details           string `json:"details"`
}

type MedicalDeleteRequest struct {
	MedicalID int `json:"medical_id"`
}

func parseDateTimeLocalOrRFC3339(v string) (time.Time, error) {
	if t, err := time.Parse(time.RFC3339, v); err == nil {
		return t, nil
	}
	return time.Parse("2006-01-02T15:04", v)
}

func truncateString(s string, max int) string {
	if len(s) <= max {
		return s
	}
	return s[:max]
}

func GetMedical(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		rows, err := database.Query(`
			SELECT Id_MEDICAL, Start_At, Doctor_Name, Location, COALESCE(Details,'')
			FROM medical_appointment
			WHERE Id_USER = ?
			ORDER BY Start_At ASC
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()
		items := []map[string]any{}
		for rows.Next() {
			var id int
			var start time.Time
			var doctor, location, details string
			if err := rows.Scan(&id, &start, &doctor, &location, &details); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}
			items = append(items, map[string]any{
				"id":          id,
				"start_at":    start.Format(time.RFC3339),
				"doctor_name": doctor,
				"location":    location,
				"details":     details,
			})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
	}
}

func GetMedicalDoctors(database *sql.DB) http.HandlerFunc {
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
			SELECT DISTINCT p.Id_USER, p.Company_Name, COALESCE(u.Prenom,''), COALESCE(u.Nom,'')
			FROM provider p
			JOIN user u ON u.Id_USER = p.Id_USER
			JOIN qualify q ON q.Id_USER = p.Id_USER
			JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
			JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
			WHERE p.Validation_Status = 1
			  AND q.Validation_Status = 1
			  AND q.Is_Active = 1
			  AND c.Name = 'Santé'
			ORDER BY p.Company_Name
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()
		doctors := []map[string]any{}
		for rows.Next() {
			var providerID int
			var companyName, prenom, nom string
			if err := rows.Scan(&providerID, &companyName, &prenom, &nom); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}
			fullName := strings.TrimSpace(prenom + " " + nom)
			label := companyName
			if fullName != "" {
				label = fullName + " — " + companyName
			}
			doctors = append(doctors, map[string]any{
				"provider_id":  providerID,
				"company_name": companyName,
				"full_name":    fullName,
				"label":        label,
			})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "doctors": doctors})
	}
}

func CreateMedical(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		var req MedicalCreateRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}
		if req.StartAt == "" || req.ProviderID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Champs manquants"})
			return
		}
		loc, _ := time.LoadLocation("Europe/Paris")
		start, err := time.Parse(time.RFC3339, req.StartAt)
		if err != nil {
			start, err = time.ParseInLocation("2006-01-02T15:04", req.StartAt, loc)
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Date invalide"})
				return
			}
		}

		if start.Before(time.Now()) {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "La date doit être dans le futur"})
			return
		}

		var companyName, prenom, nom string
		err = database.QueryRow(`
			SELECT p.Company_Name, COALESCE(u.Prenom,''), COALESCE(u.Nom,'')
			FROM provider p
			JOIN user u ON u.Id_USER = p.Id_USER
			JOIN qualify q ON q.Id_USER = p.Id_USER
			JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
			JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
			WHERE p.Id_USER = ?
			  AND p.Validation_Status = 1
			  AND q.Validation_Status = 1
			  AND q.Is_Active = 1
			  AND c.Name = 'Santé'
			LIMIT 1
		`, req.ProviderID).Scan(&companyName, &prenom, &nom)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Prestataire santé invalide"})
			return
		}
		fullName := strings.TrimSpace(prenom + " " + nom)
		doctorName := companyName
		if fullName != "" {
			doctorName = fullName + " — " + companyName
		}
		doctorName = truncateString(doctorName, 120)

		location := strings.TrimSpace(req.Location)
		if req.UseAccountAddress {
			var street, zip, city sql.NullString
			err = database.QueryRow(`
				SELECT Address_Street, Address_Zip, Address_City
				FROM user
				WHERE Id_USER = ?
				LIMIT 1
			`, userID).Scan(&street, &zip, &city)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur adresse: " + err.Error()})
				return
			}
			parts := []string{}
			if street.Valid && strings.TrimSpace(street.String) != "" {
				parts = append(parts, strings.TrimSpace(street.String))
			}
			zipCity := strings.TrimSpace(strings.TrimSpace(zip.String) + " " + strings.TrimSpace(city.String))
			if zipCity != "" {
				parts = append(parts, zipCity)
			}
			location = strings.Join(parts, ", ")
		}
		if location == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Lieu manquant"})
			return
		}
		location = truncateString(location, 160)

		res, err := database.Exec(`
			INSERT INTO medical_appointment (Id_USER, Start_At, Doctor_Name, Location, Details)
			VALUES (?, ?, ?, ?, ?)
		`, userID, start, doctorName, location, req.Details)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur insertion: " + err.Error()})
			return
		}
		id64, _ := res.LastInsertId()
		medicalID := int(id64)
		title := "RDV médical — " + doctorName
		_, err = database.Exec(`
			INSERT INTO planning_item (Id_USER, Item_Type, Ref_ID, Title, Start_At, Location, Details)
			VALUES (?, 'medical', ?, ?, ?, ?, ?)
		`, userID, medicalID, title, start, location, req.Details)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur planning_item: " + err.Error()})
			return
		}
		json.NewEncoder(w).Encode(map[string]any{
			"success":     true,
			"message":     "RDV créé",
			"medical_id":  medicalID,
			"doctor_name": doctorName,
			"location":    location,
		})
	}
}

func DeleteMedical(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		var req MedicalDeleteRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.MedicalID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "medical_id invalide"})
			return
		}
		_, _ = database.Exec(`DELETE FROM planning_item WHERE Id_USER=? AND Item_Type='medical' AND Ref_ID=?`, userID, req.MedicalID)
		_, _ = database.Exec(`DELETE FROM medical_appointment WHERE Id_MEDICAL=? AND Id_USER=?`, req.MedicalID, userID)
		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "RDV supprimé"})
	}
}
