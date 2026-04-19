package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

type MedicalCreateRequest struct {
	StartAt    string `json:"start_at"`
	DoctorName string `json:"doctor_name"`
	Location   string `json:"location"`
	Details    string `json:"details"`
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

		if req.StartAt == "" || req.DoctorName == "" || req.Location == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Champs manquants"})
			return
		}

		start, err := parseDateTimeLocalOrRFC3339(req.StartAt)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Date invalide"})
			return
		}

		res, err := database.Exec(`
			INSERT INTO medical_appointment (Id_USER, Start_At, Doctor_Name, Location, Details)
			VALUES (?, ?, ?, ?, ?)
		`, userID, start, req.DoctorName, req.Location, req.Details)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur insertion: " + err.Error()})
			return
		}

		id64, _ := res.LastInsertId()
		medicalID := int(id64)

		title := "RDV médical — " + req.DoctorName
		_, err = database.Exec(`
			INSERT INTO planning_item (Id_USER, Item_Type, Ref_ID, Title, Start_At, Location, Details)
			VALUES (?, 'medical', ?, ?, ?, ?, ?)
		`, userID, medicalID, title, start, req.Location, req.Details)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur planning_item: " + err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "RDV créé", "medical_id": medicalID})
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
