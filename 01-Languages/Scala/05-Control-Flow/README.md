# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else` as a value-producing expression, not just a statement.
- Use `match` for pattern matching, including type patterns, guards, and case-class deconstruction.
- Use `for` loops/comprehensions, including `yield`.

## Concept

`if`/`else` in Scala always produces a value — there is no separate ternary operator because `if` already is one. `match` is Scala's pattern-matching construct, considerably more powerful than Java's `switch` or a chain of `if`/`else if`: it can match on type, deconstruct case classes/tuples/lists, and apply guard conditions, similar in spirit to Rust's `match` or Kotlin's `when`, though Scala's supports deeper structural deconstruction than Kotlin's `when`.

## `if` as an Expression

```scala
val category = if (n > 0) "positive" else if (n < 0) "negative" else "zero"
```

## `match` — Pattern Matching

```scala
def describe(x: Any): String = x match {
  case 0 => "zero"
  case n: Int if n > 0 => s"positive int $n"
  case s: String => s"a string of length ${s.length}"
  case (a, b) => s"a pair: $a, $b"
  case _ => "something else"
}
```

Compared to **Rust's** `match` (which requires exhaustiveness on closed enums, similar to Scala's `match` on `sealed` hierarchies) and **Kotlin's** `when` (which supports type/range/guard matching but not structural deconstruction of arbitrary data), Scala's `match` uniquely combines type patterns, guards, and deep destructuring (case classes, tuples, `List` via `::`) in one construct.

## `for` Loops and Comprehensions

```scala
for (i <- 1 to 3) println(i)                 // loop, side effects only
val squares = for (i <- 1 to 3) yield i * i    // comprehension, produces a collection
```

## Detailed Example

See [ControlFlow.scala](ControlFlow.scala).

## Run It

```bash
cd 01-Languages/Scala/05-Control-Flow
scalac ControlFlow.scala
scala run . --main-class controlFlowDemo
```

## Expected Output

```
if-expression: 5 is positive
match: 0 -> zero
match: 7 -> positive int 7
match: hi -> a string of length 2
match: (1,2) -> a pair: 1, 2
match: 3.14 -> something else
for loop: 1 2 3
for-yield squares: List(1, 4, 9)
```

## Common Mistakes

- Forgetting a `match` on an open type (like `Int` or `String`) is not automatically exhaustive-checked — always include a wildcard `case _` unless matching a `sealed` hierarchy, where the compiler does warn on missing cases.
- Using `for` purely for side effects but forgetting `yield` is required to actually build a resulting collection.
- Confusing Scala's `match` guard syntax (`case n if n > 0 =>`) with a nested `if` inside the case body — the guard is evaluated as part of pattern selection, before the case body ever runs.

## Best Practices

- Prefer `match` over long `if`/`else if` chains once there are more than two or three branches, or whenever deconstruction is useful.
- Match on `sealed trait`/`sealed abstract class` hierarchies (Lesson 11/13) to get compiler-enforced exhaustiveness checking.

## Real-World Usage

Pattern matching over sealed hierarchies (algebraic data types) is central to idiomatic Scala domain modeling — e.g., modeling an API response as `sealed trait Result; case class Success(...); case class Failure(...)` and exhaustively `match`-ing over it, catching missing-case bugs at compile time.

## Exercises / Solutions

See [Exercises/](Exercises/) and [Solutions/](Solutions/) for hands-on practice with `if`, `match`, and `for`.

## Summary

- `if`/`else` and `match` are both expressions producing values in Scala.
- `match` supports type patterns, guards, and structural deconstruction — richer than Java's `switch` or Kotlin's `when`.
- `for ... yield` builds a new collection; a plain `for` loop is for side effects only.

## Key Terms

- **Pattern matching** — deconstructing/branching on a value's shape and type via `match`.
- **`for`-comprehension** — a `for ... yield` expression producing a transformed collection.

## Interview Questions

1. **How does Scala's `match` compare to Java's `switch`?** — `match` supports type-based patterns, guard conditions, and structural deconstruction of tuples/case classes/lists, and is compiler-checked for exhaustiveness on `sealed` hierarchies; Java's classic `switch` only compares discrete values (primitives, `String`, `enum`) with no deconstruction (Java's newer pattern-matching `switch` closes some of this gap but arrived long after Scala's).
2. **What's the difference between a `for` loop and a `for`-comprehension in Scala?** — Both share the same `for (x <- collection) ...` syntax; adding `yield` turns it into a comprehension that builds and returns a new collection of the yielded values, while a `for` loop without `yield` runs purely for side effects and evaluates to `Unit`.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
