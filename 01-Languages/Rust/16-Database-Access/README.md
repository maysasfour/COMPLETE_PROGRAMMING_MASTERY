# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using the `rusqlite` crate.
- Use parameterized queries (`?1`, `?2`, ...) to prevent SQL injection.
- Understand Rust's standard library has no database access at all — like C++, a crate is required, but `rusqlite`'s `bundled` feature compiles SQLite from source automatically.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Like C++ (and unlike Go, which at least has `database/sql` as a built-in abstraction), Rust's standard library provides **no database access whatsoever** — `rusqlite` is the de facto standard SQLite crate. This lesson uses its `bundled` feature (`Cargo.toml`'s `features = ["bundled"]`), which compiles SQLite's C source directly as part of the build — genuinely convenient, since it requires no separately-installed SQLite library on the system, only a working C compiler (which `cargo` locates automatically, the same MSVC toolchain used throughout this course).

## `rusqlite` and Parameterized Queries

```rust
use rusqlite::{params, Connection};

let conn = Connection::open_in_memory()?;

conn.execute(
    "INSERT INTO tasks (title) VALUES (?1)", // ?1, ?2, ... -- parameterized, 1-indexed
    params![title],
)?;

let mut stmt = conn.prepare("SELECT id, title FROM tasks")?;
let rows = stmt.query_map([], |row| {
    Ok((row.get::<_, i32>(0)?, row.get::<_, String>(1)?))
})?;
for row in rows {
    let (id, title) = row?;
    println!("{}: {}", id, title);
}
```

Every `rusqlite` operation returns a `rusqlite::Result<T>` (Lesson 09's pattern) — the `?` operator propagates a database error immediately, and `main` itself can return `rusqlite::Result<()>` to let errors bubble all the way up cleanly with no manual matching at every step.

## Detailed Example

See [Cargo.toml](Cargo.toml) and [src/main.rs](src/main.rs) — full CRUD against an in-memory SQLite database, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Rust/16-Database-Access
cargo run
```

(`Cargo.lock` is committed, matching Go's `go.sum` — a small, legitimate dependency-version manifest, not the dependency code itself, which Cargo downloads and compiles into `target/` on demand, excluded via `.gitignore`.)

## Expected Output

Running `cargo run` prints inserted rows (read back via `query_map`), an update reflected in a follow-up query, a delete reflected in the remaining row count, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, with the table surviving intact.

## Common Mistakes

- Building SQL by string concatenation instead of `?1`/`?2` placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting `rusqlite`'s parameter placeholders are **1-indexed** (`?1`, not `?0`), like JDBC and Go's `database/sql` equivalents.
- Using `.unwrap()` everywhere instead of propagating errors with `?` — works for a quick example, but hides which specific operation might realistically fail in production code.

## Best Practices

- Always use `?N` placeholders with `params![...]` for any dynamic value in SQL.
- Let `main` (or any function) return `Result<(), E>` and use `?` throughout, rather than `.unwrap()`-ing at every database call.
- Use the `bundled` feature for portability (no system SQLite dependency) unless you specifically need to link against an existing system installation.

## Real-World Usage

`rusqlite` (or a higher-level async database crate like `sqlx` for more complex applications, especially with PostgreSQL/MySQL) is the standard way Rust applications access relational databases; the `bundled` SQLite feature specifically is popular for CLI tools and desktop applications that want zero external runtime dependencies.

## Summary

- Rust's standard library has zero database access, like C++; `rusqlite` (with its `bundled` feature) is the standard, dependency-free-at-runtime way to use SQLite.
- `?1`/`?2` parameterized placeholders (1-indexed) prevent SQL injection, the same principle as every other language course.
- `Cargo.lock` is genuinely committed, like Go's `go.sum`, unlike the deliberately-excluded binary dependencies in the Java/C++ courses.

## Key Terms

- **`rusqlite`** — the de facto standard Rust crate for SQLite access.
- **`bundled` feature** — a Cargo feature flag causing SQLite's C source to be compiled directly into the crate, avoiding a system SQLite dependency.

## Interview Questions

1. **Does Rust's standard library provide any database access?**
   No — none at all, similar to C++'s complete gap (and a step further than Go, which at least has `database/sql` as a built-in abstraction even though drivers are external). `rusqlite` is the de facto standard crate for SQLite specifically; other databases have their own dedicated crates (or a higher-level abstraction like `sqlx`/`diesel`).

2. **What does the `bundled` feature of `rusqlite` do, and why is it convenient?**
   It compiles SQLite's C source code directly as part of building the Rust crate, rather than requiring a pre-installed system SQLite library to link against. This means the only external requirement is a working C compiler (which Cargo's build scripts locate automatically), making the crate genuinely portable and dependency-free at runtime — convenient specifically for CLI tools, desktop apps, or any project that shouldn't assume a particular SQLite version is already installed on the target machine.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
