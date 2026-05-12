package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/PA_2i2/api/lib"
	stripe "github.com/stripe/stripe-go/v76"
	"github.com/stripe/stripe-go/v76/checkout/session"
	"github.com/stripe/stripe-go/v76/webhook"
)

func planToCents(plan string) int64 {
	switch plan {
	case "monthly_normal":
		return 400
	case "yearly_normal":
		return 4000
	case "monthly_renewal":
		return 300
	case "yearly_renewal":
		return 3500
	}
	return 0
}

func planToLabel(plan string) string {
	switch plan {
	case "monthly_normal":
		return "Abonnement normal — mensuel"
	case "yearly_normal":
		return "Abonnement normal — annuel"
	case "monthly_renewal":
		return "Renouvellement — mensuel"
	case "yearly_renewal":
		return "Renouvellement — annuel"
	}
	return "Abonnement"
}

func planLabel(name string) string {
	switch name {
	case "monthly_normal":
		return "Mensuel normal"
	case "yearly_normal":
		return "Annuel normal"
	case "monthly_renewal":
		return "Mensuel renouvellement"
	case "yearly_renewal":
		return "Annuel renouvellement"
	default:
		return name
	}
}

func CreateSubscriptionCheckout(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		stripe.Key = os.Getenv("STRIPE_SECRET_KEY")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req struct {
			Plan string `json:"plan"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}

		var planID int
		var durationMonths int
		var price float64
		var displayName string
		err = database.QueryRow(
			`SELECT Id_SUBSCRIPTION_PLAN, COALESCE(Display_Name, Name, ''), COALESCE(Price, 0), COALESCE(Duration_Months, 1) FROM subscription_plan WHERE Name = ? LIMIT 1`,
			req.Plan,
		).Scan(&planID, &displayName, &price, &durationMonths)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Plan introuvable en DB"})
			return
		}
		cents := int64(math.Round(price * 100))
		if cents == 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Prix invalide"})
			return
		}
		
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Plan introuvable en DB"})
			return
		}

		interval := "month"
		if req.Plan == "yearly_normal" || req.Plan == "yearly_renewal" {
			interval = "year"
		}

		appBase := os.Getenv("APP_BASE_URL")
		if appBase == "" {
			appBase = "http://localhost/PA_2i2/public"
		}

		params := &stripe.CheckoutSessionParams{
			Mode: stripe.String(string(stripe.CheckoutSessionModeSubscription)),
			LineItems: []*stripe.CheckoutSessionLineItemParams{
				{
					PriceData: &stripe.CheckoutSessionLineItemPriceDataParams{
						Currency:   stripe.String("eur"),
						UnitAmount: stripe.Int64(cents),
						Recurring: &stripe.CheckoutSessionLineItemPriceDataRecurringParams{
							Interval: stripe.String(interval),
						},
						ProductData: &stripe.CheckoutSessionLineItemPriceDataProductDataParams{
							Name: stripe.String(displayName),
						},
					},
					Quantity: stripe.Int64(1),
				},
			},
			SubscriptionData: &stripe.CheckoutSessionSubscriptionDataParams{
				Metadata: map[string]string{
					"user_id": fmt.Sprintf("%d", userID),
					"plan":    req.Plan,
				},
			},
			Metadata: map[string]string{
				"type":            "subscription",
				"user_id":         fmt.Sprintf("%d", userID),
				"plan":            req.Plan,
				"plan_id":         strconv.Itoa(planID),
				"duration_months": strconv.Itoa(durationMonths),
			},
			SuccessURL: stripe.String(appBase + "/abonnement.php?status=success"),
			CancelURL:  stripe.String(appBase + "/abonnement.php?status=cancel"),
		}

		sess, err := session.New(params)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur Stripe: " + err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":      true,
			"checkout_url": sess.URL,
		})
	}
}

func ShopCheckout(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		stripe.Key = os.Getenv("STRIPE_SECRET_KEY")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		rows, err := database.Query(`
			SELECT p.Id_PRODUCT, p.Name, p.Price, ci.Qty
			FROM cart_item ci
			JOIN product p ON p.Id_PRODUCT = ci.Id_PRODUCT
			WHERE ci.Id_USER = ?
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur panier"})
			return
		}
		defer rows.Close()

		type cartLine struct {
			ProductID int
			Name      string
			Price     float64
			Qty       int
		}
		var lines []cartLine
		for rows.Next() {
			var l cartLine
			if err := rows.Scan(&l.ProductID, &l.Name, &l.Price, &l.Qty); err != nil {
				continue
			}
			lines = append(lines, l)
		}

		if len(lines) == 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Panier vide"})
			return
		}

		totalCents := 0
		for _, l := range lines {
			totalCents += int(math.Round(l.Price*100)) * l.Qty
		}

		res, err := database.Exec(`
			INSERT INTO shop_order (Id_USER, Amount_Total, Status) VALUES (?, ?, 'pending')
		`, userID, totalCents)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur création commande"})
			return
		}
		orderID64, _ := res.LastInsertId()
		orderID := int(orderID64)

		for _, l := range lines {
			priceCents := int(math.Round(l.Price * 100))
			_, _ = database.Exec(`
				INSERT INTO shop_order_item (Id_ORDER, Id_PRODUCT, Name, Price_Cents, Qty)
				VALUES (?, ?, ?, ?, ?)
			`, orderID, l.ProductID, l.Name, priceCents, l.Qty)
		}

		appBase := os.Getenv("APP_BASE_URL")
		if appBase == "" {
			appBase = "http://localhost/PA_2i2/public"
		}

		var lineItems []*stripe.CheckoutSessionLineItemParams
		for _, l := range lines {
			priceCents := int64(math.Round(l.Price * 100))
			name := l.Name
			qty := int64(l.Qty)
			lineItems = append(lineItems, &stripe.CheckoutSessionLineItemParams{
				PriceData: &stripe.CheckoutSessionLineItemPriceDataParams{
					Currency: stripe.String("eur"),
					ProductData: &stripe.CheckoutSessionLineItemPriceDataProductDataParams{
						Name: stripe.String(name),
					},
					UnitAmount: stripe.Int64(priceCents),
				},
				Quantity: stripe.Int64(qty),
			})
		}

		params := &stripe.CheckoutSessionParams{
			PaymentMethodTypes: stripe.StringSlice([]string{"card"}),
			LineItems:          lineItems,
			Mode:               stripe.String("payment"),
			SuccessURL:         stripe.String(appBase + "/boutique.php?status=success"),
			CancelURL:          stripe.String(appBase + "/boutique.php?status=cancel"),
			Metadata: map[string]string{
				"type":     "shop",
				"user_id":  strconv.Itoa(userID),
				"order_id": strconv.Itoa(orderID),
			},
		}

		sess, err := session.New(params)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur Stripe: " + err.Error()})
			return
		}

		_, _ = database.Exec(`UPDATE shop_order SET Stripe_Session_Id = ? WHERE Id_ORDER = ?`, sess.ID, orderID)

		json.NewEncoder(w).Encode(map[string]any{"success": true, "checkout_url": sess.URL})
	}
}

