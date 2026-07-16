// main.go - CRUD against SQLite using database/sql (built-in) plus a pure-Go SQLite driver
// (modernc.org/sqlite -- no CGO/C compiler needed, unlike the more common mattn/go-sqlite3).
package main

import (
	"database/sql"
	"fmt"

	_ "modernc.org/sqlite" // blank import: registers the "sqlite" driver with database/sql
)

func main() {
	db, err := sql.Open("sqlite", ":memory:")
	if err != nil {
		panic(err)
	}
	defer db.Close()

	_, err = db.Exec(`CREATE TABLE tasks (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		done INTEGER NOT NULL DEFAULT 0
	)`)
	if err != nil {
		panic(err)
	}

	fmt.Println("--- CREATE (parameterized) ---")
	for _, title := range []string{"Write lesson", "Test examples", "Ship it"} {
		_, err = db.Exec("INSERT INTO tasks (title) VALUES (?)", title)
		if err != nil {
			panic(err)
		}
	}
	fmt.Println("Inserted 3 rows.")

	fmt.Println("\n--- READ (all) ---")
	rows, err := db.Query("SELECT id, title, done FROM tasks")
	if err != nil {
		panic(err)
	}
	for rows.Next() {
		var id, done int
		var title string
		rows.Scan(&id, &title, &done)
		fmt.Printf("  id=%d, title=%s, done=%d\n", id, title, done)
	}
	rows.Close()

	fmt.Println("\n--- UPDATE (parameterized) ---")
	_, err = db.Exec("UPDATE tasks SET done = 1 WHERE id = ?", 1)
	if err != nil {
		panic(err)
	}
	var doneStatus int
	db.QueryRow("SELECT done FROM tasks WHERE id = ?", 1).Scan(&doneStatus)
	fmt.Println("Row 1 done status after update:", doneStatus)

	fmt.Println("\n--- DELETE (parameterized) ---")
	_, err = db.Exec("DELETE FROM tasks WHERE id = ?", 3)
	if err != nil {
		panic(err)
	}
	var count int
	db.QueryRow("SELECT COUNT(*) FROM tasks").Scan(&count)
	fmt.Println("Remaining row count:", count)

	fmt.Println("\n--- parameterized queries prevent SQL injection ---")
	maliciousTitle := "'; DROP TABLE tasks; --"
	_, err = db.Exec("INSERT INTO tasks (title) VALUES (?)", maliciousTitle)
	if err != nil {
		panic(err)
	}
	var retrievedTitle string
	db.QueryRow("SELECT title FROM tasks WHERE title = ?", maliciousTitle).Scan(&retrievedTitle)
	fmt.Println("Malicious-looking string stored and retrieved as plain data:", retrievedTitle)

	var finalCount int
	db.QueryRow("SELECT COUNT(*) FROM tasks").Scan(&finalCount)
	fmt.Println("Table still exists with all rows intact:", finalCount)
}
