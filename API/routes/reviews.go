package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"github.com/PA_2i2/api/lib"
)

func requireSeniorID(database *sql.DB, w http.ResponseWriter, r *http.Request) (int, bool) {
	token := r.Header.Get("X-Token")
	userID, err := lib.GetUserIDFromToken(database, token)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
		return 0, false
	}
	var exists int
	err = database.QueryRow(`SELECT 1 FROM senior WHERE Id_USER = ?`, userID).Scan(&exists)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Senior requis"})
		return 0, false
	}
	return userID, true
}

func ProviderReviews(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		idStr := strings.TrimPrefix(r.URL.Path, "/api/providers/")
		idStr = strings.TrimSuffix(idStr, "/reviews")
		idStr = strings.Trim(idStr, "/")
		providerID, err := strconv.Atoi(idStr)
		if err != nil || providerID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID prestataire invalide"})
			return
		}
		var avg sql.NullFloat64
		var count int
		_ = database.QueryRow(`
			SELECT AVG(Rating), COUNT(*) FROM review WHERE Id_PROVIDER = ?
		`, providerID).Scan(&avg, &count)
		rows, err := database.Query(`
			SELECT r.Id_REVIEW, r.Id_SENIOR, r.Rating, COALESCE(r.Comment,''),
			       r.Created_At, r.Updated_At,
			       COALESCE(u.Prenom,''), COALESCE(u.Nom,'')
			FROM review r
			JOIN user u ON u.Id_USER = r.Id_SENIOR
			WHERE r.Id_PROVIDER = ?
			ORDER BY r.Updated_At DESC
		`, providerID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		reviews := []map[string]any{}
		for rows.Next() {
			var id, seniorID, rating int
			var comment, createdAt, updatedAt, prenom, nom string
			if err := rows.Scan(&id, &seniorID, &rating, &comment, &createdAt, &updatedAt, &prenom, &nom); err != nil {
				continue
			}
			reviews = append(reviews, map[string]any{
				"id":         id,
				"senior_id":  seniorID,
				"rating":     rating,
				"comment":    comment,
				"created_at": createdAt,
				"updated_at": updatedAt,
				"author":     strings.TrimSpace(prenom + " " + nom),
			})
		}
		avgVal := 0.0
		if avg.Valid {
			avgVal = avg.Float64
		}
		_ = json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"average": avgVal,
			"count":   count,
			"reviews": reviews,
		})
	}
}

func SeniorReviews(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		seniorID, ok := requireSeniorID(database, w, r)
		if !ok {
			return
		}
		switch r.Method {
		case http.MethodPost:
			var req struct {
				ProviderID int    `json:"provider_id"`
				Rating     int    `json:"rating"`
				Comment    string `json:"comment"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
				return
			}
			if req.ProviderID <= 0 || req.Rating < 1 || req.Rating > 5 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
				return
			}
			var commentVal any = nil
			if strings.TrimSpace(req.Comment) != "" {
				commentVal = req.Comment
			}
			_, err := database.Exec(`
				INSERT INTO review (Id_SENIOR, Id_PROVIDER, Rating, Comment)
				VALUES (?, ?, ?, ?)
				ON DUPLICATE KEY UPDATE Rating = VALUES(Rating), Comment = VALUES(Comment)
			`, seniorID, req.ProviderID, req.Rating, commentVal)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Avis enregistré"})
			return
		case http.MethodDelete:
			providerIDStr := r.URL.Query().Get("provider_id")
			providerID, err := strconv.Atoi(providerIDStr)
			if err != nil || providerID <= 0 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "provider_id invalide"})
				return
			}
			_, err = database.Exec(`DELETE FROM review WHERE Id_SENIOR = ? AND Id_PROVIDER = ?`, seniorID, providerID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Avis supprimé"})
			return
		case http.MethodGet:
			providerIDStr := r.URL.Query().Get("provider_id")
			providerID, err := strconv.Atoi(providerIDStr)
			if err != nil || providerID <= 0 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "provider_id invalide"})
				return
			}
			var rating int
			var comment string
			err = database.QueryRow(`SELECT Rating, COALESCE(Comment,'') FROM review WHERE Id_SENIOR = ? AND Id_PROVIDER = ?`, seniorID, providerID).Scan(&rating, &comment)
			if err == sql.ErrNoRows {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "review": nil})
				return
			}
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{
				"success": true,
				"review": map[string]any{
					"rating":  rating,
					"comment": comment,
				},
			})
			return
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}
}