func StripeWebhook(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		body, err := io.ReadAll(r.Body)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		sig := r.Header.Get("Stripe-Signature")
		secret := os.Getenv("STRIPE_WEBHOOK_SECRET")

		event, err := webhook.ConstructEventWithOptions(body, sig, secret,
			webhook.ConstructEventOptions{IgnoreAPIVersionMismatch: true},
		)
		if err != nil {
			fmt.Println("ERREUR SIGNATURE:", err.Error())
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		if event.Type == "checkout.session.completed" {
			var checkoutSess stripe.CheckoutSession
			if err := json.Unmarshal(event.Data.Raw, &checkoutSess); err != nil {
				w.WriteHeader(http.StatusBadRequest)
				return
			}

			typeVal := checkoutSess.Metadata["type"]
			fmt.Println("Webhook reçu, type:", typeVal)

			if typeVal == "subscription" {
				userIDStr := checkoutSess.Metadata["user_id"]
				planIDStr := checkoutSess.Metadata["plan_id"]
				durationStr := checkoutSess.Metadata["duration_months"]

				userID, _ := strconv.Atoi(userIDStr)
				planID, _ := strconv.Atoi(planIDStr)
				duration, _ := strconv.Atoi(durationStr)

				if duration <= 0 {
					duration = 1
				}

				fmt.Println("Subscription webhook: userID=", userID, "planID=", planID, "duration=", duration)

				if userID > 0 && planID > 0 {
					_, _ = database.Exec(
						`UPDATE subscribe SET Is_Active = 0 WHERE Id_USER = ?`,
						userID,
					)

					startDate := time.Now()
					endDate := startDate.AddDate(0, duration, 0)

					var planName2, planDisplayName2 string
					var planPrice2 float64
					_ = database.QueryRow(`SELECT COALESCE(Name,''), COALESCE(Display_Name, Name, ''), COALESCE(Price, 0) FROM subscription_plan WHERE Id_SUBSCRIPTION_PLAN = ?`, planID).Scan(&planName2, &planDisplayName2, &planPrice2)
					planPriceCents2 := int(math.Round(planPrice2 * 100))
					stripeSubIDValue := ""
					if checkoutSess.Subscription != nil { stripeSubIDValue = checkoutSess.Subscription.ID }
					if stripeSubIDValue == "" {
						var rawSess map[string]interface{}
						if err := json.Unmarshal(event.Data.Raw, &rawSess); err == nil {
							if v, ok := rawSess["subscription"]; ok {
								switch t := v.(type) {
								case string:
									stripeSubIDValue = t
								case map[string]interface{}:
									if id, ok := t["id"].(string); ok { stripeSubIDValue = id }
								}
							}
						}
					}
					fmt.Println("Stripe sub ID resolved:", stripeSubIDValue)
					_, err := database.Exec(`
						INSERT INTO subscribe (Id_USER, Id_SUBSCRIPTION_PLAN, Start_Date, End_Date, Is_Active, Plan_Name_Snapshot, Plan_Display_Name_Snapshot, Plan_Price_Cents_Snapshot, Stripe_Subscription_ID)
						VALUES (?, ?, ?, ?, 1, ?, ?, ?, ?)
						ON DUPLICATE KEY UPDATE Start_Date=VALUES(Start_Date), End_Date=VALUES(End_Date), Is_Active=1, Plan_Name_Snapshot=VALUES(Plan_Name_Snapshot), Plan_Display_Name_Snapshot=VALUES(Plan_Display_Name_Snapshot), Plan_Price_Cents_Snapshot=VALUES(Plan_Price_Cents_Snapshot), Stripe_Subscription_ID=VALUES(Stripe_Subscription_ID)
					`, userID, planID, startDate.Format("2006-01-02"), endDate.Format("2006-01-02"), planName2, planDisplayName2, planPriceCents2, stripeSubIDValue)

					if err != nil {
						fmt.Println("Erreur INSERT subscribe:", err.Error())
					} else {
						fmt.Println("Abonnement créé avec succès pour userID:", userID)
					}
				}
			} else if typeVal == "shop" {
				orderIDStr := checkoutSess.Metadata["order_id"]
				userIDStr := checkoutSess.Metadata["user_id"]

				orderID, _ := strconv.Atoi(orderIDStr)
				userID, _ := strconv.Atoi(userIDStr)

				fmt.Println("Shop webhook: orderID=", orderID, "userID=", userID)

				if orderID > 0 {
					_, _ = database.Exec(
						`UPDATE shop_order SET Status = 'paid', Stripe_Session_Id = ? WHERE Id_ORDER = ?`,
						checkoutSess.ID, orderID,
					)
					if userID > 0 {
						_, _ = database.Exec(`DELETE FROM cart_item WHERE Id_USER = ?`, userID)
					}
					fmt.Println("Commande boutique payée:", orderID)
				}
			} else if typeVal == "event" {
				userIDStr := checkoutSess.Metadata["user_id"]
				eventIDStr := checkoutSess.Metadata["event_id"]

				userID, _ := strconv.Atoi(userIDStr)
				eventID, _ := strconv.Atoi(eventIDStr)

				fmt.Println("Event webhook: userID=", userID, "eventID=", eventID)

				if userID > 0 && eventID > 0 {
					_, _ = database.Exec(
						`INSERT IGNORE INTO event_registration (Id_EVENT, Id_USER) VALUES (?, ?)`,
						eventID, userID,
					)

					var title, location string
					var dt time.Time
					row := database.QueryRow(
						`SELECT Title, Location, Event_Date FROM event WHERE Id_EVENT = ? LIMIT 1`,
						eventID,
					)
					if err := row.Scan(&title, &location, &dt); err == nil {
						_, _ = database.Exec(`
							INSERT INTO planning_item (Id_USER, Item_Type, Ref_ID, Title, Start_At, Location, Details)
							VALUES (?, 'event', ?, ?, ?, ?, '')
						`, userID, eventID, title, dt, location)
					}

					fmt.Println("Inscription event confirmée: userID=", userID, "eventID=", eventID)
				}
			}
		}

		w.WriteHeader(http.StatusOK)
	}
}

