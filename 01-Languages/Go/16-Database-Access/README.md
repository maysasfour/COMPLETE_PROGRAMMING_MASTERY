# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using the built-in `database/sql` package plus a third-party driver.
- Use parameterized queries (`?` placeholders) to prevent SQL injection.
- Understand why this lesson's `go.mod`/`go.sum` **are** committed, unlike the JDBC driver/SQLite amalgamation files in the Java/C++ courses.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

`database/sql` is Go's built-in, database-agnostic SQL API (conceptually similar to Java's JDBC) — but like every other language in this repository, Go's standard library includes no specific database driver; a separate package registers itself as a driver for `database/sql` to use. This lesson uses `modernc.org/sqlite`, a **pure-Go** SQLite implementation (no CGO, no C compiler needed) — a genuinely convenient choice specifically because it avoids the C-toolchain dependency the more common `mattn/go-sqlite3` driver requires.

## Setting Up the Dependency

```bash
go mod init dbdemo
go get modernc.org/sqlite
```

Unlike the Java course's JDBC driver JAR or the C++ course's SQLite amalgamation (both deliberately *not* committed, downloaded fresh each time), **this lesson's `go.mod`/`go.sum` genuinely are committed** — they're small text files declaring dependency names/versions/checksums, not the dependency code itself (which lives in Go's shared module cache, downloaded on demand exactly like `node_modules`/Maven/NuGet caches work). This is standard, idiomatic Go practice, explained in Lesson 15.

## `database/sql` and Parameterized Queries

```go
import (
	"database/sql"
	_ "modernc.org/sqlite" // blank import: registers the driver, used only for its side effect
)

db, _ := sql.Open("sqlite", ":memory:")
defer db.Close()

db.Exec("INSERT INTO tasks (title) VALUES (?)", title) // ? placeholder -- parameterized, safe

rows, _ := db.Query("SELECT id, title FROM tasks")
for rows.Next() {
	var id int
	var title string
	rows.Scan(&id, &title) // Scan populates variables via their addresses, like json.Unmarshal
}
```

The blank import (`_ "modernc.org/sqlite"`) is a genuinely Go-specific idiom — it imports a package purely for its side effect (registering itself with `database/sql`'s driver registry via an `init()` function) without needing to reference any of its exported names directly.

## Detailed Example

See [main.go](main.go) — full CRUD against an in-memory SQLite database, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Go/16-Database-Access
go mod tidy   # go.mod/go.sum are already present and committed; this just verifies/restores them
go run main.go
```

## Expected Output

Running `go run main.go` prints inserted rows (read back via `rows.Scan`), an update reflected in a follow-up query, a delete reflected in the remaining row count, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, with the table surviving intact.

## Common Mistakes

- Building SQL by string concatenation instead of `?` placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting the blank import (`_ "modernc.org/sqlite"`) — without it, the driver never registers itself, and `sql.Open("sqlite", ...)` fails with an "unknown driver" error.
- Forgetting to check the `error` returned by `db.Exec`/`db.Query`/`rows.Scan` — same Lesson 09 discipline applies here.

## Best Practices

- Always use `?` placeholders for any dynamic value in SQL.
- Use `defer db.Close()`/`defer rows.Close()` immediately after successfully opening a connection or query result.
- Prefer a pure-Go driver (like `modernc.org/sqlite`) over a CGO-based one when avoiding a C-toolchain dependency in your build matters (e.g., simplifying cross-compilation).

## Real-World Usage

`database/sql` combined with a registered driver is the standard way Go services access relational databases; for more complex applications, a query builder or lightweight ORM (like `sqlx` or `GORM`) is often layered on top, but all of them ultimately use exactly this `database/sql` foundation.

## Summary

- `database/sql` is Go's built-in, database-agnostic SQL API; a separate driver package (registered via a blank import) provides the actual database-specific implementation.
- `?` placeholders are Go's parameterized-query syntax, preventing SQL injection the same way as every other language course.
- This lesson's `go.mod`/`go.sum` are genuinely committed — small, legitimate text files, unlike the binary dependencies deliberately excluded in the Java/C++ courses.

## Key Terms

- **`database/sql`** — Go's built-in, driver-agnostic SQL database API.
- **Blank import (`_ "package"`)** — importing a package solely for its side effects (like driver registration), without referencing its exported names.

## Interview Questions

1. **Does Go's standard library include a specific database driver, or just an abstraction?**
   Just the abstraction — `database/sql` provides a database-agnostic API (`Open`, `Exec`, `Query`, `Scan`), directly comparable to Java's JDBC, but the actual database-specific driver (for SQLite, PostgreSQL, MySQL, etc.) is always a separate package that registers itself with `database/sql`'s driver registry.

2. **What does a blank import (`_ "modernc.org/sqlite"`) do, and why is it needed here?**
   It imports a package purely for its side effects — running that package's `init()` function(s) — without giving you access to any of its exported names directly. SQLite (and other `database/sql` drivers) use their `init()` function to register themselves with `database/sql`'s internal driver registry; without the blank import, that registration never happens, and `sql.Open("sqlite", ...)` fails because no driver named `"sqlite"` was ever registered.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
