# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Recognize and fix three genuine PHP anti-patterns: loose (`==`) comparison on untrusted input, SQL built by string concatenation, and unchecked file-operation return values.
- See a real SQL injection succeed against the vulnerable version and fail against the parameterized version, in the same script.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

This lesson is a synthesis: three mistakes that compile and run in PHP but are genuinely dangerous or fragile, each demonstrated with a live "bad" version actually misbehaving, and a "good" version fixing it — reproducing the failures directly rather than just describing them, consistent with every other language course's Lesson 19 in this repository.

## Anti-Pattern 1: Loose (`==`) Comparison on Untrusted Input

```php
function isAdminBad($role): bool { return $role == 0; }     // loose
function isAdminGood($role): bool { return $role === 0; }    // strict

isAdminBad("admin");   // false on PHP 8+ (Lesson 03's versioned behavior change)... but:
isAdminBad("0");         // true -- "0" == 0 is STILL true, even on PHP 8, since "0" is a numeric string
isAdminGood("0");        // false -- correctly distinguishes the STRING "0" from the INT 0
```

Verified live: even on PHP 8.4 (where the `0 == "abc"` gotcha from Lesson 03 was fixed), `"0" == 0` is still `true`, because `"0"` is a well-formed numeric string. A permission check written with `==` could be bypassed by user input arriving as the string `"0"` where an integer `0` was expected — `===` closes this gap entirely, on any PHP version.

## Anti-Pattern 2: SQL Built by String Concatenation

```php
// NEVER do this:
$sql = "SELECT * FROM users WHERE username = '{$username}'";
$pdo->query($sql);

// Do this instead:
$stmt = $pdo->prepare("SELECT * FROM users WHERE username = :username");
$stmt->execute(["username" => $username]);
```

Verified live with a real SQL injection payload (`"nonexistent' OR '1'='1"`): the string-concatenation version's query returned a real row from the `users` table — **the injection succeeded** — while the parameterized version correctly returned no row, treating the entire malicious string as inert, literal data (exactly as demonstrated safely in Lesson 16).

## Anti-Pattern 3: Unchecked File-Operation Return Values

```php
// bad: no check at all
$contents = file_get_contents($path);
return json_decode($contents, true); // if $path doesn't exist, $contents is `false`,
                                        // and json_decode(false, true) throws an unrelated TypeError

// good: explicit checks with clear, intentional error messages
$contents = file_get_contents($path);
if ($contents === false) {
    throw new RuntimeException("could not read config file: {$path}");
}
```

Verified live: the unchecked version's actual failure was a confusing `TypeError: json_decode(): Argument #1 ($json) must be of type string, false given` — technically correct, but it obscures the real problem (a missing file) behind an unrelated-looking type error. The checked version fails with a clear, intentional `RuntimeException: could not read config file: ...` instead, pointing directly at the actual cause.

## Detailed Example

See [example.php](example.php) — all three anti-pattern/fix pairs, run and verified, including a real, successful SQL injection against the vulnerable version.

## Run It

```bash
cd 01-Languages/PHP/19-Best-Practices
php example.php
```

## Expected Output

Running `php example.php` shows `isAdminBad("0")` returning `true` (the surviving vulnerability even on PHP 8) versus `isAdminGood("0")` correctly returning `false`; the concatenated-SQL version returning `alice`'s row for a malicious payload ("INJECTION SUCCEEDED") versus the parameterized version correctly returning no row; and the unchecked file-read version failing with a confusing `TypeError` versus the checked version failing with a clear `RuntimeException` naming the actual problem.

## Common Mistakes

- Using `==` for any comparison involving untrusted/user-supplied input — even on PHP 8+, numeric-string coercion (`"0" == 0`) remains a real, exploitable gap that `===` closes entirely.
- Ever concatenating a variable directly into a SQL string — verified live in this lesson to allow a real, successful injection; always use parameterized queries (Lesson 16), with no exceptions for "trusted" input.
- Calling `file_get_contents()`/similar functions without checking for a `false` return — the resulting failure surfaces later, in a confusing, unrelated form (as seen with `json_decode`'s `TypeError`), rather than a clear error at the actual point of failure.

## Best Practices

- Default to `===`/`!==` for all comparisons, especially anything touching user input.
- Always use parameterized queries (`:name`/`?` placeholders with `execute([...])`) for SQL — never string concatenation, regardless of how "safe" the input seems.
- Check every file-operation return value explicitly (`=== false`) and fail with a clear, specific exception naming the actual problem, rather than letting a `false` propagate into unrelated code that fails confusingly later.

## Real-World Usage

All three of these anti-patterns are genuine, common findings in real PHP code review — loose-comparison authentication/authorization bypasses and SQL injection via string concatenation are both well-documented, historically significant classes of real-world PHP vulnerabilities (OWASP Top 10-relevant), not academic concerns; unchecked file I/O is a more mundane but equally common source of confusing production error reports.

## Summary

- `===` should be the default comparison operator, especially for any security-sensitive check involving user input — `==`'s numeric-string coercion remains a real gap even on PHP 8+.
- Parameterized queries are non-negotiable for any SQL involving external input — verified live to be the difference between a successful injection and a safely rejected one.
- Always check file-operation return values explicitly and fail with a clear, specific error — don't let `false` propagate silently into unrelated code.

## Key Terms

- **SQL injection** — an attack exploiting string-concatenated SQL to inject unintended query logic via user input.
- **Numeric string** — a string PHP treats as equivalent to a number under loose (`==`) comparison, even on PHP 8+.

## Interview Questions

1. **Does PHP 8's fix to `0 == "abc"` mean loose comparison is now safe for permission/authorization checks?**
   No — verified directly in this lesson: while PHP 8 fixed the specific `0 == "abc"` (number vs. non-numeric-string) case, `"0" == 0` remains `true` on PHP 8 (and every version), because `"0"` is a well-formed *numeric* string, which loose comparison still coerces and compares numerically. A permission check like `$role == 0` could still be bypassed by a role value arriving as the string `"0"` (e.g., from a form field or query parameter) rather than a true integer `0`. `===` (strict comparison) closes this gap entirely, on any PHP version, and should be the default for any comparison involving untrusted input.

2. **Why does string-concatenated SQL remain dangerous even if the "malicious" input doesn't look obviously dangerous?**
   Because any special SQL syntax character (a single quote, in the classic case) embedded in user input can escape the intended string literal and inject arbitrary SQL logic, regardless of how the input looks superficially. This was demonstrated directly: the payload `"nonexistent' OR '1'='1"` successfully retrieved a real row from a `users` table via the string-concatenated query, despite looking like a plausible (if unusual) username — the vulnerability lies entirely in mixing user data with SQL *syntax*, not in the specific content of any one malicious string. Parameterized queries eliminate the entire vulnerability class by keeping user data structurally separate from the SQL query itself, regardless of what characters that data contains.

## Recommended Next Lesson

This completes the core PHP course (Lessons 01–19). Return to the [PHP course overview](../README.md) or continue to the next language in the course order.
