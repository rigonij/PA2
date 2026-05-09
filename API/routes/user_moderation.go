package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/PA_2i2/api/lib"
)

func CheckActiveBan(database *sql.DB, userID int) (bool, string, string, *time.Time, error) {
	row := database.QueryRow(`
		SELECT Type, Reason, Banned_Until
		FROM user_sanction
		WHERE Id_USER = ?
		  AND (
		    Type = 'ban_perm'
		    OR (Type = 'ban_temp' AND Banned_Until IS NOT NULL AND Banned_Until > NOW())
		  )
		ORDER BY CASE Type WHEN 'ban_perm' THEN 0 ELSE 1 END, Created_At DESC
		LIMIT 1
	`, userID)
	var banType, reason string
	var until sql.NullTime
	if err := row.Scan(&banType, &reason, &until); err != nil {
		if err == sql.ErrNoRows {
			return false, "", "", nil, nil
		}
		return false, "", "", nil, err
	}
	var untilPtr *time.Time
	if until.Valid {
		untilPtr = &until.Time
	}
	return true, banType, reason, untilPtr, nil
}

func applyAutoEscalation(tx *sql.Tx, userID int, createdBy int) error {
	var warningCount int
	if err := tx.QueryRow(`SELECT COUNT(*) FROM user_sanction WHERE Id_USER = ? AND Type = 'warning'`, userID).Scan(&warningCount); err != nil {
		return err
	}
	if warningCount > 0 && warningCount%3 == 0 {
		until := time.Now().Add(7 * 24 * time.Hour)
		_, err := tx.Exec(`
			INSERT INTO user_sanction (Id_USER, Type, Reason, Banned_Until, Created_By, Source)
			VALUES (?, 'ban_temp', ?, ?, ?, 'auto_warning_threshold')
		`, userID, "Suspension automatique : 3 avertissements atteints.", until, createdBy)
		if err != nil {
			return err
		}
	}
	var banCount int
	if err := tx.QueryRow(`SELECT COUNT(*) FROM user_sanction WHERE Id_USER = ? AND Type IN ('ban_temp','ban_perm')`, userID).Scan(&banCount); err != nil {
		return err
	}
	if banCount > 0 && banCount%3 == 0 {
		_, err := tx.Exec(`
			INSERT INTO user_sanction (Id_USER, Type, Reason, Created_By, Source)
			VALUES (?, 'ban_perm', ?, ?, 'auto_ban_threshold')
		`, userID, "Bannissement définitif automatique : 3 bannissements atteints.", createdBy)
		if err != nil {
			return err
		}
	}
	return nil
}

