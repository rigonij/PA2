package routes

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/PA_2i2/api/lib"
	"golang.org/x/crypto/bcrypt"
)

func isAdmin(database *sql.DB, token string) (bool, error) {
	if token == "" {
		return false, nil
	}
	row := database.QueryRow(`
		SELECT a.Id_USER FROM admin a
		JOIN user u ON a.Id_USER = u.Id_USER
		WHERE u.authentication_token = ?`, token)
	var id int
	err := row.Scan(&id)
	if err == sql.ErrNoRows {
		return false, nil
	}
	return err == nil, err
}

func requireAdmin(database *sql.DB, w http.ResponseWriter, r *http.Request) bool {
	token := r.Header.Get("X-Token")
	ok, err := isAdmin(database, token)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur serveur"})
		return false
	}
	if !ok {
		w.WriteHeader(http.StatusForbidden)
		json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Accès refusé – admin requis"})
		return false
	}
	return true
}

type AdminSignupRequest struct {
	Email        string `json:"email"`
	Role         string `json:"role"`
	Password     string `json:"password"`
	Confirmation string `json:"confirmation"`
	Nom          string `json:"nom"`
	Prenom       string `json:"prenom"`
	PhoneNumber  string `json:"phone_number"`
	BirthDate    string `json:"birth_date"`
}

type AdminSignupResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}

func AdminSignup(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		var req AdminSignupRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Le corp de la requête est invalide, changez le donc très cher : " + err.Error()})
			return
		}

		if req.Email == "" || req.Password == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Email et mot de passe obligatoires"})
			return
		}

		if req.Password != req.Confirmation {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Les mots de passe ne correspondent pas"})
			return
		}

		hashedBytes, err := bcrypt.GenerateFromPassword([]byte(req.Password), 10)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Erreur lors du hachage du mot de passe"})
			return
		}

		stmt, err := database.Prepare("INSERT INTO user(Email, Password, Nom, Prenom, Phone_Number) VALUES(?, ?, ?, ?, ?)")
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Erreur SQL: " + err.Error()})
			return
		}
		defer stmt.Close()

		result, err := stmt.Exec(req.Email, string(hashedBytes), req.Nom, req.Prenom, req.PhoneNumber)
		if err != nil {
			w.WriteHeader(http.StatusConflict)
			json.NewEncoder(w).Encode(AdminSignupResponse{Success: false, Message: "Email déjà utilisé ou erreur d'insertion"})
			return
		}

		userID, _ := result.LastInsertId()

		if req.Role == "admin" {
			query := "INSERT INTO admin(Id_USER) VALUES(?)"
			_, err = database.Exec(query, userID)
			if err != nil {
				log.Println("Erreur création profil admin:", err)
			}

		}

		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(AdminSignupResponse{Success: true, Message: "Inscription admin réussie"})
	}
}

