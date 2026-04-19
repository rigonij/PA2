package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"time"

	"github.com/PA_2i2/api/lib"
)

type AvailableSlotsReq struct {
	ServiceTypeID int    `json:"service_type_id"`
	ProviderID    int    `json:"provider_id"`
	Date          string `json:"date"`
}

func overlaps(aStart, aEnd, bStart, bEnd time.Time) bool {
	return aStart.Before(bEnd) && bStart.Before(aEnd)
}

func parseClock(s string) (time.Time, error) {
	if t, err := time.Parse("15:04:05", s); err == nil {
		return t, nil
	}
	return time.Parse("15:04", s)
}

func GetAvailableServiceSlots(database *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		if r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}

		token := r.Header.Get("X-Token")
		_, err := lib.GetUserIDFromToken(database, token)
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Non authentifié"})
			return
		}

		var req AvailableSlotsReq
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Corps invalide"})
			return
		}

		if req.ServiceTypeID <= 0 || req.ProviderID <= 0 || req.Date == "" {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Champs manquants"})
			return
		}

		day, err := time.ParseInLocation("2006-01-02", req.Date, time.Local)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Date invalide (YYYY-MM-DD)"})
			return
		}

		now := time.Now().In(time.Local)
		todayDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, time.Local)
		dayDate := time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, time.Local)
		if dayDate.Before(todayDate) {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Impossible de choisir une date passée"})
			return
		}

		var isPublished int
		err = database.QueryRow(`
			SELECT COUNT(*)
			FROM qualify q
			JOIN provider p ON p.Id_USER = q.Id_USER
			WHERE q.Id_USER = ?
			  AND q.Id_SERVICE_TYPE = ?
			  AND COALESCE(q.Is_Active,1) = 1
			  AND COALESCE(q.Validation_Status,0) = 1
			  AND COALESCE(p.Validation_Status,0) = 1
			LIMIT 1
		`, req.ProviderID, req.ServiceTypeID).Scan(&isPublished)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Erreur serveur"})
			return
		}
		if isPublished == 0 {
			w.WriteHeader(http.StatusForbidden)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Service non disponible"})
			return
		}

		var durationMin int
		err = database.QueryRow(`
			SELECT COALESCE(Slot_Duration_Min, 0)
			FROM qualify
			WHERE Id_USER = ?
			  AND Id_SERVICE_TYPE = ?
			LIMIT 1
		`, req.ProviderID, req.ServiceTypeID).Scan(&durationMin)

		if err != nil || durationMin <= 0 {
			w.WriteHeader(http.StatusBadRequest)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": "Durée service introuvable"})
			return
		}

		dur := time.Duration(durationMin) * time.Minute

		dow := int(day.Weekday())
		if dow == 0 {
			dow = 7
		}

		rows, err := database.Query(`
			SELECT ps.Start_Time, ps.End_Time
			FROM provider_service_schedule pss
			JOIN provider_schedule ps ON ps.Id_SCHEDULE = pss.Id_SCHEDULE
			WHERE pss.Id_USER = ?
			  AND pss.Id_SERVICE_TYPE = ?
			  AND ps.Day_Of_Week = ?
			ORDER BY ps.Start_Time ASC
		`, req.ProviderID, req.ServiceTypeID, dow)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer rows.Close()

		type sched struct {
			start string
			end   string
		}
		schedules := []sched{}
		for rows.Next() {
			var st, en string
			if err := rows.Scan(&st, &en); err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
				return
			}
			schedules = append(schedules, sched{start: st, end: en})
		}

		absRows, err := database.Query(`
			SELECT Start_DateTime, End_DateTime
			FROM provider_absence
			WHERE Id_USER = ?
			  AND Start_DateTime < DATE_ADD(?, INTERVAL 1 DAY)
			  AND End_DateTime   > ?
		`, req.ProviderID, day.Format("2006-01-02"), day.Format("2006-01-02"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer absRows.Close()

		absences := [][2]time.Time{}
		for absRows.Next() {
			var st, en time.Time
			if err := absRows.Scan(&st, &en); err == nil {
				absences = append(absences, [2]time.Time{st.In(time.Local), en.In(time.Local)})
			}
		}

		intRows, err := database.Query(`
			SELECT Date_Start, Date_End
			FROM intervention
			WHERE Id_PROVIDER = ?
				AND Id_SERVICE_TYPE = ?
				AND Status <> 'Canceled'
				AND Date_Start < DATE_ADD(?, INTERVAL 1 DAY)
				AND Date_End > ?
		`, req.ProviderID, req.ServiceTypeID, day.Format("2006-01-02"), day.Format("2006-01-02"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": false, "message": err.Error()})
			return
		}
		defer intRows.Close()

		booked := [][2]time.Time{}
		for intRows.Next() {
			var st, en time.Time
			if err := intRows.Scan(&st, &en); err == nil {
				booked = append(booked, [2]time.Time{st.In(time.Local), en.In(time.Local)})
			}
		}

		slots := []map[string]any{}

		for _, sc := range schedules {
			stT, err1 := parseClock(sc.start)
			enT, err2 := parseClock(sc.end)
			if err1 != nil || err2 != nil {
				continue
			}

			startAt := time.Date(day.Year(), day.Month(), day.Day(), stT.Hour(), stT.Minute(), 0, 0, time.Local)
			endAt := time.Date(day.Year(), day.Month(), day.Day(), enT.Hour(), enT.Minute(), 0, 0, time.Local)

			for cur := startAt; !cur.Add(dur).After(endAt); cur = cur.Add(dur) {
				sStart := cur
				sEnd := cur.Add(dur)

				bad := false

				for _, a := range absences {
					if overlaps(sStart, sEnd, a[0], a[1]) {
						bad = true
						break
					}
				}
				if bad {
					continue
				}

				for _, b := range booked {
					if overlaps(sStart, sEnd, b[0], b[1]) {
						bad = true
						break
					}
				}
				if bad {
					continue
				}

				slots = append(slots, map[string]any{
					"start_at": sStart.Format("2006-01-02T15:04"),
					"end_at":   sEnd.Format("2006-01-02T15:04"),
				})
			}
		}

		_ = json.NewEncoder(w).Encode(map[string]any{
			"success":      true,
			"duration_min": durationMin,
			"slots":        slots,
		})
	}
}
