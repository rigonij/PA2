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
            SELECT e.Id_EVENT,
                   COALESCE(e.Title,''),
                   COALESCE(e.Location,''),
                   COALESCE(e.Description,''),
                   e.Event_Date,
                   COALESCE(e.Max_Participants,0),
                   COALESCE(e.Price,0),
                   (SELECT COUNT(*) FROM event_registration er2 WHERE er2.Id_EVENT = e.Id_EVENT) AS registered_count,
                   CASE WHEN er.Id_USER IS NULL THEN 0 ELSE 1 END AS is_registered
            FROM event e
            LEFT JOIN event_registration er
                ON er.Id_EVENT = e.Id_EVENT AND er.Id_USER = ?
            WHERE e.Event_Date >= NOW()
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
			var id, maxP, regCount, isReg int
			var title, location, description string
			var dt time.Time
			var price float64
			if err := rows.Scan(&id, &title, &location, &description, &dt, &maxP, &price, &regCount, &isReg); err != nil {
				continue
			}
			available := maxP - regCount
			if available < 0 {
				available = 0
			}
			events = append(events, map[string]any{
				"id":               id,
				"title":            title,
				"location":         location,
				"description":      description,
				"event_date":       dt.Format(time.RFC3339),
				"max_participants": maxP,
				"price":            price,
				"is_paid":          price > 0,
				"registered_count": regCount,
				"available_spots":  available,
				"is_full":          maxP > 0 && regCount >= maxP,
				"is_registered":    isReg == 1,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "events": events})
	}
}

