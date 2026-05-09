package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
)

func AdminGetProviderAuthorizedServices(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		idStr := strings.TrimPrefix(r.URL.Path, "/api/admin/provider-authorized-services/")
		idStr = strings.Trim(idStr, "/")
		providerID, err := strconv.Atoi(idStr)
		if err != nil || providerID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID prestataire invalide"})
			return
		}

		rows, err := database.Query(`
			SELECT
				COALESCE(c.Id_CATEGORY, 0),
				COALESCE(c.Name, 'Autre'),
				st.Id_SERVICE_TYPE,
				COALESCE(st.Name, ''),
				CASE WHEN past.Id_USER IS NULL THEN 0 ELSE 1 END AS authorized
			FROM service_type st
			LEFT JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
			LEFT JOIN provider_authorized_service_type past
				ON past.Id_SERVICE_TYPE = st.Id_SERVICE_TYPE AND past.Id_USER = ?
			ORDER BY c.Name ASC, st.Name ASC
		`, providerID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		type ServiceItem struct {
			ID         int    `json:"id"`
			Name       string `json:"name"`
			Authorized bool   `json:"authorized"`
		}
		type CategoryGroup struct {
			CategoryID   int           `json:"category_id"`
			CategoryName string        `json:"category_name"`
			Services     []ServiceItem `json:"services"`
		}

		groups := []CategoryGroup{}
		indexByCat := map[int]int{}

		for rows.Next() {
			var catID, stID, auth int
			var catName, stName string
			if err := rows.Scan(&catID, &catName, &stID, &stName, &auth); err != nil {
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
					Services:     []ServiceItem{},
				})
				idx = indexByCat[catID]
			}
			groups[idx].Services = append(groups[idx].Services, ServiceItem{
				ID:         stID,
				Name:       stName,
				Authorized: auth == 1,
			})
		}

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":    true,
			"categories": groups,
		})
	}
}

func AdminValidateProviderWithServices(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		var req struct {
			ProviderID               int   `json:"id"`
			Status                   int   `json:"status"`
			AuthorizedServiceTypeIDs []int `json:"authorized_service_type_ids"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
			return
		}
		if req.ProviderID <= 0 || (req.Status != 1 && req.Status != 2) {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		tx, err := database.Begin()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur transaction"})
			return
		}

		res, err := tx.Exec(`UPDATE provider SET Validation_Status = ? WHERE Id_USER = ?`, req.Status, req.ProviderID)
		if err != nil {
			_ = tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		aff, _ := res.RowsAffected()
		if aff == 0 {
			_ = tx.Rollback()
			w.WriteHeader(http.StatusNotFound)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Prestataire introuvable"})
			return
		}

		if req.Status == 1 {
			_, err = tx.Exec(`DELETE FROM provider_authorized_service_type WHERE Id_USER = ?`, req.ProviderID)
			if err != nil {
				_ = tx.Rollback()
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			for _, stID := range req.AuthorizedServiceTypeIDs {
				if stID <= 0 {
					continue
				}
				_, err = tx.Exec(`
					INSERT IGNORE INTO provider_authorized_service_type (Id_USER, Id_SERVICE_TYPE)
					VALUES (?, ?)
				`, req.ProviderID, stID)
				if err != nil {
					_ = tx.Rollback()
					w.WriteHeader(http.StatusInternalServerError)
					_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
					return
				}
			}
		}

		if err := tx.Commit(); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur commit"})
			return
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
