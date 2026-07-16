# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Beginner: Connecting and Creating a Table

Python's standard library ships `sqlite3` — no install required, no server process, the whole database is a single file (or lives entirely in memory).

```python
import sqlite3

connection = sqlite3.connect("app.db")   # file-based, persists after the program ends
connection = sqlite3.connect(":memory:") # in-memory, gone when the connection closes

connection.execute(
    """
    CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
    )
    """
)
```

`:memory:` is convenient for examples, tests, and scratch work because it never leaves a file on disk. Real applications almost always use a file path so data survives between runs.

## Beginner: Full CRUD (INSERT, SELECT, UPDATE, DELETE)

```python
# Create
connection.execute("INSERT INTO contacts (name, email) VALUES (?, ?)", ("Amina", "amina@example.com"))

# Read
cursor = connection.execute("SELECT * FROM contacts")
rows = cursor.fetchall()

# Update
connection.execute("UPDATE contacts SET email = ? WHERE name = ?", ("new@example.com", "Amina"))

# Delete
connection.execute("DELETE FROM contacts WHERE name = ?", ("Amina",))

connection.commit()  # not needed if you use `with connection:` — see below
```

Every write (`INSERT`/`UPDATE`/`DELETE`) needs a commit before it's durable, unless you wrap it in a `with connection:` block (next section).

## Intermediate: Parameterized Queries and `with`

The `?` in each query above is a **placeholder** — `sqlite3` binds the tuple's values into the query safely, keeping data completely separate from SQL syntax. Compare this to the unsafe alternative:

```python
# DO NOT DO THIS - building SQL with string formatting/concatenation:
name = user_input  # imagine this came from a web form
query = f"SELECT * FROM contacts WHERE name = '{name}'"
connection.execute(query)
```

If `user_input` were the string `' OR '1'='1`, the resulting query becomes `SELECT * FROM contacts WHERE name = '' OR '1'='1'`, which matches *every row* — a classic SQL injection. Because the malicious text is spliced directly into the SQL, the database can no longer tell "data" apart from "code." Parameterized queries (`?` placeholders with a tuple of values) never have this problem: the value is always treated as data, never parsed as part of the query's structure, no matter what characters it contains.

`with connection:` wraps a block in a transaction — it commits automatically if the block finishes without error, and rolls back if an exception is raised partway through. It does **not** close the connection; that's a separate, explicit step:

```python
with connection:
    connection.execute("INSERT INTO contacts (name, email) VALUES (?, ?)", ("Bilal", "bilal@example.com"))
# committed automatically here

connection.close()  # release the connection when you're completely done with it
```

## Advanced: Fetching Rows — `fetchone`, `fetchall`, and Cursor Iteration

A `cursor` (returned by `connection.execute(...)`) tracks a position within a result set. Three ways to pull rows out of it:

```python
cursor = connection.execute("SELECT * FROM contacts")

row = cursor.fetchone()      # one row (or None if no more rows) - good for "expect at most one match"
rows = cursor.fetchall()     # ALL remaining rows as a list - fine for small result sets

cursor = connection.execute("SELECT * FROM contacts")
for row in cursor:           # iterate lazily, one row at a time
    print(row)
```

`fetchall()` loads the *entire* remaining result set into memory as a list — convenient, but risky for a table with millions of rows. Iterating the cursor directly (the `for row in cursor:` form) pulls rows one at a time, which keeps memory usage flat regardless of table size. Prefer iteration for large tables; `fetchall()`/`fetchone()` are fine for small, bounded results.

## Real-World Usage

- Small tools, CLI scripts, desktop apps, and prototypes commonly use `sqlite3` directly — it needs no separate server, making it the simplest possible persistent storage.
- Production web applications more often use an ORM (SQLAlchemy, Django ORM) on top of a networked database (PostgreSQL, MySQL) for concurrency and scale, but the underlying concepts — parameterized queries, transactions, cursors — are identical.
- SQLite is also the standard embedded/local storage format for mobile apps and browsers (it's what's behind many app "local cache" databases).

