# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand PHP's dynamic typing: a variable can hold any type, and can change type on reassignment.
- Distinguish loose (`==`) from strict (`===`) comparison, including the PHP 8 change to numeric-string comparison.
- Use the null coalescing operator (`??`) and both constant-declaration styles (`define()`/`const`).

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

PHP is dynamically typed: a variable's type is determined by the value currently assigned to it, and reassigning a different type of value is always allowed (no `TypeError` on plain reassignment, unlike a statically-typed language rejecting an incompatible assignment at compile time). The eight PHP types are: `int`, `float`, `string`, `bool`, `array`, `object`, `null`, and the special `resource`.

## Dynamic Typing and `gettype()`

```php
$age = 30;                  // int
echo gettype($age);          // "integer"
$age = "now a string";       // reassignment to a DIFFERENT type -- perfectly legal
echo gettype($age);           // "string"
```

## Loose (`==`) vs. Strict (`===`) Comparison

```php
var_dump(0 == "abc");     // false in PHP 8+ (was TRUE in PHP 7 -- a real, versioned behavior change)
var_dump("1" == "01");     // true  -- both are numeric strings, compared numerically
var_dump("10" == "1e1");   // true  -- "1e1" is a well-formed numeric string equal to 10
var_dump(1 === "1");        // false -- strict comparison also requires the SAME type
```

PHP's loose comparison (`==`) has a long, notorious history of surprising results, particularly comparing numbers to non-numeric strings. **PHP 8 changed this specific behavior**: comparing a number to a non-numeric string (like `0 == "abc"`) now converts the number to a string and compares as strings (`false`), rather than the pre-8 behavior of converting the string to `0` and comparing as numbers (`true`) — a real, version-dependent gotcha worth knowing if working across PHP versions. `===` sidesteps the entire category of surprises by requiring identical types, and is the idiomatic default recommendation for comparisons in modern PHP.

## Type Juggling in Arithmetic vs. Concatenation

```php
$result = "5" + 3;   // int(8)  -- numeric string coerced to int for arithmetic
$concat = "5" . 3;    // string(2) "53" -- the DOT operator concatenates, NOT +
```

`+` is exclusively arithmetic in PHP (unlike JavaScript, where `+` also concatenates strings) — string concatenation always uses `.`, a genuinely distinct convention worth contrasting explicitly with the JS course.

## Null Coalescing (`??`)

```php
$config = ["debug" => false];
$mode = $config["mode"] ?? "production"; // no warning even if "mode" key doesn't exist
```

`??` returns its left operand if it's set and not `null`, otherwise its right operand — critical for safely reading possibly-missing array keys without triggering a warning.

## Constants

```php
define("MAX_USERS", 100);  // runtime-evaluated, works anywhere, classic style
const MIN_USERS = 1;         // must be a top-level (or class) declaration, evaluated at compile time
```

## Detailed Example

See [example.php](example.php) — all of the above, run and verified, including the PHP 8-specific `0 == "abc"` result.

## Run It

```bash
cd 01-Languages/PHP/03-Variables-and-Data-Types
php example.php
```

## Expected Output

Running `php example.php` shows `age` changing from `integer` to `string` type on reassignment, five loose/strict comparison results (`false`, `true`, `true`, `false`, `false` in that order on PHP 8.4.23, confirmed live), `int(8)` for `"5" + 3`, `string(2) "53"` for `"5" . 3`, `mode: production`, and both constants printed correctly.

## Common Mistakes

- Using `+` expecting string concatenation (a JavaScript habit) — PHP requires `.` for concatenation; `+` on two strings attempts numeric coercion instead.
- Relying on loose (`==`) comparison for anything involving user input or mixed numeric/string data, given PHP's history of comparison surprises (partially, but not entirely, fixed in PHP 8).
- Forgetting `const` must be declared at the top level of a file or inside a class — it cannot appear inside a function body or a conditional, unlike `define()`.

## Best Practices

- Default to `===`/`!==` for comparisons unless loose numeric-string coercion is specifically desired and well understood.
- Use `.` for concatenation, always — never rely on `+` for strings.
- Prefer `const` over `define()` in modern PHP for compile-time-evaluated constants; reserve `define()` for cases needing a computed name or runtime-conditional definition.

## Real-World Usage

PHP's `==`/`===` distinction is one of the most commonly tested PHP interview topics, precisely because of its notorious history of surprising loose-comparison results — understanding exactly which PHP version's rules apply to a given codebase matters in practice when working with legacy PHP 7 code migrating to PHP 8.

## Summary

- PHP is dynamically typed; a variable's type follows its current value and can change on reassignment.
- `==` performs type coercion before comparing; `===` requires identical types too — PHP 8 changed number-vs-non-numeric-string loose comparison specifically.
- `.` concatenates strings; `+` is exclusively arithmetic.
- `??` safely reads a possibly-missing/null value with a default.

## Key Terms

- **Type juggling** — PHP's automatic type coercion during operations like arithmetic or loose comparison.
- **Numeric string** — a string that looks like a number (e.g., `"42"`, `"1e1"`) and is treated as one during loose comparison/arithmetic.

## Interview Questions

1. **What changed about `==` comparison between PHP 7 and PHP 8?**
   In PHP 7, comparing a number to a non-numeric string (e.g., `0 == "abc"`) converted the string to a number (`"abc"` → `0`), making the comparison `true`. PHP 8 changed this: the number is now converted to a string instead, so `0 == "abc"` compares `"0" == "abc"` and returns `false`. This was a deliberate breaking change specifically to reduce a long-standing category of PHP comparison surprises, verified directly in this lesson against a real PHP 8.4 installation.

2. **Why does `"5" + 3` return `8` while `"5" . 3` returns `"53"`?**
   `+` is exclusively PHP's arithmetic addition operator — when applied to a numeric string like `"5"`, PHP coerces it to a number (`int(5)`) before adding, producing `int(8)`. `.` is PHP's dedicated string concatenation operator, unrelated to arithmetic — it converts both operands to their string representations and joins them, producing `"53"`. This is a common trip-up for developers coming from JavaScript, where `+` handles both roles depending on operand types.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