func UserReport(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		token := r.Header.Get("X-Token")
		reporterID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		var req struct {
			ReportedID int    `json:"reported_id"`
			Reason     string `json:"reason"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}
		req.Reason = strings.TrimSpace(req.Reason)
		if req.ReportedID <= 0 || req.Reason == "" {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Champs manquants"})
			return
		}
		if req.ReportedID == reporterID {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Vous ne pouvez pas vous signaler vous-même"})
			return
		}
		var existing int
		_ = database.QueryRow(`
			SELECT COUNT(*) FROM user_report
			WHERE Id_REPORTED = ? AND Id_REPORTER = ? AND Status = 'pending'
		`, req.ReportedID, reporterID).Scan(&existing)
		if existing > 0 {
			w.WriteHeader(http.StatusConflict)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Un signalement est déjà en attente pour cet utilisateur"})
			return
		}
		_, err = database.Exec(`
			INSERT INTO user_report (Id_REPORTED, Id_REPORTER, Reason)
			VALUES (?, ?, ?)
		`, req.ReportedID, reporterID, req.Reason)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func AdminUserReports(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		status := r.URL.Query().Get("status")
		query := `
			SELECT r.Id_REPORT, r.Id_REPORTED, r.Id_REPORTER, r.Reason, r.Status, r.Created_At, r.Reviewed_At,
				COALESCE(ud.Nom,''), COALESCE(ud.Prenom,''), COALESCE(ud.Email,''),
				COALESCE(ur.Nom,''), COALESCE(ur.Prenom,''), COALESCE(ur.Email,'')
			FROM user_report r
			LEFT JOIN user ud ON ud.Id_USER = r.Id_REPORTED
			LEFT JOIN user ur ON ur.Id_USER = r.Id_REPORTER
		`
		args := []any{}
		if status != "" {
			query += " WHERE r.Status = ?"
			args = append(args, status)
		}
		query += " ORDER BY r.Created_At DESC"
		rows, err := database.Query(query, args...)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		reports := []map[string]any{}
		for rows.Next() {
			var id, reportedID, reporterID int
			var reason, st string
			var createdAt time.Time
			var reviewedAt sql.NullTime
			var rdNom, rdPrenom, rdEmail string
			var rrNom, rrPrenom, rrEmail string
			if err := rows.Scan(&id, &reportedID, &reporterID, &reason, &st, &createdAt, &reviewedAt,
				&rdNom, &rdPrenom, &rdEmail, &rrNom, &rrPrenom, &rrEmail); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			item := map[string]any{
				"id":              id,
				"reported_id":     reportedID,
				"reporter_id":     reporterID,
				"reason":          reason,
				"status":          st,
				"created_at":      createdAt.Format(time.RFC3339),
				"reported_nom":    rdNom,
				"reported_prenom": rdPrenom,
				"reported_email":  rdEmail,
				"reporter_nom":    rrNom,
				"reporter_prenom": rrPrenom,
				"reporter_email":  rrEmail,
			}
			if reviewedAt.Valid {
				item["reviewed_at"] = reviewedAt.Time.Format(time.RFC3339)
			}
			reports = append(reports, item)
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "reports": reports})
	}
}

func AdminResolveUserReport(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		adminToken := r.Header.Get("X-Token")
		adminID, _ := lib.GetUserIDFromToken(database, adminToken)
		var req struct {
			ReportID int    `json:"report_id"`
			Action   string `json:"action"`
			Reason   string `json:"reason"`
			BanDays  int    `json:"ban_days"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Body invalide"})
			return
		}
		if req.ReportID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "report_id invalide"})
			return
		}
		validActions := map[string]bool{"dismiss": true, "warning": true, "ban_temp": true, "ban_perm": true}
		if !validActions[req.Action] {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Action invalide"})
			return
		}
		req.Reason = strings.TrimSpace(req.Reason)
		if req.Action != "dismiss" && req.Reason == "" {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Raison requise"})
			return
		}
		if req.Action == "ban_temp" && req.BanDays <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Durée invalide"})
			return
		}
		var reportedID int
		var status string
		if err := database.QueryRow(`SELECT Id_REPORTED, Status FROM user_report WHERE Id_REPORT = ?`, req.ReportID).Scan(&reportedID, &status); err != nil {
			w.WriteHeader(http.StatusNotFound)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Signalement introuvable"})
			return
		}
		if status != "pending" {
			w.WriteHeader(http.StatusConflict)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Signalement déjà traité"})
			return
		}
		tx, err := database.Begin()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		newStatus := "resolved"
		if req.Action == "dismiss" {
			newStatus = "dismissed"
		}
		_, err = tx.Exec(`
			UPDATE user_report
			SET Status = ?, Reviewed_At = NOW(), Reviewed_By = ?
			WHERE Id_REPORT = ?
		`, newStatus, adminID, req.ReportID)
		if err != nil {
			_ = tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		switch req.Action {
		case "warning":
			_, err = tx.Exec(`
				INSERT INTO user_sanction (Id_USER, Type, Reason, Created_By, Source, Id_REPORT)
				VALUES (?, 'warning', ?, ?, 'manual', ?)
			`, reportedID, req.Reason, adminID, req.ReportID)
		case "ban_temp":
			until := time.Now().Add(time.Duration(req.BanDays) * 24 * time.Hour)
			_, err = tx.Exec(`
				INSERT INTO user_sanction (Id_USER, Type, Reason, Banned_Until, Created_By, Source, Id_REPORT)
				VALUES (?, 'ban_temp', ?, ?, ?, 'manual', ?)
			`, reportedID, req.Reason, until, adminID, req.ReportID)
		case "ban_perm":
			_, err = tx.Exec(`
				INSERT INTO user_sanction (Id_USER, Type, Reason, Created_By, Source, Id_REPORT)
				VALUES (?, 'ban_perm', ?, ?, 'manual', ?)
			`, reportedID, req.Reason, adminID, req.ReportID)
		}
		if err != nil {
			_ = tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if req.Action != "dismiss" {
			if err := applyAutoEscalation(tx, reportedID, adminID); err != nil {
				_ = tx.Rollback()
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
		}
		if err := tx.Commit(); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func AdminGetUserSanctions(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		idStr := strings.TrimPrefix(r.URL.Path, "/api/admin/user-sanctions/")
		idStr = strings.Trim(idStr, "/")
		userID, err := strconv.Atoi(idStr)
		if err != nil || userID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}
		var nom, prenom, email string
		_ = database.QueryRow(`SELECT COALESCE(Nom,''), COALESCE(Prenom,''), COALESCE(Email,'') FROM user WHERE Id_USER = ?`, userID).Scan(&nom, &prenom, &email)
		rows, err := database.Query(`
			SELECT Id_SANCTION, Type, Reason, Banned_Until, Created_At, Source, Acknowledged, Acknowledged_At
			FROM user_sanction
			WHERE Id_USER = ?
			ORDER BY Created_At DESC
		`, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		sanctions := []map[string]any{}
		var warningCount, banCount int
		for rows.Next() {
			var id int
			var sType, reason, source string
			var until sql.NullTime
			var createdAt time.Time
			var ack int
			var ackAt sql.NullTime
			if err := rows.Scan(&id, &sType, &reason, &until, &createdAt, &source, &ack, &ackAt); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			if sType == "warning" {
				warningCount++
			}
			if sType == "ban_temp" || sType == "ban_perm" {
				banCount++
			}
			item := map[string]any{
				"id":           id,
				"type":         sType,
				"reason":       reason,
				"created_at":   createdAt.Format(time.RFC3339),
				"source":       source,
				"acknowledged": ack == 1,
			}
			if until.Valid {
				item["banned_until"] = until.Time.Format(time.RFC3339)
				item["is_active"] = until.Time.After(time.Now())
			} else if sType == "ban_perm" {
				item["is_active"] = true
			} else {
				item["is_active"] = false
			}
			if ackAt.Valid {
				item["acknowledged_at"] = ackAt.Time.Format(time.RFC3339)
			}
			sanctions = append(sanctions, item)
		}
		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":       true,
			"user_id":       userID,
			"user_nom":      nom,
			"user_prenom":   prenom,
			"user_email":    email,
			"sanctions":     sanctions,
			"warning_count": warningCount,
			"ban_count":     banCount,
		})
	}
}

