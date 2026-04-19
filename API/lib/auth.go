package lib

import (
	"crypto/rand"
	"database/sql"
	"encoding/base64"
	"errors"

	"golang.org/x/crypto/bcrypt"
)

func IsAuthenticated(database *sql.DB, token string) (bool, error) {
	if token == "" {
		return false, nil
	}

	row := database.QueryRow("SELECT Id_USER FROM user WHERE authentication_token = ?", token)
	var id int
	err := row.Scan(&id)
	if err == sql.ErrNoRows {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return true, nil
}

func GetUserIDFromToken(database *sql.DB, token string) (int, error) {
	if token == "" {
		return 0, errors.New("empty token")
	}

	row := database.QueryRow("SELECT Id_USER FROM user WHERE authentication_token = ? LIMIT 1", token)
	var id int
	if err := row.Scan(&id); err != nil {
		return 0, err
	}

	var isBanned int
	err := database.QueryRow("SELECT Is_Banned FROM user WHERE Id_USER = ? LIMIT 1", id).Scan(&isBanned)
	if err != nil {
		return 0, errors.New("utilisateur introuvable")
	}
	if isBanned == 1 {
		return 0, errors.New("compte suspendu")
	}

	return id, nil
}

func GenerateToken() (string, error) {
	bytes := make([]byte, 32)
	_, err := rand.Read(bytes)
	if err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(bytes), nil
}

func CheckPassword(hashedPassword, plainPassword string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(plainPassword))
}

func GetAdminIDFromToken(database *sql.DB, token string) (int, error) {
	if token == "" {
		return 0, errors.New("token vide")
	}

	row := database.QueryRow(`
		SELECT Id_USER
		FROM user
		WHERE authentication_token = ?
		LIMIT 1
	`, token)

	var userID int
	if err := row.Scan(&userID); err != nil {
		return 0, errors.New("token admin invalide")
	}

	row = database.QueryRow(`
		SELECT COUNT(*)
		FROM admin
		WHERE Id_USER = ?
		LIMIT 1
	`, userID)

	var count int
	if err := row.Scan(&count); err != nil {
		return 0, errors.New("erreur check admin")
	}

	if count == 0 {
		return 0, errors.New("pas admin")
	}

	return userID, nil
}
