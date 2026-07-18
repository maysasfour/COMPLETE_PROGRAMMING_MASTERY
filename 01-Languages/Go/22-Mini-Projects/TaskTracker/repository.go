// repository.go - all SQLite access lives here, behind a Repository struct, so main.go's CLI
// layer and repository_test.go's tests never touch database/sql directly. Every query uses a
// "?" placeholder for user-supplied values -- the same parameterized-query discipline as
// Lesson 16, still the only defense against SQL injection that actually works.
package main

import (
	"database/sql"
	"time"
)

type Repository struct {
	db *sql.DB
}

func NewRepository(db *sql.DB) *Repository {
	return &Repository{db: db}
}

// Init is separate from NewRepository so tests can point a Repository at a fresh in-memory
// connection and call Init() themselves, instead of NewRepository silently doing I/O as a
// side effect of construction.
func (r *Repository) Init() error {
	_, err := r.db.Exec(`CREATE TABLE IF NOT EXISTS tasks (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		title TEXT NOT NULL,
		priority INTEGER NOT NULL,
		status INTEGER NOT NULL DEFAULT 0,
		created_at TEXT NOT NULL
	)`)
	return err
}

// Add batches the INSERT and the id lookup into one round trip using SQLite's
// last_insert_rowid(), which is connection-scoped and safe to read back immediately after --
// no separate SELECT needed, and no race with any other connection's inserts.
func (r *Repository) Add(title string, priority Priority) (TaskItem, error) {
	createdAt := time.Now().Format("2006-01-02")
	result, err := r.db.Exec(
		"INSERT INTO tasks (title, priority, status, created_at) VALUES (?, ?, ?, ?)",
		title, int(priority), int(StatusPending), createdAt,
	)
	if err != nil {
		return TaskItem{}, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return TaskItem{}, err
	}
	return TaskItem{ID: id, Title: title, Priority: priority, Status: StatusPending, CreatedAt: createdAt}, nil
}

// List takes *Status rather than Status so "no filter" (nil) is distinguishable from
// "filter by StatusPending" (a valid zero value) -- a plain Status parameter couldn't tell
// the two apart, since StatusPending's underlying int is 0, the same as an unset variable.
func (r *Repository) List(statusFilter *Status) ([]TaskItem, error) {
	var rows *sql.Rows
	var err error
	if statusFilter != nil {
		rows, err = r.db.Query(
			"SELECT id, title, priority, status, created_at FROM tasks WHERE status = ? ORDER BY id",
			int(*statusFilter),
		)
	} else {
		rows, err = r.db.Query("SELECT id, title, priority, status, created_at FROM tasks ORDER BY id")
	}
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tasks []TaskItem
	for rows.Next() {
		var t TaskItem
		var priority, status int
		if err := rows.Scan(&t.ID, &t.Title, &priority, &status, &t.CreatedAt); err != nil {
			return nil, err
		}
		t.Priority = Priority(priority)
		t.Status = Status(status)
		tasks = append(tasks, t)
	}
	return tasks, rows.Err() // rows.Err() catches errors from a Next() loop that ended early, not just the initial Query
}

// MarkDone checks RowsAffected instead of running a separate SELECT first -- one round trip,
// and the "does this id exist" question and the "update it" action can't drift apart between
// two separate queries the way they could if this were split into a check-then-act pair.
func (r *Repository) MarkDone(id int64) error {
	result, err := r.db.Exec("UPDATE tasks SET status = ? WHERE id = ?", int(StatusDone), id)
	if err != nil {
		return err
	}
	affected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if affected == 0 {
		return &TaskNotFoundError{ID: id}
	}
	return nil
}

func (r *Repository) Delete(id int64) error {
	result, err := r.db.Exec("DELETE FROM tasks WHERE id = ?", id)
	if err != nil {
		return err
	}
	affected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if affected == 0 {
		return &TaskNotFoundError{ID: id}
	}
	return nil
}

// Stats uses a single aggregate query rather than fetching every row into Go and counting
// there -- the database is much better at COUNT/SUM/CASE than pulling everything over the wire.
func (r *Repository) Stats() (TaskStats, error) {
	var stats TaskStats
	row := r.db.QueryRow(`SELECT
		COUNT(CASE WHEN status = 0 THEN 1 END),
		COUNT(CASE WHEN status = 1 THEN 1 END),
		COUNT(*)
		FROM tasks`)
	if err := row.Scan(&stats.Pending, &stats.Done, &stats.Total); err != nil {
		return TaskStats{}, err
	}
	return stats, nil
}
