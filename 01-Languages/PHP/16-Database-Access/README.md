# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using PDO (PHP Data Objects), PHP's built-in, driver-agnostic database abstraction.
- Use named parameterized placeholders (`:name`) to prevent SQL injection.
- Enable `PDO::ERRMODE_EXCEPTION` so database errors throw instead of failing silently.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

PDO is PHP's built-in database access layer — a single, consistent API (`prepare`/`execute`/`query`/`fetchColumn`) working across many database backends (SQLite, MySQL, PostgreSQL) by simply changing the connection string's driver prefix (`sqlite:`, `mysql:`, `pgsql:`). This is genuinely comparable to Go's `database/sql` (a built-in abstraction with pluggable drivers) and stands in contrast to languages needing a driver-specific library with no shared abstraction at all.

## Connecting and Error Mode

```php
$pdo = new PDO("sqlite::memory:");
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // throw on errors
```

By default, PDO's error mode is `PDO::ERRMODE_SILENT` (errors must be checked manually via `errorInfo()`) — explicitly setting `ERRMODE_EXCEPTION` makes failed queries throw a `PDOException` instead, matching this course's Lesson 09 exception-handling conventions and avoiding PHP's non-exception-based-by-default file-I/O pattern from Lesson 10.

## Named Parameterized Placeholders

```php
$stmt = $pdo->prepare("INSERT INTO tasks (title) VALUES (:title)");
$stmt->execute(["title" => $title]); // named placeholder -- bound safely, no string concatenation
```

`:name`-style named placeholders (PDO also supports positional `?` placeholders) prevent SQL injection by keeping user-supplied values entirely separate from the SQL query structure, the same core principle demonstrated in every other language course's database lesson in this repository.

## CRUD Pattern

```php
$pdo->query("SELECT id, title, done FROM tasks");                       // simple, no-parameter reads
$pdo->prepare("UPDATE tasks SET done = 1 WHERE id = :id")->execute([...]); // parameterized writes
$pdo->query("SELECT COUNT(*) FROM tasks")->fetchColumn();                  // scalar result shortcut
```

## Detailed Example

See [example.php](example.php) — full CRUD against an in-memory SQLite database via PDO, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses (storing and retrieving a `'; DROP TABLE tasks; --`-style string as inert, plain data).

## Run It

```bash
cd 01-Languages/PHP/16-Database-Access
php example.php
```

## Expected Output

Running `php example.php` prints confirmation of 3 inserted rows, all 3 rows read back, row 1's `done` status flipping to `1` after an update, a remaining row count of `2` after a delete, confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, and confirmation the table survives intact with all rows present (`3` rows, including the malicious-string test row).

## Common Mistakes

- Building SQL by string concatenation/interpolation instead of named/positional placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Leaving PDO in its default `ERRMODE_SILENT` mode and never checking `errorInfo()` — failed queries fail silently, unlike this lesson's explicit `ERRMODE_EXCEPTION` setting, which surfaces failures immediately as catchable exceptions.
- Forgetting `fetchColumn()` returns a single scalar value (or `false` if no rows), while `fetch()`/`fetchAll()` return associative arrays for row(s) — using the wrong one for a given query's shape is a common mix-up.

## Best Practices

- Always set `PDO::ATTR_ERRMODE` to `PDO::ERRMODE_EXCEPTION` immediately after connecting.
- Always use `:name` or `?` placeholders with `execute([...])` for any dynamic value in SQL — never string-interpolate user input into a query.
- Use `fetchColumn()` for single-scalar-value queries (counts, existence checks) rather than fetching a full row just to extract one field.

## Real-World Usage

PDO is the standard, portable way PHP applications access relational databases when driver-agnostic code matters (an application supporting both MySQL and PostgreSQL, for instance); frameworks like Laravel build a higher-level ORM (Eloquent) on top of PDO, but PDO itself remains the foundational, driver-agnostic layer beneath it.

## Summary

- PDO is PHP's built-in, driver-agnostic database access layer — one API across SQLite/MySQL/PostgreSQL/etc.
- `PDO::ERRMODE_EXCEPTION` should be set explicitly for exception-based error handling; the default is silent.
- Named (`:name`) or positional (`?`) placeholders with `execute([...])` prevent SQL injection — the same principle as every other language course in this repository.

## Key Terms

- **PDO (PHP Data Objects)** — PHP's built-in, driver-agnostic database access API.
- **`fetchColumn()`** — retrieves a single scalar value from a query's first row/column.

## Interview Questions

1. **What does PDO provide that a database-specific extension (like the older `mysqli`) doesn't?**
   PDO offers a single, consistent API (`prepare`/`execute`/`query`/`fetch*`) that works across many different database backends by changing only the connection string's driver prefix (`sqlite:`, `mysql:`, `pgsql:`) — application code using PDO doesn't need to change when switching databases (aside from any database-specific SQL syntax differences), unlike a driver-specific extension tied permanently to one database engine. This mirrors Go's `database/sql` abstraction covered earlier in this repository.

2. **Why is `PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION` considered a best practice to set explicitly?**
   PDO's default error mode is `ERRMODE_SILENT`, meaning a failed query returns `false` and requires manually calling `errorInfo()` to discover what went wrong — easy to forget, leading to silently-ignored database failures. Setting `ERRMODE_EXCEPTION` makes any failed operation throw a `PDOException` immediately, which integrates naturally with PHP's `try`/`catch` exception handling (Lesson 09) and ensures database errors can't be silently missed the way a forgotten `errorInfo()` check would allow.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
