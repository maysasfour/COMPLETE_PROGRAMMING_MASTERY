# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP and Traits](../11-OOP-and-Traits/README.md)

## Learning Objectives

- Treat functions as first-class values: store them, pass them, return them.
- Write and use higher-order functions (HOFs) — functions that take and/or return other functions.
- Use `map`/`filter`/`foldLeft` as the core building blocks of collection transformation.
- Compose functions with `andThen`/`compose`.

## Prerequisites

[11-OOP-and-Traits](../11-OOP-and-Traits/README.md)

## Concept

Scala is a hybrid object-oriented/functional language, and functions are genuinely first-class: a function is a value with a type (`Int => Int` is the type of "a function from `Int` to `Int`"), storable in a `val`, passable as an argument, and returnable from another function. This lesson covers the functional core already used informally in earlier lessons (`.map`, `.filter` on collections) and makes the underlying concepts — higher-order functions, folding, and composition — explicit.

## Functions as First-Class Values

```scala
val square: Int => Int = x => x * x
val functions: List[Int => Int] = List(square, (x: Int) => x + 1, (x: Int) => -x)
functions.map(f => f(5))   // call each stored function
```

## Higher-Order Functions

```scala
def applyTwice(f: Int => Int, x: Int): Int = f(f(x))   // takes a function as a parameter

def multiplier(factor: Int): Int => Int = x => x * factor  // RETURNS a function (a closure over `factor`)
val triple = multiplier(3)
triple(7)  // 21
```

`multiplier` returns a *closure* — the returned function retains access to `factor` even after `multiplier` itself has returned.

## `map` / `filter` / `foldLeft`

```scala
val nums = List(1, 2, 3, 4, 5)
nums.map(_ * 2)            // transform every element
nums.filter(_ % 2 == 0)     // keep elements matching a predicate
nums.foldLeft(0)(_ + _)     // combine all elements into a single value, left to right
```

`foldLeft` is the most general of the three: `map` and `filter` can both be expressed in terms of it, though idiomatic code uses whichever combinator most directly states the intent.

## Function Composition

```scala
val addOne: Int => Int = _ + 1
val timesTwo: Int => Int = _ * 2
addOne andThen timesTwo   // left to right: addOne first, THEN timesTwo
addOne compose timesTwo   // right to left: timesTwo first, then addOne
```

## Detailed Example

See [FunctionalConcepts.scala](FunctionalConcepts.scala) — functions stored in a list and invoked, a higher-order function taking a function parameter, one returning a closure, `map`/`filter`/`foldLeft` over a list of numbers, and both composition directions with their differing results made explicit.

## Run It

```bash
cd 01-Languages/Scala/12-Functional-Concepts
scalac FunctionalConcepts.scala
scala run . --main-class functionalConceptsDemo
```

## Expected Output

```
--- functions as first-class values ---
List(25, 6, -5)

--- higher-order functions: taking/returning functions ---
applyTwice(square, 3) = 81
triple(7) = 21

--- map / filter / fold ---
nums     = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
doubled  = List(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)
evens    = List(2, 4, 6, 8, 10)
sum      = 55
product  = 3628800

--- function composition ---
(addOne andThen timesTwo)(5) = 12
(addOne compose timesTwo)(5) = 11
```

## Common Mistakes

- Confusing `andThen` and `compose` order — `f andThen g` runs `f` first, `g` second; `f compose g` runs `g` first, `f` second. Verified live above: the same two functions produce `12` one way and `11` the other.
- Overusing `foldLeft` for cases `map`/`filter` express more clearly — technically equivalent, but less readable and more error-prone to get the accumulator logic right.
- Forgetting that a closure captures a *reference* to its enclosing variables, not a frozen snapshot — relevant when the captured variable is mutable (`var`), which idiomatic Scala avoids for exactly this reason.

## Best Practices

- Prefer the most specific combinator (`map`, `filter`, `exists`, `find`) over a general `foldLeft` when it expresses the intent directly.
- Keep functions small and composable — build complex behavior by combining simple functions (`andThen`/`compose`) rather than writing one large function.
- Favor pure functions (no side effects, same input always produces same output) wherever possible; they compose predictably and are trivially testable.

## Real-World Usage

Data-processing pipelines (Spark, Scala's own collections) are built almost entirely from chained higher-order functions — `.filter(...).map(...).groupBy(...)` — expressing a transformation pipeline declaratively instead of as an imperative loop with mutable accumulators.

## Summary

- Functions are first-class values in Scala: storable, passable, returnable, with real types like `Int => Int`.
- Higher-order functions take and/or return functions; a returned function that closes over outer variables is a closure.
- `map`/`filter`/`foldLeft` are the core collection-transformation combinators, verified with real output above.
- `andThen`/`compose` combine functions in opposite orders — confirmed to produce different results on the same inputs.

## Key Terms

- **Higher-order function** — a function that takes another function as a parameter, returns one, or both.
- **Closure** — a function value that captures (closes over) variables from its enclosing scope.
- **`foldLeft`** — reduces a collection to a single value by combining elements left to right with an accumulator.

## Interview Questions

1. **What is a closure, and how was one demonstrated in this lesson?** — A closure is a function value that retains access to variables from the scope it was defined in, even after that scope has returned. `multiplier(factor: Int): Int => Int` returns `x => x * factor`; the returned function is a closure over `factor`, and calling `multiplier(3)` then invoking the result on different inputs (`triple(7) = 21`) confirmed `factor = 3` was retained inside the returned function.
2. **What's the difference between `andThen` and `compose`, verified with actual output?** — `f andThen g` applies `f` first and `g` second (left to right); `f compose g` applies `g` first and `f` second (right to left) — the reverse order. This was verified directly: with `addOne` and `timesTwo`, `addOne andThen timesTwo` applied to `5` produced `12` (`(5+1)*2`), while `addOne compose timesTwo` applied to the same `5` produced `11` (`(5*2)+1`) — same functions, same input, different order, different (and correctly predicted) results.

## Recommended Next Lesson

[13 — Generics and Type System](../13-Generics-and-Type-System/README.md)
