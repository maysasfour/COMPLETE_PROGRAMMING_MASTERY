# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand Kotlin's central, defining feature: **null safety baked into the type system** — `String` vs. `String?` are genuinely different types, checked at compile time.
- Use the safe call operator (`?.`), the Elvis operator (`?:`), and the non-null assertion (`!!`).
- Distinguish `const val` (compile-time constant) from `val` (runtime-assigned, single-assignment).

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Kotlin's single most distinctive feature — and its most commonly cited reason for adoption over Java — is **null safety enforced by the type system itself**. `String` and `String?` are different types: a plain `String` can *never* hold `null` (enforced by the compiler, not a runtime check), while `String?` explicitly allows `null` and requires the code to handle that possibility before using it as a non-null value. This is conceptually similar to Rust's `Option<T>` (also covered in this repository), but expressed as a type modifier (`?`) rather than a wrapping generic type, and specifically targeting the elimination of Java's notorious `NullPointerException`.

## `String` vs. `String?`: A Genuine, Compiler-Enforced Distinction

```kotlin
val nonNullable: String = "always has a value"
val nullable: String? = null // the ? makes this type EXPLICITLY nullable
```

Verified live: attempting `nonNullable = null` (reassigning a non-nullable `val`/`var` to `null`) produces a real compile error:

```
error: null cannot be a value of a non-null type 'String'.
```

This is caught by the compiler, before the program ever runs — genuinely different from Java, where any reference type can hold `null` and a `NullPointerException` is a runtime surprise.

## Safe Call (`?.`), Elvis (`?:`), and Non-Null Assertion (`!!`)

```kotlin
val length: Int? = nullable?.length     // ?. -- returns null instead of throwing if nullable IS null
val safeLength = nullable?.length ?: -1  // ?: -- Elvis operator, a default if the left side is null

val definitelyNotNull: String? = "trust me"
println(definitelyNotNull!!.uppercase())  // !! -- asserts non-null; throws NPE if actually null
```

`?.` (safe call) short-circuits to `null` instead of throwing when called on a `null` receiver — the direct analogue of PHP's `?->` and C#'s `?.`, both covered elsewhere in this repository. `?:` (the Elvis operator) supplies a default value when the left-hand expression is `null`. `!!` (non-null assertion) tells the compiler "trust me, this is not null" and throws a genuine `NullPointerException` at runtime if that trust turns out to be misplaced — it's the one place Kotlin's null safety can still be circumvented, and idiomatic Kotlin uses it sparingly.

## `const val` vs. `val`

```kotlin
const val MAX_SIZE = 100 // compile-time constant; must be top-level or in a companion object
val name = "Ada"           // runtime-assigned, single-assignment (Lesson 02)
```

## Detailed Example

See [Example.kt](Example.kt) — basic types, type inference, the full null-safety operator set (`?.`, `?:`, `!!`), and `const val`, all run and verified.

## Run It

```bash
cd 01-Languages/Kotlin/03-Variables-and-Data-Types
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints the basic type values, confirms `inferred` is statically typed as `Int`, shows `nullable: null`, `length of a null string: null` (from the safe call), `length of a non-null string: 18`, `safe length with default: -1` (the Elvis operator's fallback), `TRUST ME` (the non-null-asserted, uppercased string), and `MAX_SIZE: 100`.

## Common Mistakes

- Assuming any variable can hold `null` "just in case," out of Java habit — Kotlin requires an explicit `?` on the type for this, and a plain `String`/`Int`/etc. genuinely cannot hold `null`, enforced at compile time (verified live in this lesson).
- Overusing `!!` to silence a compiler complaint about nullability without actually verifying the value can't be null — this reintroduces exactly the runtime `NullPointerException` risk Kotlin's type system is designed to eliminate, just deferred to a specific, marked location instead of anywhere in the code.
- Forgetting `?.` short-circuits the *entire* chain to `null` — `a?.b?.c` returns `null` immediately if `a` is `null`, without attempting `.b` or `.c` at all.

## Best Practices

- Prefer non-nullable types (`String`, `Int`, etc.) by default; only mark a type nullable (`String?`) when `null` is a genuinely meaningful, expected value.
- Use `?:` (Elvis) to provide sensible defaults instead of `!!` wherever a reasonable fallback value exists.
- Reserve `!!` for cases with a genuine, provable invariant that the value cannot be null at that point — and treat any use of it as a candidate for later refactoring toward a safer pattern.

## Real-World Usage

Kotlin's null safety is one of its most heavily marketed and genuinely impactful features for reducing production `NullPointerException`s in real Android and backend applications — teams migrating from Java to Kotlin frequently cite a measurable drop in NPE-related crash reports specifically because the type system now catches many of these mistakes at compile time instead of in production.

## Summary

- `String` and `String?` are genuinely different, compiler-distinguished types — non-nullable types can never hold `null`, verified live via a real compile error.
- `?.` (safe call), `?:` (Elvis, default value), and `!!` (non-null assertion, can still throw) are the core null-handling operators.
- `const val` is a compile-time constant; `val` is a runtime-assigned, single-assignment reference.

## Key Terms

- **Nullable type (`String?`)** — a type explicitly allowing `null`, distinct from its non-nullable counterpart (`String`) at the type-system level.
- **Elvis operator (`?:`)** — supplies a default value when its left operand is `null`.

## Interview Questions

1. **How does Kotlin's null safety actually prevent `NullPointerException`s, compared to Java?**
   Kotlin's type system distinguishes nullable (`String?`) from non-nullable (`String`) types at compile time — a non-nullable type can never be assigned or hold `null`, verified directly in this lesson (attempting to do so produces the compile error "null cannot be a value of a non-null type"). Any value that might legitimately be `null` must be explicitly typed as nullable, and the compiler then *requires* that possibility be handled (via `?.`, `?:`, an explicit null check, or the escape-hatch `!!`) before the value can be used as if it were guaranteed non-null. Java, in contrast, allows any reference type to hold `null` with no type-level distinction, meaning a `NullPointerException` can occur at any point a null-check was forgotten — a purely runtime discovery, not a compile-time one.

2. **What does `!!` do, and why is it considered something to use sparingly?**
   `!!` (the non-null assertion operator) tells the compiler to treat a nullable value as definitely non-null at that point, allowing it to be used without further null-handling — but if the value actually is `null` at runtime, `!!` throws a genuine `NullPointerException`, reintroducing exactly the failure mode Kotlin's null safety is designed to prevent. It's considered a deliberate escape hatch, appropriate only when there's a genuine, provable guarantee the value can't be null at that point (e.g., validated earlier in the same function) — overusing it defeats the purpose of Kotlin's compile-time null checking by deferring the risk back to runtime.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
