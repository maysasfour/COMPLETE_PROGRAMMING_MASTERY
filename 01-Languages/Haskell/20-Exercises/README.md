# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

## Learning Objectives

- Apply pattern matching, `Maybe`/`Either`, custom type classes, higher-order functions/composition, and laziness together, across problems that don't fit inside any single earlier lesson.

## Prerequisites

[19-Best-Practices](../19-Best-Practices/README.md) — these problems draw on Lessons 05 (pattern matching), 09 (`Maybe`/`Either`), 11 (type classes), 12 (higher-order functions), and 14 (laziness).

## Note on Scope

Lessons 05, 06, and 07 already have their own `Exercises/`/`Solutions/` pairs (FizzBuzz/countdown, currying/partial application/point-free, infinite primes/chunking/tuple rotation) — none of that ground is repeated here. These seven problems are new, standalone, and each draws on a different later lesson.

No solutions are included in this folder — see [21-Solutions](../21-Solutions/README.md) for verified, actually-run solutions to every problem below.

## Problem 1 — Shape Pattern Matching

Define a `Shape` type with three constructors: `Circle Double` (radius), `Rectangle Double Double` (width, height), and `Triangle Double Double` (base, height). Write `area :: Shape -> Double` using pattern matching on all three constructors (no partial coverage — GHC's `-Wincomplete-patterns` should report no warning). Then write `describe :: Shape -> String` that pattern-matches to produce `"Circle with area 78.54"`-style strings (round the area to 2 decimal places).

## Problem 2 — Safe Association-List Lookup with `Maybe`

Given `type Config = [(String, String)]`, write `lookupConfig :: String -> Config -> Maybe String`. Then write `lookupPort :: Config -> Maybe Int`, which looks up the key `"port"`, and if found, tries to parse it as an `Int` — chain both `Maybe`-producing steps together using `>>=` (or do-notation), producing `Nothing` if either the key is missing *or* the value fails to parse as a number.

## Problem 3 — Validation Pipeline with `Either`

Write a user-registration validator: `data RegError = EmptyName | InvalidAge | WeakPassword deriving Show`, and `validateUser :: String -> Int -> String -> Either RegError (String, Int, String)`, which checks (in order): name is non-empty, age is between 13 and 120, password is at least 8 characters. Return the *first* failing `Left`, or `Right` with all three values if all checks pass — chain the three checks with `>>=`, do not write one giant nested `if`.

## Problem 4 — A Custom Type Class with a Default Method

Define `class Summary a where { shortSummary :: a -> String; longSummary :: a -> String; longSummary x = "Details: " ++ shortSummary x }` (i.e. `longSummary` has a default implementation in terms of `shortSummary`). Write two data types (e.g. `Book` and `Movie`, each with a title and a rating) and give each an `instance Summary` that only defines `shortSummary`, relying on the default for `longSummary`. Then give at least one of them a *custom* `longSummary` that overrides the default, and show both behaviors from `main`.

## Problem 5 — Higher-Order Functions and Composition

Without using the built-in `map`, `filter`, or `foldr`/`foldl` directly (write your own recursive versions first — `myMap`, `myFilter`, `myFoldr`), then build a pipeline using function composition (`.`) that: takes a list of `Int`, keeps only the even ones, squares each, and sums the result — once using your own `myMap`/`myFilter`/`myFoldr`, and once using the built-in Prelude equivalents, showing both produce the same answer.

## Problem 6 — Laziness: Infinite Lists and `foldl` vs `foldl'`

Part A: write `fibs :: [Integer]` as a genuinely infinite, lazily-generated Fibonacci sequence (using `zipWith (+)` on the list with itself, shifted — the classic idiom), and show `take 15 fibs` works without ever specifying an upper bound.

Part B: write a large-ish sum (`sum [1 .. 5000000 :: Int]` or similar) two ways — with `foldl (+) 0` and with `Data.List.foldl' (+) 0` — and explain (in a comment, and confirmed by actually timing/observing both) why the strict `foldl'` is the one that should be preferred for this kind of accumulation despite both being "correct."

## Recommended Next Lesson

[21 — Solutions](../21-Solutions/README.md)
