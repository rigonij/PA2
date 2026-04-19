package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

func GetProviderFinances(database *sql.DB) http.HandlerFunc {
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
				i.Id_INTERVENTION,
				i.Date_Start,
				i.Date_End,
				i.Status,
				COALESCE(st.Name, 'Service')          AS service_name,
				COALESCE(q.Negotiated_Price, 0)        AS price,
				COALESCE(u.Nom, '')                     AS senior_nom,
				COALESCE(u.Prenom, '')                  AS senior_prenom
			FROM intervention i
			LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
			LEFT JOIN qualify q ON q.Id_USER = i.Id_PROVIDER AND q.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
			LEFT JOIN user u ON u.Id_USER = i.Id_SENIOR
			WHERE i.Id_PROVIDER = ?
			AND i.Status IN ('Accepted', 'Completed', 'Done')
			ORDER BY i.Date_Start DESC
		`, userID)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		type Invoice struct {
			ID           int     `json:"id"`
			DateStart    string  `json:"date_start"`
			DateEnd      string  `json:"date_end"`
			Status       string  `json:"status"`
			ServiceName  string  `json:"service_name"`
			Price        float64 `json:"price"`
			SeniorNom    string  `json:"senior_nom"`
			SeniorPrenom string  `json:"senior_prenom"`
		}

		invoices := []Invoice{}
		totalRevenue := 0.0

		loc, _ := time.LoadLocation("Europe/Paris")

		for rows.Next() {
			var id int
			var dateStart, dateEnd time.Time
			var status, serviceName string
			var price float64
			var seniorNom, seniorPrenom string

			if err := rows.Scan(&id, &dateStart, &dateEnd, &status, &serviceName, &price, &seniorNom, &seniorPrenom); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}

			totalRevenue += price
			invoices = append(invoices, Invoice{
				ID:           id,
				DateStart:    dateStart.In(loc).Format("2006-01-02T15:04:05"),
				DateEnd:      dateEnd.In(loc).Format("2006-01-02T15:04:05"),
				Status:       status,
				ServiceName:  serviceName,
				Price:        price,
				SeniorNom:    seniorNom,
				SeniorPrenom: seniorPrenom,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":       true,
			"invoices":      invoices,
			"total_revenue": totalRevenue,
			"total_count":   len(invoices),
		})
	}
}
