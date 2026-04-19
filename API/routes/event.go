package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

type EventDTO struct {
	ID              int    `json:"id"`
	Title           string `json:"title"`
	Location        string `json:"location"`
	EventDate       string `json:"event_date"`
	MaxParticipants int    `json:"max_participants"`
	IsRegistered    bool   `json:"is_registered"`
}

type EventsResponse struct {
	Success bool       `json:"success"`
	Events  []EventDTO `json:"events"`
}

func GetEvents(database *sql.DB) http.HandlerFunc {
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
			SELECT e.Id_EVENT, e.Title, e.Location, e.Event_Date, e.Max_Participants,
				COALESCE(e.Price, 0),
				CASE WHEN er.Id_USER IS NULL THEN 0 ELSE 1 END AS is_registered
			FROM event e
			LEFT JOIN event_registration er
				ON er.Id_EVENT = e.Id_EVENT AND er.Id_USER = ?
			WHERE e.Validation_Status = 1 AND e.Event_Date >= NOW()
			ORDER BY e.Event_Date ASC
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		events := []map[string]any{}
		for rows.Next() {
			var id, max, price int
			var title, location string
			var dt time.Time
			var isReg int

			if err := rows.Scan(&id, &title, &location, &dt, &max, &price, &isReg); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			events = append(events, map[string]any{
				"id":               id,
				"title":            title,
				"location":         location,
				"event_date":       dt.Format(time.RFC3339),
				"max_participants": max,
				"price":            price,
				"is_paid":          price > 0,
				"is_registered":    isReg == 1,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "events": events})
	}
}

type eventActionReq struct {
	EventID int `json:"event_id"`
}

func SubscribeEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req eventActionReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.EventID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "event_id invalide"})
			return
		}

		var price int
		row := database.QueryRow(`SELECT COALESCE(Price, 0) FROM event WHERE Id_EVENT = ? LIMIT 1`, req.EventID)
		if err := row.Scan(&price); err != nil {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Événement introuvable"})
			return
		}

		if price > 0 {
			json.NewEncoder(w).Encode(map[string]any{
				"success":          false,
				"requires_payment": true,
				"event_id":         req.EventID,
			})
			return
		}

		_, _ = database.Exec(`INSERT IGNORE INTO event_registration (Id_EVENT, Id_USER) VALUES (?, ?)`, req.EventID, userID)

		var title, location string
		var dt time.Time
		infoRow := database.QueryRow(`SELECT Title, Location, Event_Date FROM event WHERE Id_EVENT = ? LIMIT 1`, req.EventID)
		if err := infoRow.Scan(&title, &location, &dt); err == nil {
			_, _ = database.Exec(`
				INSERT INTO planning_item (Id_USER, Item_Type, Ref_ID, Title, Start_At, Location, Details)
				VALUES (?, 'event', ?, ?, ?, ?, '')
			`, userID, req.EventID, title, dt, location)
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func UnsubscribeEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req eventActionReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.EventID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "event_id invalide"})
			return
		}

		_, _ = database.Exec(`DELETE FROM event_registration WHERE Id_EVENT = ? AND Id_USER = ?`, req.EventID, userID)
		_, _ = database.Exec(`DELETE FROM planning_item WHERE Id_USER = ? AND Item_Type = 'event' AND Ref_ID = ?`, userID, req.EventID)

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

type PlanningItemDTO struct {
	ID       int    `json:"id"`
	ItemType string `json:"item_type"`
	RefID    int    `json:"ref_id"`
	Title    string `json:"title"`
	StartAt  string `json:"start_at"`
	Location string `json:"location"`
	Details  string `json:"details"`
}

func GetPlanning(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
            SELECT
                pi.Id_ITEM,
                pi.Item_Type,
                pi.Ref_ID,
                pi.Title,
                pi.Start_At,
                pi.Location,
                pi.Details,
                COALESCE(i.Status, '')           AS intervention_status,
                COALESCE(i.Admin_Approved, 0)    AS admin_approved,
                COALESCE(i.Provider_Approved, 0) AS provider_approved
            FROM planning_item pi
            LEFT JOIN intervention i
                ON i.Id_INTERVENTION = pi.Ref_ID AND pi.Item_Type = 'service'
            WHERE pi.Id_USER = ?
            ORDER BY pi.Start_At ASC
        `, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()

		items := []map[string]any{}

		for rows.Next() {
			var itemID, refID int
			var itemType, title, location, details string
			var startAt string
			var interventionStatus string
			var adminApproved, providerApproved int

			if err := rows.Scan(
				&itemID, &itemType, &refID, &title, &startAt, &location, &details,
				&interventionStatus, &adminApproved, &providerApproved,
			); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}

			items = append(items, map[string]any{
				"id":                itemID,
				"item_type":         itemType,
				"ref_id":            refID,
				"title":             title,
				"start_at":          startAt,
				"location":          location,
				"details":           details,
				"status":            interventionStatus,
				"admin_approved":    adminApproved,
				"provider_approved": providerApproved,
			})
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
	}
}
