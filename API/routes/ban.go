package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

type BanRequest struct {
	UserID int `json:"user_id"`
}

func BanUser(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		adminID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var count int
		_ = database.QueryRow(`SELECT COUNT(*) FROM admin WHERE Id_USER = ?`, adminID).Scan(&count)
		if count == 0 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé"})
			return
		}

		var req BanRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.UserID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "user_id invalide"})
			return
		}

		var isAdmin int
		_ = database.QueryRow(`SELECT COUNT(*) FROM admin WHERE Id_USER = ?`, req.UserID).Scan(&isAdmin)
		if isAdmin > 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Impossible de bannir un admin"})
			return
		}

		_, err = database.Exec(`UPDATE user SET Is_Banned = 1 WHERE Id_USER = ?`, req.UserID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		_, _ = database.Exec(`DELETE FROM token WHERE Id_USER = ?`, req.UserID)

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func UnbanUser(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		adminID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var count int
		_ = database.QueryRow(`SELECT COUNT(*) FROM admin WHERE Id_USER = ?`, adminID).Scan(&count)
		if count == 0 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé"})
			return
		}

		var req BanRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.UserID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "user_id invalide"})
			return
		}

		_, err = database.Exec(`UPDATE user SET Is_Banned = 0 WHERE Id_USER = ?`, req.UserID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
