# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Understand and accept that **Haskell has no loops at all** — no `for`, no `while` — and why recursion plus higher-order functions genuinely replace them entirely, not just stylistically.
- Use `if`/`then`/`else` correctly as an **expression** (both branches mandatory, both must have the same type) rather than a statement.
- Use **guards** (`|`) as a cleaner alternative to chained `if`/`else if`.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept: Why There Are No Loops

Every other language in this repository has `for`/`while` because they have mutable variables to update on each iteration (a loop counter, an accumulator). Haskell has neither (Lesson 03) — there is genuinely nothing for a loop to mutate. This isn't an oversight; it's the direct consequence of immutability, and it's replaced by two mechanisms that don't need mutable state at all:

- **Recursion** — a function calls itself with a *new* set of arguments representing "the next step," rather than mutating a counter in place. Each call gets its own fresh, immutable bindings.
- **Higher-order functions** — `map`, `filter`, `foldr`/`foldl` (Lesson 12) express "do this to every element" / "keep only these" / "combine all these into one value" directly, without spelling out the underlying recursion by hand every time.

In practice, idiomatic Haskell code reaches for `map`/`filter`/`fold` (Lesson 12) far more often than hand-written recursion for everyday collection processing — but recursion is the more fundamental mechanism underneath, and is still written directly whenever a computation doesn't fit map/filter/fold's shape.

```haskell
-- "Loop" from 1 to n, summing -- no loop construct exists, so this is recursion:
sumTo :: Int -> Int
sumTo 0 = 0                      -- base case
sumTo n = n + sumTo (n - 1)      -- recursive case: "the next step," no mutation anywhere

-- The idiomatic higher-order-function equivalent (Lesson 12 covers this in depth):
sumToHOF :: Int -> Int
sumToHOF n = sum [1 .. n]
```

## `if`/`then`/`else` Is an Expression, Not a Statement

```haskell
-- BOTH branches are MANDATORY (no "if with no else"), and both must produce
-- the SAME type -- if is an expression that evaluates to a value, not a
-- control-flow statement that might optionally do nothing.
classify :: Int -> String
classify n = if n < 0 then "negative" else if n == 0 then "zero" else "positive"

-- Because it's an expression, it can be used anywhere a value is expected --
-- directly inside a function call's argument, for instance:
describe :: Int -> String
describe n = "Number is " ++ (if even n then "even" else "odd")
```

This contrasts directly with Rust's `if` (also an expression, verified in the Rust course) but even more sharply with C/Java/Python's `if` (a statement — `if x: y = 1` has no value of its own). Haskell's `if` is closer in spirit to Rust's than to C's, but stricter still: Rust allows an `if` with no `else` when the result is discarded (`()`); Haskell's `if` always requires both branches because it is *always* used as a value-producing expression.

## Guards — Cleaner Multi-Branch Logic

```haskell
bmiCategory :: Double -> String
bmiCategory bmi
  | bmi < 18.5 = "underweight"
  | bmi < 25.0 = "normal"
  | bmi < 30.0 = "overweight"
  | otherwise  = "obese"          -- `otherwise` is just `True` -- a catch-all, by convention
```

Guards read like a sequence of conditions checked top-to-bottom, the first `True` one wins — functionally a cleaner alternative to nested `if/else if/else if/.../else`, and (unlike a chained `if`) each condition's own boolean expression is visually distinct from the value it produces.

## Detailed Example

See [ControlFlow.hs](ControlFlow.hs).

## Verified Output

```bash
$ runghc ControlFlow.hs
sumTo 5 = 15
sumToHOF 5 = 15
sumTo 5 == sumToHOF 5: True
classify (-3) = negative
classify 0 = zero
classify 7 = positive
describe 4 = Number is even
describe 7 = Number is odd
bmiCategory 17.0 = underweight
bmiCategory 22.0 = normal
bmiCategory 27.0 = overweight
bmiCategory 35.0 = obese
```

## Common Mistakes

- **Writing `if` with no `else`**, out of C-family habit — a genuine compile error (`error: parse error` or a type error demanding a matching branch); every `if` needs both branches because it's always an expression.
- **Trying to write a `for`/`while` loop at all** — there is no such keyword; reach for recursion or (more idiomatically) `map`/`filter`/`fold` (Lesson 12) instead.
- **Forgetting `otherwise` in a guard chain** — without a final catch-all guard, a genuinely unmatched value causes a runtime "Non-exhaustive guards" error; `otherwise` (literally just `True`) is the conventional final guard, analogous to `_` in `case`/pattern matching.
- **Assuming recursion needs an explicit loop counter to track** — idiomatic recursive functions instead recurse on a *smaller version of the input itself* (e.g., `n - 1`, or the tail of a list) as the natural "progress" measure, with the base case (Lesson 06's pattern matching) stopping it.

## Best Practices

- Reach for `map`/`filter`/`fold` (Lesson 12) before hand-writing recursion for anything that's really "transform/select/combine over a collection" — it's shorter, and it directly signals intent rather than making a reader re-derive it from a recursive definition.
- Use guards instead of nested `if`/`else if` chains once you have more than two branches — it reads as a flat list of conditions rather than a pyramid of nesting.
- Always include `otherwise` as the final guard unless you've deliberately proven every case is covered another way (Lesson 06's exhaustive pattern matching is usually the better tool for "prove every case is handled").

## Real-World Usage

Recursion plus `map`/`filter`/`fold` is genuinely how all iteration is expressed in real Haskell code — there's no imperative escape hatch reached for "when recursion feels awkward" the way, say, JavaScript's `for` loop remains available even in a heavily functional-style codebase. Getting comfortable with this from the start is foundational to everything from Lesson 06 onward.

## Summary

- Haskell has no loops (`for`/`while`) at all — there is no mutable state for a loop to update, so recursion and higher-order functions (`map`/`filter`/`fold`) fully replace them.
- `if`/`then`/`else` is an expression: both branches are mandatory and must share a type; it can be used anywhere a value is expected.
- Guards (`|` ... `= ...`, ending in `otherwise`) are a cleaner alternative to chained `if`/`else if` for multi-branch logic.

## Key Terms

- **Recursion** — a function calling itself with new arguments representing progress toward a base case, Haskell's fundamental replacement for loops.
- **Guard** — a `|`-prefixed boolean condition attached to a function equation, checked top-to-bottom.
- **`otherwise`** — literally just `True`, used conventionally as a guard chain's catch-all final case.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Why does Haskell have no `for`/`while` loops, and what replaces them?**
   Loops in other languages rely on mutable state (a counter, an accumulator) updated on each pass — Haskell has no mutable variables in ordinary code (Lesson 03), so there's nothing for a loop construct to mutate. Recursion (a function calling itself with new arguments representing the next step) and higher-order functions (`map`/`filter`/`fold`, Lesson 12, which express common iteration patterns directly) together fully replace loops, with higher-order functions being the more commonly reached-for tool in everyday code.

2. **Why must every Haskell `if` have an `else`, unlike C or Python?**
   Because `if`/`then`/`else` is an expression that always produces a value, not a statement that might optionally do nothing. Both branches must exist and produce the same type, since the compiler must know what value the whole `if` expression has regardless of which branch runs — there's no notion of "skip and fall through" the way a statement-based `if` with no `else` allows.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