func GetSeniorSubscription(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifie"})
			return
		}
		var planID int
		var displayName, planName, endDate string
		var priceCentsSnap sql.NullInt64
		var planPrice float64
		var planDuration int
		var isActive int
		var inPeriod int
		err = database.QueryRow(`SELECT s.Id_SUBSCRIPTION_PLAN, COALESCE(s.Plan_Display_Name_Snapshot, sp.Display_Name, sp.Name, ''), COALESCE(sp.Name,''), DATE_FORMAT(s.End_Date, '%d/%m/%Y'), s.Plan_Price_Cents_Snapshot, COALESCE(sp.Price,0), COALESCE(sp.Duration_Months,1), s.Is_Active, CASE WHEN s.End_Date >= CURDATE() THEN 1 ELSE 0 END FROM subscribe s JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN WHERE s.Id_USER = ? AND (s.Is_Active = 1 OR s.End_Date >= CURDATE()) ORDER BY s.Is_Active DESC, s.Start_Date DESC LIMIT 1`, userID).Scan(&planID, &displayName, &planName, &endDate, &priceCentsSnap, &planPrice, &planDuration, &isActive, &inPeriod)
		if err != nil {
			json.NewEncoder(w).Encode(map[string]any{"success": true, "has_subscription": false})
			return
		}
		paidCents := int64(planPrice * 100)
		if priceCentsSnap.Valid && priceCentsSnap.Int64 > 0 { paidCents = priceCentsSnap.Int64 }
		renewalKey := "monthly_renewal"
		if planDuration == 12 { renewalKey = "yearly_renewal" }
		var renewalPrice float64
		var renewalDisplay sql.NullString
		_ = database.QueryRow(`SELECT COALESCE(Price,0), COALESCE(Display_Name, Name) FROM subscription_plan WHERE Name = ?`, renewalKey).Scan(&renewalPrice, &renewalDisplay)
		nextRenewalCents := int64(renewalPrice * 100)
		renewalLabel := ""
		if renewalDisplay.Valid { renewalLabel = renewalDisplay.String }
		statusLabel := "Actif"
		if isActive == 0 { statusLabel = "Desinscrit (jusqu au " + endDate + ")" }
		json.NewEncoder(w).Encode(map[string]any{
			"success": true, "has_subscription": true,
			"name": displayName, "plan_name": planName, "plan_id": planID,
			"status": statusLabel, "end_date": endDate,
			"paid_price_cents": paidCents,
			"next_renewal_price_cents": nextRenewalCents,
			"next_renewal_label": renewalLabel,
			"duration_months": planDuration,
			"is_active": isActive == 1,
			"in_period": inPeriod == 1,
		})
	}
}

