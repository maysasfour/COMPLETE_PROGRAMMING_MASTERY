# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use core string functions (`strtoupper`, `str_replace`, `substr`, `sprintf`) and PHP 8's `str_contains`/`str_starts_with`/`str_ends_with`.
- Distinguish heredoc (interpolated) from nowdoc (literal) syntax.
- Understand `strlen()` (byte length) vs. `mb_strlen()` (character count) for multibyte/UTF-8 strings — the same byte-vs-character distinction covered in the Go and Rust courses.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

PHP strings are mutable byte sequences (unlike Rust's UTF-8-guaranteed `String`, but similar to how C++'s `std::string` is a byte sequence). Core string functions (`strlen`, `substr`, etc.) operate on **bytes**, not characters — for genuine Unicode-aware operations, PHP provides a parallel `mb_*` (multibyte) function family, requiring the `mbstring` extension (verified enabled in Lesson 01).

## Core String Functions

```php
strtoupper($s); strtolower($s);
strlen($s);                    // BYTE length
str_replace("World", "PHP", $s);
substr($s, 7, 5);                // "World"
```

## PHP 8+ Convenience Functions

```php
str_contains($s, "World");     // true
str_starts_with($s, "Hello"); // true
str_ends_with($s, "!");         // true
```

Before PHP 8, these required `strpos($s, "World") !== false` — genuinely more error-prone, since `strpos` returning `0` (a match at the very start) is falsy-looking but not actually `false`, a classic PHP gotcha these newer functions eliminate entirely.

## `sprintf` for Formatted Output

```php
sprintf("%s is %d years old, %.2f%% done\n", "Ada", 30, 66.666);
// "Ada is 30 years old, 66.67% done"
```

## Heredoc vs. Nowdoc

```php
$heredoc = <<<EOT
Hello, {$name}!
This interpolates, like double quotes.
EOT;

$nowdoc = <<<'EOT'
Hello, {$name}!
This does NOT interpolate, like single quotes.
EOT;
```

Heredoc (`<<<EOT ... EOT;`) behaves like a double-quoted string spanning multiple lines, with full interpolation; nowdoc (`<<<'EOT' ... EOT;`, note the single quotes around the identifier) behaves like a single-quoted string — no interpolation at all. Both are commonly used for embedding multi-line SQL or templates directly in PHP source.

## `strlen()` vs. `mb_strlen()`: Bytes vs. Characters

```php
$multibyte = "héllo"; // é is a 2-byte UTF-8 character
strlen($multibyte);    // 6 -- byte count
mb_strlen($multibyte); // 5 -- character count
```

Verified live: a 5-character string containing one 2-byte UTF-8 character reports a byte length of `6`, not `5`. This is exactly the same byte-vs-character distinction covered in this repository's Go course (`len(s)` vs. rune iteration) and Rust course (byte length vs. `.chars().count()`) — PHP requires the `mbstring` extension and its `mb_*` function family for genuinely Unicode-aware string operations.

## Detailed Example

See [example.php](example.php) — all of the above, run and verified, including the live-confirmed `strlen`/`mb_strlen` discrepancy.

## Run It

```bash
cd 01-Languages/PHP/08-Strings
php example.php
```

## Expected Output

Running `php example.php` prints the uppercase/lowercase/length/replace/substring results, three `bool(true)` results for the PHP 8+ convenience functions, the formatted `sprintf` output (`66.67%` rounded from `66.666`), both heredoc and nowdoc strings (confirming the nowdoc's `{$name}` stays literal), and `strlen (bytes): 6` followed by `mb_strlen (chars): 5` for the multibyte string.

## Common Mistakes

- Using `strpos($s, $needle) == false` to check for absence — a match at position `0` is falsy-looking in a loose comparison, producing a false negative; PHP 8's `str_contains()` avoids this footgun entirely (and even pre-8 code should use `=== false`, the strict comparison, to sidestep it).
- Using `strlen()` on a string containing multibyte UTF-8 characters and assuming the result is the character count — it's the byte count; use `mb_strlen()` for character-accurate results.
- Forgetting the `mbstring` extension must be enabled for any `mb_*` function to exist at all — a fresh PHP install without it produces an `undefined function` fatal error, encountered and fixed live while writing this lesson.

## Best Practices

- Use PHP 8+'s `str_contains`/`str_starts_with`/`str_ends_with` instead of `strpos`-based checks wherever the PHP version supports it.
- Default to the `mb_*` function family (`mb_strlen`, `mb_substr`, `mb_strtoupper`, etc.) for any string that might contain non-ASCII characters.
- Use heredoc for readable, interpolated multi-line strings (SQL, templates); use nowdoc when the content must NOT be interpolated (e.g., embedding literal PHP-like syntax as a string).

## Real-World Usage

The byte-vs-character string-length distinction matters directly for any PHP application handling international user input (names, addresses, free-text fields) — truncating a string with byte-based `substr()` instead of `mb_substr()` can silently split a multibyte character in half, producing corrupted/invalid UTF-8 output, a real, recurring class of internationalization bug.

## Summary

- Core string functions operate on bytes; `mb_*` functions are the Unicode-aware equivalents, requiring the `mbstring` extension.
- PHP 8+'s `str_contains`/`str_starts_with`/`str_ends_with` are safer alternatives to `strpos`-based checks.
- Heredoc interpolates (like double quotes); nowdoc doesn't (like single quotes).
- The byte-vs-character distinction mirrors the Go and Rust courses' identical UTF-8 handling lessons.

## Key Terms

- **Multibyte string** — a string containing characters that occupy more than one byte in UTF-8 encoding.
- **Heredoc/Nowdoc** — multi-line string syntax; heredoc interpolates, nowdoc doesn't.

## Interview Questions

1. **Why might `strlen()` return a different value than the number of characters a user perceives in a string?**
   `strlen()` counts bytes, not characters. Any UTF-8 character outside the ASCII range occupies more than one byte (a common accented Latin character like `é` takes 2 bytes, some CJK characters take 3), so a string containing such characters will have a `strlen()` result larger than its actual character count — verified directly in this lesson, where a 5-character string reported a byte length of 6. `mb_strlen()` (from the `mbstring` extension) counts actual characters correctly, at the cost of needing to decode the UTF-8 byte sequence rather than just counting bytes.

2. **Why do PHP 8's `str_contains`/`str_starts_with`/`str_ends_with` exist when `strpos()` could already answer these questions?**
   `strpos($haystack, $needle)` returns the integer position of the first match, or `false` if not found — but a match at position `0` (the very start of the string) is a falsy-looking integer that loose comparison (`==`) or careless truthiness checks can confuse with "not found." This has been a long-standing, genuine PHP footgun requiring strict `!== false` comparison to use `strpos()` safely as an existence check. The PHP 8 functions return an actual `bool` directly, eliminating this entire class of bug and making the code's intent clearer at the call site.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
