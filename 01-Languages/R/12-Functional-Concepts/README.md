# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP Systems](../11-OOP-Systems/README.md)

## Beginner: R Is Genuinely Functional Under the Hood

Functions are first-class values in R (Lesson 06 already showed this) — they can be assigned, passed as arguments, and returned from other functions. The "apply family" (`sapply`, `lapply`, `vapply`, `Map`, `Reduce`) is R's idiomatic functional toolkit, generally preferred over hand-rolled loops for transforming data (Lesson 06/14).

## Beginner: Anonymous Functions

```r
squares <- sapply(1:5, function(x) x^2)   # traditional anonymous function syntax
print(squares)   # 1 4 9 16 25
```

R 4.1+ added a **shorthand lambda syntax**, `\(x) ...`, equivalent to `function(x) ...` but more concise:

```r
squares2 <- sapply(1:5, \(x) x^2)   # identical result, shorter syntax
```

This course was verified against **R 4.6.1**, so `\(x)` works throughout; if you're on R older than 4.1, use the full `function(x)` form instead.

## Intermediate: `sapply` / `lapply` / `vapply`

```r
lapply(1:3, \(x) x * 10)     # always returns a list: list(10, 20, 30)
sapply(1:3, \(x) x * 10)     # simplifies to a vector when possible: 10 20 30
vapply(1:3, \(x) x * 10, numeric(1))  # like sapply, but you declare the expected output type/shape
```

`vapply` requires you to specify the expected return type (`numeric(1)` means "a single number per call"), and **errors immediately** if any call doesn't match that shape — this makes it safer than `sapply` in code where an unexpected return shape would otherwise silently produce a confusing result (e.g. a list instead of a vector, if one element didn't simplify).

## Intermediate: `Map` and `Reduce`

```r
Map(\(x, y) x + y, c(1, 2, 3), c(10, 20, 30))   # applies a function over PARALLEL vectors, returns a list

Reduce(\(acc, x) acc + x, c(1, 2, 3, 4))         # 10 - folds/accumulates left to right
Reduce(\(acc, x) acc + x, c(1, 2, 3, 4), accumulate = TRUE)  # 1 3 6 10 - shows every intermediate step
```

`Map` is R's equivalent of Python's `map()` but over *multiple* parallel vectors at once (like Python's `map(f, xs, ys)`); `Reduce` is R's `functools.reduce` equivalent.

## Advanced: Closures

A closure is a function that "remembers" the environment it was created in, letting it retain private state between calls:

```r
make_counter <- function() {
  count <- 0
  function() {
    count <<- count + 1   # <<- modifies `count` in the ENCLOSING (make_counter's) environment, not a new local one
    count
  }
}

counter <- make_counter()
counter()   # 1
counter()   # 2 - state persisted between calls, because the closure holds onto its own `count`
```

`<<-` (superassignment, previewed in Lesson 02) is what makes this work: a plain `<-` inside the inner function would create a *new* local `count` each call, forgetting the previous value; `<<-` reaches up into the enclosing environment where `count` actually lives.

## Real-World Usage

- `sapply`/`lapply`/`vapply` are the default way to apply a per-element transformation across a list/vector in idiomatic R, especially when a fully vectorized expression isn't available (e.g., calling a function from a package that only handles one input at a time).
- Closures underlie memoization, custom random-number generators with fixed state, and callback-style code (e.g., building a function on the fly that "remembers" a configuration passed in earlier).

## Summary

- R functions are first-class; `\(x) ...` (R 4.1+) is shorthand for `function(x) ...`.
- `lapply` always returns a list; `sapply` simplifies to a vector/matrix when possible; `vapply` requires declaring the expected output shape and errors if violated, making it the safest of the three.
- `Map` applies a function over parallel vectors; `Reduce` folds/accumulates a vector into a single value (or a step-by-step vector, with `accumulate = TRUE`).
- Closures retain access to their creating environment; `<<-` (superassignment) is what lets an inner function mutate a variable in that enclosing environment rather than creating a fresh local one.

## Key Terms

- **`\(x) ...`** — R 4.1+ shorthand lambda syntax, equivalent to `function(x) ...`.
- **`vapply`** — like `sapply` but requires declaring the expected return type/shape; errors on mismatch instead of silently returning something unexpected.
- **`Map`** — applies a function across parallel vectors, returning a list.
- **`Reduce`** — folds a vector to a single accumulated value (or every intermediate step, with `accumulate = TRUE`).
- **Closure** — a function bundled with the environment it was defined in, letting it retain private state across calls.
- **`<<-`** — superassignment; assigns in an enclosing scope rather than creating a new local variable.

## Common Mistakes

- Using `sapply` where the result shape can vary between calls (producing an inconsistent list instead of a clean vector) instead of the safer, shape-checked `vapply`.
- Using `<-` instead of `<<-` inside a closure's inner function, silently creating a fresh local variable each call instead of mutating the shared enclosing one — the "counter" then never advances past 1.
- Forgetting `\(x)` is R 4.1+ only — code using it will fail on older R installations.

## Best Practices

- Prefer `vapply` over `sapply` in library/production code where a wrong return shape would cause a hard-to-trace downstream bug.
- Reach for closures when you need small amounts of private, persistent state (a counter, a cache) without building a full class.
- Use `Reduce(..., accumulate = TRUE)` when you want to inspect every intermediate step of a fold, not just the final result, while debugging.

## Interview Questions

1. **What's the difference between `sapply` and `vapply`?**
   Both apply a function element-wise and try to simplify the result, but `vapply` requires you to declare the expected output type/length up front and errors immediately if a call doesn't match — `sapply` will just silently produce a different (often less useful) shape in that case.

2. **What does `Reduce` do?**
   It folds a vector into a single accumulated value by repeatedly applying a two-argument function to an accumulator and the next element, left to right (equivalent to Python's `functools.reduce`); passing `accumulate = TRUE` returns every intermediate step instead of just the final value.

3. **How do closures retain state between calls in R, and why is `<<-` necessary?**
   A closure keeps a reference to the environment it was created in. A plain `<-` inside the inner function would create a brand-new local variable on every call, discarding previous state; `<<-` instead reaches up into that enclosing environment and mutates the variable that actually persists across calls.

## Suggested Next Lesson

[13 — No Generics](../13-No-Generics/README.md)
