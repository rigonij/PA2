package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"github.com/PA_2i2/api/lib"
)

func SendMessageInternal(database *sql.DB, senderID int, receiverID int, content string) {
	_, _ = database.Exec(
		`INSERT INTO message (Id_SENDER, Id_RECEIVER, Content, Is_Read, Created_At)
		 VALUES (?, ?, ?, 0, NOW())`,
		senderID,
		receiverID,
		content,
	)
}

type sendMessageReq struct {
	ReceiverID int    `json:"receiver_id"`
	Content    string `json:"content"`
}

func GetConversations(database *sql.DB) http.HandlerFunc {
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
			SELECT
				conv.other_id,
				COALESCE(p.Company_Name, TRIM(CONCAT(COALESCE(u.Prenom,''), ' ', COALESCE(u.Nom,''))), 'Système') AS other_name,
				conv.last_message_at,
				conv.unread_count
			FROM (
				SELECT
					CASE WHEN m.Id_SENDER = ? THEN m.Id_RECEIVER ELSE m.Id_SENDER END AS other_id,
					MAX(m.Created_At) AS last_message_at,
					SUM(CASE WHEN m.Id_RECEIVER = ? AND m.Is_Read = 0 THEN 1 ELSE 0 END) AS unread_count
				FROM message m
				WHERE m.Id_SENDER = ? OR m.Id_RECEIVER = ?
				GROUP BY other_id
			) conv
			LEFT JOIN user u ON u.Id_USER = conv.other_id
			LEFT JOIN provider p ON p.Id_USER = conv.other_id
			ORDER BY conv.last_message_at DESC
		`, userID, userID, userID, userID)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		convs := []map[string]any{}
		for rows.Next() {
			var otherID int
			var otherName, lastMsgAt string
			var unreadCount int

			if err := rows.Scan(&otherID, &otherName, &lastMsgAt, &unreadCount); err != nil {
				continue
			}

			convs = append(convs, map[string]any{
				"other_id":        otherID,
				"other_name":      otherName,
				"last_message_at": lastMsgAt,
				"unread_count":    unreadCount,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "conversations": convs})
	}
}

func GetMessages(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		parts := strings.Split(r.URL.Path, "/")
		otherID := 0
		if len(parts) > 0 {
			otherID, _ = strconv.Atoi(parts[len(parts)-1])
		}

		rows, err := database.Query(`
			SELECT
				m.Id_MESSAGE,
				m.Id_SENDER,
				m.Content,
				m.Created_At,
				COALESCE(p.Company_Name, TRIM(CONCAT(COALESCE(u.Prenom,''), ' ', COALESCE(u.Nom,''))), 'Système') AS sender_name
			FROM message m
			LEFT JOIN user u ON u.Id_USER = m.Id_SENDER
			LEFT JOIN provider p ON p.Id_USER = m.Id_SENDER
			WHERE (m.Id_SENDER = ? AND m.Id_RECEIVER = ?)
			   OR (m.Id_SENDER = ? AND m.Id_RECEIVER = ?)
			ORDER BY m.Created_At ASC
		`, userID, otherID, otherID, userID)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		msgs := []map[string]any{}
		for rows.Next() {
			var id, senderID int
			var content, createdAt, senderName string

			if err := rows.Scan(&id, &senderID, &content, &createdAt, &senderName); err != nil {
				continue
			}

			msgs = append(msgs, map[string]any{
				"id":          id,
				"content":     content,
				"created_at":  createdAt,
				"is_mine":     senderID == userID,
				"sender_name": senderName,
			})
		}

		_, _ = database.Exec(
			`UPDATE message SET Is_Read = 1 WHERE Id_RECEIVER = ? AND Id_SENDER = ?`,
			userID, otherID,
		)

		json.NewEncoder(w).Encode(map[string]any{"success": true, "messages": msgs})
	}
}

func SendMessage(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req sendMessageReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ReceiverID <= 0 || req.Content == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		_, err = database.Exec(
			`INSERT INTO message (Id_SENDER, Id_RECEIVER, Content) VALUES (?, ?, ?)`,
			userID, req.ReceiverID, req.Content,
		)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
