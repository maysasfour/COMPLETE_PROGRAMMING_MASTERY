# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Understand PHP as an **interpreted** language with no separate compile step, unlike every compiled language in this repository (C#, Java, C++, Go, Rust).
- Run a PHP script directly from the command line.
- Verify the extensions this course depends on (`pdo_sqlite`, `curl`, `openssl`, `json`) are loaded.

## Prerequisites

None — this is the first PHP lesson. Familiarity with at least one other language in this repository (any of Python/JavaScript/Java/C#/Go/Rust) is assumed, per this repository's overall structure.

## Concept

PHP is a dynamically-typed, interpreted scripting language originally designed for generating HTML on web servers, and remains the language behind a large share of the web (WordPress, Laravel-based applications, and much more). Unlike every compiled language covered so far (C#, Java, C++, Go, Rust), there is no build step: the `php` interpreter parses and executes a `.php` file directly, every single time it runs, top to bottom. This makes PHP's development loop closer to Python's or JavaScript's (Node) than to Rust's or Go's.

## Installing PHP

```bash
# Download from https://www.php.net/downloads (or https://windows.php.net/download/ on Windows)
php --version
```

This course was written and verified against **PHP 8.4.23 (CLI)**. A `php.ini` with `pdo_sqlite`, `sqlite3`, `curl`, `openssl`, `json`, and `mbstring` extensions enabled is required for lessons 10, 16, and 17 (the last two are usually enabled by default in most installations; this course explicitly verifies them in this lesson's example rather than assuming). A fresh Windows PHP install also needs a CA certificate bundle for outbound HTTPS requests (Lesson 17) — `curl.cainfo`/`openssl.cafile` in `php.ini` must point at a `cacert.pem` file (e.g. from https://curl.se/ca/cacert.pem), or every HTTPS request fails with "unable to get local issuer certificate," verified live while building this course.

## Running a PHP File

```bash
php example.php
```

There is no separate "build" command — `php <file>.php` parses and runs the script in one step, and produces no compiled artifact on disk (matching this repository's `.gitignore` expectations: nothing PHP-specific needs to be excluded for basic scripts, unlike compiled languages' `bin/`/`obj`/`target/` directories).

## Detailed Example

See [example.php](example.php) — prints a greeting, the running PHP version via the built-in `PHP_VERSION` constant, and checks that this course's five required extensions are loaded via `extension_loaded()`.

## Expected Output

Running `php example.php` prints a greeting, `PHP version: 8.4.23` (or whatever version is installed), a note about no build artifact being left behind, and confirms all five extensions (`pdo_sqlite`, `sqlite3`, `curl`, `openssl`, `json`) are loaded.

## Common Mistakes

- Assuming a compile/build step is needed, as with C#/Java/C++/Go/Rust — there is none; editing a `.php` file changes its behavior on the very next run with zero intermediate step.
- Forgetting the required extensions (`pdo_sqlite` for Lesson 16, `curl`/`openssl` for Lesson 17) might not be enabled by default in every PHP distribution — always verify with `extension_loaded()` or `php -m` rather than assuming.

## Best Practices

- Use `php -m` from the command line to list all currently loaded extensions when troubleshooting a missing-function error.
- Keep a project's required PHP version and extensions documented (traditionally in a `composer.json` `require` block, covered in Lesson 15), even for projects not otherwise using Composer.

## Real-World Usage

PHP is most commonly deployed behind a web server (Apache with `mod_php`, or PHP-FPM behind Nginx) executing scripts per HTTP request, though the CLI SAPI used throughout this course (`php script.php`) is identical in language semantics and is standard for command-line tooling, cron jobs, and Composer itself (which is a PHP script).

## Summary

- PHP is interpreted, not compiled — no build step, no compiled artifact, unlike every other language in this course's language order so far.
- `php <file>.php` runs a script directly.
- This course depends on `pdo_sqlite`, `sqlite3`, `curl`, `openssl`, `json`, and `mbstring` being enabled, verified explicitly in this lesson.

## Key Terms

- **Interpreter** — a program (`php`) that reads and executes source code directly, without a separate compilation step producing a standalone binary.
- **Extension** — a PHP module (like `pdo_sqlite` or `curl`) providing additional built-in functionality, enabled via `php.ini`.

## Interview Questions

1. **Is PHP compiled or interpreted, and what does that mean for the development workflow?**
   PHP is interpreted: the `php` binary parses and executes a script's source code directly on every invocation, with no separate compile step producing a standalone artifact (contrasted with C#/Java/C++/Go/Rust in this repository, all of which compile to an intermediate or native form first). This means changes to a `.php` file take effect on the very next run with no build step at all — the same immediate-feedback development loop as Python or Node.js, though (unlike Node) PHP has historically been most associated with per-request web execution rather than long-running server processes.

2. **What is a PHP extension, and why does it matter for this course specifically?**
   An extension is a compiled module (written in C, distributed alongside the PHP binary) that adds functionality beyond the language core — database drivers (`pdo_sqlite`), networking (`curl`), cryptography (`openssl`), and more. Extensions must be explicitly enabled in `php.ini` (or compiled in, for some distributions) and are not universally present in every PHP installation by default, which is why this lesson explicitly verifies the specific extensions this course's later lessons (Database Access, API Integration) depend on, rather than assuming they're available.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
