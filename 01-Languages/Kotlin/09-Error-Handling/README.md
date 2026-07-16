# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally`, and `try` as an **expression** producing a value.
- Write a custom exception class.
- Understand Kotlin's deliberate design choice to have **no checked exceptions at all** — a genuine, documented divergence from Java, covered earlier in this repository.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Kotlin's exception handling closely resembles Java's syntax (`try`/`catch`/`finally`, `throw`), but with two genuinely important differences: `try` can be used as an **expression** (like `if`/`when` in Lessons 05), and Kotlin has **no checked exceptions** — every exception is effectively "unchecked" from the compiler's perspective, a deliberate, well-documented JetBrains design decision.

## `try` as an Expression

```kotlin
val result: Double = try {
    divide(10.0, 0.0)
} catch (e: ArithmeticException) {
    -1.0 // the whole try/catch expression evaluates to this value if an exception is caught
}
```

Just like `if`/`when`, `try`/`catch` can produce a value directly — the last expression of whichever branch actually executes (the `try` block if no exception, or a `catch` block if one was thrown) becomes the value of the entire expression. This is a genuine Kotlin feature Java's `try` statement doesn't have.

## Custom Exceptions

```kotlin
class InsufficientFundsException(val shortfall: Double) :
    Exception("insufficient funds, short by $shortfall")
```

## No Checked Exceptions: A Deliberate Design Choice

```kotlin
fun riskyIO() { throw java.io.IOException("simulated IO failure") } // no `throws` clause exists in Kotlin
```

Verified live: calling a function that throws `java.io.IOException` (a *checked* exception in Java, requiring either a `throws IOException` declaration or a mandatory catch) required **no** such declaration in Kotlin at all — Kotlin has no `throws` keyword, and the compiler never forces calling code to catch or declare any exception, checked or not. This was a deliberate JetBrains design decision: their assessment was that Java's checked exceptions, in large real-world codebases, mostly led to either overly broad `catch (Exception e)` blocks or exceptions being silently swallowed just to satisfy the compiler, providing little of their intended safety benefit in practice. Kotlin treats every exception as Java would treat an unchecked (`RuntimeException`-derived) one.

## Detailed Example

See [Example.kt](Example.kt) — `try`/`catch`/`finally`, `try` as an expression, a custom exception with a data-carrying property, and the live-verified no-checked-exceptions demonstration using `java.io.IOException` (a genuinely checked exception in Java) called with no `throws` declaration at all.

## Run It

```bash
cd 01-Languages/Kotlin/09-Error-Handling
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints `5.0` (successful division), `caught: cannot divide 5.0 by zero` then `finally always runs`, `result: -1.0` (the try-expression's caught-branch value), the custom exception's message plus its `shortfall` property, and finally confirmation that `java.io.IOException` was caught with no `throws` declaration required anywhere.

## Common Mistakes

- Assuming Kotlin distinguishes checked and unchecked exceptions the way Java does — it doesn't at all; every exception behaves like Java's unchecked exceptions, verified live by throwing a genuinely-checked-in-Java `IOException` with no declaration required.
- Forgetting `try` can be used as an expression, and instead declaring a `var` outside and assigning it inside each branch — more verbose than directly assigning the `try` expression's result to a `val`.
- Writing overly broad `catch (e: Exception)` blocks purely out of habit from Java's checked-exception-driven catch requirements — Kotlin's lack of checked exceptions removes the *compiler pressure* to do this, so catches can (and should) be as narrowly scoped as actually intended.

## Best Practices

- Use `try` as an expression when a fallback value on exception is the natural way to express the logic.
- Catch specific exception types rather than broad `Exception`/`Throwable` — Kotlin's lack of checked exceptions means there's no compiler-driven reason to over-broaden a catch clause.
- When calling Java libraries that declare checked exceptions, remember Kotlin doesn't enforce catching them — read the Java library's documentation to know what exceptions a call might realistically throw, since the Kotlin compiler won't remind you.

## Real-World Usage

Kotlin's no-checked-exceptions design is frequently cited as one of its ergonomic improvements over Java specifically for interoperability — when calling into Java libraries with checked exceptions declared, Kotlin code isn't forced to catch or re-declare them, though this also means Kotlin code calling such libraries needs to consult documentation (rather than rely on compiler-enforced `throws` declarations) to know what might be thrown.

## Summary

- `try`/`catch`/`finally` largely mirror Java's syntax, but `try` can additionally be used as an expression producing a value.
- Kotlin has no checked exceptions at all — a deliberate design choice, verified live by throwing Java's checked `IOException` with no `throws` declaration required or even possible.
- Custom exceptions are ordinary classes extending `Exception` (or a subclass), optionally carrying extra structured data as constructor properties.

## Key Terms

- **Checked exception** — in Java, an exception type the compiler forces calling code to catch or declare; Kotlin has no equivalent concept at all.
- **`try` expression** — Kotlin's ability to use `try`/`catch` as a value-producing expression, not just a statement.

## Interview Questions

1. **Why doesn't Kotlin have checked exceptions, and what's the practical implication of that when calling Java code?**
   JetBrains deliberately omitted checked exceptions from Kotlin's design, based on their observation that in large real-world Java codebases, checked exceptions mostly led developers to either write overly broad catch blocks (`catch (Exception e)`) or silently swallow exceptions purely to satisfy the compiler's `throws`-declaration requirement — providing little of their intended safety benefit in practice. Practically, this means when Kotlin code calls a Java method that declares a checked exception (verified live in this lesson with `java.io.IOException`), Kotlin doesn't require catching or declaring it at all — the exception can propagate freely unless explicitly caught, so understanding what a called Java method might throw requires reading its documentation rather than relying on the compiler to enforce it.

2. **What does it mean for `try` to be usable as an "expression" in Kotlin, and how does this differ from Java?**
   In Kotlin, a `try`/`catch` block can appear anywhere an expression is expected, with its overall value being the last expression evaluated in whichever branch actually ran (the `try` block, if no exception occurred, or the matching `catch` block, if one was caught and handled). This allows patterns like `val x = try { riskyCall() } catch (e: SomeException) { fallbackValue }`, assigning directly to a `val`. Java's `try` is purely a statement — it has no value of its own, so achieving the same effect in Java requires declaring a mutable variable outside the `try` block and assigning it separately inside each branch, a noticeably more verbose equivalent.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