## Summary

- `sqlite3` is a stdlib module — no installation needed — for a file-based or in-memory SQL database.
- Full CRUD: `INSERT`, `SELECT`, `UPDATE`, `DELETE`, executed via `connection.execute(sql, params)`.
- Always use `?` placeholders with a params tuple instead of building SQL strings by hand — this is what prevents SQL injection.
- `with connection:` auto-commits on success and rolls back on error; `connection.close()` releases resources when you're fully done.
- `fetchone()` gets a single row, `fetchall()` gets all remaining rows as a list, and iterating the cursor directly is the most memory-efficient option for large result sets.

## Key Terms

- **Cursor** — an object that tracks position within a query's result set and is used to fetch rows.
- **Parameterized query** — a SQL statement with `?` placeholders whose actual values are bound separately, keeping data and SQL syntax separate.
- **SQL injection** — an attack where untrusted input is spliced directly into a SQL string, letting it change the query's logic.
- **Transaction** — a group of database operations that either all succeed (commit) or all fail together (rollback).
- **`rowcount`** — the number of rows affected by the most recently executed statement.

## Common Mistakes

- Building SQL with f-strings/`.format()`/concatenation instead of `?` placeholders — this opens the door to SQL injection even in "internal" tools.
- Forgetting to commit (or forgetting to use `with connection:`), then wondering why data "disappeared" after the program exits.
- Using `fetchall()` on a huge table and loading millions of rows into memory at once instead of iterating the cursor.
- Forgetting to close the connection, leaking file handles/resources in long-running programs.
- Assuming `:memory:` databases persist across separate `connect()` calls — each new `:memory:` connection is a completely fresh, empty database.

## Best Practices

- Always use parameterized queries (`?` placeholders) — never interpolate untrusted values into SQL text.
- Wrap related writes in `with connection:` so they commit or roll back together as a single transaction.
- Use `fetchone()` when you expect at most one row, iterate the cursor for large result sets, and reserve `fetchall()` for small, bounded results.
- Close connections explicitly (or use a `with sqlite3.connect(...) as connection:` pattern) when a script is done with the database.
- Add a `UNIQUE`/`PRIMARY KEY` constraint at the schema level for anything that must not duplicate, rather than only checking in application code.

## Interview Questions

1. **Why should you use `?` placeholders instead of building SQL strings with f-strings or concatenation?**
   Placeholders keep user-supplied data completely separate from SQL syntax — the database driver binds the value as data, never parses it as part of the query. String concatenation lets a crafted input (like `' OR '1'='1`) change the query's actual logic, which is the root cause of SQL injection vulnerabilities.

2. **What's the difference between `fetchone()`, `fetchall()`, and iterating a cursor directly?**
   `fetchone()` returns a single row (or `None`), `fetchall()` returns every remaining row as a list (loading it all into memory at once), and iterating the cursor (`for row in cursor:`) pulls rows lazily one at a time — the most memory-efficient choice for large result sets.

3. **What does `with connection:` do, and what does it *not* do?**
   It wraps the block in a transaction: on success it commits automatically, and on an unhandled exception it rolls back. It does not close the connection — you still need an explicit `connection.close()` when you're done with the database entirely.

4. **Why is `:memory:` useful for examples and tests but not for real applications?**
   An in-memory database exists only for the lifetime of that connection — as soon as the connection closes (or the process ends), all data is gone. That's exactly what you want for a disposable demo or test fixture, but real applications need a file path (or a networked database) so data survives between runs.

5. **What does `cursor.rowcount` tell you, and when is it useful?**
   It reports how many rows the most recently executed statement affected — useful for confirming an `UPDATE` or `DELETE` matched the number of rows you expected (e.g., verifying exactly one row changed instead of silently matching zero or many).

## Suggested Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
