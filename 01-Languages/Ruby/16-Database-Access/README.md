# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Gems](../15-Modules-and-Gems/README.md)

## Learning Objectives

- Install and use the `sqlite3` gem for CRUD operations against a real SQLite database.
- Use parameterized queries (`?` placeholders) for every operation involving external data.
- Reproduce a real SQL injection via string interpolation, then defuse the identical attack with a parameterized query — the same demonstration used throughout this repository's other language courses.

## Prerequisites

[15-Modules-and-Gems](../15-Modules-and-Gems/README.md)

## Concept

The `sqlite3` gem (`gem install sqlite3`) wraps the SQLite C library, providing `SQLite3::Database` for opening a database file (or `:memory:` for an in-memory one) and `.execute`/`.prepare` for running SQL. `results_as_hash = true` makes result rows come back as Hashes with column-name keys instead of plain Arrays, matching the idiomatic style used throughout this course (Lesson 03/07).

The central, recurring safety lesson (verified live, not just described): building SQL by interpolating untrusted input directly into the query string lets that input change the query's *structure*, not just supply a data value — a classic SQL injection. Parameterized queries (`?` placeholders plus a separate arguments array) treat the same input purely as data, defusing the attack entirely.

## Detailed Example

See [example.rb](example.rb) — full CRUD against a temporary SQLite file (created and deleted by the script itself): `CREATE TABLE`, parameterized `INSERT`/`UPDATE`/`DELETE`, and a `SELECT` with a block iterating result rows; then the SQL-injection demonstration — an interpolated query with a malicious `name` value (`x' OR '1'='1`) that matches every row it shouldn't, immediately contrasted with the identical malicious value passed as a bound parameter instead, matching zero rows.

## Run It

```bash
gem install sqlite3
cd 01-Languages/Ruby/16-Database-Access
ruby example.rb
```

## Expected Output (real, captured)

```
inserted 2 rows
1: Ada Lovelace <ada@example.com>
2: Grace Hopper <grace@example.com>
ada@newmail.com
remaining rows: 1
unsafe query text: SELECT * FROM users WHERE name = 'x' OR '1'='1'
UNSAFE query returned 1 row(s) -- the injected OR '1'='1' matched everything!
SAFE parameterized query returned 0 row(s) -- injection defused
cleaned up temp db: true
```

(At the point the injection demo runs, only Ada's row remains — Grace's was already deleted earlier in the script — so "matched everything" here means the one remaining row; the structural point, that the injected `OR '1'='1'` bypassed the intended `WHERE name = ...` filter entirely, holds regardless of row count.)

## Common Mistakes

- Building any SQL string via `"...#{user_input}..."` interpolation — verified live above to let an attacker-controlled value change the query's logical structure, not just its data.
- Forgetting to close/clean up a temporary database file used only for a demo or test — this lesson's script deletes its own `lesson16_temp.db` at both the start (defensively) and the end.
- Assuming `results_as_hash = true` is the default — it isn't; without it, rows come back as plain Arrays indexed by column position, not Hashes keyed by column name.

## Best Practices

- Always use `?` placeholders (or `:named` placeholders with `.prepare`) for any value that isn't a hardcoded literal — never string-interpolate untrusted data into SQL, ever.
- Use `.prepare`/`.execute` for repeated inserts (as shown) rather than re-parsing the same SQL string on every call.
- Wrap multi-statement operations that must succeed or fail together in a transaction (`db.transaction { ... }`) — not shown in this lesson's simple CRUD example, but essential for real multi-step writes.

## Real-World Usage

This is the exact same "verified live SQL injection, then defused" demonstration this repository has already performed for Python (`sqlite3`), JavaScript/TypeScript (`node:sqlite`), PHP (PDO), C# (`Microsoft.Data.Sqlite`), and other language courses — parameterized queries are a universal, language-independent defense, not a Ruby-specific technique.

## Summary

- The `sqlite3` gem provides straightforward CRUD against a real SQLite database, with `results_as_hash = true` for Hash-shaped rows.
- String-interpolated SQL is a genuine, live-reproduced SQL injection vector; parameterized (`?`) queries defuse the identical attack completely.

## Key Terms

- **Parameterized query** — a SQL statement with placeholders (`?`) bound separately from the query text, preventing input from altering the query's structure.
- **SQL injection** — an attack where untrusted input, concatenated directly into SQL text, changes the query's logic rather than supplying an intended data value.

## Interview Questions

1. **Why does `"SELECT * FROM users WHERE name = '#{name}'"` risk a real SQL injection?**
   Because whatever `name` actually contains becomes part of the SQL text itself, not just a data value — if `name` is `x' OR '1'='1`, the resulting query's `WHERE` clause becomes structurally `name = 'x' OR '1'='1'`, which is true for every row, bypassing the intended filter entirely. This was reproduced live in this lesson, matching a row that should never have matched the literal name `x' OR '1'='1'`.

2. **How does a parameterized query (`?` placeholder) prevent that same attack?**
   The placeholder and the bound value are sent to SQLite separately — the database driver never re-parses the bound value as SQL syntax at all, so a value like `x' OR '1'='1` is compared literally, character-for-character, against the `name` column and matches nothing (verified directly: 0 rows returned for the identical malicious string, vs. a real match when the same value was interpolated into the query text).

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
