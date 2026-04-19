package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"
)

func GetAdminPayments(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		payments := []map[string]any{}

		rows, err := database.Query(`
            SELECT so.Id_ORDER, so.Created_At,
                COALESCE(u.Nom,''), COALESCE(u.Prenom,''), u.Email,
                so.Amount_Total
            FROM shop_order so
            JOIN user u ON u.Id_USER = so.Id_USER
            WHERE so.Status = 'paid'
            ORDER BY so.Created_At DESC
        `)
		if err == nil {
			defer rows.Close()
			for rows.Next() {
				var id int
				var createdAt time.Time
				var nom, prenom, email string
				var amountTotal int
				if err := rows.Scan(&id, &createdAt, &nom, &prenom, &email, &amountTotal); err == nil {
					payments = append(payments, map[string]any{
						"id":      id,
						"date":    createdAt.Format("2006-01-02 15:04"),
						"nom":     nom + " " + prenom,
						"email":   email,
						"montant": amountTotal,
						"type":    "boutique",
						"ref_id":  id,
					})
				}
			}
		}

		rows2, err2 := database.Query(`
            SELECT s.Id_USER, s.Start_Date, s.Id_SUBSCRIPTION_PLAN,
                COALESCE(u.Nom,''), COALESCE(u.Prenom,''), u.Email,
                sp.Price, sp.Name
            FROM subscribe s
            JOIN user u ON u.Id_USER = s.Id_USER
            JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
            ORDER BY s.Start_Date DESC
        `)
		if err2 == nil {
			defer rows2.Close()
			for rows2.Next() {
				var userID, planID int
				var startDate time.Time
				var nom, prenom, email, planName string
				var price float64
				if err := rows2.Scan(&userID, &startDate, &planID, &nom, &prenom, &email, &price, &planName); err == nil {
					payments = append(payments, map[string]any{
						"id":      planID,
						"date":    startDate.Format("2006-01-02 15:04"),
						"nom":     nom + " " + prenom,
						"email":   email,
						"montant": int(price * 100),
						"type":    "abonnement",
						"ref_id":  userID,
						"plan":    planName,
					})
				}
			}
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "payments": payments})
	}
}

func GetAdminPaymentDetail(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		id := r.URL.Query().Get("id")
		typ := r.URL.Query().Get("type")

		if typ == "boutique" {
			var nom, prenom, email string
			var createdAt time.Time
			var amount int
			err := database.QueryRow(`
                SELECT u.Nom, u.Prenom, u.Email, so.Created_At, so.Amount_Total
                FROM shop_order so JOIN user u ON u.Id_USER = so.Id_USER
                WHERE so.Id_ORDER = ? AND so.Status = 'paid'`, id,
			).Scan(&nom, &prenom, &email, &createdAt, &amount)
			if err != nil {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false})
				return
			}
			rows, _ := database.Query(`SELECT Name, Price_Cents, Qty FROM shop_order_item WHERE Id_ORDER = ?`, id)
			defer rows.Close()
			items := []map[string]any{}
			for rows.Next() {
				var name string
				var price, qty int
				if rows.Scan(&name, &price, &qty) == nil {
					items = append(items, map[string]any{"name": name, "price_cents": price, "qty": qty})
				}
			}
			json.NewEncoder(w).Encode(map[string]any{
				"success": true,
				"payment": map[string]any{"nom": nom + " " + prenom, "email": email, "date": createdAt.Format("02/01/2006 15:04"), "montant": amount},
				"items":   items,
			})

		} else {
			var nom, prenom, email, planName, startDate, endDate string
			var price float64
			err := database.QueryRow(`
                SELECT u.Nom, u.Prenom, u.Email, sp.Name, sp.Price,
                    DATE_FORMAT(s.Start_Date,'%d/%m/%Y'), DATE_FORMAT(s.End_Date,'%d/%m/%Y')
                FROM subscribe s
                JOIN user u ON u.Id_USER = s.Id_USER
                JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
                WHERE s.Id_USER = ?
                ORDER BY s.Start_Date DESC LIMIT 1`, id,
			).Scan(&nom, &prenom, &email, &planName, &price, &startDate, &endDate)
			if err != nil {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false})
				return
			}
			json.NewEncoder(w).Encode(map[string]any{
				"success": true,
				"payment": map[string]any{
					"nom": nom + " " + prenom, "email": email, "plan": planName,
					"montant": int(price * 100), "start_date": startDate, "end_date": endDate,
				},
			})
		}
	}
}
