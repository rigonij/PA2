package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"

	"github.com/PA_2i2/api/middleware"
	"github.com/PA_2i2/api/routes"
)

func main() {
	dbHost := getenv("DB_HOST", "localhost")
	dbPort := getenv("DB_PORT", "3306")
	dbUser := getenv("DB_USER", "root")
	dbPass := getenv("DB_PASS", "root")
	dbName := getenv("DB_NAME", "projet_annuel")
	apiPort := getenv("API_PORT", "8080")

	bdd := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?parseTime=true&loc=Local&charset=utf8mb4",
		dbUser, dbPass, dbHost, dbPort, dbName,
	)

	database, err := sql.Open("mysql", bdd)
	if err != nil {
		log.Fatal("Impossible d'ouvrir la connexion MySQL:", err)
	}
	defer database.Close()

	if err := database.Ping(); err != nil {
		log.Fatal("Impossible de joindre la base de données:", err)
	}
	log.Println("Connecté à la base de données MySQL")

	mux := http.NewServeMux()

	mux.HandleFunc("/api/health", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintln(w, `{"success":true,"message":"API opérationnelle"}`)
	}))

	mux.HandleFunc("/api/auth/signup", middleware.CORS(routes.Signup(database)))
	mux.HandleFunc("/api/auth/signin", middleware.CORS(routes.Signin(database)))

	mux.HandleFunc("/api/events", middleware.CORS(routes.GetEvents(database)))
	mux.HandleFunc("/api/events/subscribe", middleware.CORS(routes.SubscribeEvent(database)))
	mux.HandleFunc("/api/events/unsubscribe", middleware.CORS(routes.UnsubscribeEvent(database)))
	mux.HandleFunc("/api/events/detail", middleware.CORS(routes.GetEventDetail(database)))
	mux.HandleFunc("/api/events/checkout", middleware.CORS(routes.EventCheckout(database)))

	mux.HandleFunc("/api/planning", middleware.CORS(routes.GetPlanning(database)))

	mux.HandleFunc("/api/services/reserve", middleware.CORS(routes.ReserveService(database)))
	mux.HandleFunc("/api/services/unreserve", middleware.CORS(routes.UnreserveService(database)))
	mux.HandleFunc("/api/services", middleware.CORS(routes.GetServicesCatalog(database)))

	mux.HandleFunc("/api/medical", middleware.CORS(routes.GetMedical(database)))
	mux.HandleFunc("/api/medical/create", middleware.CORS(routes.CreateMedical(database)))
	mux.HandleFunc("/api/medical/delete", middleware.CORS(routes.DeleteMedical(database)))
	mux.HandleFunc("/api/medical/doctors", middleware.CORS(routes.GetMedicalDoctors(database)))

	mux.HandleFunc("/api/shop/products", middleware.CORS(routes.GetProducts(database)))
	mux.HandleFunc("/api/cart", middleware.CORS(routes.GetCart(database)))
	mux.HandleFunc("/api/cart/add", middleware.CORS(routes.AddToCart(database)))
	mux.HandleFunc("/api/cart/decrement", middleware.CORS(routes.DecrementCart(database)))
	mux.HandleFunc("/api/cart/clear", middleware.CORS(routes.ClearCart(database)))

	mux.HandleFunc("/api/advice", middleware.CORS(routes.GetAdviceList(database)))
	mux.HandleFunc("/api/advice/", middleware.CORS(routes.GetAdviceDetail(database)))
	mux.HandleFunc("/api/admin/advice/create", middleware.CORS(routes.CreateAdvice(database)))
	mux.HandleFunc("/api/admin/advice/update", middleware.CORS(routes.UpdateAdvice(database)))
	mux.HandleFunc("/api/admin/advice/delete", middleware.CORS(routes.DeleteAdvice(database)))

	mux.HandleFunc("/api/provider/senior-info", middleware.CORS(routes.GetProviderSeniorInfo(database)))

	mux.HandleFunc("/api/me", middleware.CORS(
		middleware.AuthRequired(database, func(w http.ResponseWriter, r *http.Request) {
			switch r.Method {
			case http.MethodGet:
				routes.GetProfile(database)(w, r)
			case http.MethodPut:
				routes.UpdateProfile(database)(w, r)
			default:
				w.WriteHeader(http.StatusMethodNotAllowed)
			}
		}),
	))

	mux.HandleFunc("/api/admin/auth/signup", middleware.CORS(routes.AdminSignup(database)))
	mux.HandleFunc("/api/admin/auth/signin", middleware.CORS(routes.AdminSignin(database)))
	mux.HandleFunc("/api/admin/users", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			routes.AdminGetUser(database)(w, r)
			return
		}
		w.WriteHeader(http.StatusMethodNotAllowed)
	}))

	mux.HandleFunc("/api/admin/user/", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case http.MethodGet:
			routes.AdminGetUserByID(database)(w, r)
		case http.MethodPut:
			routes.AdminUpdateUser(database)(w, r)
		case http.MethodDelete:
			routes.AdminDeleteUser(database)(w, r)
		default:
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))

	mux.HandleFunc("/api/admin/providers", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			routes.AdminGetProviders(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/admin/providers/", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPut {
			routes.AdminValidateProvider(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/admin/seniors", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			routes.AdminGetSeniors(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/admin/seniors/", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodDelete {
			routes.AdminDeleteSenior(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/admin/events", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			routes.AdminGetEvents(database)(w, r)
		} else if r.Method == http.MethodPost {
			routes.AdminCreateEvent(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))
	mux.HandleFunc("/api/admin/events/", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodPut {
			routes.AdminUpdateEvent(database)(w, r)
		} else if r.Method == http.MethodDelete {
			routes.AdminDeleteEvent(database)(w, r)
		} else {
			w.WriteHeader(http.StatusMethodNotAllowed)
		}
	}))

	mux.HandleFunc("/api/admin/events/history", middleware.CORS(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodDelete {
			routes.AdminClearEventHistory(database)(w, r)
			return
		}
		w.WriteHeader(http.StatusMethodNotAllowed)
	}))

	mux.HandleFunc("/api/admin/events/registrations/", middleware.CORS(routes.AdminGetEventRegistrations(database)))

	mux.HandleFunc("/api/admin/ban", middleware.CORS(routes.BanUser(database)))
	mux.HandleFunc("/api/admin/unban", middleware.CORS(routes.UnbanUser(database)))

	mux.HandleFunc("GET /api/provider/me", middleware.CORS(routes.GetProviderMe(database)))
	mux.HandleFunc("PUT /api/provider/me", middleware.CORS(routes.UpdateProviderMe(database)))

	mux.HandleFunc("/api/provider/planning", middleware.CORS(routes.GetProviderPlanning(database)))

	mux.HandleFunc("/api/provider/schedule", middleware.CORS(routes.ProviderSchedule(database)))
	mux.HandleFunc("/api/provider/schedule/", middleware.CORS(routes.ProviderSchedule(database)))

	mux.HandleFunc("/api/provider/absence", middleware.CORS(routes.ProviderAbsence(database)))
	mux.HandleFunc("/api/provider/absence/", middleware.CORS(routes.ProviderAbsence(database)))

	mux.HandleFunc("/api/provider/service-types", middleware.CORS(routes.ProviderGetServiceTypes(database)))
	mux.HandleFunc("/api/provider/services", middleware.CORS(routes.ProviderServices(database)))
	mux.HandleFunc("/api/provider/services/", middleware.CORS(routes.ProviderServiceByID(database)))

	mux.HandleFunc("/api/provider/service-schedules/", middleware.CORS(routes.ProviderServiceSchedules(database)))

	mux.HandleFunc("/api/services/available-slots", middleware.CORS(routes.GetAvailableServiceSlots(database)))

	mux.HandleFunc("/api/provider/interventions", middleware.CORS(routes.GetProviderInterventions(database)))
	mux.HandleFunc("GET /api/provider/interventions/new-count", middleware.CORS(routes.GetProviderInterventionsNewCount(database)))
	mux.HandleFunc("/api/provider/interventions/approve", middleware.CORS(routes.ApproveIntervention(database)))
	mux.HandleFunc("POST /api/provider/interventions/history/clear", middleware.CORS(routes.ClearProviderHistory(database)))

	mux.HandleFunc("GET /api/messages", middleware.CORS(routes.GetConversations(database)))
	mux.HandleFunc("GET /api/messages/{user_id}", middleware.CORS(routes.GetMessages(database)))
	mux.HandleFunc("POST /api/messages/send", middleware.CORS(routes.SendMessage(database)))

	mux.HandleFunc("POST /api/stripe/subscribe", middleware.CORS(routes.CreateSubscriptionCheckout(database)))
	mux.HandleFunc("POST /api/stripe/webhook", middleware.CORS(routes.StripeWebhook(database)))

	mux.HandleFunc("GET /api/senior/subscription", middleware.CORS(routes.GetSeniorSubscription(database)))
	mux.HandleFunc("GET /api/senior/payments", middleware.CORS(routes.GetSeniorPayments(database)))

	mux.HandleFunc("/api/stripe/checkout/shop", middleware.CORS(routes.ShopCheckout(database)))

	mux.HandleFunc("/api/stripe/checkout/event", middleware.CORS(routes.EventCheckout(database)))

	mux.HandleFunc("/api/provider/finances", middleware.CORS(routes.GetProviderFinances(database)))

	mux.HandleFunc("GET /api/senior/orders", middleware.CORS(routes.GetSeniorOrders(database)))

	mux.HandleFunc("GET /api/admin/stats", middleware.CORS(routes.GetAdminStats(database)))

	mux.HandleFunc("GET /api/admin/payments", middleware.CORS(routes.GetAdminPayments(database)))

	mux.HandleFunc("GET /api/admin/payment-detail", middleware.CORS(routes.GetAdminPaymentDetail(database)))

	mux.HandleFunc("GET /api/provider/invoices", middleware.CORS(routes.GetProviderInvoices(database)))

	mux.HandleFunc("GET /api/provider/invoice/{id}", middleware.CORS(routes.GetProviderInvoiceDetail(database)))

	mux.HandleFunc("/api/senior/invoices", middleware.CORS(routes.GetSeniorInvoices(database)))
	mux.HandleFunc("/api/senior/invoice", middleware.CORS(routes.GetSeniorInvoiceDetail(database)))
	mux.HandleFunc("/api/senior/invoice/pdf", routes.GetSeniorInvoicePDF(database))

	mux.HandleFunc("/api/providers", middleware.CORS(routes.GetProvidersCatalog(database)))

	mux.HandleFunc("/api/provider/document", middleware.CORS(routes.UploadProviderDocument(database)))
	mux.HandleFunc("/api/provider/document/me", middleware.CORS(routes.GetMyProviderDocument(database)))
	mux.HandleFunc("/api/admin/providers/pending", middleware.CORS(routes.AdminGetPendingProviders(database)))
	mux.HandleFunc("/api/admin/providers/document/", middleware.CORS(routes.AdminDownloadProviderDocument(database)))
	mux.HandleFunc("/api/admin/providers/validate", middleware.CORS(routes.AdminValidateProvider(database)))
	mux.HandleFunc("/api/admin/provider-authorized-services/", middleware.CORS(routes.AdminGetProviderAuthorizedServices(database)))
	mux.HandleFunc("/api/admin/provider-validate-with-services", middleware.CORS(routes.AdminValidateProviderWithServices(database)))
	mux.HandleFunc("/api/admin/provider-services", middleware.CORS(routes.AdminProviderServices(database)))

	mux.HandleFunc("/api/providers/", middleware.CORS(routes.ProviderReviews(database)))
	mux.HandleFunc("/api/senior/reviews", middleware.CORS(routes.SeniorReviews(database)))

	mux.HandleFunc("GET /api/provider/reviews", middleware.CORS(routes.ProviderMyReviews(database)))
	mux.HandleFunc("POST /api/provider/reviews/report", middleware.CORS(routes.ProviderReportReview(database)))
	mux.HandleFunc("GET /api/admin/review-reports", middleware.CORS(routes.AdminReviewReports(database)))
	mux.HandleFunc("/api/admin/review-reports/", middleware.CORS(routes.AdminUpdateReviewReport(database)))
	mux.HandleFunc("/api/admin/reviews/", middleware.CORS(routes.AdminDeleteReview(database)))

	mux.HandleFunc("/api/user/report", middleware.CORS(routes.UserReport(database)))
	mux.HandleFunc("/api/admin/user-reports", middleware.CORS(routes.AdminUserReports(database)))
	mux.HandleFunc("/api/admin/user-reports/resolve", middleware.CORS(routes.AdminResolveUserReport(database)))
	mux.HandleFunc("/api/admin/user-sanctions/", middleware.CORS(routes.AdminGetUserSanctions(database)))
	mux.HandleFunc("/api/me/pending-sanction", middleware.CORS(routes.MyPendingSanction(database)))
	mux.HandleFunc("/api/me/acknowledge-sanction", middleware.CORS(routes.AcknowledgeSanction(database)))

	mux.HandleFunc("GET /api/provider/invoice/{id}/pdf", routes.GetProviderInvoicePDF(database))

	mux.HandleFunc("/api/services/details", middleware.CORS(routes.GetServiceDetails(database)))

	mux.HandleFunc("/api/planning/clear-history", middleware.CORS(routes.ClearPlanningHistory(database)))

	addr := ":" + apiPort
	log.Printf("API démarrée sur http://localhost%s", addr)
	log.Println("  POST /api/auth/signup")
	log.Println("  POST /api/auth/signin")
	log.Println("  GET/PUT /api/me")

	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatal("Erreur démarrage serveur:", err)
	}
}

func getenv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
