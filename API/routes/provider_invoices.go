package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

func GetProviderInvoices(database *sql.DB) http.HandlerFunc {
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
                i.Status,
                st.Name AS service_name,
                u.Nom,
                u.Prenom,
                u.Email,
                COALESCE(q.Negotiated_Price, 0)
            FROM intervention i
            JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            JOIN user u ON u.Id_USER = i.Id_SENIOR
            LEFT JOIN qualify q ON q.Id_USER = i.Id_PROVIDER AND q.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            WHERE i.Id_PROVIDER = ?
            ORDER BY i.Date_Start DESC
        `, userID)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		invoices := []map[string]any{}

		for rows.Next() {
			var id int
			var dateStart time.Time
			var status, serviceName, nom, prenom, email string
			var price float64

			if err := rows.Scan(&id, &dateStart, &status, &serviceName, &nom, &prenom, &email, &price); err != nil {
				continue
			}

			invoices = append(invoices, map[string]any{
				"id":           id,
				"date":         dateStart.Format("02/01/2006"),
				"service":      serviceName,
				"senior_nom":   nom + " " + prenom,
				"senior_email": email,
				"statut":       status,
				"montant":      price,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "invoices": invoices})
	}
}

func GetProviderInvoiceDetail(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		idStr := r.PathValue("id")
		var id int
		fmt.Sscanf(idStr, "%d", &id)

		var interventionID int
		var dateStart, dateEnd time.Time
		var status, serviceName, seniorNom, seniorPrenom, seniorEmail, companyName, providerNom, providerPrenom, comment string
		var price float64

		err = database.QueryRow(`
            SELECT i.Id_INTERVENTION, i.Date_Start, i.Date_End, i.Status,
                COALESCE(i.Senior_Comment, ''),
                st.Name,
                u_senior.Nom, u_senior.Prenom, u_senior.Email,
                p.Company_Name,
                u_prov.Nom, u_prov.Prenom,
                COALESCE(q.Negotiated_Price, 0)
            FROM intervention i
            JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            JOIN user u_senior ON u_senior.Id_USER = i.Id_SENIOR
            JOIN provider p ON p.Id_USER = i.Id_PROVIDER
            JOIN user u_prov ON u_prov.Id_USER = i.Id_PROVIDER
            LEFT JOIN qualify q ON q.Id_USER = i.Id_PROVIDER AND q.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
            WHERE i.Id_INTERVENTION = ? AND i.Id_PROVIDER = ?
        `, id, userID).Scan(
			&interventionID, &dateStart, &dateEnd, &status, &comment,
			&serviceName, &seniorNom, &seniorPrenom, &seniorEmail,
			&companyName, &providerNom, &providerPrenom, &price,
		)

		if err != nil {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Intervention introuvable"})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":      true,
			"id":           interventionID,
			"date_start":   dateStart.Format("02/01/2006 15:04"),
			"date_end":     dateEnd.Format("02/01/2006 15:04"),
			"status":       status,
			"comment":      comment,
			"service":      serviceName,
			"senior_nom":   seniorNom + " " + seniorPrenom,
			"senior_email": seniorEmail,
			"company":      companyName,
			"provider_nom": providerNom + " " + providerPrenom,
			"montant":      price,
		})
	}
}
