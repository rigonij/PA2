package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strings"
)

func AdminGetProducts(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		rows, err := database.Query(`
			SELECT Id_PRODUCT, Name, COALESCE(Category,''), Price, COALESCE(link_img,'')
			FROM product
			ORDER BY Id_PRODUCT DESC`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		products := []map[string]any{}
		for rows.Next() {
			var id int
			var name, category, linkImg string
			var price float64
			if err := rows.Scan(&id, &name, &category, &price, &linkImg); err != nil {
				continue
			}
			products = append(products, map[string]any{
				"id":       id,
				"name":     name,
				"category": category,
				"price":    price,
				"link_img": linkImg,
			})
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "products": products})
	}
}

func AdminCreateProduct(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		var req struct {
			Name     string  `json:"name"`
			Category string  `json:"category"`
			Price    float64 `json:"price"`
			LinkImg  string  `json:"link_img"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
			return
		}
		req.Name = strings.TrimSpace(req.Name)
		req.Category = strings.TrimSpace(req.Category)
		req.LinkImg = strings.TrimSpace(req.LinkImg)
		if req.Name == "" || req.Price < 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Nom requis et prix >= 0"})
			return
		}
		res, err := database.Exec(`INSERT INTO product (Name, Category, Price, link_img) VALUES (?, ?, ?, ?)`,
			req.Name, req.Category, req.Price, req.LinkImg)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		id, _ := res.LastInsertId()
		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Produit créé", "id": id})
	}
}

func AdminUpdateProduct(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		var req struct {
			ID       int     `json:"id"`
			Name     string  `json:"name"`
			Category string  `json:"category"`
			Price    float64 `json:"price"`
			LinkImg  string  `json:"link_img"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Données invalides"})
			return
		}
		req.Name = strings.TrimSpace(req.Name)
		req.Category = strings.TrimSpace(req.Category)
		req.LinkImg = strings.TrimSpace(req.LinkImg)
		if req.Name == "" || req.Price < 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Nom requis et prix >= 0"})
			return
		}
		res, err := database.Exec(`UPDATE product SET Name = ?, Category = ?, Price = ?, link_img = ? WHERE Id_PRODUCT = ?`,
			req.Name, req.Category, req.Price, req.LinkImg, req.ID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		affected, _ := res.RowsAffected()
		if affected == 0 {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Produit introuvable"})
			return
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Produit modifié"})
	}
}

func AdminDeleteProduct(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		var req struct {
			ID int `json:"id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}
		_, _ = database.Exec(`DELETE FROM cart_item WHERE Id_PRODUCT = ?`, req.ID)
		if _, err := database.Exec(`DELETE FROM product WHERE Id_PRODUCT = ?`, req.ID); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Produit supprimé"})
	}
}
