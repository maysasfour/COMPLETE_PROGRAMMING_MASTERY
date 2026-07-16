# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift has **no built-in database access** — matching C++'s complete gap (covered earlier in this repository), requiring either the raw SQLite3 C API (used here) or a wrapper library.
- Use `sqlite3_prepare_v2`/`sqlite3_bind_*` parameterized queries to prevent SQL injection.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Swift's standard library provides no database access at all, matching C++'s complete gap (covered earlier in this repository) rather than Go's built-in `database/sql` abstraction. Since SQLite ships as a system library on Apple platforms (and is commonly available on Linux too), this lesson uses SQLite3's raw C API directly via `import SQLite3` — genuinely usable from Swift thanks to its strong C interoperability, though most real Swift projects use a higher-level wrapper library (SQLite.swift or GRDB) instead of raw C interop for a more idiomatic, type-safe API.

## Raw SQLite3 C API from Swift

```swift
import SQLite3

var db: OpaquePointer?
sqlite3_open(":memory:", &db)

var stmt: OpaquePointer?
sqlite3_prepare_v2(db, "INSERT INTO tasks (title) VALUES (?)", -1, &stmt, nil)
sqlite3_bind_text(stmt, 1, title, -1, nil) // ?, 1-indexed, bound safely -- no string concatenation
sqlite3_step(stmt)
sqlite3_finalize(stmt)
```

`OpaquePointer` represents the C API's opaque `sqlite3*`/`sqlite3_stmt*` handles — Swift's C interoperability lets it call C functions and manage C pointers directly, though with noticeably more manual bookkeeping (`sqlite3_finalize` must be called explicitly for every prepared statement) than a wrapper library or the higher-level database APIs covered in this repository's other language courses.

## Reading Rows

```swift
var readStmt: OpaquePointer?
sqlite3_prepare_v2(db, "SELECT id, title, done FROM tasks", -1, &readStmt, nil)
while sqlite3_step(readStmt) == SQLITE_ROW {
    let id = sqlite3_column_int(readStmt, 0)
    let title = String(cString: sqlite3_column_text(readStmt, 1)) // C string -> Swift String
    // ...
}
sqlite3_finalize(readStmt)
```

## Detailed Example

See [Example.swift](Example.swift) — full CRUD against an in-memory SQLite database via the raw C API, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
swiftc Example.swift -o example -lsqlite3
./example
```

**Not verified by execution in this course** — see the honesty note above. (`-lsqlite3` links the system SQLite library; exact linking flags may vary by platform.)

## Expected Output

Running the compiled binary should print confirmation of 3 inserted rows, all 3 rows read back, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query.

## Common Mistakes

- Forgetting `sqlite3_finalize` for every prepared statement — unlike higher-level database APIs covered elsewhere in this repository (which often provide automatic resource cleanup, like Kotlin's `.use { }` or Python's context managers), the raw C API requires explicit, manual cleanup for every statement handle.
- Building SQL by string concatenation instead of `?`-placeholders with `sqlite3_bind_*` — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Assuming Swift has a built-in database abstraction the way Go does (`database/sql`) — it doesn't; SQLite3's C API (or a wrapper library) is required, matching C++'s equivalent gap covered earlier in this repository.

## Best Practices

- Use a wrapper library (SQLite.swift or GRDB, both popular, idiomatic Swift options) for real projects rather than raw C API calls, for type safety and automatic resource management.
- Always use `?`-parameterized queries bound via `sqlite3_bind_*`, never string-interpolated SQL.
- Wrap raw C API resource management (statement finalization, connection closing) in Swift's `defer` keyword to guarantee cleanup even if an error occurs partway through a function.

## Real-World Usage

Real Swift/iOS applications needing local persistence typically use Core Data (Apple's own object-graph/persistence framework, built on SQLite internally) or a wrapper library like GRDB/SQLite.swift rather than raw C API calls — this lesson's direct C interop demonstrates what those higher-level tools abstract away, mirroring how this repository's C++ course used the raw SQLite C API directly for the same reason (no built-in abstraction to fall back on).

## Summary

- Swift has no built-in database access, matching C++'s complete gap covered earlier in this repository.
- The raw SQLite3 C API is directly callable from Swift via `import SQLite3` and `OpaquePointer`, though it requires manual resource management (`sqlite3_finalize`) that higher-level APIs would handle automatically.
- `?`-parameterized queries via `sqlite3_bind_*` prevent SQL injection — the same principle as every other language course in this repository.

## Key Terms

- **`OpaquePointer`** — Swift's representation of an opaque C pointer type, used here for SQLite's `sqlite3*`/`sqlite3_stmt*` handles.
- **C interoperability** — Swift's ability to call C functions and work with C data types directly, used here to access SQLite's C API with no wrapper library.

## Interview Questions

1. **Why does this lesson use the raw SQLite3 C API instead of a higher-level Swift database library?**
   Swift's standard library has no built-in database access at all — the same gap this repository's C++ course found in the C++ standard library. SQLite happens to be available as a system library on Apple platforms (and commonly on Linux), and Swift's strong C interoperability makes it directly callable via `import SQLite3` with no additional dependency, which is why this lesson uses it directly for a genuinely install-free demonstration. Real Swift projects would typically use a wrapper library like GRDB or SQLite.swift instead, which provide a more idiomatic, type-safe, and memory-safe API on top of the same underlying C library, abstracting away the manual pointer/statement management shown in this lesson.

2. **What manual responsibility does using SQLite's raw C API from Swift introduce that a higher-level database API (like Kotlin's JDBC + `.use { }`, covered in this repository's Kotlin course) would handle automatically?**
   Every prepared statement obtained via `sqlite3_prepare_v2` must be explicitly finalized with `sqlite3_finalize` once it's no longer needed — there's no automatic resource cleanup mechanism at this level, unlike Kotlin's `.use { }` (or Java/C#'s try-with-resources equivalents), which guarantee a `Closeable` resource's cleanup even if an exception occurs. Working with the raw C API means the programmer is responsible for remembering this cleanup at every call site, ideally wrapped in Swift's `defer` keyword to ensure it happens even if an error occurs partway through a function — a genuine, manual bookkeeping burden that higher-level, wrapper-based or built-in database APIs are specifically designed to eliminate.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
