# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else` as an expression producing a value directly, not just a statement.
- Use `when` (Kotlin's `switch` replacement): no fall-through, usable with arbitrary conditions (not just equality), and exhaustive when used with a `sealed class`.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Kotlin's `if`/`else` can be used as an **expression** — the whole construct evaluates to a value, assignable directly to a variable — a pattern shared with Rust's `if` (covered earlier in this repository) but not with Java's statement-only `if`. `when` replaces `switch` entirely: no fall-through, works with arbitrary boolean conditions (not just equality checks), and — when its subject is a `sealed class` hierarchy — is exhaustiveness-checked by the compiler, much like Rust's `match`.

## `if`/`else` as an Expression

```kotlin
val grade = if (score >= 90) "A" else if (score >= 80) "B" else "C or below"
```

## `when`: No Fall-Through, Works with Ranges/Conditions

```kotlin
val dayType = when (day) {
    1, 2, 3, 4, 5 -> "Weekday" // no break needed -- no fall-through at all
    6, 7 -> "Weekend"
    else -> "Invalid day"
}

val description = when { // subject-less `when`: each branch is its own boolean condition
    temp < 32 -> "freezing"
    temp in 32..60 -> "cold"
    temp in 61..80 -> "mild"
    else -> "hot"
}
```

## `when` with `sealed class`: Compiler-Verified Exhaustiveness

```kotlin
sealed class Shape
data class Circle(val radius: Double) : Shape()
data class Rectangle(val width: Double, val height: Double) : Shape()

fun area(shape: Shape): Double = when (shape) {
    is Circle -> Math.PI * shape.radius * shape.radius // smart-cast: shape treated as Circle here
    is Rectangle -> shape.width * shape.height
    // no `else` needed -- the compiler proves these are the ONLY possible Shape subtypes
}
```

`sealed class` restricts a class hierarchy to a fixed, known set of subtypes declared in the same file/module. A `when` expression over a sealed type doesn't need an `else` branch if every subtype is covered — and critically, the compiler *enforces* this: adding a new `Shape` subtype elsewhere would make this `when` fail to compile until updated, catching a whole class of "forgot to handle the new case" bugs at compile time. This directly mirrors Rust's exhaustive `match` over an `enum` (covered in this repository's Rust course), applied to Kotlin's class-hierarchy model instead of an algebraic data type.

## Detailed Example

See [Example.kt](Example.kt) — `if`/`else` as an expression, both forms of `when` (subject-based and subject-less), the sealed-class exhaustiveness demonstration, and loops.

## Practice

- [Exercises/Exercise.kt](Exercises/Exercise.kt) — implement FizzBuzz using a subject-less `when` expression.
- [Solutions/Solution.kt](Solutions/Solution.kt) — a worked solution, verified to produce the correct 1–15 FizzBuzz sequence.

## Run It

```bash
cd 01-Languages/Kotlin/05-Control-Flow
kotlinc Example.kt -include-runtime -d Example.jar && java -jar Example.jar
kotlinc Solutions/Solution.kt -include-runtime -d Solution.jar && java -jar Solution.jar
```

## Expected Output

`Example.kt` prints `grade: B`, `dayType: Weekday`, `description: mild`, both computed shape areas (`12.566370614359172` for the circle, `12.0` for the rectangle), and the loop/indexed-iteration output. `Solutions/Solution.kt` prints the standard FizzBuzz sequence for 1–15.

## Common Mistakes

- Writing `break` inside a `when` branch out of Java `switch` habit — it's unnecessary and not needed, since `when` never falls through.
- Forgetting `else` in a subject-based `when` over a *non-sealed* type — without exhaustiveness the compiler can prove, a missing `else` is a compile error when `when` is used as an expression (since every possible input must produce a value).
- Assuming any class hierarchy gets `sealed`-style compiler-enforced exhaustiveness automatically — only classes explicitly marked `sealed` get this; a regular open/abstract class hierarchy requires an explicit `else` branch, since the compiler can't know all possible subtypes.

## Best Practices

- Use `if`/`when` as expressions (assigning their result directly) rather than declaring a `var` and assigning it inside each branch — more concise and leverages Kotlin's expression-oriented design.
- Use `sealed class` for any fixed, closed set of related types (like `Shape` here) specifically to get compiler-enforced exhaustiveness in `when` expressions handling them.
- Prefer subject-less `when { condition -> ... }` over a long `if`/`else if` chain when checking multiple unrelated boolean conditions.

## Real-World Usage

`sealed class` plus exhaustive `when` is a widely-used, idiomatic Kotlin pattern for modeling state machines, UI states, and API result types (a `Result` sealed class with `Success`/`Error`/`Loading` subtypes is extremely common in real Android/Kotlin codebases) — the compiler's guarantee that every case is handled is considered one of Kotlin's most valuable correctness features for this kind of code.

## Summary

- `if`/`else` and `when` are both usable as expressions, producing a value directly.
- `when` replaces `switch` entirely: no fall-through, arbitrary boolean conditions, range checks (`in`), and type checks (`is`) with smart-casting.
- `sealed class` + exhaustive `when` gives compiler-enforced handling of every possible subtype, directly comparable to Rust's exhaustive `match` over an `enum`.

## Key Terms

- **Sealed class** — a class hierarchy with a fixed, compiler-known set of subtypes, enabling exhaustiveness checking in `when`.
- **Smart cast** — Kotlin's automatic narrowing of a variable's type within a branch after a type check (e.g., `is Circle`), with no explicit cast needed.

## Interview Questions

1. **How does Kotlin's `when` over a `sealed class` provide a guarantee that Java's `switch` (or even a plain Kotlin `when` over a non-sealed type) cannot?**
   Because a `sealed class` restricts its possible subtypes to a fixed, compiler-known set declared in the same file/module, a `when` expression checking `is SubtypeA -> ...`, `is SubtypeB -> ...` for every existing subtype doesn't need an `else` branch — and if a new subtype is added to the sealed hierarchy later, any `when` expression that doesn't handle it will fail to compile until updated. This gives a compile-time guarantee that every case is handled, directly comparable to Rust's exhaustive `match` over an `enum`, and is not something Java's `switch` (or a `when` over a regular open class hierarchy) can provide, since neither can prove the full set of possible subtypes exists.

2. **What does "smart casting" mean in the context of a `when (shape) { is Circle -> ... }` branch?**
   Inside a branch guarded by `is Circle`, the compiler automatically treats the checked variable (`shape`) as having the narrowed type `Circle` for the rest of that branch's scope, without requiring an explicit cast — accessing `shape.radius` directly works, even though `shape`'s declared type is the broader `Shape`. This is a compiler feature (not a runtime cast) available whenever the compiler can prove the checked variable can't change type between the check and its use, and is one of the conveniences that makes exhaustive `when`-over-sealed-classes ergonomic in practice.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
