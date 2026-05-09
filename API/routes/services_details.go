package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/PA_2i2/api/lib"
)

func GetServiceDetails(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		serviceTypeID, _ := strconv.Atoi(r.URL.Query().Get("service_type_id"))
		providerID, _ := strconv.Atoi(r.URL.Query().Get("provider_id"))
		if serviceTypeID <= 0 || providerID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}

		var serviceName, categoryName string
		var defaultPrice float64
		var customTitle sql.NullString
		var negotiatedPrice sql.NullFloat64
		var experienceYears sql.NullInt64
		var qualifyValid, qualifyActive int

		err = database.QueryRow(`
			SELECT st.Name, c.Name, st.Default_Hourly_Price,
				q.Custom_Title, q.Negotiated_Price, q.Experience_Years,
				COALESCE(q.Validation_Status, 0), COALESCE(q.Is_Active, 0)
			FROM qualify q
			JOIN service_type st ON st.Id_SERVICE_TYPE = q.Id_SERVICE_TYPE
			JOIN category c ON c.Id_CATEGORY = st.Id_CATEGORY
			WHERE q.Id_USER = ? AND q.Id_SERVICE_TYPE = ?
			LIMIT 1
		`, providerID, serviceTypeID).Scan(
			&serviceName, &categoryName, &defaultPrice,
			&customTitle, &negotiatedPrice, &experienceYears,
			&qualifyValid, &qualifyActive,
		)
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service introuvable"})
			return
		}
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur SQL: " + err.Error()})
			return
		}

		if qualifyValid != 1 || qualifyActive != 1 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service non disponible"})
			return
		}

		var companyName string
		var providerDesc sql.NullString
		var providerValid sql.NullInt64
		var prenom, nom sql.NullString

		err = database.QueryRow(`
			SELECT p.Company_Name, p.Provider_Description, p.Validation_Status,
				u.Prenom, u.Nom
			FROM provider p
			JOIN user u ON u.Id_USER = p.Id_USER
			WHERE p.Id_USER = ?
			LIMIT 1
		`, providerID).Scan(&companyName, &providerDesc, &providerValid, &prenom, &nom)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur prestataire: " + err.Error()})
			return
		}

		if !providerValid.Valid || providerValid.Int64 != 1 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Prestataire non disponible"})
			return
		}

		var ratingAvg sql.NullFloat64
		var ratingCount int
		err = database.QueryRow(`
			SELECT ROUND(AVG(Rating), 1), COUNT(*)
			FROM review
			WHERE Id_PROVIDER = ?
		`, providerID).Scan(&ratingAvg, &ratingCount)
		if err != nil {
			ratingCount = 0
		}

		rows, err := database.Query(`
			SELECT r.Rating, COALESCE(r.Comment, ''), r.Created_At,
				COALESCE(u.Prenom, ''), COALESCE(u.Nom, '')
			FROM review r
			JOIN user u ON u.Id_USER = r.Id_SENIOR
			WHERE r.Id_PROVIDER = ?
			ORDER BY r.Created_At DESC
			LIMIT 10
		`, providerID)
		reviews := []map[string]any{}
		if err == nil {
			defer rows.Close()
			for rows.Next() {
				var rating int
				var comment, createdAt, rPrenom, rNom string
				if err := rows.Scan(&rating, &comment, &createdAt, &rPrenom, &rNom); err != nil {
					continue
				}
				author := rPrenom
				if rNom != "" {
					author = rPrenom + " " + string([]rune(rNom)[0]) + "."
				}
				if author == "" {
					author = "Anonyme"
				}
				reviews = append(reviews, map[string]any{
					"author":     author,
					"rating":     rating,
					"comment":    comment,
					"created_at": createdAt,
				})
			}
		}

		finalPrice := defaultPrice
		if negotiatedPrice.Valid {
			finalPrice = negotiatedPrice.Float64
		}

		avgValue := 0.0
		if ratingAvg.Valid {
			avgValue = ratingAvg.Float64
		}

		expValue := 0
		if experienceYears.Valid {
			expValue = int(experienceYears.Int64)
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success": true,
			"service": map[string]any{
				"id":               serviceTypeID,
				"name":             serviceName,
				"category":         categoryName,
				"custom_title":     customTitle.String,
				"price":            finalPrice,
				"experience_years": expValue,
			},
			"provider": map[string]any{
				"id":           providerID,
				"company_name": companyName,
				"prenom":       prenom.String,
				"nom":          nom.String,
				"description":  providerDesc.String,
			},
			"stats": map[string]any{
				"rating_avg":   avgValue,
				"rating_count": ratingCount,
			},
			"reviews": reviews,
		})
	}
}
