# PHP

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What PHP Is

PHP is a dynamically-typed, interpreted scripting language originally designed for generating dynamic web content, and remains one of the most widely deployed server-side languages (WordPress alone powers a huge share of the web, and Laravel/Symfony are major modern PHP frameworks). Unlike every compiled language covered earlier in this repository (C#, Java, C++, Go, Rust), PHP has no build step at all — the interpreter parses and executes a script directly, every time it runs.

## Why / Where It's Used

- **Web development** — PHP's original and still-dominant use case; WordPress, Laravel, Symfony, and a huge share of the server-side web run on PHP.
- **Content management systems** — WordPress, Drupal, and many other CMS platforms are built in PHP.
- **Rapid web application development** — PHP's request-per-execution model and mature framework ecosystem (Laravel especially) make it a common choice for quickly building web backends.

## Advantages

- No build step — extremely fast iteration loop, changes take effect on the very next request/run.
- Mature, huge ecosystem: Composer for package management, Laravel/Symfony as full-featured frameworks, and near-universal web hosting support.
- Genuinely built-in JSON support (unlike this repository's Java and C++ courses), and a large standard library covering strings, arrays, and file I/O without needing external packages for basic tasks.
- PHP 8's additions (`match`, enums, named arguments, constructor property promotion, first-class callable syntax, `Fiber`) have substantially modernized the language in recent years.

## Disadvantages

- A long history of design inconsistencies and surprising behaviors (inconsistent function argument ordering across the standard library, the historically notorious loose-comparison rules) — some fixed in PHP 8, some still present, several verified live in this course.
- No true generics (Lesson 13) — type-safety for container-like classes depends entirely on external static analysis tooling (PHPStan/Psalm), not the language itself.
- No built-in OS-level threading and no `async`/`await` — concurrency (Lesson 14) is either cooperative (`Fiber`) or achieved by overlapping I/O (`curl_multi_*`), not genuine CPU parallelism.

## How to Install

```bash
# Download from https://www.php.net/downloads (or https://windows.php.net/download/ on Windows)
php --version
```

This course was written and verified against **PHP 8.4.23 (CLI)**, with `pdo_sqlite`, `sqlite3`, `curl`, `openssl`, `json`, and `mbstring` extensions enabled (see Lesson 01), plus a configured CA certificate bundle for HTTPS requests (see Lesson 17).

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.php`. From the repository root:

```bash
cd 01-Languages/PHP/03-Variables-and-Data-Types
php example.php
```

Lesson 18 (Testing) needs PHPUnit, downloaded as a standalone `.phar` (see that lesson's README) — no Composer install required.

## Common Beginner Mistakes

- **Using `==` instead of `===`** — PHP's loose comparison has a long, genuine history of surprising results, including a real, versioned behavior change between PHP 7 and PHP 8 for number-vs-non-numeric-string comparisons, verified live in Lesson 03. Even on PHP 8+, `"0" == 0` remains `true`, a real gap `===` closes (Lesson 19).
- **Assuming `array_filter()` re-indexes its result** — it preserves original keys, verified live in Lesson 07; `array_values()` must be called explicitly for a clean, 0-indexed list.
- **Writing a literal `?>` inside a comment or string** — this ends PHP mode immediately, regardless of context, reproduced live while writing this course's own Lesson 02 example.
- **Assuming file I/O failures throw exceptions** — they return `false` with a warning by default (Lesson 10), a genuinely different convention from most other languages in this repository.

## Best Practices

- Default to `===`/`!==` for all comparisons, especially anything touching user or external input.
- Always use parameterized queries (PDO's `:name`/`?` placeholders) for SQL — never string concatenation, verified live in Lesson 19 to allow a real, successful SQL injection when done wrong.
- Use `declare(strict_types=1);` at the top of every file for predictable, non-coercive type checking.
- Use PHPStan or Psalm in any codebase relying on generic-like type safety, since PHP itself provides none (Lesson 13).

## Interview Questions

1. **Why is `===` generally preferred over `==` in PHP, even after PHP 8's comparison fixes?**
   PHP 8 fixed a specific, long-standing gotcha (`0 == "abc"` now correctly evaluates to `false`), but loose comparison's broader numeric-string coercion behavior remains: `"0" == 0` is still `true` on every PHP version, since `"0"` is treated as a numeric string. This was verified directly in this course (Lessons 03 and 19) and can create real security gaps in permission/authorization checks written with `==` instead of `===`. Strict comparison avoids the entire category of surprises by requiring both value and type to match.

2. **Does PHP have generics, and how do real PHP projects work around the lack of them?**
   No — PHP has no generic type parameter syntax at all (Lesson 13). Real projects rely on a combination of interface-based constraints (enforced at runtime via `instanceof` checks) and PHPDoc `@template` annotations understood by static analysis tools like PHPStan and Psalm, which can catch generic-type mismatches during a separate analysis step — but the PHP runtime itself performs no such checking, verified directly by successfully pushing a mismatched-type value into a "typed" container with no error at any point.

3. **How does PHP achieve concurrency without OS-level threads or `async`/await?**
   PHP CLI scripts run single-threaded by default, with no bundled thread support and no `async`/`await` keywords. PHP 8.1+'s `Fiber` class provides *cooperative* multitasking (explicit suspend/resume points, verified live in Lesson 14, but no parallelism), while genuine concurrent I/O is achieved via `curl_multi_*`, which overlaps multiple HTTP requests' network-wait time at the libcurl level — measured directly in this course to produce a roughly 7x speedup for four concurrent requests versus sequential ones, despite PHP's fundamentally single-threaded execution model.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Interpreted execution, no build step, required extensions |
| 02 | [Syntax](02-Syntax/README.md) | PHP tags, comments, `echo`/`print`, the `?>`-in-comment gotcha |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Dynamic typing, `==` vs `===`, PHP 8's comparison fix |
| 04 | [Operators](04-Operators/README.md) | Spaceship (`<=>`), null-safe (`?->`), the `and`/`=` precedence trap |
| 05 | [Control Flow](05-Control-Flow/README.md) | `switch` fall-through, `match` (PHP 8+, strict, expression-based) |
| 06 | [Functions](06-Functions/README.md) | Named/variadic parameters, by-reference params, arrow functions |
| 07 | [Collections](07-Collections/README.md) | The single `array` type, `array_filter`'s key-preservation gotcha |
| 08 | [Strings](08-Strings/README.md) | Core vs. `mb_*` functions, heredoc/nowdoc, byte vs. character length |
| 09 | [Error Handling](09-Error-Handling/README.md) | `try`/`catch`/`finally`, the split `Error`/`Exception` hierarchy |
| 10 | [File Handling](10-File-Handling/README.md) | File I/O returns `false` (not exceptions) by default, built-in JSON |
| 11 | [OOP](11-OOP/README.md) | Classes, traits (horizontal reuse), PHP 8.1+ backed enums |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Closure capture by value vs. `use (&$var)` by reference |
| 13 | [Generics](13-Generics/README.md) | No real generics; `mixed`, `@template`, interface-based workarounds |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | `Fiber` (cooperative), `curl_multi_*` (real concurrent I/O) |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Namespaces, PSR-4 autoloading, Composer |
| 16 | [Database Access](16-Database-Access/README.md) | PDO, parameterized queries |
| 17 | [API Integration](17-API-Integration/README.md) | `curl`/`file_get_contents`, no exception on 404 |
| 18 | [Testing](18-Testing/README.md) | PHPUnit (downloaded `.phar`), data providers |
| 19 | [Best Practices](19-Best-Practices/README.md) | `===`, parameterized queries, checked file I/O — reproduced live |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-07* |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises`/`Solutions` pairs. Lesson 13 (Generics) is worth reading even though PHP has none — it explains the real workarounds used in professional PHP codebases. Lesson 19 ties together the course's three most consequential recurring gotchas (`==` vs `===`, SQL injection via concatenation, unchecked file I/O), each reproduced live.

**Previous language:** [Rust](../Rust/README.md) | **Next:** [Kotlin](../Kotlin/README.md)
