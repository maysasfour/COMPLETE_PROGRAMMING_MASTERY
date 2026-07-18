# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally`, including `try` as a value-producing expression.
- Write a custom exception.
- Use `Option`, `Either`, and `Try` — Scala's idiomatic *functional* alternative to exceptions, making success/failure part of a value's type.

## Concept

Scala supports Java-style `try`/`catch`/`finally` (and, like Kotlin, has no checked exceptions), but idiomatic Scala code favors expressing failure through the *type system* instead: `Option[T]` for optional values (no `null`), `Either[L, R]` for a typed success/failure result carrying a reason, and `Try[T]` for wrapping a computation that might throw as an inspectable value. These make the *possibility* of failure visible in a function's signature, forcing callers to handle it — the same philosophy Rust's `Option`/`Result` (covered elsewhere in this repository) is built on.

## `try` as an Expression

```scala
val result: Double =
  try divide(10.0, 0.0)
  catch case e: ArithmeticException => -1.0
  finally println("cleanup")
```

## `Option` — No `null`, Ever

```scala
def findUser(id: Int): Option[String] = if id == 1 then Some("Ada") else None
findUser(99).getOrElse("unknown")   // provide a fallback instead of a null check
```

## `Either` — Typed Failure With a Reason

```scala
def parseAge(input: String): Either[String, Int] = // Left = failure reason, Right = success
  input.toIntOption match
    case Some(n) if n >= 0 => Right(n)
    case Some(_)             => Left(s"age cannot be negative: $input")
    case None                => Left(s"not a number: $input")
```

## `Try` — Wrapping a Throwing Computation as a Value

```scala
import scala.util.{Try, Success, Failure}
val t: Try[Double] = Try(divide(10.0, 0.0))   // Success(v) or Failure(exception), never throws
```

## Detailed Example

See [ErrorHandling.scala](ErrorHandling.scala) — `try` as an expression, a custom exception, and all three of `Option`/`Either`/`Try` exercised with genuinely both success and failure paths.

## Run It

```bash
cd 01-Languages/Scala/09-Error-Handling
scalac ErrorHandling.scala
scala run . --main-class errorHandlingDemo
```

## Expected Output

```
--- try/catch/finally, and try AS AN EXPRESSION ---
finally always runs
result: -1.0

--- custom exception ---
insufficient funds, short by 50.0 (shortfall=50.0)

--- Option: no null anywhere ---
findUser(1) = Some(Ada)
findUser(99) = None
getOrElse fallback: unknown

--- Either: typed success/failure with a reason ---
parseAge("31") = Right(31)
parseAge("-5") = Left(age cannot be negative: -5)
parseAge("abc") = Left(not a number: abc)

--- Try: wraps a possibly-throwing computation as a value ---
Try success: Success(5.0)
Try failure: Failure(java.lang.ArithmeticException: cannot divide 10.0 by zero)
handled failure: cannot divide 10.0 by zero
```

## Common Mistakes

- Calling `.get` on an `Option`/`Try` without checking first — reintroduces the exact `null`-check-style crash risk these types exist to prevent; prefer `.getOrElse`, pattern matching, or `.map`/`.flatMap`.
- Using exceptions for ordinary, expected failure conditions (like "user not found") instead of `Option`/`Either` — exceptions are best reserved for genuinely exceptional, unexpected conditions.
- Forgetting `Either`'s convention: `Left` is failure, `Right` is success ("right" as in "correct") — reversing them compiles fine but confuses every reader familiar with the convention.

## Best Practices

- Prefer `Option`/`Either`/`Try` over `null` and unchecked exceptions for representing absence/failure whenever the failure is an expected, everyday outcome.
- Reserve real exceptions (and `try`/`catch`) for genuinely exceptional conditions or when interoperating with Java APIs that throw.
- Use `Either[String, T]` (or a proper sealed error type instead of a bare `String`) when callers need to know *why* something failed, not just *whether*.

## Real-World Usage

Web frameworks (http4s, Play) and validation libraries (Cats' `Validated`) build directly on this `Either`/`Option` foundation to represent request-parsing failures, validation errors, and optional query parameters — all as ordinary values flowing through `.map`/`.flatMap` chains, rather than as thrown exceptions interrupting control flow.

## Summary

- `try`/`catch`/`finally` exists and `try` can be used as an expression, but idiomatic Scala prefers `Option`/`Either`/`Try` for expected failure.
- `Option[T]` eliminates `null` from the type system entirely.
- `Either[L, R]` carries a typed failure reason on `Left` alongside a success value on `Right`.
- `Try[T]` wraps a possibly-throwing computation as an inspectable `Success`/`Failure` value.

## Key Terms

- **`Option[T]`** — `Some(value)` or `None`; makes absence part of the type.
- **`Either[L, R]`** — `Left(reason)` or `Right(value)`; a typed, reasoned success/failure result.
- **`Try[T]`** — `Success(value)` or `Failure(exception)`; a value-level wrapper around a throwing computation.

## Interview Questions

1. **Why does idiomatic Scala prefer `Option`/`Either`/`Try` over exceptions for expected failures?** — Because these types make the possibility of failure part of a function's *signature*, forcing the compiler to require callers to handle it (via pattern matching, `.map`/`.getOrElse`, etc.), whereas an exception's possibility is invisible in the type signature (Scala has no checked exceptions) and can silently propagate uncaught until it crashes something far from where it originated.
2. **What's the practical difference between `Option` and `Either`?** — `Option[T]` only distinguishes presence (`Some`) from absence (`None`) with no information about *why* a value is absent; `Either[L, R]` carries an actual reason on its `Left` case alongside the success value on `Right`, making it the better choice whenever a caller needs to know why an operation failed, not merely that it did.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
