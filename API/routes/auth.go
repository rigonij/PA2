package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/PA_2i2/api/lib"
	"golang.org/x/crypto/bcrypt"
)

type SignupRequest struct {
	Email        string `json:"email"`
	Password     string `json:"password"`
	Confirmation string `json:"confirmation"`
	Nom          string `json:"nom"`
	Prenom       string `json:"prenom"`
	PhoneNumber  string `json:"phone_number"`
	Role         string `json:"role"`

	CompanyName string `json:"company_name"`
	Siret       string `json:"siret"`
	BirthDate   string `json:"birth_date"`
	SponsorCode string `json:"sponsor_code"`
}

type SignupResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}

func Signup(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		var req SignupRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Le corp de la requête est invalide, changez le donc très cher : " + err.Error()})
			return
		}

		if req.Email == "" || req.Password == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Email et mot de passe obligatoires"})
			return
		}

		if req.Password != req.Confirmation {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Les mots de passe ne correspondent pas"})
			return
		}

		hashedBytes, err := bcrypt.GenerateFromPassword([]byte(req.Password), 10)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Erreur lors du hachage du mot de passe"})
			return
		}

		stmt, err := database.Prepare("INSERT INTO user(Email, Password, Nom, Prenom, Phone_Number) VALUES(?, ?, ?, ?, ?)")
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Erreur SQL: " + err.Error()})
			return
		}
		defer stmt.Close()

		result, err := stmt.Exec(req.Email, string(hashedBytes), req.Nom, req.Prenom, req.PhoneNumber)
		if err != nil {
			w.WriteHeader(http.StatusConflict)
			json.NewEncoder(w).Encode(SignupResponse{Success: false, Message: "Email déjà utilisé ou erreur d'insertion"})
			return
		}

		userID, _ := result.LastInsertId()

		if req.Role == "senior" {
			var birthDate interface{}
			if req.BirthDate != "" {
				birthDate = req.BirthDate
			} else {
				birthDate = nil
			}

			query := "INSERT INTO senior(Id_USER, Birth_Date) VALUES(?, ?)"
			_, err = database.Exec(query, userID, birthDate)
			if err != nil {
				log.Println("Erreur création profil senior:", err)
			}

		} else if req.Role == "provider" {
			companyName := req.CompanyName
			if companyName == "" {
				companyName = req.Nom + " " + req.Prenom
			}

			query := "INSERT INTO provider(Id_USER, Company_Name, SIRET_Number, Validation_Status) VALUES(?, ?, ?, 0)"
			_, err = database.Exec(query, userID, companyName, req.Siret)
			if err != nil {
				log.Println("Erreur création profil provider:", err)
			}
		}

		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(SignupResponse{Success: true, Message: "Inscription réussie"})
	}
}

type SigninRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type SigninResponse struct {
	Success bool   `json:"success"`
	Token   string `json:"token"`
	Message string `json:"message"`
}

func Signin(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		var req SigninRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(SigninResponse{Success: false, Message: "Corps de requête invalide"})
			return
		}
		row := database.QueryRow("SELECT Id_USER, Password FROM user WHERE Email = ?", req.Email)
		var userID int
		var hashedPassword string
		if err := row.Scan(&userID, &hashedPassword); err == sql.ErrNoRows {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(SigninResponse{Success: false, Message: "Identifiants incorrects"})
			return
		} else if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(SigninResponse{Success: false, Message: "Erreur serveur"})
			return
		}
		if err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(req.Password)); err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(SigninResponse{Success: false, Message: "Identifiants incorrects"})
			return
		}

		var isBanned int
		_ = database.QueryRow("SELECT Is_Banned FROM user WHERE Id_USER = ? LIMIT 1", userID).Scan(&isBanned)
		if isBanned == 1 {
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Votre compte a été suspendu.",
				"code":    "BANNED",
			})
			return
		}

		banned, banType, banReason, bannedUntil, errBan := CheckActiveBan(database, userID)
		if errBan == nil && banned {
			msg := "Votre compte est banni définitivement."
			code := "BANNED_PERM"
			if banType == "ban_temp" && bannedUntil != nil {
				msg = "Votre compte est suspendu jusqu'au " + bannedUntil.Format("02/01/2006 à 15:04") + "."
				code = "BANNED_TEMP"
			}
			if banReason != "" {
				msg += " Raison : " + banReason
			}
			w.WriteHeader(http.StatusForbidden)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": msg,
				"code":    code,
			})
			return
		}

		role := "senior"
		validationStatus := -1
		err := database.QueryRow(`
            SELECT Validation_Status
            FROM provider
            WHERE Id_USER = ?
            LIMIT 1
        `, userID).Scan(&validationStatus)
		if err == nil {
			role = "provider"
			if validationStatus == 2 {
				w.WriteHeader(http.StatusForbidden)
				json.NewEncoder(w).Encode(map[string]any{
					"success": false,
					"message": "Compte prestataire refusé par un administrateur",
					"code":    "PROVIDER_REJECTED",
				})
				return
			}
		} else if err != sql.ErrNoRows {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Erreur serveur",
			})
			return
		}

		token, err := lib.GenerateToken()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Erreur génération token",
			})
			return
		}
		_, err = database.Exec("UPDATE user SET authentication_token = ? WHERE Id_USER = ?", token, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]any{
				"success": false,
				"message": "Erreur sauvegarde token",
			})
			return
		}

		json.NewEncoder(w).Encode(map[string]any{
			"success":           true,
			"token":             token,
			"role":              role,
			"validation_status": validationStatus,
			"message":           "Connexion réussie",
		})
	}
}

type SignoutResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}

func Signout(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		if token == "" {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(SignoutResponse{Success: false, Message: "Token manquant"})
			return
		}

		result, err := database.Exec("UPDATE user SET authentication_token = NULL WHERE authentication_token = ?", token)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(SignoutResponse{Success: false, Message: "Erreur lors de la déconnexion"})
			return
		}

		affected, _ := result.RowsAffected()
		if affected == 0 {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(SignoutResponse{Success: false, Message: "Token invalide ou déjà déconnecté"})
			return
		}

		json.NewEncoder(w).Encode(SignoutResponse{Success: true, Message: "Déconnexion réussie"})
	}
}

type ProfileResponse struct {
	Success bool     `json:"success"`
	User    lib.User `json:"user"`
}

func GetProfile(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "message": "Non authentifié"})
			return
		}

		row := database.QueryRow(`
			SELECT Id_USER, Email, COALESCE(Nom,''), COALESCE(Prenom,''), 
			       COALESCE(Phone_Number,''), COALESCE(Address_Street,''), 
			       COALESCE(Address_Zip,''), COALESCE(Address_City,''), Registration_Date
			FROM user WHERE Id_USER = ?`, userID)

		var u lib.User
		if err := row.Scan(&u.ID, &u.Email, &u.Nom, &u.Prenom, &u.PhoneNumber,
			&u.AddressStreet, &u.AddressZip, &u.AddressCity, &u.RegistrationDate); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_, printError := fmt.Fprintln(w, "Erreur récupération profil:", err)
			if printError != nil {
				log.Fatal(printError)
			}
			return
		}

		json.NewEncoder(w).Encode(ProfileResponse{Success: true, User: u})
	}
}

type UpdateProfileRequest struct {
	Email         string `json:"email"`
	Nom           string `json:"nom"`
	Prenom        string `json:"prenom"`
	PhoneNumber   string `json:"phone_number"`
	AddressStreet string `json:"address_street"`
	AddressZip    string `json:"address_zip"`
	AddressCity   string `json:"address_city"`
}

func UpdateProfile(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Non authentifié",
			})
			return
		}

		var req UpdateProfileRequest
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Données invalides",
			})
			return
		}

		log.Println("UPDATE PROFILE userID =", userID, "newEmail =", req.Email)

		res, err := database.Exec(`
			UPDATE user
			SET Email=?, Nom=?, Prenom=?, Phone_Number=?, Address_Street=?, Address_Zip=?, Address_City=?
			WHERE Id_USER=?`,
			req.Email, req.Nom, req.Prenom, req.PhoneNumber, req.AddressStreet, req.AddressZip, req.AddressCity, userID,
		)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			json.NewEncoder(w).Encode(map[string]interface{}{
				"success": false,
				"message": "Erreur mise à jour: " + err.Error(),
			})
			return
		}

		rows, _ := res.RowsAffected()

		json.NewEncoder(w).Encode(map[string]interface{}{
			"success":       true,
			"message":       "Profil mis à jour",
			"rows_affected": rows,
		})
	}
}

func CheckPassword(hashedPassword, plainPassword string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(plainPassword))
}
