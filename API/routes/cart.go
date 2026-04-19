package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/PA_2i2/api/lib"
)

type CartLine struct {
	Id_PRODUCT int     `json:"Id_PRODUCT"`
	Name       string  `json:"Name"`
	Category   string  `json:"Category"`
	Price      float64 `json:"Price"`
	Qty        int     `json:"Qty"`
}

func GetProducts(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
			SELECT Id_PRODUCT, Name, COALESCE(Category,''), Price, COALESCE(link_img,'')
			FROM product
			ORDER BY Name
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()

		products := []map[string]any{}
		for rows.Next() {
			var id int
			var name, category, linkImg string
			var price float64
			if err := rows.Scan(&id, &name, &category, &price, &linkImg); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}
			products = append(products, map[string]any{
				"Id_PRODUCT": id,
				"Name":       name,
				"Category":   category,
				"Price":      price,
				"link_img":   linkImg,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "products": products})
	}
}

func GetCart(database *sql.DB) http.HandlerFunc {
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
				p.Id_PRODUCT, p.Name, COALESCE(p.Category,''), p.Price, COALESCE(p.link_img,''), ci.Qty
			FROM cart_item ci
			JOIN product p ON p.Id_PRODUCT = ci.Id_PRODUCT
			WHERE ci.Id_USER = ?
			ORDER BY p.Name
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}
		defer rows.Close()

		items := []map[string]any{}
		totalQty := 0
		totalPrice := 0.0

		for rows.Next() {
			var id int
			var name, category, linkImg string
			var price float64
			var qty int
			if err := rows.Scan(&id, &name, &category, &price, &linkImg, &qty); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur lecture: " + err.Error()})
				return
			}

			totalQty += qty
			totalPrice += price * float64(qty)

			items = append(items, map[string]any{
				"Id_PRODUCT": id,
				"Name":       name,
				"Category":   category,
				"Price":      price,
				"link_img":   linkImg,
				"Qty":        qty,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":     true,
			"items":       items,
			"total_qty":   totalQty,
			"total_price": totalPrice,
		})
	}
}

type CartActionReq struct {
	ProductID int `json:"product_id"`
}

func AddToCart(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req CartActionReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ProductID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "product_id invalide"})
			return
		}

		_, err = database.Exec(`
			INSERT INTO cart_item (Id_USER, Id_PRODUCT, Qty)
			VALUES (?, ?, 1)
			ON DUPLICATE KEY UPDATE Qty = Qty + 1
		`, userID, req.ProductID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur panier: " + err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func DecrementCart(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req CartActionReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ProductID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "product_id invalide"})
			return
		}

		res, err := database.Exec(`
			UPDATE cart_item
			SET Qty = Qty - 1
			WHERE Id_USER = ? AND Id_PRODUCT = ? AND Qty > 1
		`, userID, req.ProductID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur panier: " + err.Error()})
			return
		}

		affected, _ := res.RowsAffected()

		if affected == 0 {
			_, err = database.Exec(`
				DELETE FROM cart_item
				WHERE Id_USER = ? AND Id_PRODUCT = ? AND Qty = 1
			`, userID, req.ProductID)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur panier: " + err.Error()})
				return
			}
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func ClearCart(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		_, err = database.Exec(`DELETE FROM cart_item WHERE Id_USER = ?`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur panier: " + err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
