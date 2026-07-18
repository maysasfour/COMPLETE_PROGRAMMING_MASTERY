# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Define functions via **pattern matching** across multiple equations, instead of a single body with internal `if`/`switch` dispatch.
- Understand and verify live that **every function in Haskell is curried by default** — a function of "two arguments" is really a function of one argument that returns a function of one argument.
- Write in **point-free style** — defining a function without ever naming its argument.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept: Pattern Matching in Function Definitions

Rather than one function body with an internal `if`/`case` dispatching on a parameter's shape, Haskell lets you write **multiple equations**, each matching a different pattern, tried top-to-bottom:

```haskell
describe :: Int -> String
describe 0 = "zero"                -- matches only the literal value 0
describe n | n < 0 = "negative"    -- guard attached to a pattern-matched equation
describe _ = "positive"            -- `_` is a wildcard, matches anything

-- Pattern matching also destructures data directly, not just literals:
firstOrDefault :: [Int] -> Int
firstOrDefault []      = 0          -- matches the empty list
firstOrDefault (x : _) = x          -- matches "at least one element," binds it to x
```

This is genuinely more expressive than Rust's `match` (which is an expression matched once, see the Rust course) — here, matching literally *is* how the function is defined, equation by equation, and the compiler can (and does, with `-Wincomplete-patterns`) warn if a case is missing.

## Currying — Verified Live

**Every Haskell function takes exactly one argument.** A function that looks like it takes two, `add :: Int -> Int -> Int`, is actually a function that takes one `Int` and returns *another function* (`Int -> Int`) which takes the second argument. This isn't a manual technique layered on top, like Python's `functools.partial` or JavaScript's hand-written curry helpers (both covered in [10-Functional-Programming](../../../10-Functional-Programming/05-Currying-and-Partial-Application/README.md)) — it's simply what `->` in a type signature means, all the way down, for every function, with zero opt-in required.

```haskell
add :: Int -> Int -> Int    -- really: Int -> (Int -> Int)
add x y = x + y

addFive :: Int -> Int
addFive = add 5             -- PARTIAL APPLICATION -- supply one argument, get a function back

result = addFive 3          -- 8
```

This is verified directly in [Functions.hs](Functions.hs), including confirming with `:t` in `ghci` that `add 5` genuinely has type `Int -> Int` — a real function value, not a special "curried" pseudo-value; you can pass it to `map`, store it, or call it later, exactly like any other function.

## Point-Free Style

"Point-free" means defining a function without explicitly naming its argument(s) — the function is built by composing/partially-applying other functions instead:

```haskell
-- With an explicit argument ("pointful"):
isPositive :: Int -> Bool
isPositive n = n > 0

-- Point-free -- no argument named at all, built from partial application of (>):
isPositive' :: Int -> Bool
isPositive' = (> 0)

-- Point-free composition (recap of Lesson 04's `.`):
isPositiveLength :: [a] -> Bool
isPositiveLength = isPositive' . length
```

## Detailed Example

See [Functions.hs](Functions.hs).

## Verified Output

```bash
$ runghc Functions.hs
describe 0 = zero
describe (-5) = negative
describe 7 = positive
firstOrDefault [] = 0
firstOrDefault [9,2,3] = 9
add 5 3 = 8
addFive 3 = 8
addFive is a real function value: True
isPositive' 5 = True
isPositive' (-5) = False
isPositiveLength [1,2,3] = True
```

```
$ ghci Functions.hs
ghci> :t add
add :: Int -> Int -> Int
ghci> :t add 5
add 5 :: Int -> Int
ghci> :t addFive
addFive :: Int -> Int
```

(`add 5 :: Int -> Int` is the direct, live proof of currying: applying `add` to only one argument doesn't error or need special syntax — it produces a genuine function value of type `Int -> Int`, which is exactly what `addFive` is bound to.)

## Common Mistakes

- **Forgetting a pattern-matching equation and hitting a real runtime crash** — an incomplete set of equations compiles with a warning (`-Wincomplete-patterns`) but crashes at runtime (`Non-exhaustive patterns`) the moment an unhandled shape is passed in; always compile with `-Wall` during development to catch this before runtime.
- **Assuming currying requires some special syntax** — beginners sometimes look for a `curry()` function equivalent to JavaScript's/Python's manual currying helpers; in Haskell there's nothing to opt into, `f :: a -> b -> c` already means "a function from `a` to (a function from `b` to `c`)."
- **Overusing point-free style until it's unreadable** — chaining many `.`/`$`/sections together with no named argument at all can become a genuine readability regression ("point-free golf"); prefer it only when it stays clearly readable.

## Best Practices

- Prefer multiple pattern-matched equations over one equation with an internal `if`/`case` when a function's behavior genuinely differs by the *shape* of its input (empty vs. non-empty list, zero vs. non-zero) — it documents each case as its own line.
- Take advantage of partial application deliberately: passing `add 5` (rather than `\x -> add 5 x`) directly to `map` is idiomatic, not merely possible.
- Reach for point-free style when it's genuinely clearer (`isEvenLength = even . length`), and back off to a named argument the moment point-free composition would require a reader to mentally "unwind" more than two or three functions.
- Always build with `-Wall -Wincomplete-patterns` during development to catch missing pattern-match cases before they become runtime crashes.

## Real-World Usage

Currying is what makes Haskell's function-composition-heavy style (Lessons 04, 12) work as smoothly as it does: partially applying a function is never a special case requiring extra syntax, so building small specialized functions out of general ones (`map (add 5)`, `filter (> 0)`) is exactly as natural as calling the general function directly.

## Summary

- Function definitions can pattern-match across multiple equations, tried top-to-bottom, directly destructuring the argument's shape (literal, `_` wildcard, list cons `(x:xs)`).
- Every Haskell function is curried by default: `a -> b -> c` really means `a -> (b -> c)`; partial application (supplying fewer arguments than the full arity) needs no special syntax and produces a genuine, reusable function value.
- Point-free style defines a function by composing/partially-applying other functions, with no argument named — useful when it stays readable, a regression when it doesn't.

## Key Terms

- **Pattern matching (in function definitions)** — defining a function as multiple equations, each matching a different input shape, tried top-to-bottom.
- **Currying** — every multi-argument function is really a chain of one-argument functions; `f :: a -> b -> c` is `a -> (b -> c)`.
- **Partial application** — supplying fewer arguments than a curried function's full arity, producing a new function awaiting the rest.
- **Point-free style** — defining a function without naming its argument(s), via composition/partial application.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What does it mean that "every function in Haskell is curried by default," and how is that different from `functools.partial` in Python?**
   A Haskell function typed `a -> b -> c` is really a one-argument function `a -> (b -> c)`: applying it to one argument returns a genuine function value of type `b -> c`, needing no special syntax. Python functions are not curried by default — `functools.partial(f, x)` is a manual, opt-in wrapper you construct explicitly to fix one argument; the underlying function itself still expects all its arguments in one call unless you build that wrapper. Haskell's version is a structural property of every function's type, not an extra step.

2. **What's the practical difference between defining a function with multiple pattern-matched equations versus one equation with an internal `if`/`case`?**
   Both can express the same logic, but multiple equations let each case be matched directly against the input's *shape* (a literal value, an empty vs. non-empty list, `_` as a wildcard) as part of the function's definition itself, and GHC can warn (`-Wincomplete-patterns`) if a shape is left unhandled. An internal `if`/`case` inside one equation works too, but doesn't get that same per-case exhaustiveness checking tied directly to the function's own equations.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
