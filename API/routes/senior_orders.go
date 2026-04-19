package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

func GetSeniorOrders(database *sql.DB) http.HandlerFunc {
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
			SELECT Id_ORDER, Amount_Total, Status, Created_At
			FROM shop_order
			WHERE Id_USER = ?
			ORDER BY Created_At DESC
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		orders := []map[string]any{}

		for rows.Next() {
			var orderID int
			var amountTotal int
			var status, createdAt string

			if err := rows.Scan(&orderID, &amountTotal, &status, &createdAt); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			itemRows, err := database.Query(`
				SELECT Name, Price_Cents, Qty
				FROM shop_order_item
				WHERE Id_ORDER = ?
			`, orderID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			items := []map[string]any{}
			for itemRows.Next() {
				var name string
				var priceCents, qty int
				if err := itemRows.Scan(&name, &priceCents, &qty); err != nil {
					itemRows.Close()
					w.WriteHeader(http.StatusInternalServerError)
					json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
				items = append(items, map[string]any{
					"name":        name,
					"price_cents": priceCents,
					"qty":         qty,
				})
			}
			itemRows.Close()

			orders = append(orders, map[string]any{
				"id":           orderID,
				"amount_total": amountTotal,
				"status":       status,
				"created_at":   createdAt,
				"items":        items,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "orders": orders})
	}
}