func AdminSignin(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		var req struct {
			Email    string `json:"email"`
			Password string `json:"password"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Corps invalide"})
			return
		}

		row := database.QueryRow(`
			SELECT u.Id_USER, u.Password
			FROM user u
			JOIN admin a ON u.Id_USER = a.Id_USER
			WHERE u.Email = ?`, req.Email)

		var userID int
		var hashedPassword string
		if err := row.Scan(&userID, &hashedPassword); err == sql.ErrNoRows {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Identifiants incorrects ou compte non admin"})
			return
		} else if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur serveur"})
			return
		}

		if err := lib.CheckPassword(hashedPassword, req.Password); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Identifiants incorrects"})
			return
		}

		token, err := lib.GenerateToken()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur génération token"})
			return
		}
		_, err = database.Exec("UPDATE user SET authentication_token = ? WHERE Id_USER = ?", token, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur sauvegarde token"})
			return
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "token": token, "message": "Connexion admin réussie"})
	}
}

func AdminGetStats(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		stats := map[string]int{"total_users": 0, "total_seniors": 0, "total_providers": 0, "pending_providers": 0}
		queries := []struct{ key, query string }{
			{"total_users", "SELECT COUNT(*) FROM user"},
			{"total_seniors", "SELECT COUNT(*) FROM senior"},
			{"total_providers", "SELECT COUNT(*) FROM provider"},
			{"pending_providers", "SELECT COUNT(*) FROM provider WHERE Validation_Status = 0"},
		}
		for _, q := range queries {
			var count int
			if err := database.QueryRow(q.query).Scan(&count); err == nil {
				stats[q.key] = count
			}
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "stats": stats})
	}
}

func AdminGetUser(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		rows, err := database.Query(`
			SELECT u.Id_USER,
			       COALESCE(u.Email,''),
			       COALESCE(u.Address_City,''),
			       COALESCE(u.Nom,''),
			       COALESCE(u.Prenom,''),
			       COALESCE(u.Phone_Number,''),
			       CASE WHEN p.Id_USER IS NOT NULL THEN 'Prestataire'
			            WHEN s.Id_USER IS NOT NULL THEN 'Senior'
			            WHEN a.Id_USER IS NOT NULL THEN 'Admin'
			            ELSE 'Utilisateur Basic' END AS user_type,
			       u.Is_Banned
			FROM user u
			LEFT JOIN provider p ON u.Id_USER = p.Id_USER
			LEFT JOIN senior   s ON u.Id_USER = s.Id_USER
			LEFT JOIN admin    a ON u.Id_USER = a.Id_USER
			ORDER BY u.Id_USER DESC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		type UserRow struct {
			ID          int    `json:"id"`
			Email       string `json:"email"`
			AddressCity string `json:"address_city"`
			Nom         string `json:"nom"`
			Prenom      string `json:"prenom"`
			PhoneNumber string `json:"phone_number"`
			UserType    string `json:"user_type"`
			IsBanned    bool   `json:"is_banned"`
		}

		users := []UserRow{}
		for rows.Next() {
			var u UserRow
			var banned int
			if err := rows.Scan(&u.ID, &u.Email, &u.AddressCity, &u.Nom, &u.Prenom, &u.PhoneNumber, &u.UserType, &banned); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
				return
			}
			u.IsBanned = banned == 1
			users = append(users, u)
		}

		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "users": users})
	}
}

func AdminGetUserByID(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		log.Println("HIT AdminGetUserByID", r.URL.Path)

		idStr := strings.TrimPrefix(r.URL.Path, "/api/admin/user/")
		idStr = strings.Trim(idStr, "/")
		id, err := strconv.Atoi(idStr)

		if idStr == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID manquant"})
			return
		}

		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}

		var u struct {
			ID          int    `json:"id"`
			Email       string `json:"email"`
			Nom         string `json:"nom"`
			Prenom      string `json:"prenom"`
			PhoneNumber string `json:"phone_number"`
			AddressCity string `json:"address_city"`
			IsBanned    bool   `json:"is_banned"`
		}
		var banned int
		err = database.QueryRow(`
            SELECT Id_USER, COALESCE(Email,''), COALESCE(Nom,''), COALESCE(Prenom,''),
                   COALESCE(Phone_Number,''), COALESCE(Address_City,''), Is_Banned
            FROM user WHERE Id_USER = ?`, id).Scan(
			&u.ID, &u.Email, &u.Nom, &u.Prenom, &u.PhoneNumber, &u.AddressCity, &banned)
		if err != nil {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Utilisateur introuvable"})
			return
		}
		u.IsBanned = banned == 1

		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "user": u})
	}
}

