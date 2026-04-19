package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"

	"github.com/PA_2i2/api/lib"
)

func requireProviderValidatedID(database *sql.DB, w http.ResponseWriter, r *http.Request) (int, bool) {
	token := r.Header.Get("X-Token")
	userID, err := lib.GetUserIDFromToken(database, token)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
		return 0, false
	}

	var status int
	err = database.QueryRow(`SELECT Validation_Status FROM provider WHERE Id_USER = ? LIMIT 1`, userID).Scan(&status)

	if err == sql.ErrNoRows {
		w.WriteHeader(http.StatusForbidden)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Accès refusé – prestataire requis"})
		return 0, false
	}
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
		return 0, false
	}
	if status != 1 {
		w.WriteHeader(http.StatusForbidden)
		_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Compte prestataire non validé"})
		return 0, false
	}

	return userID, true
}

func ProviderGetServiceTypes(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		_, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}

		rows, err := database.Query(`
			SELECT
				COALESCE(c.Id_CATEGORY, 0) AS category_id,
				COALESCE(c.Name,'')       AS category_name,
				st.Id_SERVICE_TYPE        AS service_type_id,
				COALESCE(st.Name,'')      AS service_type_name
			FROM service_type st
			LEFT JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
			ORDER BY c.Name ASC, st.Name ASC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		type ServiceType struct {
			ID   int    `json:"id"`
			Name string `json:"name"`
		}
		type CategoryGroup struct {
			CategoryID   int           `json:"category_id"`
			CategoryName string        `json:"category_name"`
			Services     []ServiceType `json:"services"`
		}

		groups := []CategoryGroup{}
		indexByCat := map[int]int{}

		for rows.Next() {
			var catID int
			var catName string
			var stID int
			var stName string

			if err := rows.Scan(&catID, &catName, &stID, &stName); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			idx, exists := indexByCat[catID]
			if !exists {
				indexByCat[catID] = len(groups)
				groups = append(groups, CategoryGroup{
					CategoryID:   catID,
					CategoryName: catName,
					Services:     []ServiceType{},
				})
				idx = indexByCat[catID]
			}

			groups[idx].Services = append(groups[idx].Services, ServiceType{
				ID:   stID,
				Name: stName,
			})
		}

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":    true,
			"categories": groups,
		})
	}
}

func ProviderServices(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}

		switch r.Method {

		case http.MethodGet:
			rows, err := database.Query(`
				SELECT
					q.Id_SERVICE_TYPE,
					COALESCE(st.Name,''),
					COALESCE(st.link_img,''),
					COALESCE(q.Custom_Title,''),
					COALESCE(q.Negotiated_Price, 0),
					COALESCE(q.Experience_Years, 0),
					COALESCE(q.Is_Active, 1),
					COALESCE(q.Validation_Status, 0)
				FROM qualify q
				JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
				WHERE q.Id_USER = ?
				ORDER BY st.Name ASC
			`, providerID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			defer rows.Close()

			items := []map[string]any{}
			for rows.Next() {
				var id int
				var name, linkImg, customTitle string
				var price float64
				var exp int
				var active int
				var vstatus int

				if err := rows.Scan(&id, &name, &linkImg, &customTitle, &price, &exp, &active, &vstatus); err != nil {
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}

				items = append(items, map[string]any{
					"service_type_id":   id,
					"name":              name,
					"link_img":          linkImg,
					"custom_title":      customTitle,
					"negotiated_price":  price,
					"experience_years":  exp,
					"is_active":         active == 1,
					"validation_status": vstatus,
				})
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "items": items})
			return

		case http.MethodPost:
			var req struct {
				ServiceTypeID int `json:"service_type_id"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ServiceTypeID <= 0 {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "service_type_id invalide"})
				return
			}

			_, err := database.Exec(`
				INSERT INTO qualify (Id_USER, Id_SERVICE_TYPE, Is_Active, Validation_Status)
				VALUES (?, ?, 1, 0)
			`, providerID, req.ServiceTypeID)

			if err != nil {
				w.WriteHeader(http.StatusConflict)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service déjà dans votre catalogue"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Service ajouté"})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
	}
}

func ProviderServiceByID(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}

		idStr := strings.TrimPrefix(r.URL.Path, "/api/provider/services/")
		idStr = strings.Trim(idStr, "/")
		serviceTypeID, err := strconv.Atoi(idStr)
		if err != nil || serviceTypeID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID service invalide"})
			return
		}

		switch r.Method {

		case http.MethodPut:
			var req struct {
				CustomTitle     string  `json:"custom_title"`
				NegotiatedPrice float64 `json:"negotiated_price"`
				ExperienceYears int     `json:"experience_years"`
				IsActive        bool    `json:"is_active"`
			}
			if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
				return
			}

			activeInt := 0
			if req.IsActive {
				activeInt = 1
			}

			res, err := database.Exec(`
				UPDATE qualify
				SET Custom_Title = ?,
					Negotiated_Price = ?,
					Experience_Years = ?,
					Is_Active = ?
				WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
			`, req.CustomTitle, req.NegotiatedPrice, req.ExperienceYears, activeInt, providerID, serviceTypeID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			aff, _ := res.RowsAffected()
			if aff == 0 {
				w.WriteHeader(http.StatusNotFound)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service non trouvé pour ce prestataire"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Service mis à jour"})
			return

		case http.MethodDelete:
			res, err := database.Exec(`
				DELETE FROM qualify
				WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
			`, providerID, serviceTypeID)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			aff, _ := res.RowsAffected()
			if aff == 0 {
				w.WriteHeader(http.StatusNotFound)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service non trouvé pour ce prestataire"})
				return
			}

			_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Service supprimé"})
			return

		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
	}
}
