package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
)

func GetAdminStats(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		stats := map[string]any{}

		var totalSeniors int
		database.QueryRow(`SELECT COUNT(*) FROM senior`).Scan(&totalSeniors)
		stats["total_seniors"] = totalSeniors

		var totalProviders int
		database.QueryRow(`SELECT COUNT(*) FROM provider WHERE Validation_Status = 1`).Scan(&totalProviders)
		stats["total_providers"] = totalProviders
		stats["total_users"] = totalSeniors + totalProviders

		var totalInterventions int
		database.QueryRow(`SELECT COUNT(*) FROM intervention`).Scan(&totalInterventions)
		stats["total_interventions"] = totalInterventions

		var pendingInterventions int
		database.QueryRow(`SELECT COUNT(*) FROM intervention WHERE Status = 'Pending'`).Scan(&pendingInterventions)
		stats["pending_interventions"] = pendingInterventions

		var activeSubscriptions int
		database.QueryRow(`SELECT COUNT(*) FROM subscribe WHERE Is_Active = 1`).Scan(&activeSubscriptions)
		stats["active_subscriptions"] = activeSubscriptions

		var shopRevenueCents int
		database.QueryRow(`SELECT COALESCE(SUM(Amount_Total), 0) FROM shop_order WHERE Status = 'paid'`).Scan(&shopRevenueCents)
		stats["shop_revenue_cents"] = shopRevenueCents

		var shopOrders int
		database.QueryRow(`SELECT COUNT(*) FROM shop_order WHERE Status = 'paid'`).Scan(&shopOrders)
		stats["shop_orders"] = shopOrders

		var totalEvents int
		database.QueryRow(`SELECT COUNT(*) FROM event`).Scan(&totalEvents)
		stats["total_events"] = totalEvents

		var totalEventRegistrations int
		database.QueryRow(`SELECT COUNT(*) FROM event_registration`).Scan(&totalEventRegistrations)
		stats["total_event_registrations"] = totalEventRegistrations

		var pendingServices int
		database.QueryRow(`SELECT COUNT(*) FROM qualify WHERE Validation_Status = 0`).Scan(&pendingServices)
		stats["pending_services"] = pendingServices

		var pendingProviders int
		database.QueryRow(`SELECT COUNT(*) FROM provider WHERE Validation_Status = 0`).Scan(&pendingProviders)
		stats["pending_providers"] = pendingProviders

		var subscriptionRevenueFloat float64
		database.QueryRow(`
			SELECT COALESCE(SUM(sp.Price * 100), 0)
			FROM subscribe s
			JOIN subscription_plan sp ON sp.Id_SUBSCRIPTION_PLAN = s.Id_SUBSCRIPTION_PLAN
		`).Scan(&subscriptionRevenueFloat)
		subscriptionRevenueCents := int(subscriptionRevenueFloat)

		stats["subscription_revenue_cents"] = subscriptionRevenueCents
		stats["total_revenue_cents"] = shopRevenueCents + subscriptionRevenueCents

		json.NewEncoder(w).Encode(map[string]any{"success": true, "stats": stats})
	}
}