func AdminUpdateUser(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		parts := strings.Split(strings.TrimSuffix(r.URL.Path, "/"), "/")
		id, err := strconv.Atoi(parts[len(parts)-1])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}

		var req struct {
			Email       string `json:"email"`
			Nom         string `json:"nom"`
			Prenom      string `json:"prenom"`
			PhoneNumber string `json:"phone_number"`
			AddressCity string `json:"address_city"`
			Password    string `json:"password"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Corps invalide"})
			return
		}

		_, err = database.Exec(`
            UPDATE user SET Email = ?, Nom = ?, Prenom = ?, Phone_Number = ?, Address_City = ?
            WHERE Id_USER = ?`,
			req.Email, req.Nom, req.Prenom, req.PhoneNumber, req.AddressCity, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur mise à jour: " + err.Error()})
			return
		}

		if req.Password != "" {
			hashed, err := bcrypt.GenerateFromPassword([]byte(req.Password), 10)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur hachage mot de passe"})
				return
			}
			_, err = database.Exec("UPDATE user SET Password = ? WHERE Id_USER = ?", string(hashed), id)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Erreur mise à jour mot de passe"})
				return
			}
		}

		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Utilisateur modifié"})
	}
}

func AdminDeleteUser(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		parts := strings.Split(strings.TrimSuffix(r.URL.Path, "/"), "/")
		id, err := strconv.Atoi(parts[len(parts)-1])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		if _, err = database.Exec("DELETE FROM user WHERE Id_USER = ?", id); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Utilisateur supprimé"})
	}
}

func AdminDeleteSenior(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		parts := strings.Split(strings.TrimSuffix(r.URL.Path, "/"), "/")
		id, err := strconv.Atoi(parts[len(parts)-1])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		if _, err = database.Exec("DELETE FROM user WHERE Id_USER = ?", id); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Senior supprimé"})
	}
}

func AdminGetProviders(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		rows, err := database.Query(`
			SELECT u.Id_USER,
			       COALESCE(u.Prenom,''),
			       COALESCE(u.Nom,''),
			       COALESCE(u.Email,''),
			       COALESCE(u.Phone_Number,''),
			       COALESCE(u.Address_Street,''),
			       COALESCE(u.Address_City,''),
			       COALESCE(u.Address_Zip,''),
			       COALESCE(p.Company_Name,''),
			       COALESCE(p.SIRET_Number,''),
			       p.Validation_Status
			FROM user u JOIN provider p ON u.Id_USER = p.Id_USER
			ORDER BY p.Validation_Status ASC, u.Id_USER DESC`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		type ProviderRow struct {
			ID               int    `json:"id"`
			Prenom           string `json:"prenom"`
			Nom              string `json:"nom"`
			Email            string `json:"email"`
			PhoneNumber      string `json:"phone_number"`
			AddressStreet    string `json:"address_street"`
			AddressCity      string `json:"address_city"`
			AddressZip       string `json:"address_zip"`
			CompanyName      string `json:"company_name"`
			SIRET            string `json:"siret"`
			ValidationStatus int    `json:"validation_status"`
		}
		var providers []ProviderRow
		for rows.Next() {
			var p ProviderRow
			if err := rows.Scan(&p.ID, &p.Prenom, &p.Nom, &p.Email, &p.PhoneNumber, &p.AddressStreet, &p.AddressCity, &p.AddressZip, &p.CompanyName, &p.SIRET, &p.ValidationStatus); err == nil {
				providers = append(providers, p)
			}
		}
		if providers == nil {
			providers = []ProviderRow{}
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "providers": providers})
	}
}

func AdminValidateProvider(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
		if len(parts) < 4 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		id, err := strconv.Atoi(parts[3])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		var body struct {
			Status int `json:"status"`
		}
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil || body.Status == 0 {
			body.Status = 1
		}
		if _, err = database.Exec("UPDATE provider SET Validation_Status = ? WHERE Id_USER = ?", body.Status, id); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		msg := "Prestataire validé"
		if body.Status == 2 {
			msg = "Prestataire refusé"
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": msg})
	}
}

func AdminGetSeniors(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		rows, err := database.Query(`
			SELECT u.Id_USER,
				COALESCE(u.Email,''),
				COALESCE(u.Phone_Number,''),
				COALESCE(u.Address_City,''),
				COALESCE(CAST(s.Birth_Date AS CHAR),''),
				COALESCE(u.Prenom,''),
				COALESCE(u.Nom,'')
			FROM user u
			JOIN senior s ON u.Id_USER = s.Id_USER
			ORDER BY u.Id_USER DESC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		type SeniorRow struct {
			ID          int    `json:"id"`
			Email       string `json:"email"`
			PhoneNumber string `json:"phone_number"`
			AddressCity string `json:"address_city"`
			BirthDate   string `json:"birth_date"`
			Prenom      string `json:"prenom"`
			Nom         string `json:"nom"`
		}
		var seniors []SeniorRow
		for rows.Next() {
			var s SeniorRow
			if err := rows.Scan(
				&s.ID,
				&s.Email,
				&s.PhoneNumber,
				&s.AddressCity,
				&s.BirthDate,
				&s.Prenom,
				&s.Nom,
			); err == nil {
				seniors = append(seniors, s)
			}
		}
		if seniors == nil {
			seniors = []SeniorRow{}
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "seniors": seniors})
	}
}

