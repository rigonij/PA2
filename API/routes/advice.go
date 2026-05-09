package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/PA_2i2/api/lib"
)

type AdviceCreateRequest struct {
	Title   string `json:"title"`
	Excerpt string `json:"excerpt"`
	Content string `json:"content"`
}

type AdviceUpdateRequest struct {
	ID      int    `json:"id"`
	Title   string `json:"title"`
	Excerpt string `json:"excerpt"`
	Content string `json:"content"`
}

type AdviceDeleteRequest struct {
	ID int `json:"id"`
}

func GetAdviceList(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		if _, err := lib.GetUserIDFromToken(database, token); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
            SELECT Id_ADVICE, Title, COALESCE(Excerpt, ''), Created_At, COALESCE(Updated_At, Created_At)
            FROM advice
            ORDER BY COALESCE(Updated_At, Created_At) DESC, Id_ADVICE DESC
        `)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		advices := []map[string]any{}
		for rows.Next() {
			var id int
			var title, excerpt string
			var createdAt, updatedAt time.Time
			if err := rows.Scan(&id, &title, &excerpt, &createdAt, &updatedAt); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}
			advices = append(advices, map[string]any{
				"id":         id,
				"title":      title,
				"excerpt":    excerpt,
				"created_at": createdAt.Format(time.RFC3339),
				"updated_at": updatedAt.Format(time.RFC3339),
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "advices": advices})
	}
}

func GetAdviceDetail(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		if _, err := lib.GetUserIDFromToken(database, token); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		idStr := strings.TrimPrefix(r.URL.Path, "/api/advice/")
		idStr = strings.TrimSpace(idStr)
		id, err := strconv.Atoi(idStr)
		if err != nil || id <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}

		var title, excerpt, content string
		var createdAt, updatedAt time.Time
		err = database.QueryRow(`
            SELECT Title, COALESCE(Excerpt, ''), COALESCE(Content, ''), Created_At, COALESCE(Updated_At, Created_At)
            FROM advice
            WHERE Id_ADVICE = ?
            LIMIT 1
        `, id).Scan(&title, &excerpt, &content, &createdAt, &updatedAt)
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Conseil introuvable"})
			return
		}
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"advice": map[string]any{
				"id":         id,
				"title":      title,
				"excerpt":    excerpt,
				"content":    content,
				"created_at": createdAt.Format(time.RFC3339),
				"updated_at": updatedAt.Format(time.RFC3339),
			},
		})
	}
}

func CreateAdvice(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req AdviceCreateRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}

		title := strings.TrimSpace(req.Title)
		excerpt := strings.TrimSpace(req.Excerpt)
		content := strings.TrimSpace(req.Content)

		if title == "" || content == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Titre et contenu obligatoires"})
			return
		}
		if len(title) > 150 {
			title = title[:150]
		}
		if len(excerpt) > 255 {
			excerpt = excerpt[:255]
		}

		res, err := database.Exec(`
			INSERT INTO advice (Title, Excerpt, Content, Created_By)
			VALUES (?, ?, ?, ?)
		`, title, excerpt, content, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		id64, _ := res.LastInsertId()
		json.NewEncoder(w).Encode(map[string]any{"success": true, "id": int(id64)})
	}
}

func UpdateAdvice(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		if _, err := lib.GetUserIDFromToken(database, token); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req AdviceUpdateRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}

		title := strings.TrimSpace(req.Title)
		excerpt := strings.TrimSpace(req.Excerpt)
		content := strings.TrimSpace(req.Content)

		if title == "" || content == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Titre et contenu obligatoires"})
			return
		}
		if len(title) > 150 {
			title = title[:150]
		}
		if len(excerpt) > 255 {
			excerpt = excerpt[:255]
		}

		res, err := database.Exec(`
			UPDATE advice
			SET Title = ?, Excerpt = ?, Content = ?
			WHERE Id_ADVICE = ?
		`, title, excerpt, content, req.ID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		affected, _ := res.RowsAffected()
		if affected == 0 {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Conseil introuvable"})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func DeleteAdvice(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		if _, err := lib.GetUserIDFromToken(database, token); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req AdviceDeleteRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}

		res, err := database.Exec(`DELETE FROM advice WHERE Id_ADVICE = ?`, req.ID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		affected, _ := res.RowsAffected()
		if affected == 0 {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Conseil introuvable"})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
