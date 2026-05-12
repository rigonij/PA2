package routes

import (
	"database/sql"
	"encoding/json"
	"math"
	"net/http"
	"strings"
)

func AdminGetSubscriptionPlans(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) { return }
		rows, err := database.Query(`SELECT Id_SUBSCRIPTION_PLAN, COALESCE(Name,''), COALESCE(Display_Name, Name), COALESCE(Price,0), COALESCE(Duration_Months,0) FROM subscription_plan ORDER BY Id_SUBSCRIPTION_PLAN ASC`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		plans := []map[string]any{}
		for rows.Next() {
			var id, months int
			var name, display string
			var price float64
			if err := rows.Scan(&id, &name, &display, &price, &months); err != nil { continue }
			plans = append(plans, map[string]any{"id": id, "name": name, "display_name": display, "price": price, "duration_months": months})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "plans": plans})
	}
}

func AdminUpdateSubscriptionPlan(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) { return }
		var req struct {
			ID             int     `json:"id"`
			DisplayName    string  `json:"display_name"`
			Price          float64 `json:"price"`
			DurationMonths int     `json:"duration_months"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Donnees invalides"})
			return
		}
		req.DisplayName = strings.TrimSpace(req.DisplayName)
		if req.DisplayName == "" || req.Price < 0 || req.DurationMonths <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Champs invalides"})
			return
		}

		var oldDisplay, oldName string
		var oldPrice float64
		_ = database.QueryRow(`SELECT COALESCE(Display_Name, Name), COALESCE(Name,''), COALESCE(Price,0) FROM subscription_plan WHERE Id_SUBSCRIPTION_PLAN = ?`, req.ID).Scan(&oldDisplay, &oldName, &oldPrice)

		_, err := database.Exec(`UPDATE subscription_plan SET Display_Name = ?, Price = ?, Duration_Months = ? WHERE Id_SUBSCRIPTION_PLAN = ?`,
			req.DisplayName, req.Price, req.DurationMonths, req.ID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		oldCents := int(math.Round(oldPrice * 100))
		newCents := int(math.Round(req.Price * 100))
		if oldCents != newCents || oldDisplay != req.DisplayName {
			rows, qerr := database.Query(`SELECT DISTINCT Id_USER FROM subscribe WHERE Id_SUBSCRIPTION_PLAN = ? AND Is_Active = 1`, req.ID)
			if qerr == nil {
				defer rows.Close()
				for rows.Next() {
					var uid int
					if err := rows.Scan(&uid); err == nil {
						_, _ = database.Exec(`INSERT INTO subscription_price_notification (Id_USER, Id_SUBSCRIPTION_PLAN, Old_Price_Cents, New_Price_Cents, Old_Display_Name, New_Display_Name) VALUES (?, ?, ?, ?, ?, ?)`, uid, req.ID, oldCents, newCents, oldDisplay, req.DisplayName)
					}
				}
			}
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Plan modifie"})
	}
}