func MyPendingSanction(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		row := database.QueryRow(`
			SELECT Id_SANCTION, Type, Reason, Banned_Until, Source
			FROM user_sanction
			WHERE Id_USER = ? AND Acknowledged = 0
			ORDER BY Created_At ASC
			LIMIT 1
		`, userID)
		var id int
		var sType, reason, source string
		var until sql.NullTime
		if err := row.Scan(&id, &sType, &reason, &until, &source); err != nil {
			if err == sql.ErrNoRows {
				_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "sanction": nil})
				return
			}
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		var warningCount, banCount int
		_ = database.QueryRow(`SELECT COUNT(*) FROM user_sanction WHERE Id_USER = ? AND Type = 'warning'`, userID).Scan(&warningCount)
		_ = database.QueryRow(`SELECT COUNT(*) FROM user_sanction WHERE Id_USER = ? AND Type IN ('ban_temp','ban_perm')`, userID).Scan(&banCount)
		item := map[string]any{
			"id":            id,
			"type":          sType,
			"reason":        reason,
			"source":        source,
			"warning_count": warningCount,
			"ban_count":     banCount,
		}
		if until.Valid {
			item["banned_until"] = until.Time.Format(time.RFC3339)
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "sanction": item})
	}
}

func AcknowledgeSanction(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		token := r.Header.Get("X-Token")
		userID, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}
		var req struct {
			SanctionID int `json:"sanction_id"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.SanctionID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "sanction_id invalide"})
			return
		}
		_, err = database.Exec(`
			UPDATE user_sanction
			SET Acknowledged = 1, Acknowledged_At = NOW()
			WHERE Id_SANCTION = ? AND Id_USER = ?
		`, req.SanctionID, userID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
