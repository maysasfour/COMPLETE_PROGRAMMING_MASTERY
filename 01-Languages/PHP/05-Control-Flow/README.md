# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`elseif`/`else`, `switch` (falls through by default, like C/JS/C++), and `for`/`while`/`foreach`.
- Use PHP 8's `match` expression: strict comparison, no fall-through, and usable as a value-producing expression.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

PHP's `if`/`for`/`while`/`foreach` are unsurprising and closely resemble C/JavaScript/Java. `switch`, like C/JavaScript/C++ (and unlike Go, which flips the default), falls through unless each case ends with `break`. PHP 8 added `match`, a genuinely more modern alternative to `switch` for value-selection logic.

## `switch`: Falls Through by Default

```php
switch ($day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
        echo "Weekday\n";
        break; // required, or execution falls into "Weekend"
    case 6:
    case 7:
        echo "Weekend\n";
        break;
    default:
        echo "Invalid day\n";
}
```

Grouping cases with no `break` between them (`case 1: case 2: ... case 5:`) is the idiomatic way to share one body across several values — deliberate use of fall-through, not a bug.

## `match` (PHP 8+): Strict, Expression-Based, No Fall-Through

```php
$grade = match (true) {
    $score >= 90 => "A",
    $score >= 80 => "B",
    default => "C or below",
};
```

`match` differs from `switch` in three real ways: it's an **expression** (produces a value directly, assignable to a variable, like Rust's `match` or Kotlin's `when`), it uses **strict (`===`) comparison** rather than `switch`'s loose (`==`), and there is **no fall-through** — each arm is independent, with no `break` needed or possible.

```php
$value = "1";
$result = match ($value) {
    1 => "matched the integer 1",
    "1" => "matched the string \"1\"",
    default => "no match",
};
// result: matched the string "1" -- match's strict comparison distinguishes int 1 from string "1"
```

This was verified live: with `switch`'s loose comparison, `1` and `"1"` would be treated as equal; `match`'s strict comparison correctly distinguishes them.

## Loops

```php
for ($i = 0; $i < 3; $i++) { }
while ($i < 3) { $i++; }
foreach (["a", "b", "c"] as $index => $letter) { }
```

## Detailed Example

See [example.php](example.php) — `if`/`switch`/`match`/loop demonstrations, including the live-verified `match`-uses-strict-comparison distinction between `1` and `"1"`.

## Practice

- [Exercises/exercise.php](Exercises/exercise.php) — implement FizzBuzz using `match (true) { ... }`.
- [Solutions/solution.php](Solutions/solution.php) — a worked solution, run and verified to produce the correct 1–15 FizzBuzz sequence.

## Run It

```bash
cd 01-Languages/PHP/05-Control-Flow
php example.php
php Exercises/exercise.php   # after implementing fizzbuzz()
php Solutions/solution.php
```

## Expected Output

`example.php` prints `B` (the if/elseif grade), `Weekday` (the switch), `match result: B` and `strict match: matched the string "1"` (the match demonstrations), then the for/while/foreach loop output. `Solutions/solution.php` prints the standard FizzBuzz sequence for 1–15, with `Fizz`/`Buzz`/`FizzBuzz` at the correct positions (verified: 3, 5, 6, 9, 10, 12, 15).

## Common Mistakes

- Forgetting `break` in a `switch` case not intended to fall through — a classic, still-common bug given PHP's C-like fall-through-by-default design.
- Assuming `match` behaves like `switch` with loose comparison — it uses strict (`===`) comparison, which can produce a different result than `switch` would for the exact same cases, as demonstrated live in this lesson.
- Forgetting `match` requires an exhaustive set of arms (or a `default`) — an unmatched value with no `default` throws an `UnhandledMatchError`, unlike `switch`, which silently does nothing if no case matches and there's no `default`.

## Best Practices

- Prefer `match` over `switch` for pure value-selection logic in PHP 8+ codebases — it's more concise, avoids fall-through bugs entirely, and its strict comparison is usually what's actually intended.
- Reserve `switch` for cases genuinely wanting fall-through behavior (grouped cases sharing one body) or where the body needs multiple statements/side effects rather than producing a single value.

## Real-World Usage

`match` has rapidly become the idiomatic choice for value-mapping logic in modern PHP (8.0+) codebases — framework routing logic, enum-like value dispatch, and validation-result mapping are common real-world use cases, while `switch` remains common in older PHP 7 codebases and for genuinely fall-through-dependent logic.

## Summary

- `switch` falls through by default (like C/JS/C++, unlike Go) and requires explicit `break`.
- `match` (PHP 8+) is an expression, uses strict comparison, and has no fall-through — genuinely different behavior from `switch`, not just different syntax.
- `for`/`while`/`foreach` closely resemble every other C-family language covered in this repository.

## Key Terms

- **`match`** — a PHP 8+ expression for value selection: strict comparison, no fall-through, exhaustiveness-checked at runtime.
- **Fall-through** — `switch` continuing execution into the next case when no `break` is hit.

## Interview Questions

1. **What are the three concrete differences between `switch` and `match` in PHP?**
   `match` is an expression that produces a value directly (assignable, like `$x = match(...) {...};`), while `switch` is a statement with no return value of its own. `match` uses strict (`===`) comparison, while `switch` uses loose (`==`) comparison — this was verified directly: matching `"1"` against arms for both `1` and `"1"` produces different results between the two constructs. And `match` has no fall-through at all — every arm is independent, with no `break` needed or even syntactically valid — while `switch` falls through by default unless each case ends with `break`.

2. **What happens if a `match` expression's value doesn't match any arm and there's no `default`?**
   PHP throws an `UnhandledMatchError` at runtime. This is a deliberate design choice contrasting with `switch`, which simply does nothing (no error) if no case matches and there's no `default` — `match`'s stricter behavior helps catch missing-case bugs immediately rather than silently doing nothing.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
