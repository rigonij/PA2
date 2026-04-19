package lib

import "time"

type User struct {
	ID               int       `json:"id"`
	Email            string    `json:"email"`
	Nom              string    `json:"nom"`
	Prenom           string    `json:"prenom"`
	PhoneNumber      string    `json:"phone_number"`
	AddressStreet    string    `json:"address_street"`
	AddressZip       string    `json:"address_zip"`
	AddressCity      string    `json:"address_city"`
	RegistrationDate time.Time `json:"registration_date"`
}
