# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Write top-level functions with no enclosing class — a genuine syntactic simplification over Java.
- Use `val` (read-only) vs. `var` (reassignable) and string templates.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Kotlin's syntax is deliberately more concise than Java's while remaining statically typed and fully JVM-interoperable. Two of the most immediately visible differences from Java (covered earlier in this repository): functions can exist at the top level of a file with no enclosing class required at all, and semicolons are optional (the compiler infers statement boundaries from line breaks in almost all cases).

## Top-Level Functions (No Class Wrapper Needed)

```kotlin
fun main() {
    println("Hello, Kotlin!")
}
```

Unlike Java, where even a single `main` method must live inside a class (`public class Example { public static void main(...) }`), Kotlin allows functions directly at the top level of a `.kt` file — the compiler generates a synthetic class behind the scenes for JVM compatibility, but source code never needs to reference it.

## `val` vs. `var`

```kotlin
val name = "World"  // read-only reference -- cannot be reassigned, the default/idiomatic choice
var count = 0          // reassignable
count = 1               // fine
// name = "other"      // COMPILE ERROR: val cannot be reassigned
```

`val` is Kotlin's equivalent of Java's `final` local variable, but framed as the *default*, idiomatic choice rather than an opt-in modifier — Kotlin style strongly favors `val` over `var` wherever a value doesn't genuinely need to change.

## String Templates

```kotlin
println("Hello, $name!")            // simple variable interpolation
println("count + 1 = ${count + 1}")  // ${...} for arbitrary expressions
```

String templates (`$var` or `${expression}`) replace explicit string concatenation entirely — no `+` needed, similar to JavaScript/TypeScript's template literals or C#'s string interpolation, but using `$`/`${}` syntax instead of backticks or `$"..."`.

## Detailed Example

See [Example.kt](Example.kt) — a top-level `main` function demonstrating comments, `val`/`var`, and both string template forms.

## Run It

```bash
cd 01-Languages/Kotlin/02-Syntax
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints `Hello, World!`, `count + 1 = 1`, and `count is now 1`.

## Common Mistakes

- Trying to reassign a `val` — the compiler rejects this outright as a compile error, not a runtime exception; this is enforced statically, matching Rust's default immutability more than Java's opt-in `final`.
- Using string concatenation (`"Hello, " + name + "!"`) out of habit instead of a string template — functionally equivalent, but far less idiomatic Kotlin style.
- Assuming a `main` function needs a wrapping class, out of Java habit — it doesn't; Kotlin allows top-level functions directly.

## Best Practices

- Default to `val`; reach for `var` only when a variable genuinely needs to be reassigned after initialization.
- Use string templates (`$var`/`${expr}`) instead of concatenation for building strings with embedded values.

## Real-World Usage

Kotlin's top-level-function and `val`-by-default conventions are widely credited (alongside null safety, Lesson 03) for making Kotlin code noticeably more concise and less error-prone than equivalent Java code — a common, genuine motivation cited by teams migrating Android codebases from Java to Kotlin.

## Summary

- Kotlin allows top-level functions with no enclosing class, unlike Java.
- `val` (read-only, the idiomatic default) and `var` (reassignable) are enforced at compile time.
- String templates (`$var`/`${expr}`) replace string concatenation.

## Key Terms

- **`val`** — a read-only (single-assignment) reference, Kotlin's idiomatic default.
- **String template** — Kotlin's `$var`/`${expr}` syntax for embedding values directly into a string literal.

## Interview Questions

1. **What's the practical difference between `val` and `var` in Kotlin, and why does Kotlin style favor `val`?**
   `val` declares a read-only reference — it can be assigned once and never reassigned, enforced by the compiler as a hard error on any attempted reassignment. `var` declares a reassignable reference. Kotlin style favors `val` as the default because immutable-by-default references reduce a whole class of bugs around unexpected mutation, make code easier to reason about (a `val`'s value is guaranteed stable once assigned), and align with Kotlin's broader design philosophy of null safety and defensive-by-default programming (Lesson 03 extends this same philosophy to nullability).

2. **Why can Kotlin have a `main` function directly in a file with no enclosing class, when Java requires one?**
   The Kotlin compiler generates a synthetic class behind the scenes to hold top-level functions and properties, satisfying the JVM's requirement that all bytecode live inside some class — but this is entirely a compiler implementation detail invisible at the source level. Kotlin's design deliberately avoids forcing a class wrapper for code that doesn't conceptually need one (a `main` entry point, small utility functions), reducing the boilerplate present in equivalent Java code while still producing fully JVM-compatible bytecode underneath.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
