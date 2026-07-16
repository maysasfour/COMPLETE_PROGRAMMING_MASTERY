# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Use default, named (PHP 8+), and variadic parameters, plus type declarations and `declare(strict_types=1)`.
- Pass a parameter by reference (`&$param`) to mutate the caller's variable directly.
- Distinguish arrow functions (`fn`, auto-capturing) from anonymous functions (`function`, explicit `use`).
- Use first-class callable syntax (`strlen(...)`, PHP 8.1+).

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

PHP functions support default values, optional type declarations (enforced strictly only with `declare(strict_types=1)`), named arguments (PHP 8+), and variadic parameters — broadly similar to Python's function signature flexibility, though with its own specific syntax and a genuinely distinctive reference-parameter mechanism.

## `declare(strict_types=1)`

```php
declare(strict_types=1); // must be the FIRST statement in the file
```

Without this declaration, PHP coerces argument types where possible (e.g., passing `"5"` to an `int` parameter silently converts it). With it, passing a mismatched type (like a `string` where `int` is declared) throws a `TypeError` instead of coercing — the stricter, more predictable choice used throughout this course's examples.

## Default, Named, and Variadic Parameters

```php
function greet(string $name, string $greeting = "Hello"): string {
    return "{$greeting}, {$name}!";
}
greet(name: "Grace", greeting: "Hi"); // named arguments -- order-independent (PHP 8+)

function sum(int ...$numbers): int { return array_sum($numbers); }
sum(1, 2, 3, 4); // 10 -- variadic, collects any number of arguments into an array
```

## By-Reference Parameters (`&$param`)

```php
function increment(int &$n): void { $n++; }
$counter = 5;
increment($counter);
// $counter is now 6 -- genuinely mutated, unlike every by-value parameter so far
```

Prefixing a parameter with `&` makes it an alias to the caller's variable, not a copy — a mechanism most other languages in this course avoid (Rust requires an explicit `&mut`; Go, Java, C#, JS all pass references-to-objects but never let a function reassign the caller's own local variable binding the way PHP's `&$param` does).

## Arrow Functions vs. Anonymous Functions

```php
$multiplier = 3;
$triple = fn(int $x): int => $x * $multiplier;      // auto-captures $multiplier

$add = function (int $a, int $b) use ($multiplier): int {   // must explicitly `use` it
    return ($a + $b) * $multiplier;
};
```

Arrow functions (`fn`, PHP 7.4+) are single-expression, implicitly `return`, and automatically capture any variable from the enclosing scope they reference — a real convenience over plain anonymous functions, which require every captured variable to be listed explicitly in a `use (...)` clause.

## First-Class Callable Syntax (PHP 8.1+)

```php
$lengths = array_map(strlen(...), ["a", "bb", "ccc"]); // strlen(...) makes a Closure, doesn't call it
```

`strlen(...)` creates a `Closure` referencing the `strlen` function without invoking it — a cleaner, more concise alternative to the older `'strlen'`/`[$this, 'method']` string/array-based callable syntax.

## Detailed Example

See [example.php](example.php) — all of the above, verified live, including the by-reference mutation and named-argument order-independence.

## Practice

- [Exercises/exercise.php](Exercises/exercise.php) — implement a variadic `average()` and an arrow-function `$square`, combining `array_map` and the spread operator.
- [Solutions/solution.php](Solutions/solution.php) — a worked solution, verified to print `7.5` for the average of `[1, 4, 9, 16]`.

## Run It

```bash
cd 01-Languages/PHP/06-Functions
php example.php
php Solutions/solution.php
```

## Expected Output

`example.php` prints three greetings (two using named arguments in different orders, both correct), `10` for the variadic sum, `counter after increment: 6` (confirming the by-reference mutation), `21` and `15` for the two closures, and `1, 2, 3` for the first-class-callable `array_map`. `Solutions/solution.php` prints `squared: 1, 4, 9, 16` and `average of squares: 7.5`.

## Common Mistakes

- Forgetting `declare(strict_types=1)` and being surprised when a `"5"` string is silently coerced to `int(5)` for a typed parameter — without it, PHP coerces by default.
- Using a plain anonymous function (`function`) and forgetting the `use (...)` clause for an outer variable it references — unlike an arrow function, which captures automatically.
- Assuming by-reference parameters are the norm — they're an explicit opt-in (`&$param`) and should be reserved for cases where mutating the caller's variable is genuinely the intended contract, since it's a surprising side effect otherwise.

## Best Practices

- Add `declare(strict_types=1);` to every new PHP file for predictable, non-coercing type checking.
- Prefer arrow functions (`fn`) for short, single-expression callbacks; reserve full anonymous functions for multi-statement bodies.
- Use named arguments for functions with several optional/boolean parameters, to make call sites self-documenting.

## Real-World Usage

Named arguments and first-class callable syntax are both recent (PHP 8.0/8.1) additions widely adopted in modern PHP codebases (notably Laravel and Symfony) specifically because they make call sites far more readable than positional booleans or string-based callables.

## Summary

- `declare(strict_types=1)` makes type declarations strict rather than coercive.
- Named arguments (PHP 8+) are order-independent; variadic parameters collect any number of arguments.
- `&$param` lets a function mutate the caller's variable directly — an explicit, deliberate opt-in.
- Arrow functions (`fn`) auto-capture outer scope; anonymous functions need an explicit `use (...)`.
- First-class callable syntax (`strlen(...)`) creates a `Closure` without invoking the function.

## Key Terms

- **By-reference parameter (`&$param`)** — an alias to the caller's variable, allowing direct mutation.
- **Arrow function (`fn`)** — a single-expression closure that auto-captures its enclosing scope.

## Interview Questions

1. **What's the difference between an arrow function (`fn`) and a regular anonymous function (`function`) in PHP regarding variable capture?**
   An arrow function automatically captures (by value) any variable from the enclosing scope that it references inside its expression body — no explicit syntax needed. A regular anonymous function captures nothing automatically; any outer variable it needs must be explicitly listed in a `use (...)` clause after the parameter list, or the function won't have access to it (it'll be undefined inside the function body).

2. **What does prefixing a parameter with `&` do, and why is it unusual compared to most other languages?**
   `&$param` makes the parameter a reference/alias to the caller's actual variable rather than a copy of its value — any mutation inside the function (like `$n++`) is directly visible to the caller after the call returns. This is unusual because most languages in this repository don't let a called function reassign the caller's own local variable binding at all: Rust requires an explicit `&mut` reference type (not a special parameter syntax), and Go/Java/C#/JavaScript only allow mutating an object's *contents* through a reference, never rebinding the caller's local variable itself the way PHP's `&$param` does.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
