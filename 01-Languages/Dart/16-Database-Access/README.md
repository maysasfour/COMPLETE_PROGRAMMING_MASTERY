# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using the `sqlite3` pub.dev package — Dart has **no built-in database access**, matching Swift and C++ (both covered earlier in this repository).
- Use `?`-parameterized queries to prevent SQL injection.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Dart's standard library provides no database access at all, the same gap found in this repository's Swift and C++ courses. The `sqlite3` package (from pub.dev, Dart's package registry) bundles/loads the native SQLite library directly and works out of the box with no separate system installation required — verified live in this environment.

## CRUD with `?`-Parameterized Queries

```dart
import 'package:sqlite3/sqlite3.dart';

final db = sqlite3.openInMemory();
db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT NOT NULL, done INTEGER DEFAULT 0)');

final stmt = db.prepare('INSERT INTO tasks (title) VALUES (?)');
stmt.execute([title]); // ? placeholder, bound safely -- no string concatenation
stmt.dispose();

final rows = db.select('SELECT id, title, done FROM tasks');
for (var row in rows) {
  print('${row['id']}: ${row['title']}');
}
```

`db.select()` handles a full query in one call for simple cases; `db.prepare()` produces a reusable `PreparedStatement` for repeated parameterized execution (as with the insert loop above), and must be explicitly `dispose()`d when no longer needed.

## Detailed Example

See [pubspec.yaml](pubspec.yaml) and [example.dart](example.dart) — full CRUD against an in-memory SQLite database via the `sqlite3` package, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Dart/16-Database-Access
dart pub get   # resolves the sqlite3 dependency (downloaded, not committed to the repo)
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints confirmation of 3 inserted rows, all 3 rows read back, row 1's `done` status flipping to `1` after an update, a remaining row count of `2` after a delete, confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, and confirmation the table survives intact with all rows present (3, including the malicious-string test row) — all confirmed by actual execution.

## Common Mistakes

- Building SQL by string concatenation instead of `?`-placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting to `dispose()` a `PreparedStatement` (or the database connection itself) when finished with it — the `sqlite3` package relies on Dart's FFI (foreign function interface) to the native library, which doesn't automatically garbage-collect the underlying native resources the way pure-Dart objects are collected.
- Assuming Dart has built-in database access the way some other languages do — it doesn't; a package like `sqlite3` (or a higher-level abstraction like `drift`, popular in Flutter) is required, matching the gap in this repository's Swift and C++ courses.

## Best Practices

- Always use `?`-parameterized queries for any dynamic value in SQL.
- Explicitly `dispose()` prepared statements and database connections once finished, since they wrap native (non-Dart-garbage-collected) resources.
- Consider a higher-level package like `drift` (a popular, type-safe Dart ORM built on top of `sqlite3`) for larger, real applications wanting compile-time-checked queries rather than raw SQL strings.

## Real-World Usage

In Flutter apps specifically, `sqflite` (a Flutter-specific SQLite plugin using platform-native database APIs) is more common than the plain `sqlite3` package used in this lesson, since it integrates with Flutter's plugin system for mobile/desktop platforms; the `sqlite3` package (used here) is more common for standalone Dart CLI tools, servers, and tests, exactly the context this lesson's single-file, install-via-`pub-get` example represents.

## Summary

- Dart has no built-in database access, matching Swift and C++'s gaps, both covered earlier in this repository.
- The `sqlite3` pub.dev package provides direct SQLite access, verified live to work with no separate system installation needed.
- `?`-parameterized queries prevent SQL injection — the same principle as every other language course in this repository.

## Key Terms

- **`sqlite3` package** — a pub.dev package providing Dart bindings to the native SQLite library.
- **`PreparedStatement`** — a reusable, parameterized SQL statement object, requiring explicit `dispose()`.

## Interview Questions

1. **Why does this lesson use an external package instead of a built-in Dart database API?**
   Dart's standard library provides no database access at all — the same gap this repository's Swift and C++ courses found in their respective standard libraries. The `sqlite3` package (from pub.dev, Dart's package registry) was used here specifically because it bundles/loads the native SQLite library directly and works with no separate system installation, verified live in this environment. Real Flutter apps more commonly use `sqflite` (a Flutter-specific plugin using each platform's native database APIs), while `sqlite3` (used in this lesson) is a more natural fit for standalone Dart CLI tools and tests.

2. **Why must a `PreparedStatement` (or database connection) be explicitly `dispose()`d in Dart's `sqlite3` package, when Dart itself has automatic garbage collection?**
   The `sqlite3` package works via Dart's FFI (foreign function interface), wrapping calls to the native, compiled SQLite library — the actual database connection and prepared statement resources live in native memory, outside Dart's garbage-collected heap. Dart's garbage collector manages Dart objects, but has no visibility into or control over native resources allocated through FFI, so those must be released explicitly via `dispose()` (much like Kotlin's `.use { }` guarantees `close()` for JDBC resources, though Dart's `sqlite3` package requires the `dispose()` call to be made explicitly rather than via an automatic resource-management construct).

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
