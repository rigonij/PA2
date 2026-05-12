package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
)

func GetSubscriptionPlansPublic(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
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
			if err := rows.Scan(&id, &name, &display, &price, &months); err != nil {
				continue
			}
			plans = append(plans, map[string]any{
				"id": id, "name": name, "display_name": display,
				"price": price, "duration_months": months,
			})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "plans": plans})
	}
}