func GetEventDetail(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		idStr := r.URL.Query().Get("id")
		eventID, err := strconv.Atoi(idStr)
		if err != nil || eventID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}

		var title, location, description string
		var dt time.Time
		var max, registered, isReg int
		var price float64

		err = database.QueryRow(`
            SELECT COALESCE(e.Title,''),
                   COALESCE(e.Location,''),
                   COALESCE(e.Description,''),
                   e.Event_Date,
                   COALESCE(e.Max_Participants,0),
                   COALESCE(e.Price,0),
                   (SELECT COUNT(*) FROM event_registration er2 WHERE er2.Id_EVENT = e.Id_EVENT),
                   CASE WHEN er.Id_USER IS NULL THEN 0 ELSE 1 END
            FROM event e
            LEFT JOIN event_registration er
                ON er.Id_EVENT = e.Id_EVENT AND er.Id_USER = ?
            WHERE e.Id_EVENT = ?
            LIMIT 1
        `, userID, eventID).Scan(&title, &location, &description, &dt, &max, &price, &registered, &isReg)

		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Evenement introuvable"})
			return
		}
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		rows, err := database.Query(`
            SELECT COALESCE(u.Prenom,''), COALESCE(u.Nom,'')
            FROM event_registration er
            JOIN user u ON u.Id_USER = er.Id_USER
            WHERE er.Id_EVENT = ?
            ORDER BY u.Nom, u.Prenom
        `, eventID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		participants := []map[string]any{}
		for rows.Next() {
			var prenom, nom string
			if err := rows.Scan(&prenom, &nom); err != nil {
				continue
			}
			full := strings.TrimSpace(prenom + " " + nom)
			if full == "" {
				full = "Participant"
			}
			participants = append(participants, map[string]any{
				"full_name": full,
			})
		}

		avail := max - registered
		if avail < 0 {
			avail = 0
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"event": map[string]any{
				"id":               eventID,
				"title":            title,
				"location":         location,
				"description":      description,
				"event_date":       dt.Format(time.RFC3339),
				"max_participants": max,
				"price":            price,
				"registered_count": registered,
				"available_spots":  avail,
				"is_full":          registered >= max,
				"is_registered":    isReg == 1,
				"participants":     participants,
			},
		})
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

		var price float64
		_ = database.QueryRow(`SELECT COALESCE(Price, 0) FROM event WHERE Id_EVENT = ? LIMIT 1`, req.EventID).Scan(&price)
		if price > 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Événement payant — utilisez le checkout Stripe"})
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

		scope := r.URL.Query().Get("scope")
		if scope != "history" {
			scope = "upcoming"
		}

		var dateCond, orderDir string
		if scope == "history" {
			dateCond = "pi.Start_At < NOW()"
			orderDir = "DESC"
		} else {
			dateCond = "pi.Start_At >= NOW()"
			orderDir = "ASC"
		}

		events := []map[string]any{}
		rowsE, err := database.Query(`
			SELECT pi.Id_ITEM, pi.Ref_ID, pi.Title, pi.Start_At, pi.Location, pi.Details
			FROM planning_item pi
			WHERE pi.Id_USER = ? AND pi.Item_Type = 'event' AND `+dateCond+`
			ORDER BY pi.Start_At `+orderDir, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL events: " + err.Error()})
			return
		}
		for rowsE.Next() {
			var id, refID int
			var title, location, details string
			var startAt time.Time
			if err := rowsE.Scan(&id, &refID, &title, &startAt, &location, &details); err != nil {
				rowsE.Close()
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture events: " + err.Error()})
				return
			}
			events = append(events, map[string]any{
				"id":       id,
				"ref_id":   refID,
				"title":    title,
				"start_at": startAt.Format(time.RFC3339),
				"location": location,
				"details":  details,
			})
		}
		rowsE.Close()

		services := []map[string]any{}
		rowsS, err := database.Query(`
			SELECT pi.Id_ITEM, pi.Ref_ID, pi.Title, pi.Start_At, pi.Location, pi.Details,
				COALESCE(i.Status, '')           AS intervention_status,
				COALESCE(i.Admin_Approved, 0)    AS admin_approved,
				COALESCE(i.Provider_Approved, 0) AS provider_approved
			FROM planning_item pi
			LEFT JOIN intervention i ON i.Id_INTERVENTION = pi.Ref_ID
			WHERE pi.Id_USER = ? AND pi.Item_Type = 'service' AND `+dateCond+`
			ORDER BY pi.Start_At `+orderDir, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL services: " + err.Error()})
			return
		}
		for rowsS.Next() {
			var id, refID int
			var title, location, details, status string
			var startAt time.Time
			var adminApproved, providerApproved int
			if err := rowsS.Scan(&id, &refID, &title, &startAt, &location, &details, &status, &adminApproved, &providerApproved); err != nil {
				rowsS.Close()
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture services: " + err.Error()})
				return
			}
			services = append(services, map[string]any{
				"id":                id,
				"ref_id":            refID,
				"title":             title,
				"start_at":          startAt.Format(time.RFC3339),
				"location":          location,
				"details":           details,
				"status":            status,
				"admin_approved":    adminApproved,
				"provider_approved": providerApproved,
			})
		}
		rowsS.Close()

		medicals := []map[string]any{}
		rowsM, err := database.Query(`
			SELECT pi.Id_ITEM, pi.Ref_ID, pi.Title, pi.Start_At, pi.Location, pi.Details
			FROM planning_item pi
			WHERE pi.Id_USER = ? AND pi.Item_Type = 'medical' AND `+dateCond+`
			ORDER BY pi.Start_At `+orderDir, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL medicals: " + err.Error()})
			return
		}
		for rowsM.Next() {
			var id, refID int
			var title, location, details string
			var startAt time.Time
			if err := rowsM.Scan(&id, &refID, &title, &startAt, &location, &details); err != nil {
				rowsM.Close()
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture medicals: " + err.Error()})
				return
			}
			medicals = append(medicals, map[string]any{
				"id":       id,
				"ref_id":   refID,
				"title":    title,
				"start_at": startAt.Format(time.RFC3339),
				"location": location,
				"details":  details,
			})
		}
		rowsM.Close()

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":  true,
			"scope":    scope,
			"events":   events,
			"services": services,
			"medicals": medicals,
		})
	}
}

func ClearPlanningHistory(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		res, err := database.Exec(`DELETE FROM planning_item WHERE Id_USER = ? AND Start_At < NOW()`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}

		affected, _ := res.RowsAffected()
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "deleted": affected})
	}
}
