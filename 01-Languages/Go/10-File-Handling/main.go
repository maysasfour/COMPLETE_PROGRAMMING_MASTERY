// main.go - os text file I/O, encoding/json (built-in), missing-file handling.
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type Config struct {
	Theme    string `json:"theme"`
	FontSize int    `json:"fontSize"`
}

func main() {
	path := filepath.Join(os.TempDir(), "example-notes.txt")

	fmt.Println("--- text file round-trip ---")
	err := os.WriteFile(path, []byte("Hello, file system!\n"), 0644)
	if err != nil {
		panic(err)
	}
	contents, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	fmt.Print("Read back: ", string(contents))

	fmt.Println("\n--- encoding/json (built into the standard library) ---")
	config := Config{Theme: "dark", FontSize: 14}
	data, err := json.Marshal(config)
	if err != nil {
		panic(err)
	}
	fmt.Println("Marshaled:", string(data))

	var loaded Config
	err = json.Unmarshal(data, &loaded)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Unmarshaled: Theme=%s, FontSize=%d\n", loaded.Theme, loaded.FontSize)

	fmt.Println("\n--- missing file handled via os.IsNotExist ---")
	missingPath := filepath.Join(os.TempDir(), "does-not-exist-example.txt")
	_, err = os.ReadFile(missingPath)
	if os.IsNotExist(err) {
		fmt.Println("File doesn't exist -- using defaults, handled gracefully")
	}

	os.Remove(path)
	fmt.Println("\nCleaned up temporary file.")
}
