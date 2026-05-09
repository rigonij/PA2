package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

func GetSeniorInvoices(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		type Invoice struct {
			Ref    string  `json:"ref"`
			Date   string  `json:"date"`
			Label  string  `json:"label"`
			Amount float64 `json:"amount"`
			Type   string  `json:"type"`
			ID     int     `json:"id"`
		}

		invoices := []Invoice{}

		rowsSub, errSub := database.Query(`
			SELECT s.Id_SUBSCRIPTION_PLAN, s.Start_Date, sp.Name, sp.Price
			FROM subscribe s
			JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
			WHERE s.Id_USER = ?
			ORDER BY s.Start_Date DESC
		`, userID)
		if errSub == nil {
			defer rowsSub.Close()
			for rowsSub.Next() {
				var id int
				var dt time.Time
				var name string
				var price float64
				if err := rowsSub.Scan(&id, &dt, &name, &price); err == nil {
					invoices = append(invoices, Invoice{
						Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
						Date:   dt.Format("02/01/2006"),
						Label:  "Abonnement",
						Amount: price,
						Type:   "sub",
						ID:     id,
					})
				}
			}
		}

		rowsShop, errShop := database.Query(`
			SELECT so.Id_ORDER, so.Created_At,
				COALESCE((
					SELECT SUM(soi.Price_Cents * soi.Qty)
					FROM shop_order_item soi
					WHERE soi.Id_ORDER = so.Id_ORDER
				), 0) AS total_cents
			FROM shop_order so
			WHERE so.Id_USER = ?
			ORDER BY so.Created_At DESC
		`, userID)
		if errShop == nil {
			defer rowsShop.Close()
			for rowsShop.Next() {
				var id int
				var dt time.Time
				var totalCents int
				if err := rowsShop.Scan(&id, &dt, &totalCents); err == nil {
					invoices = append(invoices, Invoice{
						Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
						Date:   dt.Format("02/01/2006"),
						Label:  "Boutique",
						Amount: float64(totalCents) / 100.0,
						Type:   "shop",
						ID:     id,
					})
				}
			}
		}

		rowsSvc, errSvc := database.Query(`
			SELECT i.Id_INTERVENTION, i.Date_Start, COALESCE(i.Negotiated_Price, 0)
			FROM intervention i
			WHERE i.Id_SENIOR = ? AND i.Status IN ('Accepted', 'Confirmed')
			ORDER BY i.Date_Start DESC
		`, userID)
		if errSvc == nil {
			defer rowsSvc.Close()
			for rowsSvc.Next() {
				var id int
				var dt time.Time
				var price float64
				if err := rowsSvc.Scan(&id, &dt, &price); err == nil {
					invoices = append(invoices, Invoice{
						Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
						Date:   dt.Format("02/01/2006"),
						Label:  "Service",
						Amount: price,
						Type:   "svc",
						ID:     id,
					})
				}
			}
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "invoices": invoices})
	}
}