func GetSeniorPayments(database *sql.DB) http.HandlerFunc {
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
			COALESCE(s.Plan_Display_Name_Snapshot, sp.Display_Name, sp.Name, '') AS display_name,
			COALESCE(s.Plan_Price_Cents_Snapshot / 100.0, sp.Price, 0) AS price,
			s.Start_Date
		FROM subscribe s
		LEFT JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
		WHERE s.Id_USER = ?
		ORDER BY s.Start_Date DESC
	`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		payments := []map[string]any{}
		for rows.Next() {
			var planName string
			var startDateRaw []byte
			var price float64
			if err := rows.Scan(&planName, &price, &startDateRaw); err != nil { continue }

			startStr := string(startDateRaw)
			displayDate := startStr
			if len(startStr) >= 10 {
				displayDate = startStr[8:10] + "/" + startStr[5:7] + "/" + startStr[0:4]
			}

			payments = append(payments, map[string]any{
				"type_label":   planName,
				"amount_euros": price,
				"date":         displayDate,
			})
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "payments": payments})
	}
}

func EventCheckout(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req struct {
			EventID int `json:"event_id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.EventID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "event_id invalide"})
			return
		}

		var title string
		var price float64
		row := database.QueryRow(`SELECT Title, COALESCE(Price, 0) FROM event WHERE Id_EVENT = ? LIMIT 1`, req.EventID)
		if err := row.Scan(&title, &price); err != nil || price <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Événement introuvable ou gratuit"})
			return
		}

		stripe.Key = os.Getenv("STRIPE_SECRET_KEY")

		appBase := os.Getenv("APP_BASE_URL")
		if appBase == "" {
			appBase = "http://localhost/PA_2i2/public"
		}

		userIDStr := strconv.Itoa(userID)
		eventIDStr := strconv.Itoa(req.EventID)

		params := &stripe.CheckoutSessionParams{
			PaymentMethodTypes: stripe.StringSlice([]string{"card"}),
			LineItems: []*stripe.CheckoutSessionLineItemParams{
				{
					PriceData: &stripe.CheckoutSessionLineItemPriceDataParams{
						Currency: stripe.String("eur"),
						ProductData: &stripe.CheckoutSessionLineItemPriceDataProductDataParams{
							Name: stripe.String("Événement : " + title),
						},
						UnitAmount: stripe.Int64(int64(math.Round(price * 100))),
					},
					Quantity: stripe.Int64(1),
				},
			},
			Mode:       stripe.String("payment"),
			SuccessURL: stripe.String(appBase + "/catalogue-evenements.php?status=success&event_id=" + eventIDStr),
			CancelURL:  stripe.String(appBase + "/catalogue-evenements.php?status=cancel"),
			Metadata: map[string]string{
				"type":     "event",
				"user_id":  userIDStr,
				"event_id": eventIDStr,
			},
		}

		sess, err := session.New(params)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur Stripe: " + err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{"success": true, "checkout_url": sess.URL})
	}
}
