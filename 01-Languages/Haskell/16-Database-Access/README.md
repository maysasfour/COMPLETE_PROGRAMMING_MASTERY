# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules](../15-Modules/README.md)

## Learning Objectives

- Use `sqlite-simple` to connect to a SQLite database, create a table, and run parameterized CRUD queries.
- See how Haskell's type system extends to database rows — `query`/`query_` return strongly, statically-typed tuples/records, not untyped dicts or arrays.
- Understand `OverloadedStrings`, a real, genuinely-hit compile requirement for this package.

## Prerequisites

[15-Modules](../15-Modules/README.md)

## Environment Honesty Note (Read First)

This lesson's package, **`sqlite-simple`, was genuinely installed and built via Cabal in this environment**, and every code sample below was actually compiled and run — this is not conceptual or adapted content. It took real, non-trivial build time (Cabal had to compile `sqlite-simple`'s own C `direct-sqlite` dependency plus its transitive Haskell dependency chain from source, since no Windows binary packages are published to Hackage), but it succeeded outright with no admin rights, no system package manager, and no missing system library — see [01-Setup](../01-Setup/README.md) for the full account of how this GHC/Cabal toolchain was obtained in the first place.

## Setup

```
db-demo/
  db-demo.cabal
  Main.hs
```

```
# db-demo.cabal (abbreviated)
cabal-version:      2.4
name:                db-demo
version:             0.1.0.0
build-type:          Simple

executable db-demo
    main-is:          Main.hs
    build-depends:    base, sqlite-simple
    default-language: Haskell2010
```

```bash
cabal build
cabal run
```

## A Real Compile Error Hit Live: `OverloadedStrings`

The very first version of this lesson's code was written with ordinary string literals for SQL text, and it **genuinely failed to compile**:

```
Main.hs:7:16: error: [GHC-83865]
    * Couldn't match type `[Char]' with `Query'
      Expected: Query
        Actual: String
