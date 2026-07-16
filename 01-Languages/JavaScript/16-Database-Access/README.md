# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against a real SQL database from Node with no external dependency.
- Use parameterized queries to prevent SQL injection.
- Explain the difference between `.run()`, `.get()`, and `.all()` for a prepared statement.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

This lesson mirrors [01-Languages/Python/16-Database-Access](../../Python/16-Database-Access/README.md), which uses Python's built-in `sqlite3` module specifically so the lesson needs no external database server or install step. Node's equivalent, `node:sqlite`, is a genuinely built-in core module (no `npm install` required) providing a synchronous SQLite API — it's marked experimental by Node itself as of this writing, but is stable enough for local learning and small tools; production code today more commonly reaches for a dependency like `better-sqlite3` (same API shape) or a full ORM (covered in [07-Databases](../../../07-Databases/)) for a real production database like PostgreSQL.

## Syntax

```js
const { DatabaseSync } = require("node:sqlite");

const db = new DatabaseSync(":memory:"); // or a file path, e.g. "app.db"

db.exec(`
  CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    done INTEGER NOT NULL DEFAULT 0
  )
`);
```

`:memory:` creates a database that exists only for the process's lifetime — ideal for this lesson (nothing to clean up afterward) and for tests; a real path (`"app.db"`) persists to disk.

## Prepared Statements: `.run()`, `.get()`, `.all()`

```js
const insert = db.prepare("INSERT INTO tasks (title) VALUES (?)");
insert.run("Write lesson"); // .run() -- for INSERT/UPDATE/DELETE, no rows returned

const one = db.prepare("SELECT * FROM tasks WHERE id = ?").get(1);   // .get() -- first matching row, or undefined
const all = db.prepare("SELECT * FROM tasks").all();                 // .all() -- every matching row, as an array
```

`db.prepare(sql)` compiles the SQL once, returning a reusable statement object; `?` placeholders are filled in by whatever arguments you pass to `.run()`/`.get()`/`.all()`. Reusing a prepared statement for repeated inserts (rather than building a new SQL string each time) is both faster and, critically, safe from injection.

## Parameterized Queries Prevent SQL Injection

```js
// SAFE: the value is bound as data, never interpreted as SQL syntax
db.prepare("SELECT * FROM tasks WHERE title = ?").get(userInput);

// UNSAFE -- never do this: directly interpolating user input into a SQL string
// db.exec(`SELECT * FROM tasks WHERE title = '${userInput}'`);
```

If `userInput` were `"'; DROP TABLE tasks; --"`, the unsafe version would execute that as real SQL, potentially destroying the table. The parameterized `?` version treats the exact same string as inert data to search for — this is demonstrated directly in this lesson's example, not just asserted.

## Detailed Example

See [example.js](example.js) — full CRUD against an in-memory SQLite database, plus a direct demonstration that a SQL-injection-shaped string is safely treated as plain data when passed through a parameterized query.

## Expected Output

Running `node example.js` prints three inserted rows, a full-table read, a single parameterized row lookup, an update reflected in a follow-up read, a delete reflected in the remaining rows, and finally a malicious-looking string being inserted and retrieved as an ordinary value — with the table's row count confirming it was never dropped.

## Common Mistakes

- Building SQL by string concatenation/template literals with user input — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Confusing `.get()` (single row, or `undefined` if no match) with `.all()` (always an array, empty if no matches) and mishandling the "not found" case for one when expecting the other's shape.
- Forgetting `db.close()` when using a file-backed (not `:memory:`) database in a script, potentially leaving the file locked.
- Not using prepared statements for repeated similar queries, recompiling the same SQL string on every call for no benefit.

## Best Practices

- Always use parameterized queries (`?` placeholders) for any value not hardcoded at development time — never string-interpolate user input into SQL.
- Reuse a single prepared statement object for repeated queries with the same shape (e.g., inside a loop inserting many rows) rather than calling `db.prepare(...)` again each time.
- Use `:memory:` for tests and throwaway scripts; use a real file path (or a full database server, see [07-Databases](../../../07-Databases/)) for anything that needs to persist.

## Real-World Usage

This exact `.prepare(sql).run(...)`/`.get(...)`/`.all(...)` shape is also how `better-sqlite3` (the most popular third-party SQLite driver for Node, sharing an almost identical API) works, so these patterns transfer directly; production Node backends typically use an ORM ([07-Databases](../../../07-Databases/) — Prisma, Sequelize, TypeORM) over PostgreSQL/MySQL, but the underlying "parameterized queries, never string-interpolated SQL" principle is identical regardless of database or driver.

## Security Considerations

SQL injection remains one of the OWASP Top 10 vulnerabilities (see [16-Security](../../../16-Security/)) precisely because string-interpolated queries are so easy to write without thinking. The rule is absolute: user-controlled data always goes through parameter placeholders, never directly into the SQL string itself, with no exceptions for "this input is probably fine."

## Summary

- `node:sqlite`'s `DatabaseSync` gives CRUD access to a real SQL database with zero external dependencies.
- `.run()` is for statements with no result rows (INSERT/UPDATE/DELETE); `.get()` returns one row (or `undefined`); `.all()` returns every matching row as an array.
- Parameterized (`?`) queries are what actually prevent SQL injection — this was demonstrated with a genuinely malicious-shaped string, not just claimed.

## Key Terms

- **Prepared statement** — a precompiled SQL query object, reusable across multiple calls with different bound parameter values.
- **SQL injection** — a vulnerability where untrusted input is interpreted as SQL syntax rather than as data, because it was concatenated directly into a query string.
- **`:memory:` database** — a SQLite database that exists only in RAM for the process's lifetime, leaving nothing on disk.

## Review Questions

1. Why does `.get()` return `undefined` instead of throwing when no row matches?
2. Why is a hardcoded, never-user-supplied SQL string still worth writing with `?` placeholders when it does take dynamic values?
3. What would have happened in this lesson's example if the malicious title had been concatenated into the query string directly instead of bound as a parameter?

## Interview Questions

1. **What is SQL injection, and how do parameterized queries prevent it?**
   SQL injection happens when untrusted input is inserted directly into a SQL query string, letting an attacker supply text that the database interprets as additional SQL syntax rather than as a plain value (e.g., ending the intended string early and appending a `DROP TABLE`). Parameterized queries send the query structure and the data separately — the database driver binds parameter values as pure data, never re-parsing them as SQL, which makes injection through that parameter structurally impossible regardless of what the value contains.

2. **What's the difference between `.get()` and `.all()` on a prepared statement?**
   `.get()` returns the first matching row as an object, or `undefined` if nothing matched — appropriate when you expect at most one result (e.g., a lookup by primary key). `.all()` always returns an array of every matching row, empty if there were no matches — appropriate for queries that can return any number of rows.

3. **Why use an in-memory (`:memory:`) database for a lesson or test suite?**
   It behaves like a real SQLite database for every query, but exists only for the current process and is automatically discarded when the process ends — no setup, no file left behind to clean up, and no risk of test runs interfering with each other's data, since each process gets a fresh, isolated database.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
