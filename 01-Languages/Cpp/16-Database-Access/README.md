# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using its C API (`sqlite3.h`) directly from C++.
- Use prepared statements with `?` placeholders to prevent SQL injection.
- Understand C++ has no built-in database access at all — not even a database-agnostic API like Java's JDBC.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Unlike Java (which at least has JDBC as a built-in, database-agnostic API even though drivers are external), the C++ standard library has **zero** database access support of any kind. This lesson uses SQLite's own C API directly, compiled from the "amalgamation" — a distribution of the entire SQLite engine as a single `sqlite3.c`/`sqlite3.h` pair, compiled directly alongside your program with no separate library-linking step needed. A real project would more commonly use a C++ wrapper library (like SQLiteCpp) or a full ORM, but the raw C API is what every C++ SQLite wrapper is ultimately built on.

## Getting the Amalgamation

```bash
curl -L -o sqlite-amalgamation.zip "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip"
unzip sqlite-amalgamation.zip
cp sqlite-amalgamation-3450300/sqlite3.h sqlite-amalgamation-3450300/sqlite3.c .
```

## Prepared Statements and Parameterized Queries

```cpp
#include "sqlite3.h"

sqlite3_stmt* stmt;
sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?)", -1, &stmt, nullptr);
sqlite3_bind_text(stmt, 1, title.c_str(), -1, SQLITE_TRANSIENT); // 1-indexed, like JDBC
sqlite3_step(stmt);   // executes the statement
sqlite3_finalize(stmt); // releases the prepared statement -- manual, no RAII wrapper in the raw C API
```

The C API is manual and C-style throughout — no RAII, no exceptions, error codes returned from every call (checked via `sqlite3_errmsg`) — a stark contrast to every other lesson in this course that could lean on RAII/exceptions. A real C++ project would typically wrap this in RAII classes (or use a library like SQLiteCpp that already does), consistent with Lesson 19's guidance.

## Detailed Example

See [example.cpp](example.cpp) — full CRUD against an in-memory SQLite database via the raw C API, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Cpp/16-Database-Access
curl -L -o sqlite-amalgamation.zip "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip"
unzip sqlite-amalgamation.zip
cp sqlite-amalgamation-3450300/sqlite3.h sqlite-amalgamation-3450300/sqlite3.c .
g++ -std=c++20 example.cpp sqlite3.c -o app && ./app
# or, from an MSVC Developer Command Prompt:
cl /EHsc /std:c++20 /Zc:__cplusplus example.cpp sqlite3.c /Fe:app.exe && app.exe
```

(`sqlite3.c`/`sqlite3.h` are deliberately not committed to this repository — like the JDBC driver JAR in the Java course, they're downloaded on demand and covered by `.gitignore`.)

## Expected Output

Running the command above prints inserted rows (read back with `sqlite3_column_*` accessors), an update reflected in a follow-up query, a delete reflected in the remaining row count, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, with the table surviving intact.

## Common Mistakes

- Building SQL by string concatenation instead of `?` placeholders with `sqlite3_bind_*` — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting `sqlite3_finalize()` on a prepared statement — leaks the statement's resources, since there's no RAII in the raw C API to do this automatically.
- Forgetting SQLite's C API parameter indices are 1-indexed, like JDBC, not 0-indexed.

## Best Practices

- Always use `?` placeholders with `sqlite3_bind_*` for any dynamic value.
- Wrap raw SQLite handles/statements in your own small RAII classes (or use a library like SQLiteCpp) rather than manually tracking every `sqlite3_finalize()`/`sqlite3_close()` call — exactly Lesson 19's broader guidance applied here.
- Check every SQLite API call's return code in real code (simplified/omitted in places in this lesson's example for readability) via `sqlite3_errmsg(db)`.

## Real-World Usage

Real C++ projects needing SQLite almost always use a thin RAII wrapper library (SQLiteCpp) rather than the raw C API directly, specifically to get exception-based error handling and automatic cleanup — but the raw API shown here is what every such wrapper compiles down to.

## Summary

- C++ has zero built-in database access — not even a database-agnostic API the way Java has JDBC.
- SQLite's C API (via the amalgamation) is manual and C-style: prepared statements, 1-indexed `?` placeholders, explicit `sqlite3_finalize()`, no RAII/exceptions by default.
- A real project would wrap this in RAII classes or use an existing wrapper library.

## Key Terms

- **SQLite amalgamation** — SQLite's entire engine distributed as a single `sqlite3.c`/`sqlite3.h` pair, compiled directly into your program.
- **Prepared statement (`sqlite3_stmt`)** — a compiled SQL statement object, bound with parameters via `sqlite3_bind_*` and executed via `sqlite3_step`.

## Interview Questions

1. **Does the C++ standard library provide any database access API, even a database-agnostic one like Java's JDBC?**
   No — C++ has zero built-in database support of any kind. Every database access approach (the raw SQLite C API used here, a wrapper library like SQLiteCpp, or an ORM) is entirely third-party, a more extreme version of the JSON gap the Java course identified in its standard library.

2. **Why does SQLite's raw C API require manual `sqlite3_finalize()` calls, unlike, say, C#'s `using var connection = ...`?**
   The raw C API is a pure C API with no concept of C++ RAII or destructors — every resource (a prepared statement, a database connection) must be explicitly released via its corresponding `sqlite3_finalize()`/`sqlite3_close()` call. A real C++ project would typically wrap these C handles in small RAII classes (or use a library that already does), so a destructor calls the cleanup function automatically, mirroring the safety C#'s `using` or Java's try-with-resources provide.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