func AdminGetEvents(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		rows, err := database.Query(`
			SELECT e.Id_EVENT, COALESCE(e.Title,''), COALESCE(e.Location,''),
				COALESCE(CAST(e.Event_Date AS CHAR),''), COALESCE(e.Max_Participants, 0),
				COALESCE(e.Price, 0),
				(SELECT COUNT(*) FROM event_registration er WHERE er.Id_EVENT = e.Id_EVENT) AS registered_count
			FROM event e ORDER BY e.Event_Date DESC`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		type EventRow struct {
			ID              int     `json:"id"`
			Title           string  `json:"title"`
			Location        string  `json:"location"`
			EventDate       string  `json:"event_date"`
			MaxParticipants int     `json:"max_participants"`
			Price           float64 `json:"price"`
			RegisteredCount int     `json:"registered_count"`
		}
		var events []EventRow
		for rows.Next() {
			var e EventRow
			if err := rows.Scan(&e.ID, &e.Title, &e.Location, &e.EventDate, &e.MaxParticipants, &e.Price, &e.RegisteredCount); err == nil {
				events = append(events, e)
			}
		}
		if events == nil {
			events = []EventRow{}
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "events": events})
	}
}

func AdminCreateEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		var req struct {
			Title           string  `json:"title"`
			Location        string  `json:"location"`
			Description     string  `json:"description"`
			EventDate       string  `json:"event_date"`
			MaxParticipants int     `json:"max_participants"`
			Price           float64 `json:"price"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Corps invalide"})
			return
		}

		req.Title = strings.TrimSpace(req.Title)
		req.Location = strings.TrimSpace(req.Location)
		req.Description = strings.TrimSpace(req.Description)
		req.EventDate = strings.TrimSpace(req.EventDate)

		if req.Title == "" || req.Location == "" || req.Description == "" || req.EventDate == "" || req.MaxParticipants <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Champs obligatoires manquants"})
			return
		}
		if req.Price < 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Prix invalide"})
			return
		}

		locParis, _ := time.LoadLocation("Europe/Paris")
		start, err := time.ParseInLocation("2006-01-02T15:04", req.EventDate, locParis)
		if err != nil {
			start, err = time.Parse(time.RFC3339, req.EventDate)
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Date invalide"})
				return
			}
		}
		if start.Before(time.Now().In(locParis)) {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "La date doit etre future"})
			return
		}

		result, err := database.Exec(`
			INSERT INTO event (Title, Location, Description, Event_Date, Max_Participants, Price)
			VALUES (?, ?, ?, ?, ?, ?)
		`, req.Title, req.Location, req.Description, start, req.MaxParticipants, req.Price)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		eventID, _ := result.LastInsertId()
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success":  true,
			"message":  "Evenement cree",
			"event_id": eventID,
		})
	}
}

func AdminUpdateEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
		if len(parts) < 4 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		id, err := strconv.Atoi(parts[3])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}

		var req struct {
			Title           string  `json:"title"`
			Location        string  `json:"location"`
			Description     string  `json:"description"`
			EventDate       string  `json:"event_date"`
			MaxParticipants int     `json:"max_participants"`
			Price           float64 `json:"price"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Corps invalide"})
			return
		}

		req.Title = strings.TrimSpace(req.Title)
		req.Location = strings.TrimSpace(req.Location)
		req.Description = strings.TrimSpace(req.Description)
		req.EventDate = strings.TrimSpace(req.EventDate)

		if req.Title == "" || req.Location == "" || req.Description == "" || req.EventDate == "" || req.MaxParticipants <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Champs obligatoires manquants"})
			return
		}
		if req.Price < 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Prix invalide"})
			return
		}

		locParis, _ := time.LoadLocation("Europe/Paris")
		start, err := time.ParseInLocation("2006-01-02T15:04", req.EventDate, locParis)
		if err != nil {
			start, err = time.Parse(time.RFC3339, req.EventDate)
			if err != nil {
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Date invalide"})
				return
			}
		}

		res, err := database.Exec(`
			UPDATE event
			SET Title = ?, Location = ?, Description = ?, Event_Date = ?, Max_Participants = ?, Price = ?
			WHERE Id_EVENT = ?
		`, req.Title, req.Location, req.Description, start, req.MaxParticipants, req.Price, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		affected, _ := res.RowsAffected()
		if affected == 0 {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Evenement introuvable"})
			return
		}

		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Evenement modifie"})
	}
}

func AdminDeleteEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
		if len(parts) < 4 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		id, err := strconv.Atoi(parts[3])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}

		if _, err = database.Exec("DELETE FROM event WHERE Id_EVENT = ?", id); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}

		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Evenement supprime"})
	}
}

func AdminValidateEvent(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}

		parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
		if len(parts) < 4 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		id, err := strconv.Atoi(parts[3])
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}

		var body struct {
			Status int `json:"status"`
		}
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil || body.Status == 0 {
			body.Status = 1
		}

		_, err = database.Exec("UPDATE event SET Validation_Status = ? WHERE Id_EVENT = ?", body.Status, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}

		msg := "Événement validé"
		if body.Status == 2 {
			msg = "Événement refusé"
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": msg})
	}
}

func AdminGetPayments(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		rows, err := database.Query(`
			SELECT i.Id_INVOICE, COALESCE(CAST(i.Date_Generated AS CHAR),''), 
			       COALESCE(i.PDF_Url,''), COALESCE(i.Total_Amount,0), i.Is_Paid,
			       COALESCE(u.Email,''), COALESCE(u.Nom,''), COALESCE(u.Prenom,'')
			FROM invoice i
			LEFT JOIN intervention inv ON i.Id_INVOICE = inv.Id_INVOICE
			LEFT JOIN senior s ON inv.Id_SENIOR = s.Id_USER
			LEFT JOIN user u ON s.Id_USER = u.Id_USER
			WHERE i.Is_Paid = 1
			ORDER BY i.Date_Generated DESC`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		type PaymentRow struct {
			ID              int     `json:"id"`
			DateGenerated   string  `json:"date_generated"`
			PDFUrl          string  `json:"pdf_url"`
			TotalAmount     float64 `json:"total_amount"`
			IsPaid          bool    `json:"is_paid"`
			SeniorEmail     string  `json:"senior_email"`
			SeniorName      string  `json:"senior_name"`
			SeniorFirstName string  `json:"senior_first_name"`
		}
		var payments []PaymentRow
		for rows.Next() {
			var p PaymentRow
			if err := rows.Scan(&p.ID, &p.DateGenerated, &p.PDFUrl, &p.TotalAmount, &p.IsPaid,
				&p.SeniorEmail, &p.SeniorName, &p.SeniorFirstName); err == nil {
				payments = append(payments, p)
			}
		}
		if payments == nil {
			payments = []PaymentRow{}
		}
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "payments": payments})
	}
}

func AdminClearEventHistory(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		res, err := database.Exec("DELETE FROM event WHERE Event_Date < NOW()")
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		n, _ := res.RowsAffected()
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "Historique vidé", "deleted": n})
	}
}

func AdminGetEventRegistrations(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")
		if len(parts) == 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		idStr := parts[len(parts)-1]
		id, err := strconv.Atoi(idStr)
		if err != nil || id <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "ID invalide"})
			return
		}
		var title string
		var maxP, regCount int
		_ = database.QueryRow(`
            SELECT COALESCE(Title,''), COALESCE(Max_Participants,0),
                   (SELECT COUNT(*) FROM event_registration er WHERE er.Id_EVENT = ?)
            FROM event WHERE Id_EVENT = ? LIMIT 1
        `, id, id).Scan(&title, &maxP, &regCount)

		rows, err := database.Query(`
            SELECT u.Id_USER, COALESCE(u.Prenom,''), COALESCE(u.Nom,''), COALESCE(u.Email,''), COALESCE(u.Phone_Number,'')
            FROM event_registration er
            JOIN user u ON u.Id_USER = er.Id_USER
            WHERE er.Id_EVENT = ?
            ORDER BY u.Nom, u.Prenom
        `, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		registrations := []map[string]any{}
		for rows.Next() {
			var uid int
			var prenom, nom, email, phone string
			if err := rows.Scan(&uid, &prenom, &nom, &email, &phone); err != nil {
				continue
			}
			registrations = append(registrations, map[string]any{
				"id_user": uid,
				"prenom":  prenom,
				"nom":     nom,
				"email":   email,
				"phone":   phone,
			})
		}
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success":          true,
			"event_id":         id,
			"title":            title,
			"max_participants": maxP,
			"registered_count": regCount,
			"registrations":    registrations,
		})
	}
}
