# 12 — Higher-Order Functions

[Back to course overview](../README.md) | [Previous: Type Classes](../11-Type-Classes/README.md)

## Learning Objectives

- Use `map`, `filter`, `foldr`, and `foldl` fluently — Haskell's bread-and-butter replacement for hand-written loops (Lesson 05).
- Understand the practical difference between `foldr` and `foldl` — not just direction, but which one is safe on infinite lists.
- Go deeper on function composition (`.`, recapping Lesson 04) by building small pipelines out of `map`/`filter`/`fold`.

## Prerequisites

[11-Type-Classes](../11-Type-Classes/README.md)

## Concept

Lesson 05 established that Haskell has no loops — `map`, `filter`, and `fold` are the concrete, everyday tools that fill that gap for collection processing, and they're used far more often in real Haskell code than hand-written recursion. This module has already covered [10-Functional-Programming](../../../10-Functional-Programming/03-Map-Filter-Reduce/README.md)'s Python version of these same ideas — the difference here is that in Haskell these aren't merely *available* higher-order functions layered onto an otherwise-imperative language; they're the primary, idiomatic way essentially all collection iteration is expressed, with no loop-based alternative to fall back on.

## `map` and `filter`

```haskell
doubleAll :: [Int] -> [Int]
doubleAll = map (* 2)

keepEven :: [Int] -> [Int]
keepEven = filter even
```

## `foldr` vs. `foldl`

```haskell
-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldr f z [x1, x2, x3] == x1 `f` (x2 `f` (x3 `f` z))   -- combines from the RIGHT

-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldl f z [x1, x2, x3] == ((z `f` x1) `f` x2) `f` x3   -- combines from the LEFT

sumR :: [Int] -> Int
sumR = foldr (+) 0

sumL :: [Int] -> Int
sumL = foldl (+) 0

-- Both give the same answer for a commutative/associative operator like (+),
-- but the DIRECTION each recurses genuinely differs, with a real consequence:

-- foldr can produce a result from an INFINITE list, if the combining function
-- is lazy enough not to need the whole thing -- e.g. `any`/`or`-style short-
-- circuiting. foldl CANNOT -- it must walk the entire list before producing
-- anything, so foldl on an infinite list never terminates.
firstEven :: [Int] -> Maybe Int
firstEven = foldr (\x acc -> if even x then Just x else acc) Nothing
```

`firstEven [1 ..]` genuinely terminates (verified in [HigherOrder.hs](HigherOrder.hs)) because `foldr` can produce `Just 2` without ever forcing evaluation of the rest of the infinite list — the moment the combining function returns `Just x` without touching `acc`, laziness (Lesson 14) means the remaining, unevaluated tail of `[1 ..]` is simply never touched. The equivalent attempted with `foldl` would hang forever, since `foldl` must fully traverse to the end before it can produce anything (there is no "end" of an infinite list to reach).

## Detailed Example

See [HigherOrder.hs](HigherOrder.hs).

## Verified Output

```bash
$ runghc HigherOrder.hs
doubleAll [1,2,3] = [2,4,6]
keepEven [1..10] = [2,4,6,8,10]
sumR [1,2,3,4] = 10
sumL [1,2,3,4] = 10
firstEven [1..] (infinite list) = Just 2
pipeline (sum of squares of evens, 1..10) = 220
```

## Common Mistakes

- **Calling `foldl` (not `foldl'`) on a large list and hitting a stack-space blowup** — the standard, lazy `foldl` builds up a chain of unevaluated thunks before ever forcing them, which can genuinely exhaust stack space on large inputs; `Data.List.foldl'` (strict left fold) is the practical, commonly-recommended alternative for large finite lists.
- **Assuming `foldl` works on an infinite list the same way `foldr` sometimes can** — it doesn't, structurally: `foldl` must walk to the very end before producing any result, which is impossible for a genuinely unbounded list; `foldr` can short-circuit if its combining function doesn't force its accumulator argument.
- **Forgetting `map`/`filter` are lazy** (echoing the Python course's own equivalent Common Mistake for `map`/`filter`) — `map f xs` builds its result on demand; this is invisible for a short finite list but is exactly what makes `map`/`filter` safely usable on infinite lists too.

## Best Practices

- Default to `map`/`filter`/`fold` over hand-written recursion for anything shaped like "transform," "select," or "combine into one value" — it's both shorter and directly signals intent (Lesson 05's recommendation, restated with the concrete tools now in hand).
- Use `foldr` when the combining function might short-circuit (stop early) or when working with potentially-infinite structures; use `Data.List.foldl'` (the strict left fold) for ordinary large finite accumulation, to avoid the lazy `foldl` thunk-buildup trap.
- Build pipelines with `.` (Lesson 04) chaining `map`/`filter`/`fold` stages, rather than one large function that manually loops and mutates an accumulator by hand.

## Real-World Usage

`map`/`filter`/`fold` (and their many specialized siblings — `mapMaybe`, `concatMap`, `foldMap`) are used constantly in real Haskell code for exactly the same "process a collection" tasks a `for` loop handles in every other language in this repository — the difference is these compose cleanly via `.`/`$` (Lesson 04) into pipelines, rather than being sequences of individually-scoped statements.

## Summary

- `map`/`filter` transform/select over a list; both are lazy, safely usable on infinite lists.
- `foldr`/`foldl` combine a list's elements from the right/left respectively — not just a direction difference: `foldr` can short-circuit and terminate on an infinite list (if the combining function is lazy in its accumulator), `foldl` structurally cannot.
- `Data.List.foldl'` (strict) is the practical choice for ordinary large finite accumulation, avoiding lazy `foldl`'s thunk-buildup risk.

## Key Terms

- **`foldr`/`foldl`** — combine a list's elements into one value, recursing from the right/left respectively.
- **`foldl'`** — the strict variant of `foldl` (from `Data.List`), evaluating the accumulator eagerly at each step to avoid excessive thunk buildup.
- **Short-circuiting fold** — a fold whose combining function can produce a result without forcing its full accumulator argument, enabling termination on an infinite list via `foldr`.

## Interview Questions

1. **Why can `foldr` sometimes terminate on an infinite list while `foldl` never can?**
   `foldr f z [x1, x2, ...]` expands as `x1 `f` (x2 `f` (x3 `f` ...))` — if `f` can produce a result without forcing its second argument (the rest of the fold), evaluation can stop without ever reaching the (possibly infinite) tail. `foldl f z [x1, x2, ...]` expands as `((z `f` x1) `f` x2) `f` ...` — it must reach the *last* element before it can produce anything at all, which is structurally impossible for a list with no last element.

2. **When would you reach for `Data.List.foldl'` instead of plain `foldl`?**
   For ordinary large *finite* accumulation (e.g., summing a big list) where you want the whole list traversed anyway — plain `foldl` builds up a long chain of unevaluated thunks before forcing anything, which can blow the stack on large inputs; `foldl'` forces the accumulator at each step, avoiding that buildup, at the cost of no longer being usable on infinite lists (which need `foldr`'s short-circuiting potential instead).

## Recommended Next Lesson

[13 — Type System and Generics](../13-Type-System-and-Generics/README.md)
