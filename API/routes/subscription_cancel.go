package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/PA_2i2/api/lib"
)

func CancelSubscription(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifie"})
			return
		}

		var stripeSubID sql.NullString
		err = database.QueryRow(`
			SELECT Stripe_Subscription_ID
			FROM subscribe
			WHERE Id_USER = ? AND Is_Active = 1
			ORDER BY Start_Date DESC
			LIMIT 1
		`, userID).Scan(&stripeSubID)

		if err != nil {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Aucun abonnement actif"})
			return
		}

		if stripeSubID.Valid && stripeSubID.String != "" {
			secret := os.Getenv("STRIPE_SECRET_KEY")
			form := url.Values{}
			form.Set("cancel_at_period_end", "true")
			req, _ := http.NewRequest("POST",
				"https://api.stripe.com/v1/subscriptions/"+stripeSubID.String,
				strings.NewReader(form.Encode()))
			req.Header.Set("Authorization", "Bearer "+secret)
			req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
			resp, err := http.DefaultClient.Do(req)
			if err == nil {
				resp.Body.Close()
			}
		}

		_, _ = database.Exec(`UPDATE subscribe SET Is_Active = 0 WHERE Id_USER = ? AND Is_Active = 1`, userID)

		json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Desinscription enregistree"})
	}
}
