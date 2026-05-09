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
			var status, serviceName string
			var nom, prenom, email sql.NullString
			var price float64
			if err := rows.Scan(&id, &dateStart, &status, &serviceName, &nom, &prenom, &email, &price); err != nil {
				continue
			}
			invoices = append(invoices, map[string]any{
				"id":           id,
				"date":         dateStart.Format("02/01/2006"),
				"service":      serviceName,
				"senior_nom":   nom.String + " " + prenom.String,
				"senior_email": email.String,
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
		var status, serviceName, comment string
		var seniorNom, seniorPrenom, seniorEmail, companyName, providerNom, providerPrenom sql.NullString
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
			"senior_nom":   seniorNom.String + " " + seniorPrenom.String,
			"senior_email": seniorEmail.String,
			"company":      companyName.String,
			"provider_nom": providerNom.String + " " + providerPrenom.String,
			"montant":      price,
		})
	}
}

func GetProviderInvoicePDF(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		idStr := r.PathValue("id")
		var id int
		fmt.Sscanf(idStr, "%d", &id)

		var interventionID int
		var dateStart, dateEnd time.Time
		var status, serviceName, comment string
		var seniorNom, seniorPrenom, seniorEmail, companyName, providerNom, providerPrenom sql.NullString
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
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Intervention introuvable"})
			return
		}

		fields := []lib.ProviderRecapField{
			{Label: "Service", Value: serviceName},
			{Label: "Prestataire", Value: companyName.String + " (" + providerNom.String + " " + providerPrenom.String + ")"},
			{Label: "Senior", Value: seniorNom.String + " " + seniorPrenom.String + " — " + seniorEmail.String},
			{Label: "Début", Value: dateStart.Format("02/01/2006 15:04")},
			{Label: "Fin", Value: dateEnd.Format("02/01/2006 15:04")},
			{Label: "Statut", Value: status},
		}
		if comment != "" {
			fields = append(fields, lib.ProviderRecapField{Label: "Commentaire", Value: comment})
		}

		data := lib.ProviderRecapData{
			ID:      interventionID,
			DateSub: dateStart.Format("02/01/2006"),
			Fields:  fields,
			Amount:  price,
			Footer:  "Document généré automatiquement par SilverHappy.",
		}

		pdfBytes, err := lib.BuildProviderRecapPDF(data)
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur génération PDF: " + err.Error()})
			return
		}

		filename := fmt.Sprintf("FAC-prov-%d.pdf", interventionID)
		w.Header().Set("Content-Type", "application/pdf")
		w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="%s"`, filename))
		w.Header().Set("Content-Length", fmt.Sprintf("%d", len(pdfBytes)))
		w.Write(pdfBytes)
	}
}
