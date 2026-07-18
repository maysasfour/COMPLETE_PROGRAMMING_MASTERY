// solution-07.go - Exercise 07: JSON roundtrip through a real temp file, then filter+sort.
package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"sort"
)

type Book struct {
	Title  string  `json:"title"`
	Author string  `json:"author"`
	Year   int     `json:"year"`
	Rating float64 `json:"rating"`
}

func main() {
	books := []Book{
		{"The Go Programming Language", "Donovan & Kernighan", 2015, 4.7},
		{"Concurrency in Go", "Katherine Cox-Buday", 2017, 4.3},
		{"Learning Go", "Jon Bodner", 2021, 4.6},
		{"The Old Guard", "Anon", 2009, 3.2},
		{"100 Go Mistakes", "Teiva Harsanyi", 2022, 4.8},
		{"Go in Action", "Kennedy, Ketelsen & St. Martin", 2015, 4.0},
	}

	data, err := json.MarshalIndent(books, "", "  ")
	if err != nil {
		panic(err)
	}

	tmp, err := os.CreateTemp("", "books-*.json")
	if err != nil {
		panic(err)
	}
	path := tmp.Name()
	if _, err := tmp.Write(data); err != nil {
		panic(err)
	}
	tmp.Close()
	fmt.Println("wrote temp file:", path)

	// Read back and unmarshal into a genuinely new slice -- proves the roundtrip, not just
	// that the original in-memory slice still has the right values.
	raw, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	var roundtripped []Book
	if err := json.Unmarshal(raw, &roundtripped); err != nil {
		panic(err)
	}
	fmt.Printf("read back %d books from disk\n\n", len(roundtripped))

	var filtered []Book
	for _, b := range roundtripped {
		if b.Year > 2015 && b.Rating >= 4.0 {
			filtered = append(filtered, b)
		}
	}
	sort.Slice(filtered, func(i, j int) bool {
		return filtered[i].Rating > filtered[j].Rating
	})

	fmt.Println("books published after 2015 with rating >= 4.0, sorted by rating descending:")
	for _, b := range filtered {
		fmt.Printf("  %-30s %-30s %d  %.1f\n", b.Title, b.Author, b.Year, b.Rating)
	}

	if err := os.Remove(path); err != nil {
		panic(err)
	}
	if _, err := os.Stat(path); errors.Is(err, os.ErrNotExist) {
		fmt.Println("\ntemp file cleanup confirmed: os.Stat now returns os.ErrNotExist")
	} else {
		fmt.Println("\nWARNING: temp file cleanup did not take effect")
	}
}
