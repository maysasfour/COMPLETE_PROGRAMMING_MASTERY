# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `file_put_contents`/`file_get_contents` (simplest API) and `fopen`/`fgets`/`fclose` (streaming API).
- Understand that missing-file reads return `false` with a warning by default, not an exception.
- Use PHP's genuinely built-in `json_encode`/`json_decode` — no external library needed, unlike Java and C++ covered earlier in this repository.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

PHP offers two levels of file I/O: the simple, whole-file `file_put_contents()`/`file_get_contents()` functions (most common for small files), and the lower-level, streaming `fopen()`/`fgets()`/`fwrite()`/`fclose()` functions (needed for line-by-line processing of large files). Critically, PHP's default file-I/O error convention is **not exception-based** — a missing file produces a warning and a `false` return value, not a thrown exception, a genuinely different convention from most languages in this repository (Python's `open()` raises `FileNotFoundError`, Java/C#/Go all use exceptions/errors for the same case).

## Simple Whole-File I/O

```php
file_put_contents($path, "line one\nline two\n");
$contents = file_get_contents($path);

file_put_contents($path, "line three\n", FILE_APPEND); // append instead of overwrite
```

## Streaming I/O for Line-by-Line Reading

```php
$handle = fopen($path, "r");
while (($line = fgets($handle)) !== false) {
    echo rtrim($line) . "\n";
}
fclose($handle);
```

## Missing Files: `false` + a Warning, Not an Exception

```php
$missing = @file_get_contents("does-not-exist.txt"); // @ suppresses the warning for this demo
var_dump($missing); // bool(false)
if ($missing === false) {
    echo "file not found";
}
```

Verified live: reading a nonexistent file returns `false` (with an `E_WARNING` emitted, suppressed here with `@` purely for clean lesson output) rather than throwing any kind of exception. Production code should check `=== false` explicitly (strict comparison, since some valid file contents could be falsy-looking otherwise) rather than relying on a `try`/`catch` the way file I/O errors are handled in most other languages covered in this repository.

## Built-In JSON Support

```php
$json = json_encode(["name" => "Ada", "age" => 30, "active" => true], JSON_PRETTY_PRINT);
$decoded = json_decode($json, true); // true = decode to associative array, not stdClass
```

Unlike Java (no built-in JSON at all — needs Jackson/Gson) and C++ (needs a third-party library), PHP has `json_encode`/`json_decode` built directly into the language core, matching JavaScript/Python/Go/C#'s built-in JSON support.

## Detailed Example

See [example.php](example.php) — all of the above, run and verified, including the live-confirmed `false`-not-exception behavior for a missing file. Generated scratch files are cleaned up at the end of the script (`unlink`/`rmdir`), leaving nothing behind.

## Run It

```bash
cd 01-Languages/PHP/10-File-Handling
php example.php
```

## Expected Output

Running `php example.php` prints the two-line file contents, then three lines after appending, then the same three lines read back individually via `fgets` with line numbers, then `bool(false)` and a confirmation message for the missing-file case, then pretty-printed JSON and the decoded `name` field. No files remain in the directory after the script finishes.

## Common Mistakes

- Assuming a missing/unreadable file throws an exception, and never checking the return value of `file_get_contents()`/`fopen()` — both simply return `false` on failure by default.
- Using loose (`==`) rather than strict (`===`) comparison when checking for `false` — some legitimately-read file contents (like the string `"0"`) are falsy in a loose sense but not actually the `false` failure indicator.
- Forgetting `fclose()` after a manual `fopen()` — PHP does clean up file handles at script end automatically, but explicit `fclose()` is still the correct, resource-conscious habit, especially in a long-running process or loop.

## Best Practices

- Use `file_get_contents()`/`file_put_contents()` for whole small files; reserve `fopen()`/`fgets()` streaming for large files processed line-by-line.
- Always check file-operation return values with `=== false` (strict comparison) rather than assuming success or relying on exceptions.
- Use `json_encode`/`json_decode` directly — no external dependency needed, unlike this repository's Java and C++ courses.

## Real-World Usage

PHP's non-exception-based file I/O error convention is a real, practical consideration when writing robust PHP code — many production bugs stem from unchecked `file_get_contents()`/`fopen()` calls whose `false` return value silently propagates instead of failing loudly, unlike languages where a missing file would immediately throw and halt execution unless explicitly caught.

## Summary

- `file_put_contents`/`file_get_contents` are the simplest file I/O API; `fopen`/`fgets`/`fclose` support streaming, line-by-line reads.
- A missing/unreadable file returns `false` with a warning by default — not an exception, a genuinely different convention from most other languages in this repository, verified live.
- `json_encode`/`json_decode` are built directly into PHP core, matching JS/Python/Go/C# rather than Java/C++'s external-library requirement.

## Key Terms

- **Stream** — PHP's abstraction for a file (or other resource) handle opened via `fopen()`, read/written incrementally.
- **`JSON_PRETTY_PRINT`** — a `json_encode()` flag producing human-readable, indented JSON output.

## Interview Questions

1. **How does PHP's default file-I/O error handling differ from most other languages, and why does it matter?**
   PHP's core file functions (`file_get_contents`, `fopen`) return `false` (accompanied by an `E_WARNING`) when a file can't be read, rather than throwing an exception. This was verified directly: reading a nonexistent file produced `bool(false)`, not a thrown error. This matters practically because code that assumes exception-based error handling (a common pattern in Python/Java/C#/Go) and doesn't explicitly check for `false` will silently continue with a falsy value instead of failing loudly — a real, recurring class of PHP bug, and the reason `=== false` checks are considered a best practice for every file operation.

2. **Why doesn't PHP need an external library for JSON, unlike Java or C++?**
   `json_encode()`/`json_decode()` are part of PHP's core language (the `json` extension, enabled by default in virtually all PHP installations) — no Composer package needed, matching JavaScript's native `JSON.parse`/`JSON.stringify` and Python's built-in `json` module. This contrasts directly with Java (which needs Jackson or Gson) and C++ (which needs a third-party library like nlohmann/json), both covered earlier in this repository as genuine, real gaps in their respective standard libraries.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
