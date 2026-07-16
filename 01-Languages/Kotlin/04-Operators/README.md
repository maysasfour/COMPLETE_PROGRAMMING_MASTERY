# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Understand that Kotlin's `==` performs **structural** equality by default (calls `.equals()`) — the opposite convention from Java, where `==` is referential and `.equals()` is structural.
- Use range operators (`..`, `until`, `downTo`, `step`) and operator overloading via `operator fun`.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Kotlin deliberately flips Java's equality convention: in Kotlin, `==` calls `.equals()` (structural/content equality) by default, and `===` is referential equality (same object instance) — the exact opposite of Java, where `==` is referential and `.equals()` must be called explicitly for content comparison. This is a genuinely important, easy-to-mix-up distinction for anyone coming from this repository's Java course.

## `==` (Structural) vs. `===` (Referential)

```kotlin
data class Person(val name: String)
val p1 = Person("Ada")
val p2 = Person("Ada")

p1 == p2   // true  -- structural: data class auto-generates a content-based equals()
p1 === p2  // false -- referential: two genuinely different object instances
```

Verified live: two separately-constructed `Person("Ada")` instances compare `true` with `==` (their `equals()` compares field content) but `false` with `===` (they're different objects in memory) — precisely the reverse of what `==`/`.equals()` mean in Java.

## A Genuine, Verified String-Interning Quirk

```kotlin
val a = "hello"
val b = "hel" + "lo"
println(a == b)   // true -- expected, structural equality
println(a === b) // true -- ALSO true! Compile-time constant folding interned both to the same object
```

Verified live: `a === b` printed `true`, not just `a == b`. This is because `"hel" + "lo"`, being a compile-time-constant expression, gets folded and interned by the compiler into the same string-pool object as the literal `"hello"` — the same JVM string-interning behavior covered in this repository's Java course (Lesson 04), inherited here since Kotlin compiles to the same bytecode and shares the JVM's string pool.

## Ranges

```kotlin
for (i in 1..5) { }        // inclusive range: 1, 2, 3, 4, 5
for (i in 1 until 5) { }     // exclusive of upper bound: 1, 2, 3, 4
for (i in 5 downTo 1) { }     // descending: 5, 4, 3, 2, 1
for (i in 1..10 step 3) { }    // step: 1, 4, 7, 10
```

## Operator Overloading via `operator fun`

```kotlin
data class Point(val x: Int, val y: Int) {
    operator fun plus(other: Point): Point = Point(x + other.x, y + other.y)
}
val sum = Point(1, 2) + Point(3, 4) // calls Point.plus() -- Point(x=4, y=6)
```

Kotlin allows overloading a fixed set of operators (`+`, `-`, `*`, `/`, `==`/`.equals()`, indexing `[]`, and more) by defining a specially-named function marked `operator` — a real, first-class feature contrasted with Go and Rust's differing operator-overloading conventions covered earlier in this repository.

## Detailed Example

See [Example.kt](Example.kt) — `kotlin.math.pow` for exponentiation, the live-verified `==`/`===` distinction (including the string-interning surprise), all four range forms, and operator overloading via a `Point` data class.

## Run It

```bash
cd 01-Languages/Kotlin/04-Operators
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints `1024.0` (2 to the 10th power), `true`/`true` (both `==` and `===` for the interned strings) then `true`/`false` (the `Person` data class's structural-vs-referential comparison), the four range demonstrations (`1 2 3 4 5`, `1 2 3 4`, `5 4 3 2 1`, `1 4 7 10`), `sum: Point(x=4, y=6)`, and `default: 0` (the Elvis operator fallback).

## Common Mistakes

- Assuming `==` in Kotlin behaves like Java's `==` (referential) — it's the opposite; Kotlin's `==` is structural (calls `.equals()`) by default, and `===` is the referential check, a genuinely important distinction for anyone with a Java background.
- Assuming `===` always reflects "different object literals mean different instances" — verified live that compile-time constant string folding can make `===` return `true` even for separately-written string expressions, due to JVM string interning.
- Forgetting the `operator` keyword when defining a function meant to overload an operator — without it, `fun plus(...)` is just a regular method named `plus`, not usable with `+` syntax.

## Best Practices

- Default to `==` for value comparison in Kotlin (matching its structural semantics) and reserve `===` specifically for the rare cases where object identity itself matters.
- Use `data class` for value-like types needing structural equality — it generates `equals()`/`hashCode()`/`toString()` automatically (Lesson 11 covers this in depth).
- Use range expressions (`..`, `until`, `downTo`, `step`) instead of manual index-counting loops wherever they express the intent more directly.

## Real-World Usage

The `==`-is-structural/`===`-is-referential convention is one of the most commonly cited "gotchas" for Java developers learning Kotlin specifically because it's the *inverse* of what they're used to — getting this backwards is a common, genuine source of confusion in code review and interview settings for developers transitioning between the two languages.

## Summary

- Kotlin's `==` is structural equality (calls `.equals()`) by default; `===` is referential equality — the opposite of Java's convention.
- Compile-time string constant folding can make `===` return `true` for two independently-written string expressions, verified live, mirroring the same JVM string-interning behavior from this repository's Java course.
- Range operators (`..`, `until`, `downTo`, `step`) and `operator fun`-based overloading are both first-class Kotlin features.

## Key Terms

- **Structural equality** — comparing two values by content (`.equals()`); Kotlin's `==` default.
- **Referential equality** — comparing two values by object identity (same memory reference); Kotlin's `===`.

## Interview Questions

1. **How does Kotlin's `==` operator differ from Java's `==`, and why does this matter for developers switching between the two languages?**
   In Kotlin, `==` calls `.equals()` automatically, performing structural (content-based) comparison by default; `===` is the referential (same-object-instance) check. In Java, it's reversed: `==` is referential comparison, and `.equals()` must be called explicitly for content comparison. This was verified directly: two separately-constructed `Person("Ada")` data class instances compared `true` with Kotlin's `==` (matching content) but `false` with `===` (different instances) — a developer applying Java's `==` intuition in Kotlin (or vice versa) would draw exactly the wrong conclusion about what's being compared.

2. **Why might two separately-written string expressions compare `true` with Kotlin's `===` (referential equality) even though they look like they'd produce different objects?**
   Because the JVM (which Kotlin compiles to, sharing this behavior with the Java course covered earlier in this repository) interns string literals and folds compile-time-constant string expressions into the same pooled object. This was verified directly: `"hello"` and `"hel" + "lo"` (a compile-time-constant concatenation) compared `true` under `===`, not just `==`, because the compiler recognized the concatenation as a constant expression and folded it to the identical interned string object — a genuine JVM-level optimization detail, not a Kotlin-specific behavior, and one worth being aware of before relying on `===` for string comparison at all (structural `==` is almost always what's actually intended for strings).

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
