# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use Haskell's list type — a **singly-linked, homogeneous, lazy** list — and its core operations.
- Use tuples for fixed-size, heterogeneous groupings.
- Write list comprehensions.
- Build and safely consume a genuinely **infinite list**, using laziness to only compute as much as `take` actually demands — verified live, not just claimed.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept: Lists Are Singly-Linked and Lazy

A Haskell `[a]` is not an array — it's a singly-linked list, built from exactly two constructors: `[]` (empty) and `x : xs` ("cons" — an element `x` in front of the rest of the list `xs`). This is structurally identical to a Lisp list, and it means:

- **Random access (`xs !! 5`) is O(n)**, not O(1) like Rust's `Vec`/Python's `list` — you must walk the links.
- **Prepending (`x : xs`) is O(1)**; **appending (`xs ++ [x]`) is O(n)** — the mirror image of an array's cost profile.
- **Lists are lazy by default** (a direct consequence of Haskell's overall lazy evaluation, covered in depth in Lesson 14): a list's elements aren't computed until something actually demands them. This is what makes infinite lists possible at all — genuinely unique among the collection types covered anywhere else in this repository.

```haskell
xs :: [Int]
xs = [1, 2, 3, 4, 5]

empty :: [Int]
empty = []

consed :: [Int]
consed = 0 : xs        -- [0,1,2,3,4,5] -- O(1), just wraps xs with a new front element
```

## Tuples — Fixed-Size, Heterogeneous

```haskell
point :: (Int, Int)
point = (3, 4)

personRecord :: (String, Int, Bool)
personRecord = ("Ada", 36, True)

-- fst/snd only exist for PAIRS (2-tuples) -- larger tuples need pattern matching:
x, y :: Int
(x, y) = point

getName :: (String, Int, Bool) -> String
getName (name, _, _) = name
```

Unlike a list, a tuple's size is fixed at the type level and its elements can be different types — `(Int, Int)` and `(String, Int, Bool)` are genuinely different types, unlike a Python tuple, where size/types aren't tracked at all.

## List Comprehensions

```haskell
squares :: [Int]
squares = [x * x | x <- [1 .. 10]]                    -- transform

evens :: [Int]
evens = [x | x <- [1 .. 20], even x]                  -- filter

pairs :: [(Int, Int)]
pairs = [(x, y) | x <- [1 .. 3], y <- [1 .. 3], x /= y]  -- multiple generators + filter
```

This directly parallels Python's list comprehensions (`[x*x for x in range(1,11)]`) — genuinely the same idea, syntax rearranged, and it's no coincidence: Python's comprehensions were explicitly inspired by Haskell's (and SETL's before that).

## Infinite Lists — A Real, Unique Capability of Laziness

This is something no other language course in this repository can do the same way — not because of a syntax difference, but because **laziness is a semantic guarantee**, not an optimization. A list defined with no upper bound simply never gets fully evaluated; only the prefix something like `take` actually demands is ever computed.

```haskell
naturals :: [Integer]
naturals = [1 ..]                     -- genuinely infinite -- no upper bound given at all

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)   -- infinite, defined IN TERMS OF ITSELF

firstTenNaturals :: [Integer]
firstTenNaturals = take 10 naturals   -- only the first 10 are ever actually computed

firstTenFibs :: [Integer]
firstTenFibs = take 10 fibs
```

`fibs` is especially striking: it's defined recursively in terms of itself (`zipWith (+) fibs (tail fibs)`, i.e. each Fibonacci number is the sum of the two before it), and this genuinely works — GHC only forces as many cells of the infinite structure as `take 10` demands, never attempting (and never needing) to build the "whole" infinite list first. [Collections.hs](Collections.hs) verifies this actually terminates and produces the right answer, live.

## Detailed Example

See [Collections.hs](Collections.hs).

## A Real Warning Hit Live

Compiling [Collections.hs](Collections.hs) with this GHC version genuinely produces a `-Wx-partial` warning on `fibs`'s own definition:

```
Collections.hs:29:34: warning: [GHC-63394] [-Wx-partial]
    In the use of `tail'
    (imported from Prelude, but defined in GHC.List):
    "This is a partial function, it throws an error on empty lists.
     Replace it with drop 1, or use pattern matching or Data.List.uncons instead."
```

This is real, not hypothetical — GHC 9.8.2 added `-Wx-partial` warnings for several Prelude functions (`head`, `tail`, `init`, `last`) that crash on empty input, exactly the anti-pattern [19-Best-Practices](../19-Best-Practices/README.md) is built around. `tail fibs` is provably always safe here (`fibs` is defined as `0 : 1 : ...`, so it can never be empty), so the code is left as-is and the warning is documented rather than silenced — but it's a genuine, live-caught instance of the exact "partial function" trap this course spends a whole later lesson warning about, encountered while writing an entirely different lesson.

## Verified Output

```bash
$ runghc Collections.hs
xs = [1,2,3,4,5]
consed = [0,1,2,3,4,5]
point = (3,4)
personRecord name = Ada
squares = [1,4,9,16,25,36,49,64,81,100]
evens = [2,4,6,8,10,12,14,16,18,20]
pairs = [(1,2),(1,3),(2,1),(2,3),(3,1),(3,2)]
firstTenNaturals = [1,2,3,4,5,6,7,8,9,10]
firstTenFibs = [0,1,1,2,3,5,8,13,21,34]
list append (++) O(n) demo: [1,2,3,4,5,6]
random access xs !! 3 = 4
```

## Common Mistakes

- **Trying to `print` or `length` an infinite list directly** — `print naturals` (with no `take`) genuinely hangs forever (it never terminates, since `length`/full `print` demand every element); always `take` (or otherwise bound) an infinite list before consuming it fully.
- **Using `++` (append) in a loop/recursion to build up a list incrementally** — each `++` is O(n) in the length of its left operand, so repeated appending is O(n²) overall; prefer consing (`:`) onto the front and reversing once, or use `foldr`.
- **Assuming `xs !! i` is O(1) like array indexing** — it's O(i), since the list must be walked from the front; for genuinely frequent random access, a different structure (`Data.Array`, `Data.Sequence`, or `Data.Vector` from a package) is the right tool, not a plain list.
- **Confusing tuple `fst`/`snd` as working on any tuple size** — they're defined only for 2-tuples; a 3-tuple or larger needs pattern matching to extract fields.

## Best Practices

- Default to lists for sequential, mostly-front-accessed data (exactly the shape recursion/pattern matching naturally consumes); reach for `Data.Map`/`Data.Set`/`Data.Sequence`/`Data.Vector` (all from the standard `containers`/`vector` packages) when you need efficient lookup, membership testing, or random access.
- Use list comprehensions for the common "transform + filter" shape; use explicit `map`/`filter`/recursion when the logic doesn't fit that shape cleanly.
- Take laziness seriously as a real tool, not just a curiosity: infinite lists (`[1..]`, a stream of random numbers, an infinite list of Fibonacci numbers) are genuinely practical when combined with `take`/`takeWhile`.

## Real-World Usage

Lazy, infinite-list-capable sequences underlie real patterns like generating an unbounded stream of test data and taking only as many as a test needs, or defining a self-referential sequence (like `fibs` above) without a explicit loop or mutable accumulator — the exact "define it declaratively, let laziness handle the rest" style that's distinctively Haskell.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Summary

- Haskell's `[a]` is a singly-linked, lazy list — O(1) cons/prepend, O(n) append/random-access, the mirror image of an array's cost profile.
- Tuples are fixed-size, heterogeneous, and type-checked per size — `(Int,Int)` and `(Int,Int,Int)` are different types; `fst`/`snd` only exist for pairs.
- List comprehensions (`[expr | gen <- src, cond]`) directly parallel — and historically inspired — Python's list comprehensions.
- Infinite lists (`[1..]`, self-referential `fibs`) are a genuine, unique capability enabled by laziness: only what `take` (or similar) actually demands is ever computed, verified live to actually terminate.

## Key Terms

- **Cons (`:`)** — prepends an element to the front of a list in O(1); the list's fundamental constructor alongside `[]`.
- **Lazy list** — a list whose elements are computed on demand, not eagerly up front, making infinite lists representable at all.
- **List comprehension** — `[expr | generator, ..., condition, ...]` syntax for building a list by transforming/filtering a source.

## Interview Questions

1. **Why is `xs !! 5` O(n) in Haskell, unlike array indexing in most other languages?**
   Haskell's list is a singly-linked list (built from `[]` and `:`), not a contiguous array — reaching the 6th element means walking 5 cons cells from the front, an O(n) operation. This is the direct trade-off for O(1) prepending (`:`) instead; a language whose default sequence is a contiguous array (Rust's `Vec`, Python's `list`) has the opposite cost profile, O(1) indexing but generally O(n) worst-case insertion at the front.

2. **How is an infinite list like `fibs = 0 : 1 : zipWith (+) fibs (tail fibs)` possible without infinite memory or an infinite loop?**
   Haskell is lazily evaluated (Lesson 14): a list's cons cells are only constructed as something downstream actually demands them. `take 10 fibs` forces exactly the first 10 cells to be evaluated and no more — the "rest" of the infinite definition is never touched, so it never needs to (and never does) fully evaluate. This is a semantic guarantee of the language, not a special case for this one example.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