```

`sqlite-simple`'s functions (`execute`, `query`, `query_`) expect their SQL-text argument as its own `Query` newtype, not a plain `String`/`[Char]` — a deliberate design choice (it lets the library statically distinguish "this is meant to be SQL" from an arbitrary string). The fix, genuinely applied and re-verified: add `{-# LANGUAGE OverloadedStrings #-}` at the top of the file, which lets string literals be interpreted as *any* type with the right `IsString` instance (here, `Query`), not just `String`.

```haskell
{-# LANGUAGE OverloadedStrings #-}
import Database.SQLite.Simple

main :: IO ()
main = do
    conn <- open "tasks.db"
    execute_ conn "CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, title TEXT, done INTEGER)"
    ...
```

## Parameterized Queries (SQL-Injection-Safe, Matching Every Other Language Course's Own Lesson)

```haskell
-- INSERT with a placeholder (?) and a tuple of parameters -- never string-interpolate
-- untrusted input directly into SQL text, exactly the lesson every other language
-- course in this repository (Python, JavaScript, Rust, C#, ...) makes the same way:
execute conn "INSERT INTO tasks (title, done) VALUES (?, ?)" (title, 0 :: Int)

-- SELECT with a typed result -- rows come back as a strongly-typed tuple,
-- CHECKED AT COMPILE TIME against the type annotation you give `query`:
rows <- query_ conn "SELECT id, title, done FROM tasks" :: IO [(Int, String, Int)]
```

If the query's actual column shapes don't match the annotated result type, `sqlite-simple` throws a runtime `ResultError` (it can't statically know your SQL's actual result shape, unlike some more advanced type-level-SQL libraries) — but the *parsing/marshaling* of each row into your requested Haskell type is otherwise fully type-directed, unlike a raw untyped-dict/array-of-columns interface.

## Another Real Gotcha: Boot Packages Still Need Declaring

[Main.hs](Main.hs) also imports `System.Directory` (to delete any leftover `tasks.db` so the demo is repeatable) and the very first build genuinely failed:

```
Main.hs:3:1: error: [GHC-87110]
    Could not load module `System.Directory'.
    It is a member of the hidden package `directory-1.3.11.0'.
    Perhaps you need to add `directory' to the build-depends in your .cabal file.
```

Even though `directory` ships as one of GHC's own "boot" packages (bundled with the compiler, no separate download needed — confirmed already present from Lesson 08's honesty note), Cabal still requires it listed explicitly in `build-depends` before a module from it can be imported; being bundled with GHC doesn't make a package's modules automatically visible. The fix was simply adding `directory` alongside `sqlite-simple` in `db-demo.cabal`'s `build-depends` line — see the actual file for the corrected version.

## Detailed Example

See [Main.hs](Main.hs), a full, genuinely-run CRUD example: create table, insert, select, update, delete.

## Verified Output

```bash
$ cabal run
Created table.
Inserted task: Buy milk
All tasks: [(1,"Buy milk",0)]
Marked done: 1
After update: [(1,"Buy milk",1)]
After delete: []
```

## Common Mistakes

- **Forgetting `{-# LANGUAGE OverloadedStrings #-}`** — a genuine, live-hit compile error in this lesson's own authoring (see above); every `sqlite-simple` file needs it for SQL-text literals to type-check as `Query`.
- **String-interpolating user input directly into SQL text** instead of using `?` placeholders with a parameter tuple — the exact SQL-injection vulnerability every other language course in this repository specifically warns against; `sqlite-simple`'s `execute`/`query` (with a separate parameters argument) make the safe pattern the natural one.
- **Mismatching the `query`/`query_` result-type annotation against the actual selected columns** — e.g., annotating `IO [(Int, String)]` for a three-column `SELECT` — causes a runtime `ResultError`, not a compile error, since the library can't statically verify your SQL against your Haskell type; keep the annotation's arity/order in sync with the `SELECT` clause by hand.

## Best Practices

- Always use parameterized queries (`?` placeholders + a tuple/record of arguments) for any value that ultimately comes from outside the program — never build SQL text via string concatenation with untrusted input.
- Keep the `query`/`query_` result-type annotation's shape (arity, column order) visually adjacent to the SQL text it corresponds to, since nothing enforces they stay in sync automatically.
- Close connections (`close conn`) when done, or use `withConnection` (open/close paired automatically, exception-safe) for anything beyond a short demo script.

## Real-World Usage

`sqlite-simple`'s parameterized-query, typed-row-marshaling approach is the same fundamental pattern every other language course in this repository's own database lesson establishes (Python's `sqlite3`, Rust's `rusqlite`, C#'s `Microsoft.Data.Sqlite`) — SQL injection prevention via placeholders, typed results wherever the language's type system allows it. This lesson's mini-project payoff ([22-Mini-Projects](../22-Mini-Projects/README.md)) reuses this exact `sqlite-simple` setup for a genuine CLI Task Tracker.

## Summary

- `sqlite-simple` was genuinely installed and verified in this environment via Cabal — every example here was actually compiled and run, not left conceptual.
- `{-# LANGUAGE OverloadedStrings #-}` is a real, necessary requirement for SQL-text literals to type-check as `sqlite-simple`'s `Query` type — hit and fixed live during this lesson's own authoring.
- Parameterized queries (`?` + a parameter tuple) are the safe, idiomatic pattern, identical in spirit to every other language course's own database lesson.

## Key Terms

- **`Query`** — `sqlite-simple`'s newtype wrapper around SQL text, requiring `OverloadedStrings` for plain string literals to type-check as one.
- **Parameterized query** — a SQL statement with `?` placeholders, filled in safely via a separate parameters argument rather than string concatenation.
- **`ResultError`** — a runtime error `sqlite-simple` throws when a query's actual result shape doesn't match the Haskell type you annotated it with.

## Interview Questions

1. **Why does `sqlite-simple` need `OverloadedStrings`, and what does that language extension actually do?**
   `sqlite-simple`'s SQL-text arguments are typed as its own `Query` newtype, not plain `String`, so that the library can statically distinguish "this is meant to be SQL" — but Haskell string literals default to `String` unless told otherwise. `OverloadedStrings` makes string literals polymorphic over any type with an `IsString` instance (which `Query` provides), letting `"SELECT ..."` type-check directly as a `Query` value without an explicit conversion function. This was a genuine, live-hit compile error during this lesson's authoring, not a hypothetical.

2. **How does `sqlite-simple` help prevent SQL injection, and where does its type-safety guarantee stop?**
   Parameterized queries (`?` placeholders, with actual values supplied via a separate parameters tuple/record rather than string-concatenated into the SQL text) are the safe pattern the library's API makes natural to use. Type safety extends to marshaling each returned row into the Haskell type you annotate for `query`/`query_` — but the library cannot statically verify that annotation matches your SQL's actual column shape; a mismatch is a runtime `ResultError`, not a compile-time guarantee, since SQL text itself isn't checked against the schema at compile time (unlike some more specialized type-level-SQL libraries).

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
