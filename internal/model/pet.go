package model

import "time"

type Pet struct {
	ID        uint32     `json:"id"`
	Name      string     `json:"name"`
	Owner     string     `json:"owner"`
	Breed     string     `json:"breed"`
	Species   string     `json:"species"`
	Age       *int       `json:"age"`
	Notes     *string    `json:"notes"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
}

type PetRequest struct {
	Name    string  `json:"name"`
	Owner   string  `json:"owner"`
	Breed   string  `json:"breed"`
	Species string  `json:"species"`
	Age     *int    `json:"age"`
	Notes   *string `json:"notes"`
}
