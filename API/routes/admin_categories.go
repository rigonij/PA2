package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strings"
)

func AdminCategories(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		switch r.Method {
		case http.MethodGet:
			rows, err := database.Query(`SELECT Id_CATEGORY, Name FROM category ORDER BY Name ASC`)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()
			items := []map[string]any{}
			for rows.Next() {
				var id int
				var name string
				_ = rows.Scan(&id, &name)
				items = append(items, map[string]any{"id": id, "name": name})
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
		case http.MethodPost:
			var body struct {
				Name string `json:"name"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			body.Name = strings.TrimSpace(body.Name)
			if body.Name == "" {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Nom requis"})
				return
			}
			res, err := database.Exec(`INSERT INTO category (Name) VALUES (?)`, body.Name)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			id, _ := res.LastInsertId()
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "id": id})
		case http.MethodPut:
			var body struct {
				ID   int    `json:"id"`
				Name string `json:"name"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			body.Name = strings.TrimSpace(body.Name)
			if body.ID <= 0 || body.Name == "" {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID et nom requis"})
				return
			}
			_, err := database.Exec(`UPDATE category SET Name=? WHERE Id_CATEGORY=?`, body.Name, body.ID)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
		case http.MethodDelete:
			var body struct {
				ID int `json:"id"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			if body.ID <= 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID requis"})
				return
			}
			var n int
			_ = database.QueryRow(`SELECT COUNT(*) FROM service_type WHERE Id_CATEGORY=?`, body.ID).Scan(&n)
			if n > 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Categorie utilisee par des types de service"})
				return
			}
			_, err := database.Exec(`DELETE FROM category WHERE Id_CATEGORY=?`, body.ID)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}
}

func AdminServiceTypes(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		switch r.Method {
		case http.MethodGet:
			rows, err := database.Query(`
				SELECT st.Id_SERVICE_TYPE, COALESCE(st.Name,''), COALESCE(st.Id_CATEGORY,0), COALESCE(c.Name,''), COALESCE(st.Default_Hourly_Price,0), COALESCE(st.Duration_Min,60)
				FROM service_type st
				LEFT JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
				ORDER BY c.Name ASC, st.Name ASC`)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()
			items := []map[string]any{}
			for rows.Next() {
				var id, cid, dur int
				var name, cname string
				var price float64
				_ = rows.Scan(&id, &name, &cid, &cname, &price, &dur)
				items = append(items, map[string]any{
					"id": id, "name": name,
					"category_id": cid, "category_name": cname,
					"price": price, "duration_min": dur,
				})
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
		case http.MethodPost:
			var body struct {
				Name        string  `json:"name"`
				CategoryID  int     `json:"category_id"`
				Price       float64 `json:"price"`
				DurationMin int     `json:"duration_min"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			body.Name = strings.TrimSpace(body.Name)
			if body.Name == "" || body.CategoryID <= 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Nom et categorie requis"})
				return
			}
			if body.DurationMin <= 0 {
				body.DurationMin = 60
			}
			res, err := database.Exec(`INSERT INTO service_type (Name, Id_CATEGORY, Default_Hourly_Price, Duration_Min) VALUES (?, ?, ?, ?)`,
				body.Name, body.CategoryID, body.Price, body.DurationMin)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			id, _ := res.LastInsertId()
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "id": id})
		case http.MethodPut:
			var body struct {
				ID          int     `json:"id"`
				Name        string  `json:"name"`
				CategoryID  int     `json:"category_id"`
				Price       float64 `json:"price"`
				DurationMin int     `json:"duration_min"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			body.Name = strings.TrimSpace(body.Name)
			if body.ID <= 0 || body.Name == "" || body.CategoryID <= 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID, nom et categorie requis"})
				return
			}
			if body.DurationMin <= 0 {
				body.DurationMin = 60
			}
			_, err := database.Exec(`UPDATE service_type SET Name=?, Id_CATEGORY=?, Default_Hourly_Price=?, Duration_Min=? WHERE Id_SERVICE_TYPE=?`,
				body.Name, body.CategoryID, body.Price, body.DurationMin, body.ID)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
		case http.MethodDelete:
			var body struct {
				ID int `json:"id"`
			}
			_ = json.NewDecoder(r.Body).Decode(&body)
			if body.ID <= 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID requis"})
				return
			}
			var n int
			_ = database.QueryRow(`SELECT COUNT(*) FROM qualify WHERE Id_SERVICE_TYPE=?`, body.ID).Scan(&n)
			if n > 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Type utilise par des prestataires"})
				return
			}
			var m int
			_ = database.QueryRow(`SELECT COUNT(*) FROM intervention WHERE Id_SERVICE_TYPE=?`, body.ID).Scan(&m)
			if m > 0 {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Type utilise par des interventions"})
				return
			}
			_, err := database.Exec(`DELETE FROM service_type WHERE Id_SERVICE_TYPE=?`, body.ID)
			if err != nil {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}
}
