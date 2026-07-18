# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand that Haskell has **no mutable variables at all** in ordinary code — `let`/`where`/top-level bindings are all permanent, one-time name-to-value associations, not reassignable "variables" in the C/Python sense.
- Read and write type annotations with `::`.
- Use Haskell's core primitive types: `Int`, `Integer`, `Double`, `Char`, `Bool`.
- Understand type inference: GHC infers most types without annotations, but this course annotates top-level bindings anyway for clarity (following Lesson 01's convention).

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

This is the single biggest mental shift coming from almost any other language in this repository, including Rust (which at least has `mut`). **There is no `var` in Haskell. There is no reassignment.** `let x = 5` doesn't create a mutable slot you can later set to `6` — it's a permanent binding of the name `x` to the value `5` within its scope, full stop. Rust's `let` is immutable *by default* but escapes into mutability with `mut`; Haskell's `let` has no mutability escape hatch in ordinary code at all.

This isn't a missing feature — it's the foundation the entire language is built on. Referential transparency (an expression always evaluates to the same value, everywhere, forever) is what makes equational reasoning, safe laziness (Lesson 14), and safe concurrency all work. A "variable" that could change value out from under you would break every one of those guarantees.

(Haskell *does* have genuinely mutable references — `IORef`, `MVar`, `STRef` — for the narrow cases where controlled mutation is truly needed, always inside `IO` or `ST`, always visible in the type. These are advanced escape hatches covered only briefly in Lesson 14, not the default way of programming.)

## No `var`, Only `let` — Verified Live

```haskell
main :: IO ()
main = do
    let x = 5
    print x
    -- let x = 6      -- this does NOT reassign x -- it SHADOWS it with a new binding
    print x            -- x is still 5 in the ORIGINAL binding's scope
```

Rebinding the same name with a second `let` doesn't mutate the first `x` — it introduces a brand-new binding that shadows the old one for the rest of that scope. The original `x` was never touched; nothing pointing at it could ever observe a change, because nothing can change it.

## Type Annotations with `::`

```haskell
age :: Int
age = 30

pi_approx :: Double
pi_approx = 3.14159

initial :: Char
initial = 'A'

isReady :: Bool
isReady = True
```

## `Int` vs. `Integer`

```haskell
smallNum :: Int       -- fixed-width (platform word size, typically 64-bit) -- CAN overflow/wrap
bigNum   :: Integer   -- arbitrary-precision -- grows as large as memory allows, never overflows
```

`Int` is analogous to a fixed-width integer in most other languages here (Rust's `i64`, Java's `long`); `Integer` is Haskell's arbitrary-precision type, closer to Python's built-in `int` — genuinely unbounded, at the cost of being slower for everyday small arithmetic.

## Type Inference

```haskell
-- GHC infers this is `Integer` (its numeric-literal default) with no annotation:
inferred = 42

-- This course annotates top-level bindings anyway, per Lesson 01's stated convention,
-- but inference is real and works throughout the language, not just for literals.
```

## Detailed Example

See [Types.hs](Types.hs), which also demonstrates GHCi's `:t` for checking an expression's inferred type live.

## Verified Output

```bash
$ runghc Types.hs
5
5
age: 30 :: Int
pi_approx: 3.14159 :: Double
initial: A :: Char
isReady: True :: Bool
bigNum: 123456789012345678901234567890
```

```
$ ghci Types.hs
ghci> :t age
age :: Int
ghci> :t pi_approx
pi_approx :: Double
ghci> :t 42
42 :: Num a => a
```

(`:t 42`'s output is exactly why "GHC infers `Integer` for numeric literals with no annotation" needs a caveat: an un-annotated numeric literal's *actual* type is `Num a => a` — polymorphic over any type in the `Num` class — until context forces it to a concrete type like `Int`, `Integer`, or `Double`. This is a real, verified-live nuance worth being precise about rather than oversimplifying to "always defaults to Integer.")

## Common Mistakes

- **Trying to "update" a `let` binding and being surprised it silently shadows instead of erroring** — since shadowing is legal syntax, this doesn't fail to compile, it just doesn't do what an imperative-language habit might expect. Read shadowing warnings (`-Wname-shadowing`) seriously.
- **Assuming `Int` never overflows, like Python's `int`** — `Int` is fixed-width and *can* silently wrap on overflow (verified in [Types.hs](Types.hs)); use `Integer` when a value could genuinely grow unbounded.
- **Forgetting numeric literals are polymorphic until used** — `5` alone has type `Num a => a`; only usage (an annotation, or being passed to a function expecting a concrete numeric type) resolves it to `Int`, `Integer`, `Double`, etc.

## Best Practices

- Default to `Int` for everyday counting/indexing; reach for `Integer` specifically when a value could plausibly exceed roughly ±9.2 × 10¹⁸ (`Int`'s 64-bit range) or when arbitrary precision is a genuine requirement (cryptography, factorials, combinatorics).
- Annotate top-level bindings' types explicitly even though GHC could infer them — it documents intent, and a mismatch between your annotation and what the body actually produces is a compile error GHC catches for you, functioning as free, always-checked documentation.
- Treat every `let`/`where` binding as truly permanent — if you find yourself wanting to "update" one, that's usually a sign the function should take the new value as a parameter or return it, not evidence you need a mutable variable.

## Real-World Usage

The complete absence of mutable variables is precisely what makes Haskell's laziness (Lesson 14) and concurrency primitives safe: since nothing can change out from under a running computation, the compiler and runtime are both free to reorder, defer, or parallelize evaluation in ways that would be outright dangerous in a language with ordinary mutable variables.

## Summary

- Haskell has **no mutable variables** in ordinary code — `let x = 5` is permanent; a second `let x = ...` shadows rather than mutates.
- `::` annotates a type; GHC's inference works even without annotations, though this course annotates top-level bindings for clarity.
- `Int` is fixed-width (can overflow); `Integer` is arbitrary-precision (cannot).
- Numeric literals are polymorphic (`Num a => a`) until context resolves them to a concrete type.

## Key Terms

- **Binding** — Haskell's term for a name-to-value association (`let`/`where`/top-level); deliberately not called a "variable" since it never varies.
- **Shadowing** — a new binding of an already-used name hiding the old one for the rest of its scope, without mutating the original.
- **Referential transparency** — the property that an expression always evaluates to the same value wherever it appears, guaranteed by the absence of mutable variables.

## Interview Questions

1. **Why doesn't Haskell have mutable variables, and what does that buy the language?**
   Every binding is a permanent association between a name and a value — there's no reassignment in ordinary code. This guarantees referential transparency (an expression's value never changes based on when/where it's evaluated), which underpins safe laziness (evaluation order can be deferred or reordered with no observable difference) and safe concurrency (no shared mutable state to race over). Controlled, explicitly-typed mutation still exists (`IORef`/`MVar`/`STRef`) for the narrow cases that genuinely need it, always visible in a value's type.

2. **What's the difference between `Int` and `Integer`?**
   `Int` is a fixed-width integer (platform word size, typically 64-bit) that can silently overflow/wrap, similar to Rust's `i64` or Java's `long`. `Integer` is arbitrary-precision — it grows to represent any value memory allows and never overflows, similar to Python's built-in `int`, at some performance cost relative to `Int` for everyday small arithmetic.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
