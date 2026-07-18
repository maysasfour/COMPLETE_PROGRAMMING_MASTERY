# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Header Files](../15-Modules-and-Header-Files/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using its C API (`sqlite3.h`) directly.
- Use prepared statements with `?` placeholders to prevent SQL injection.
- Understand C has **zero** built-in database access — not even a database-agnostic API like Java's JDBC.

## Prerequisites

[15-Modules-and-Header-Files](../15-Modules-and-Header-Files/README.md)

## Concept

C's standard library has no database access support of any kind — the same gap this repository's C++ course documents, except here there isn't even a C++-style wrapper convention to reach for by default; the raw C API genuinely **is** the everyday interface real C programs use against SQLite. This lesson compiles against the SQLite "amalgamation" — the entire SQLite engine distributed as a single `sqlite3.c`/`sqlite3.h` pair, compiled directly alongside the program with no separate library-linking step needed, exactly as this repository's C++ Lesson 16 does.

## Getting the Amalgamation

```bash
curl -L -o sqlite-amalgamation.zip "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip"
unzip sqlite-amalgamation.zip
cp sqlite-amalgamation-3450300/sqlite3.h sqlite-amalgamation-3450300/sqlite3.c .
```

(`sqlite3.h`/`sqlite3.c` are deliberately **not** committed to this repository — downloaded on demand and covered by `.gitignore`, identical treatment to the C++/Java/Swift courses' own external dependencies.)

## Prepared Statements and Parameterized Queries

```c
sqlite3_stmt* stmt;
sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?);", -1, &stmt, NULL);
sqlite3_bind_text(stmt, 1, title, -1, SQLITE_TRANSIENT);   /* 1-indexed, like JDBC */
sqlite3_step(stmt);                                          /* executes the statement */
sqlite3_finalize(stmt);                                      /* releases it -- fully manual, no RAII */
```

The API is manual and C-style throughout: error codes returned from every call (checked via `sqlite3_errmsg(db)`), no exceptions, no automatic cleanup — `sqlite3_finalize`/`sqlite3_close` must always be called explicitly.

## Detailed Example

See [example.c](example.c) — full CRUD against an in-memory SQLite database (`:memory:`, so no file is left behind), plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/C/16-Database-Access
curl -L -o sqlite-amalgamation.zip "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip"
unzip sqlite-amalgamation.zip
cp sqlite-amalgamation-3450300/sqlite3.h sqlite-amalgamation-3450300/sqlite3.c .
cl /std:c17 example.c sqlite3.c /Fe:app.exe && app.exe
# or, with gcc: gcc -std=c17 example.c sqlite3.c -o app && ./app
```

## Expected Output

```
Inserted 3 tasks.

All tasks:
  [ ] #1 Write report
  [ ] #2 Review PR
  [ ] #3 Water plants

Marked task #1 done.
Deleted task #3.

Tasks after update/delete:
  [x] #1 Write report
  [ ] #2 Review PR

SQL-injection-safety check:
  Malicious-looking string inserted safely as plain data.
  Table survived intact -- 3 rows remain (table was NOT dropped).
```

Genuinely compiled (`example.c` + the downloaded `sqlite3.c`, together, as a single `cl` invocation) and run with MSVC 19.51 — zero warnings, real captured output, `sqlite3.c`/`sqlite3.h`/the downloaded zip all cleaned up afterward per this repository's convention.

## Common Mistakes

- Building SQL by string concatenation instead of `?` placeholders with `sqlite3_bind_*` — the exact vulnerability this lesson demonstrates a safe alternative to.
- Forgetting `sqlite3_finalize()` on a prepared statement — leaks the statement's resources, since there's no RAII in the raw C API to do this automatically.
- Forgetting SQLite's C API parameter indices are 1-indexed, not 0-indexed.
- Forgetting `sqlite3_reset()` when reusing the same prepared statement for multiple rows (as `example.c`'s insert loop does) — without it, a second `sqlite3_step()` call on an already-stepped-to-completion statement returns `SQLITE_MISUSE` instead of executing again.

## Best Practices

- Always use `?` placeholders with `sqlite3_bind_*` for any dynamic value.
- Check every SQLite API call's return code in real code (some checks are simplified in this lesson's example for readability) via `sqlite3_errmsg(db)`.
- Since C has no RAII to lean on at all (unlike C++, which can at least wrap the C handles in an RAII class as Lesson 19 there suggests), be especially disciplined about pairing every `sqlite3_prepare_v2` with a `sqlite3_finalize`, and every `sqlite3_open` with a `sqlite3_close`.

## Real-World Usage

Real C projects needing SQLite use this exact raw C API directly far more often than C++ projects do (which can reach for a thin RAII wrapper like SQLiteCpp) — this raw API genuinely is idiomatic, everyday C, not just an educational stepping stone to something higher-level.

## Summary

- C has zero built-in database access — even more starkly than C++, since C has no RAII to even partially soften the raw API's manual cleanup discipline.
- SQLite's C API (via the amalgamation) is manual and C-style: prepared statements, 1-indexed `?` placeholders, explicit `sqlite3_finalize()`/`sqlite3_reset()`, no exceptions.
- Genuinely compiled and run with real, captured CRUD output including the SQL-injection-safety check, matching this repository's C++/Java/C# courses' own equivalent demonstrations.

## Key Terms

- **SQLite amalgamation** — SQLite's entire engine distributed as a single `sqlite3.c`/`sqlite3.h` pair, compiled directly into your program.
- **Prepared statement (`sqlite3_stmt`)** — a compiled SQL statement object, bound with parameters via `sqlite3_bind_*` and executed via `sqlite3_step`.

## Interview Questions

1. **Does C have any built-in database access, even a database-agnostic API like Java's JDBC?**
   No — genuinely none. Every database access approach in C (the raw SQLite C API used here, or any third-party wrapper/ORM) is entirely external to the language and standard library, and — unlike C++, which can at least wrap the raw handles in an RAII class to get automatic cleanup — C has no language mechanism to soften the raw API's fully manual resource-management discipline at all.

2. **What does `sqlite3_reset()` do, and why does `example.c`'s insert loop need it?**
   `sqlite3_reset()` returns an already-executed prepared statement to its initial state so it can be re-bound with new parameter values and executed again, without recompiling the SQL from scratch. `example.c`'s insert loop prepares the `INSERT` statement once, then for each of the three titles calls `sqlite3_bind_text` + `sqlite3_step` + `sqlite3_reset` — omitting the reset would leave the statement in its post-execution state, and a second `sqlite3_step()` call on it would return `SQLITE_MISUSE` instead of inserting the next row.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
