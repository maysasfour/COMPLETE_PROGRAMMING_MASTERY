# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `Result<T, E>` for recoverable errors and `Option<T>` for optional values (recap and extension).
- Use the `?` operator to propagate errors concisely.
- Understand `panic!` is reserved for unrecoverable situations, similar to Go's `panic`/`recover` philosophy but with no `recover` equivalent in ordinary code.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Rust has no exceptions — `Result<T, E>` (`Ok(T)` or `Err(E)`) is the idiomatic mechanism for recoverable errors, and `Option<T>` (`Some(T)` or `None`) for values that might be absent (Lesson 04). This is conceptually similar to Go's `(value, error)` pattern, but **compiler-enforced**: `Result`/`Option` are real enum types you must explicitly unwrap (via pattern matching, `?`, or methods like `.unwrap()`), unlike Go where you're free to `_`-discard an error with no compiler complaint at all.

## `Result<T, E>` and Explicit Handling

```rust
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err(String::from("cannot divide by zero"));
    }
    Ok(a / b)
}

match divide(10.0, 0.0) {
    Ok(result) => println!("Result: {}", result),
    Err(e) => println!("Error: {}", e),
}
```

## The `?` Operator: Concise Propagation

```rust
fn calculate(a: f64, b: f64, c: f64) -> Result<f64, String> {
    let step1 = divide(a, b)?; // if divide(...) returns Err, immediately RETURN that Err from calculate
    let step2 = divide(step1, c)?;
    Ok(step2)
}
```

The `?` operator is Rust's most distinctive error-handling ergonomics feature: applied to a `Result`, it either unwraps the `Ok` value and continues, or immediately returns the `Err` from the enclosing function — eliminating the repetitive `if err != nil { return err }` boilerplate the Go course's equivalent pattern requires at every step.

## Custom Error Types

```rust
use std::fmt;

#[derive(Debug)]
struct ValidationError {
    field: String,
    message: String,
}

impl fmt::Display for ValidationError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}: {}", self.field, self.message)
    }
}

impl std::error::Error for ValidationError {} // marks it as a genuine error type
```

## `panic!`: For Truly Unrecoverable Situations

```rust
fn must_divide(a: f64, b: f64) -> f64 {
    if b == 0.0 {
        panic!("division by zero"); // crashes the program (or thread) -- not routine error handling
    }
    a / b
}
```

Unlike Go's `panic`/`recover` pair, ordinary Rust code has no general-purpose `recover` — a `panic!` in the main thread crashes the whole program (though `std::panic::catch_unwind` exists for specialized cases like a web server isolating one request's panic). This makes `panic!` even more clearly "last resort" in Rust than in Go.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints `Result` handled via `match`, the `?` operator propagating an error concisely through a multi-step calculation, and a custom error type implementing `Display`.

## Common Mistakes

- Calling `.unwrap()`/`.expect()` reflexively on a `Result`/`Option` instead of handling the `Err`/`None` case properly — both panic immediately if the value is `Err`/`None`, appropriate only when you've already proven (or genuinely don't care about) that case.
- Forgetting `?` requires the enclosing function's return type to be compatible (`Result<_, E>` where the propagated error converts to `E`) — using `?` in a function that doesn't return `Result`/`Option` is a compile error.

## Best Practices

- Use `?` for propagating errors through a chain of fallible operations, rather than manually matching and re-returning at every step.
- Reserve `.unwrap()`/`.expect()` for cases you've already proven can't fail, or genuinely unrecoverable startup-time conditions — never for routine, expected failure paths.
- Implement `std::error::Error` (plus `Display`/`Debug`) for custom error types, enabling them to compose with `?` and generic error-handling code.

## Real-World Usage

The `?` operator is one of Rust's most beloved ergonomic features specifically because it turns Go's often-repetitive `if err != nil { return err }` pattern into a single character, while keeping error handling fully explicit and compiler-enforced (unlike exceptions, which can be silently uncaught).

## Summary

- `Result<T, E>`/`Option<T>` are Rust's compiler-enforced alternatives to exceptions/null, extending Lesson 04.
- The `?` operator concisely propagates an `Err`/`None` up through the call stack, eliminating Go-style manual error-checking boilerplate at every step.
- `panic!` is for truly unrecoverable situations; ordinary code has no general `recover`, making it even more clearly last-resort than Go's `panic`/`recover`.

## Key Terms

- **`?` operator** — concisely propagates a `Result`'s `Err` (or an `Option`'s `None`) out of the enclosing function.
- **`panic!`** — Rust's mechanism for unrecoverable errors, crashing the program/thread with no general-purpose recovery in ordinary code.

## Interview Questions

1. **How does the `?` operator work, and what problem does it solve?**
   Applied to a `Result` (or `Option`) expression, `?` unwraps the `Ok`/`Some` value if present and lets execution continue; if it's `Err`/`None`, `?` immediately returns that `Err`/`None` from the enclosing function. It solves the verbosity of manually checking and re-returning an error at every step of a multi-step fallible operation — the same problem Go's `if err != nil { return err }` pattern addresses, but Rust's `?` handles it in a single character per fallible call.

2. **What's the practical difference between Rust's `panic!`/no-general-`recover` and Go's `panic`/`recover`?**
   Both represent "genuinely exceptional, not routine" failure handling. But Go provides a general-purpose `recover()` any goroutine can use to catch a panic and continue running. Ordinary Rust code has no equivalent general recovery mechanism — a `panic!` in the main thread terminates the whole program (only specialized tools like `std::panic::catch_unwind`, typically used at isolation boundaries like a web server's per-request handler, can catch one). This makes `panic!` an even stronger "last resort" signal in Rust than in Go.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
