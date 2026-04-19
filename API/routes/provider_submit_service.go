package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
)

func ProviderSubmitService(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method != http.MethodPut {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		providerID, ok := requireProviderValidatedID(database, w, r)
		if !ok {
			return
		}

		idStr := strings.TrimPrefix(r.URL.Path, "/api/provider/services-submit/")
		idStr = strings.Trim(idStr, "/")
		serviceTypeID, err := strconv.Atoi(idStr)
		if err != nil || serviceTypeID <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "ID service invalide"})
			return
		}

		res, err := database.Exec(`
			UPDATE qualify
			SET Validation_Status = 0
			WHERE Id_USER = ? AND Id_SERVICE_TYPE = ?
		`, providerID, serviceTypeID)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}

		aff, _ := res.RowsAffected()
		if aff == 0 {
			w.WriteHeader(http.StatusNotFound)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service non trouvé"})
			return
		}

		_ = json.NewEncoder(w).Encode(map[string]any{"success": true, "message": "Service soumis à validation"})
	}
}