func GetSeniorInvoiceDetail(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		invType := r.URL.Query().Get("type")
		invIDStr := r.URL.Query().Get("id")
		var invID int
		fmt.Sscanf(invIDStr, "%d", &invID)

		if invID <= 0 || invType == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		type InvoiceDetail struct {
			Ref    string  `json:"ref"`
			Date   string  `json:"date"`
			Label  string  `json:"label"`
			Amount float64 `json:"amount"`
			Detail string  `json:"detail"`
		}

		var inv InvoiceDetail

		switch invType {
		case "sub":
			row := database.QueryRow(`
				SELECT s.Id_SUBSCRIPTION_PLAN, s.Start_Date, sp.Name, sp.Price
				FROM subscribe s
				JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
				WHERE s.Id_SUBSCRIPTION_PLAN = ? AND s.Id_USER = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var name string
			var price float64
			if err := row.Scan(&id, &dt, &name, &price); err != nil {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			inv = InvoiceDetail{
				Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
				Date:   dt.Format("02/01/2006"),
				Label:  "Abonnement",
				Amount: price,
				Detail: name,
			}

		case "shop":
			row := database.QueryRow(`
				SELECT so.Id_ORDER, so.Created_At,
					COALESCE((SELECT SUM(soi.Price_Cents * soi.Qty) FROM shop_order_item soi WHERE soi.Id_ORDER = so.Id_ORDER), 0)
				FROM shop_order so
				WHERE so.Id_ORDER = ? AND so.Id_USER = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var totalCents int
			if err := row.Scan(&id, &dt, &totalCents); err != nil {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			inv = InvoiceDetail{
				Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
				Date:   dt.Format("02/01/2006"),
				Label:  "Boutique",
				Amount: float64(totalCents) / 100.0,
				Detail: "Commande boutique",
			}

		case "svc":
			row := database.QueryRow(`
				SELECT i.Id_INTERVENTION, i.Date_Start, COALESCE(i.Negotiated_Price, 0),
					COALESCE(st.Name, 'Service')
				FROM intervention i
				LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
				WHERE i.Id_INTERVENTION = ? AND i.Id_SENIOR = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var price float64
			var svcName string
			if err := row.Scan(&id, &dt, &price, &svcName); err != nil {
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			inv = InvoiceDetail{
				Ref:    fmt.Sprintf("FAC-%d-%03d", dt.Year(), id),
				Date:   dt.Format("02/01/2006"),
				Label:  "Service",
				Amount: price,
				Detail: svcName,
			}

		default:
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Type invalide"})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "invoice": inv})
	}
}

func GetSeniorInvoicePDF(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		invType := r.URL.Query().Get("type")
		invIDStr := r.URL.Query().Get("id")
		var invID int
		fmt.Sscanf(invIDStr, "%d", &invID)

		if invID <= 0 || invType == "" {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		var ref, date, label, detail string
		var amount float64

		switch invType {
		case "sub":
			row := database.QueryRow(`
				SELECT s.Id_SUBSCRIPTION_PLAN, s.Start_Date, sp.Name, sp.Price
				FROM subscribe s
				JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
				WHERE s.Id_SUBSCRIPTION_PLAN = ? AND s.Id_USER = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var name string
			var price float64
			if err := row.Scan(&id, &dt, &name, &price); err != nil {
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			ref = fmt.Sprintf("FAC-%d-%03d", dt.Year(), id)
			date = dt.Format("02/01/2006")
			label = "Abonnement"
			detail = name
			amount = price

		case "shop":
			row := database.QueryRow(`
				SELECT so.Id_ORDER, so.Created_At,
					COALESCE((SELECT SUM(soi.Price_Cents * soi.Qty) FROM shop_order_item soi WHERE soi.Id_ORDER = so.Id_ORDER), 0)
				FROM shop_order so
				WHERE so.Id_ORDER = ? AND so.Id_USER = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var totalCents int
			if err := row.Scan(&id, &dt, &totalCents); err != nil {
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			ref = fmt.Sprintf("FAC-%d-%03d", dt.Year(), id)
			date = dt.Format("02/01/2006")
			label = "Boutique"
			detail = "Commande boutique"
			amount = float64(totalCents) / 100.0

		case "svc":
			row := database.QueryRow(`
				SELECT i.Id_INTERVENTION, i.Date_Start, COALESCE(i.Negotiated_Price, 0),
					COALESCE(st.Name, 'Service')
				FROM intervention i
				LEFT JOIN service_type st ON st.Id_SERVICE_TYPE = i.Id_SERVICE_TYPE
				WHERE i.Id_INTERVENTION = ? AND i.Id_SENIOR = ?
			`, invID, userID)
			var id int
			var dt time.Time
			var price float64
			var svcName string
			if err := row.Scan(&id, &dt, &price, &svcName); err != nil {
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(http.StatusNotFound)
				json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Facture introuvable"})
				return
			}
			ref = fmt.Sprintf("FAC-%d-%03d", dt.Year(), id)
			date = dt.Format("02/01/2006")
			label = "Service"
			detail = svcName
			amount = price

		default:
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Type invalide"})
			return
		}

		data := lib.InvoiceData{
			Ref:      ref,
			Date:     date,
			Title:    "SilverHappy",
			Subtitle: "Facture & reçu de paiement",
			Lines: []lib.InvoiceLine{
				{Label: label, Detail: detail, Amount: amount},
			},
			Total:  amount,
			Footer: "Document généré automatiquement par SilverHappy. Conservez ce reçu à titre de justificatif.",
		}

		pdfBytes, err := lib.BuildInvoicePDF(data)
		if err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur génération PDF: " + err.Error()})
			return
		}

		w.Header().Set("Content-Type", "application/pdf")
		w.Header().Set("Content-Disposition", fmt.Sprintf(`attachment; filename="%s.pdf"`, ref))
		w.Header().Set("Content-Length", fmt.Sprintf("%d", len(pdfBytes)))
		w.Write(pdfBytes)
	}
}
