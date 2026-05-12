package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
)

func ProviderMyReviews(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}
		rows, err := database.Query(`
			SELECT r.Id_REVIEW, r.Id_SENIOR, r.Rating, COALESCE(r.Comment,''),
			       r.Created_At, r.Updated_At,
			       COALESCE(u.Prenom,''), COALESCE(u.Nom,''),
			       (SELECT COUNT(*) FROM review_report rr WHERE rr.Id_REVIEW = r.Id_REVIEW AND rr.Id_REPORTER = ?) AS reported_by_me
			FROM review r
			JOIN user u ON u.Id_USER = r.Id_SENIOR
			WHERE r.Id_PROVIDER = ?
			ORDER BY r.Updated_At DESC
		`, providerID, providerID)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		reviews := []map[string]any{}
		for rows.Next() {
			var id, seniorID, rating, reportedByMe int
			var comment, createdAt, updatedAt, prenom, nom string
			if err := rows.Scan(&id, &seniorID, &rating, &comment, &createdAt, &updatedAt, &prenom, &nom, &reportedByMe); err != nil {
				continue
			}
			reviews = append(reviews, map[string]any{
				"id":             id,
				"senior_id":      seniorID,
				"rating":         rating,
				"comment":        comment,
				"created_at":     createdAt,
				"updated_at":     updatedAt,
				"author":         strings.TrimSpace(prenom + " " + nom),
				"reported_by_me": reportedByMe > 0,
			})
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "reviews": reviews})
	}
}

func ProviderReportReview(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}
		var req struct {
			ReviewID int    `json:"review_id"`
			Reason   string `json:"reason"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil || req.ReviewID <= 0 || strings.TrimSpace(req.Reason) == "" {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Paramètres invalides"})
			return
		}
		var targetProvider int
		err := database.QueryRow(`SELECT Id_PROVIDER FROM review WHERE Id_REVIEW = ?`, req.ReviewID).Scan(&targetProvider)
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Avis introuvable"})
			return
		}
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if targetProvider != providerID {
			w.WriteHeader(http.StatusForbidden)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Cet avis ne vous concerne pas"})
			return
		}
		_, err = database.Exec(`
			INSERT INTO review_report (Id_REVIEW, Id_REPORTER, Reason)
			VALUES (?, ?, ?)
		`, req.ReviewID, providerID, req.Reason)
		if err != nil {
			w.WriteHeader(http.StatusConflict)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Avis déjà signalé"})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Signalement envoyé"})
	}
}

func AdminReviewReports(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodGet {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		rows, err := database.Query(`
			SELECT rr.Id_REPORT, rr.Reason, rr.Status, rr.Created_At,
			       r.Id_REVIEW, r.Rating, COALESCE(r.Comment,''),
			       r.Id_SENIOR, COALESCE(us.Prenom,''), COALESCE(us.Nom,''),
			       r.Id_PROVIDER, COALESCE(p.Company_Name,''),
			       rr.Id_REPORTER
			FROM review_report rr
			JOIN review r ON r.Id_REVIEW = rr.Id_REVIEW
			JOIN user us ON us.Id_USER = r.Id_SENIOR
			JOIN provider p ON p.Id_USER = r.Id_PROVIDER
			ORDER BY (rr.Status = 'pending') DESC, rr.Created_At DESC
		`)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()
		reports := []map[string]any{}
		for rows.Next() {
			var reportID, reviewID, rating, seniorID, providerID, reporterID int
			var reason, status, createdAt, comment, prenom, nom, company string
			if err := rows.Scan(&reportID, &reason, &status, &createdAt, &reviewID, &rating, &comment, &seniorID, &prenom, &nom, &providerID, &company, &reporterID); err != nil {
				continue
			}
			reports = append(reports, map[string]any{
				"id":           reportID,
				"reason":       reason,
				"status":       status,
				"created_at":   createdAt,
				"review_id":    reviewID,
				"rating":       rating,
				"comment":      comment,
				"senior_id":    seniorID,
				"senior_name":  strings.TrimSpace(prenom + " " + nom),
				"provider_id":  providerID,
				"company_name": company,
				"reporter_id":  reporterID,
			})
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "reports": reports})
	}
}

func AdminUpdateReviewReport(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodPut {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		idStr := strings.TrimPrefix(r.URL.Path, "/api/admin/review-reports/")
		idStr = strings.Trim(idStr, "/")
		id, err := strconv.Atoi(idStr)
		if err != nil || id <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}
		var req struct {
			Status string `json:"status"`
		}
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
			return
		}
		if req.Status != "reviewed" && req.Status != "dismissed" && req.Status != "pending" {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Status invalide"})
			return
		}
		_, err = database.Exec(`UPDATE review_report SET Status = ?, Reviewed_At = CURRENT_TIMESTAMP WHERE Id_REPORT = ?`, req.Status, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}

func AdminDeleteReview(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodDelete {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		idStr := strings.TrimPrefix(r.URL.Path, "/api/admin/reviews/")
		idStr = strings.Trim(idStr, "/")
		id, err := strconv.Atoi(idStr)
		if err != nil || id <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}
		_, err = database.Exec(`DELETE FROM review WHERE Id_REVIEW = ?`, id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Avis supprimé"})
	}
}

func AdminWarnReviewAuthor(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if !requireAdmin(database, w, r) {
			return
		}
		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		path := strings.TrimPrefix(r.URL.Path, "/api/admin/review-reports/")
		path = strings.TrimSuffix(path, "/warn")
		path = strings.Trim(path, "/")
		reportID, err := strconv.Atoi(path)
		if err != nil || reportID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID invalide"})
			return
		}
		var seniorID int
		var reason string
		if err := database.QueryRow(`
			SELECT r.Id_SENIOR, rr.Reason
			FROM review_report rr
			JOIN review r ON r.Id_REVIEW = rr.Id_REVIEW
			WHERE rr.Id_REPORT = ?
		`, reportID).Scan(&seniorID, &reason); err != nil {
			w.WriteHeader(http.StatusNotFound)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Signalement introuvable"})
			return
		}
		tx, err := database.Begin()
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if _, err := tx.Exec(`
			INSERT INTO user_sanction (Id_USER, Type, Reason, Source)
			VALUES (?, 'warning', ?, 'admin_review_report')
		`, seniorID, "Avis signalé : "+reason); err != nil {
			tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if err := applyAutoEscalation(tx, seniorID, 0); err != nil {
			tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if _, err := tx.Exec(`UPDATE review_report SET Status = 'reviewed', Reviewed_At = CURRENT_TIMESTAMP WHERE Id_REPORT = ?`, reportID); err != nil {
			tx.Rollback()
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		if err := tx.Commit(); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"success": true})
	}
}
