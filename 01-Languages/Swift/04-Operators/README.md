# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift requires explicit numeric conversion between types (`Int`/`Double`) — no implicit widening, matching Rust and Kotlin's strictness, unlike C/Java/JavaScript's implicit numeric coercions.
- Use closed (`...`) vs. half-open (`..<`) ranges.
- Use `Equatable` for automatic, structural `==` on structs, and overload a custom operator.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Swift's arithmetic operators are unsurprising, but — like Rust and Kotlin, both covered earlier in this repository — Swift requires **explicit** conversion between numeric types; there is no implicit `Int`-to-`Double` widening the way C, Java, or JavaScript allow.

## No Implicit Numeric Conversion

```swift
let intValue: Int = 5
let doubleValue: Double = 2.5
// let sum = intValue + doubleValue // COMPILE ERROR: binary operator '+' cannot be applied
let sum = Double(intValue) + doubleValue // explicit conversion required
```

## Closed (`...`) vs. Half-Open (`..<`) Ranges

```swift
for i in 1...5 { }   // 1, 2, 3, 4, 5 -- INCLUDES the upper bound
for i in 1..<5 { }    // 1, 2, 3, 4    -- EXCLUDES the upper bound
stride(from: 1, through: 10, by: 3) // 1, 4, 7, 10
```

Swift's `...` (closed range) and `..<` (half-open range) are directly comparable to Kotlin's `..`/`until` (covered in this repository's Kotlin course), just with different operator symbols.

## `Equatable`: Automatic Structural Equality

```swift
struct Point: Equatable {
    let x: Int
    let y: Int
}
let p1 = Point(x: 1, y: 2)
let p2 = Point(x: 1, y: 2)
print(p1 == p2) // true -- Equatable auto-synthesizes memberwise structural equality
```

Declaring a struct conforms to `Equatable` (with all its stored properties themselves `Equatable`) lets the compiler auto-generate a memberwise `==` implementation — no manual code needed, similar in spirit to Kotlin's `data class` auto-generating `equals()` (covered in this repository's Kotlin course), though Swift requires the explicit `Equatable` conformance declaration rather than a dedicated `data class`-style keyword.

## Custom Operator Overloading

```swift
struct Vector2D {
    let x: Double
    let y: Double
    static func + (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
let v = Vector2D(x: 1, y: 2) + Vector2D(x: 3, y: 4)
```

Operator overloads are declared as `static func` inside (or as an extension of) the type, taking both operands as parameters — a genuinely different mechanism from Kotlin's `operator fun` member functions (covered in this repository's Kotlin course), though serving the same purpose.

## Detailed Example

See [Example.swift](Example.swift) — explicit numeric conversion, both range types, `stride`, `Equatable`-based structural equality, custom operator overloading via `Vector2D`, and logical operators.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `sum: 7.5`, `20`, `3`, `3.3333333333333335`, `1`, both range iterations (`1 2 3 4 5` and `1 2 3 4`), the stride sequence (`1 4 7 10`), `p1 == p2: true`, `v: (4.0, 6.0)`, and the three logical operator results.

## Common Mistakes

- Assuming `Int + Double` works directly, out of habit from languages with implicit numeric widening (C, Java, JavaScript) — Swift requires explicit `Double(intValue)` conversion.
- Confusing `...` (closed, includes upper bound) with `..<` (half-open, excludes upper bound) — a common source of off-by-one bugs when the wrong range operator is used.
- Forgetting a struct needs an explicit `Equatable` conformance declaration to get `==` — without it, comparing two struct instances with `==` is a compile error, not a default reference comparison.

## Best Practices

- Use `..<` for the common "iterate over indices 0 to count" pattern (avoiding an explicit `- 1`), and reserve `...` for genuinely inclusive ranges.
- Declare `Equatable` conformance on any struct that's naturally compared by value.
- Prefer Swift's built-in `Equatable`/`Comparable`/`Hashable` protocol conformances (often auto-synthesized) over hand-writing custom `==`/comparison logic.

## Real-World Usage

Swift's strict numeric-conversion requirement and its two distinct range operators are both commonly encountered on day one by developers new to the language — the "binary operator cannot be applied" numeric-type-mismatch error and off-by-one range mistakes are both frequently-cited early learning friction points in real Swift onboarding.

## Summary

- Swift requires explicit numeric type conversion — no implicit `Int`-to-`Double` widening, matching Rust/Kotlin's strictness.
- `...` is an inclusive (closed) range; `..<` excludes its upper bound (half-open) — directly comparable to Kotlin's `..`/`until`.
- `Equatable` conformance auto-synthesizes structural `==` for structs; custom operators are overloaded via `static func`.

## Key Terms

- **Half-open range (`..<`)** — a range excluding its upper bound.
- **`Equatable`** — a protocol conformance enabling `==`/`!=`, often auto-synthesized by the compiler for simple structs.

## Interview Questions

1. **Why does `let sum = intValue + doubleValue` fail to compile in Swift, and how is it fixed?**
   Swift, like Rust and Kotlin (both covered earlier in this repository), performs no implicit numeric type conversion — `Int` and `Double` are distinct types, and `+` has no overload accepting one of each directly. The fix is an explicit conversion: `Double(intValue) + doubleValue`, converting the `Int` to a `Double` first so both operands share the same type. This is a deliberate design choice trading a small amount of verbosity for eliminating an entire class of subtle precision-loss bugs that implicit numeric coercion (as in C or JavaScript) can silently introduce.

2. **What does declaring `Equatable` conformance on a Swift struct actually provide, and when is it auto-synthesized?**
   `Equatable` conformance provides `==` (and, by negation, `!=`) for a type. When every one of a struct's stored properties is itself `Equatable`, the Swift compiler automatically synthesizes a memberwise `==` implementation just from the `: Equatable` declaration — no manual code required, comparing each property in turn. This mirrors Kotlin's `data class` auto-generating `equals()` (covered in this repository's Kotlin course), though Swift requires the explicit protocol conformance annotation rather than a dedicated keyword, and the auto-synthesis only applies when all properties are themselves comparable this way — a struct containing a non-`Equatable` property would need a manually-written `==` instead.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
