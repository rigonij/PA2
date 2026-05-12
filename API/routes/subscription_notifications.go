package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

func GetPriceChangeNotifications(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false})
			return
		}
		rows, err := database.Query(`SELECT Id_NOTIFICATION, Id_SUBSCRIPTION_PLAN, Old_Price_Cents, New_Price_Cents, COALESCE(Old_Display_Name,''), COALESCE(New_Display_Name,'') FROM subscription_price_notification WHERE Id_USER = ? AND Acknowledged_At IS NULL ORDER BY Created_At ASC`, userID)
		if err != nil {
			json.NewEncoder(w).Encode(map[string]any{"success": true, "notifications": []any{}})
			return
		}
		defer rows.Close()
		notifs := []map[string]any{}
		for rows.Next() {
			var id, planID, oldP, newP int
			var oldN, newN string
			if err := rows.Scan(&id, &planID, &oldP, &newP, &oldN, &newN); err != nil {
				continue
			}
			notifs = append(notifs, map[string]any{
				"id": id, "plan_id": planID,
				"old_price_cents": oldP, "new_price_cents": newP,
				"old_display_name": oldN, "new_display_name": newN,
			})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "notifications": notifs})
	}
}

func AcknowledgePriceChangeNotification(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false})
			return
		}
		_, _ = database.Exec(`UPDATE subscription_price_notification SET Acknowledged_At = NOW() WHERE Id_USER = ? AND Acknowledged_At IS NULL`, userID)
		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
