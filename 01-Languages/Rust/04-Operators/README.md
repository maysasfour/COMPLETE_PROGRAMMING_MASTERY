# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators.
- Understand Rust has **no null** — `Option<T>` is the alternative, and there is no implicit numeric type conversion.
- Understand integer overflow behavior differs between debug and release builds.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Rust's arithmetic/comparison/logical operators are C-family familiar, but two design choices stand out among this repository's languages: **Rust has no `null`/`nil` at all** — the type system uses `Option<T>` (`Some(value)` or `None`) to represent "might not have a value," making the absence of a value visible in the type signature and checked by the compiler (Lesson 09 covers this in depth). And Rust has **no implicit numeric type conversions** — even `i32` to `i64` requires an explicit `as` cast or `.into()`, unlike most languages that silently widen smaller types.

## Arithmetic, Comparison, Logical

```rust
let a = 5;
let b = 10;
println!("{} {} {} {}", a + b, a == b, a < b, a > 0 && b > 0);
```

## No Null — `Option<T>` Instead

```rust
let some_number: Option<i32> = Some(5);
let no_number: Option<i32> = None;

// A raw `Option<i32>` cannot be used as if it were an i32 directly -- must be unwrapped/matched:
match some_number {
    Some(n) => println!("Got a number: {}", n),
    None => println!("No number"),
}
```

Since there is no null value that can be silently substituted for any type, Rust eliminates an entire category of "null reference" bugs at the type-system level — you cannot forget to check for "no value" the way you can in a language where any reference might silently be null; the compiler forces the check via `Option<T>`'s API.

## No Implicit Numeric Conversion

```rust
let x: i32 = 5;
let y: i64 = 10;
// let sum = x + y; // COMPILE ERROR: mismatched types (i32 vs i64)
let sum = x as i64 + y; // explicit cast required
println!("{}", sum);
```

## Integer Overflow: Debug vs. Release

```rust
let x: u8 = 255;
// In a DEBUG build, `x + 1` PANICS at runtime (overflow check enabled)
// In a RELEASE build, `x + 1` silently WRAPS to 0 (overflow checks disabled for performance)
let y = x.wrapping_add(1); // explicit, intentional wrapping -- works the same in both build types
println!("{}", y); // 0
```

This debug/release discrepancy is a genuine, documented Rust behavior worth knowing — code that "works" in a release build might have silently wrapped an overflow that a debug build would have caught as a panic. Using explicit `wrapping_add`/`checked_add`/`saturating_add` methods (rather than relying on the ambient overflow-checking behavior) makes overflow handling intentional and consistent across build types.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints arithmetic/comparison results, `Option<T>` pattern matching for both `Some` and `None`, and explicit wrapping-add behavior for an intentional overflow.

## Common Mistakes

- Expecting `null` to exist — it doesn't; use `Option<T>` and handle both `Some`/`None` cases.
- Expecting implicit numeric widening (like `i32` to `i64`) the way many other languages allow — Rust requires an explicit `as` cast or `.into()`/`.try_into()`.
- Relying on debug-build overflow panics as a substitute for actually handling overflow, then being surprised when a release build silently wraps instead.

## Best Practices

- Use `Option<T>` (and `Result<T, E>`, Lesson 09) to make "might not have a value"/"might fail" explicit in a function's signature, rather than any null-like sentinel.
- Use explicit `checked_add`/`wrapping_add`/`saturating_add` when overflow is a real possibility you need to handle deliberately, rather than relying on ambient debug/release differences.

## Real-World Usage

The complete absence of `null` is one of Rust's most-cited safety advantages over languages like Java/C#/C++ (where `NullPointerException`/`NullReferenceException`/null-pointer-dereference crashes are extremely common) — every place a value might be absent is visible and enforced in the type system via `Option<T>`.

## Summary

- Rust has no `null`; `Option<T>` (`Some`/`None`) represents "might not have a value," checked by the compiler.
- No implicit numeric type conversions — an explicit `as` cast or `.into()` is always required.
- Integer overflow panics in debug builds but silently wraps in release builds by default; explicit `wrapping_add`/`checked_add`/`saturating_add` make behavior intentional and consistent.

## Key Terms

- **`Option<T>`** — Rust's type-safe alternative to null, representing a value that might be `Some(T)` or `None`.
- **Overflow checking (debug vs. release)** — Rust panics on integer overflow in debug builds but wraps silently in release builds by default.

## Interview Questions

1. **Why doesn't Rust have `null`, and what does it use instead?**
   `null`/`nil` references are one of the most common sources of runtime crashes in other languages (`NullPointerException`, segfaults from null pointer dereferences) precisely because a variable's type doesn't reveal whether it might be null. Rust eliminates this by having no null at all — `Option<T>` explicitly represents "might not have a value" in the type system itself, and the compiler forces you to handle both the `Some(T)` and `None` cases (via pattern matching or `Option`'s API) before you can access the inner value.

2. **What happens on integer overflow in Rust, and why does it differ between debug and release builds?**
   In a debug build, arithmetic overflow triggers a runtime panic, catching the bug loudly during development/testing. In a release build, overflow checks are disabled by default for performance, and overflow instead wraps silently (e.g., `255u8 + 1` becomes `0`). This is a deliberate trade-off — the checks have a real runtime cost, acceptable during development but not always desired in optimized production builds — and is exactly why explicit methods like `checked_add`/`wrapping_add`/`saturating_add` exist, to make overflow-handling behavior consistent and intentional regardless of build type.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
