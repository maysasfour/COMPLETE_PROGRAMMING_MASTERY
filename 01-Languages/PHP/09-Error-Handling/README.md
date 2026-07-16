# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally` and write a custom exception class with constructor property promotion.
- Use PHP 8's multi-catch syntax (`catch (TypeA | TypeB $e)`).
- Understand PHP's split `Error`/`Exception` hierarchy, both implementing `Throwable` — a genuinely distinctive design compared to most languages in this course, which have a single root throwable type.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

PHP uses exceptions (`try`/`catch`/`finally`), similar to Python/Java/C#/JavaScript, but with one genuinely distinctive twist: **`Error` and `Exception` are two separate class hierarchies**, both implementing a common `Throwable` interface. `Error` (and subclasses like `TypeError`, `DivisionByZeroError`, `ArgumentCountError`) represents programming mistakes the language itself detects — a wrong argument count, a type mismatch — while `Exception` (and subclasses) represents expected, recoverable runtime failures an application defines and throws deliberately.

## `try`/`catch`/`finally`

```php
try {
    echo divide(5, 0);
} catch (DivisionByZeroError $e) {
    echo "caught: " . $e->getMessage();
} finally {
    echo "finally always runs";
}
```

## Custom Exceptions with Constructor Property Promotion

```php
class InsufficientFundsException extends Exception {
    public function __construct(public readonly float $shortfall) {
        parent::__construct("insufficient funds, short by {$shortfall}");
    }
}
```

`public readonly float $shortfall` directly in the constructor signature is PHP 8+'s constructor property promotion — it declares, types, and assigns the property in one place, avoiding a separate property declaration plus a manual `$this->shortfall = $shortfall;` assignment.

## Multi-Catch (PHP 8+)

```php
try {
    risky($mode);
} catch (InvalidArgumentException | RuntimeException $e) {
    echo get_class($e) . ": " . $e->getMessage();
}
```

One `catch` block can handle several unrelated exception types with a shared `|`-separated type list, avoiding duplicate catch blocks with identical bodies.

## `Error` vs. `Exception`: Two Hierarchies, One `Throwable` Interface

```php
try {
    strlen(); // ArgumentCountError -- extends Error, NOT Exception
} catch (Throwable $e) {
    echo get_class($e); // "ArgumentCountError"
}
```

Verified live: calling `strlen()` with no arguments throws `ArgumentCountError`, which extends `Error`, not `Exception`. A `catch (Exception $e)` block would **not** catch this — only `catch (Error $e)` or the shared `catch (Throwable $e)` would. This split is a deliberate PHP design choice: `Error` subclasses generally represent bugs (wrong argument counts, type mismatches) that a well-written program shouldn't be routinely catching and recovering from, while `Exception` subclasses represent expected failure modes (a file not found, insufficient funds) that application code is meant to handle.

## Detailed Example

See [example.php](example.php) — all of the above, run and verified, including the live-confirmed `ArgumentCountError extends Error` distinction.

## Run It

```bash
cd 01-Languages/PHP/09-Error-Handling
php example.php
```

## Expected Output

Running `php example.php` prints `5` (the successful division), `caught: cannot divide 5 by zero` then `finally always runs` (confirming `finally` runs even after a caught exception), the custom exception's message plus its promoted `$shortfall` property, both multi-catch results (`InvalidArgumentException: bad argument` and `RuntimeException: bad runtime state`), and finally `ArgumentCountError: strlen() expects exactly 1 argument, 0 given` confirming the `Error`-vs-`Exception` hierarchy split.

## Common Mistakes

- Writing `catch (Exception $e)` and assuming it catches every possible failure — it doesn't catch `Error` subclasses (`TypeError`, `DivisionByZeroError`, `ArgumentCountError`); use `catch (Throwable $e)` if genuinely every failure type needs handling.
- Catching `Error` broadly in normal application control flow — it usually indicates a programming bug that should be fixed, not silently handled at runtime, unlike `Exception`, which is meant for expected, recoverable conditions.
- Forgetting `parent::__construct($message)` in a custom exception's constructor — without it, `getMessage()` returns an empty string instead of the intended message.

## Best Practices

- Extend `Exception` (not `Error`) for custom, application-defined failure conditions meant to be caught and handled.
- Use constructor property promotion (`public readonly float $shortfall` directly in the constructor) for custom exceptions carrying extra structured data.
- Reserve broad `catch (Throwable $e)` for top-level error boundaries (e.g., a global request handler logging unexpected failures), not routine business logic.

## Real-World Usage

Custom exception hierarchies extending `Exception` are standard in PHP frameworks (Laravel's `ValidationException`, Symfony's various HTTP exception classes) for representing domain-specific, application-level failures distinctly from PHP-internal `Error`s, which usually indicate a bug in the framework or application code itself rather than an expected runtime condition.

## Summary

- `try`/`catch`/`finally` work much like Java/C#/Python; `finally` always runs.
- PHP splits throwables into `Error` (language-detected programming mistakes) and `Exception` (application-defined recoverable failures), both implementing `Throwable` — a genuinely distinctive design verified live in this lesson.
- Constructor property promotion (`public readonly Type $prop` in the constructor signature) is idiomatic for custom exceptions carrying data.
- PHP 8's multi-catch (`catch (A | B $e)`) handles several exception types in one block.

## Key Terms

- **`Throwable`** — the common interface implemented by both the `Error` and `Exception` class hierarchies.
- **Constructor property promotion** — PHP 8+ syntax declaring, typing, and assigning a property directly in a constructor parameter.

## Interview Questions

1. **Why does PHP have both `Error` and `Exception`, and why does `catch (Exception $e)` sometimes miss real failures?**
   PHP deliberately splits throwables into two hierarchies: `Error` (and subclasses like `TypeError`, `ArgumentCountError`, `DivisionByZeroError`) represents mistakes the language runtime itself detects — usually programming bugs, not expected runtime conditions — while `Exception` represents application-defined, expected failure modes meant to be caught and handled as part of normal control flow. Since `Error` does not extend `Exception` (they're siblings under the shared `Throwable` interface), a `catch (Exception $e)` block will not catch an `Error`; this was verified directly by calling `strlen()` with no arguments, which throws `ArgumentCountError` — only `catch (Error $e)` or `catch (Throwable $e)` catches it.

2. **What does constructor property promotion do, and why is it useful for custom exceptions?**
   It's PHP 8+ syntax that lets a constructor parameter's visibility modifier (`public`/`private`/`protected`, optionally `readonly`) declare a class property, type it, and assign it from the argument — all in the parameter list itself, eliminating a separate property declaration and a manual `$this->prop = $prop;` line. For custom exceptions specifically, this is a clean way to attach extra structured data (like a `$shortfall` amount) to the exception object itself, retrievable by the catching code, rather than encoding everything into the string message alone.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
