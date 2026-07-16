# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use PHP's arithmetic, spaceship (`<=>`), and null-safe (`?->`) operators.
- Understand the real precedence trap between `and`/`or` and `=`.
- Know that PHP defines increment behavior on strings, not just numbers.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Most of PHP's operators are unsurprising (`+ - * / %`, `== === < > <= >=`, `&& ||`), but PHP has several genuinely distinctive operators and a real, documented precedence gotcha worth calling out explicitly.

## Arithmetic: `**`, `intdiv()`, `%`

```php
echo 2 ** 10;        // 1024 -- exponentiation operator
echo intdiv(10, 3);   // 3    -- explicit integer division (as a function, not an operator)
echo 10 / 3;            // 3.3333333333333 -- / always returns a float unless evenly divisible
echo 10 % 3;              // 1
```

## Spaceship Operator (`<=>`)

```php
1 <=> 2;  // -1 (less than)
2 <=> 2;  //  0 (equal)
3 <=> 2;  //  1 (greater than)

usort($nums, fn($a, $b) => $a <=> $b); // idiomatic ascending sort
```

`<=>` is PHP's three-way comparison operator, purpose-built for sort callbacks — `usort()`/`uasort()`/`uksort()` all expect a callback returning negative/zero/positive, exactly what `<=>` produces directly.

## Null-Safe Operator (`?->`, PHP 8+)

```php
echo $user->address?->city ?? "no city on file";
```

`?->` short-circuits to `null` the moment any link in the chain is `null`, instead of throwing an error — avoiding a nested nullable nightmare of `isset($user) && isset($user->address) && isset($user->address->city)` checks.

## `and`/`or` vs. `&&`/`||`: A Real Precedence Trap

```php
$a = true and false; // parses as ($a = true) and false -- $a is TRUE, not false!
var_dump($a);          // bool(true) -- verified live
```

`and`/`or` have **lower precedence than `=`**, while `&&`/`||` have **higher precedence than `=`** — this is not a stylistic difference, it changes what the code actually does. `$a = true and false` assigns `true` to `$a` first, then evaluates the (discarded) `and false`. The equivalent using `&&` — `$a = true && false;` — correctly assigns `false`. This was reproduced live in this lesson's example, not just described.

## String Increment (a PHP-Specific Feature)

```php
$letter = "a";
$letter++;
echo $letter; // "b" -- PHP defines increment on strings (Perl-derived behavior)
```

## Detailed Example

See [example.php](example.php) — all operators above, including a live-verified demonstration of the `and`-vs-`=` precedence trap.

## Run It

```bash
cd 01-Languages/PHP/04-Operators
php example.php
```

## Expected Output

Running `php example.php` prints `1024`, `3`, `3.3333333333333`, `1` for arithmetic; `-1`/`0`/`1` for the spaceship comparisons and a sorted `1, 3, 5, 8`; `no city on file` for the null-safe chain; `bool(false)`/`bool(true)` for `&&`/`||`, then `bool(true)` for `$a` after the `and`/`=` precedence trap (confirming `$a` became `true`, not `false`); and `b` for the string-increment demonstration.

## Common Mistakes

- Using `and`/`or` in place of `&&`/`||` assuming they're just stylistic synonyms — they are not, due to the precedence difference relative to `=`, reproduced live in this lesson.
- Assuming `/` always returns an integer for integer operands — it returns a `float` unless the division is exact; use `intdiv()` when integer division is specifically required.
- Chaining `->` on a value that might be `null` without `?->` — this throws an `Error` in PHP 8+ (a fatal error, not a warning), unlike some dynamic languages that silently return `null`.

## Best Practices

- Use `&&`/`||` for logical operators in expressions involving assignment; reserve `and`/`or` (if used at all) for their true intended use — low-precedence control-flow-like joining of statements, not inline expressions.
- Use `?->` for any chain of property/method access where an intermediate value might legitimately be `null`.
- Use `<=>` directly in sort callbacks instead of manually writing `if ($a < $b) return -1; ...`.

## Real-World Usage

The `and`/`&&` precedence difference is a classic PHP interview and code-review topic precisely because it silently produces wrong behavior without any syntax error — code reviewers specifically watch for `and`/`or` used where `&&`/`||` was intended, especially in conditionals combined with assignment.

## Summary

- `**` is exponentiation; `intdiv()` gives true integer division; `/` returns a float unless exact.
- `<=>` (spaceship) is purpose-built for sort callbacks.
- `?->` short-circuits an access chain to `null` instead of erroring.
- `and`/`or` have lower precedence than `=`, unlike `&&`/`||` — a genuine, live-verified gotcha.
- PHP defines increment behavior on strings, a distinctive feature.

## Key Terms

- **Spaceship operator (`<=>`)** — a three-way comparison returning -1/0/1.
- **Null-safe operator (`?->`)** — short-circuits a chained access to `null` if any link is `null`.

## Interview Questions

1. **Why is `$a = true and false;` a trap, and what does it actually do?**
   `and` has lower precedence than `=` in PHP, while `&&` has higher precedence than `=`. So `$a = true and false;` parses as `($a = true) and false` — the assignment happens first (assigning `true` to `$a`), and the `and false` portion is evaluated but its result is discarded. This was verified directly: `$a` ends up `true`, not `false`, despite looking like it should logically-AND to `false`. The fix is to use `&&` for any logical expression that also involves assignment: `$a = true && false;` correctly assigns `false`.

2. **What does the null-safe operator `?->` do, and what problem does it solve?**
   `?->` (PHP 8+) accesses a property or calls a method, but if the value on its left is `null`, the entire expression short-circuits to `null` instead of throwing an error. This avoids writing verbose, nested `isset()`/`is_null()` checks for each link in a chain like `$user->address->city` where any intermediate value might legitimately be absent — `$user->address?->city ?? "default"` expresses the same safe-navigation-with-fallback in one line.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
