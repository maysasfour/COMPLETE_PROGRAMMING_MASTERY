# 16 — Database Access

[Back to Bash course](../README.md)

## Honest Availability Check — Verified Live

Bash has no built-in database driver of any kind (no equivalent of Python's `sqlite3` module or Ruby's `sqlite3` gem) — any database access from a Bash script means shelling out to a database's own command-line client. The most common pairing for lightweight local persistence is the `sqlite3` CLI. This course's environment was checked live:

```bash
$ where sqlite3
INFO: Could not find files for the given pattern(s).
```

`sqlite3` is **not installed** in this environment. In the interest of honesty (per this repository's standard), this lesson documents the pattern precisely as it would be used, but the following blocks marked "not runnable here" were not executed live — everything else in this course was. The Lesson 22 mini-project therefore uses a flat-file persistence approach instead (which **was** fully run live), so as not to depend on a tool this environment doesn't have.

## The Pattern, Documented (not runnable in this environment)

If `sqlite3` were installed, a Bash script would drive it non-interactively like this:

```bash
#!/usr/bin/env bash
set -euo pipefail
DB="app.db"

sqlite3 "$DB" <<'SQL'
CREATE TABLE IF NOT EXISTS tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending'
);
SQL

# CREATE
sqlite3 "$DB" "INSERT INTO tasks (description) VALUES ('Buy milk');"

# READ
sqlite3 -header -column "$DB" "SELECT * FROM tasks;"

# UPDATE
sqlite3 "$DB" "UPDATE tasks SET status = 'done' WHERE id = 1;"

# DELETE
sqlite3 "$DB" "DELETE FROM tasks WHERE id = 1;"
```

Key idioms: a heredoc (`<<'SQL' ... SQL`) feeds multi-statement SQL to `sqlite3` in one call; `-header -column` produces human-readable tabular output for `SELECT`; each CRUD operation is just one more `sqlite3 "$DB" "..."` invocation, with `$DB` quoted since paths can contain spaces.

## How to Check for `sqlite3` Yourself

```bash
if command -v sqlite3 >/dev/null 2>&1; then
  echo "sqlite3 available"
else
  echo "sqlite3 not found — falling back to flat-file storage"
fi
```

`command -v` is the portable, POSIX way to check for a command's existence (preferred over `which`, which isn't guaranteed to exist on every system) — this is exactly the check the Lesson 22 mini-project uses conceptually to decide its persistence strategy.

## Common Beginner Mistakes

- Assuming `sqlite3` (or any database client) ships with Bash itself — it's always an external dependency, installed separately.
- Forgetting to quote SQL string values that might contain a single quote themselves, which breaks the SQL string literal — real scripts need to sanitize or escape user input before interpolating it into a query string (a genuine SQL-injection-shaped risk when building queries via string concatenation in Bash).
- Not checking `command -v sqlite3` before assuming it's available in every deployment environment.

## Best Practices

- Always check for a database CLI's availability with `command -v` before depending on it, and fail with a clear message (or fall back) if missing.
- Prefer parameterized approaches or careful escaping over raw string concatenation when building SQL from variable input.
- For genuinely small, single-user, local persistence needs (like Lesson 22's task tracker), a flat delimited file is a legitimate, dependency-free alternative to a real database.

## Interview Questions

1. Why does Bash have no "database driver" concept the way Python or Ruby does?
2. What real risk does building a SQL string via Bash variable concatenation introduce, and how would you check for it?
3. When might a flat file be a reasonable substitute for `sqlite3` in a Bash script?
