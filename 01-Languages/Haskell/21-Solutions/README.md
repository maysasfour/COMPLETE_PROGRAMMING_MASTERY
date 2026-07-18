# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

## Learning Objectives

- Compare your own attempts at [20-Exercises](../20-Exercises/README.md) against verified, actually-run solutions, with real captured output for every problem.

## Prerequisites

[20-Exercises](../20-Exercises/README.md)

## Environment Honesty Note (Read First)

Every solution file below was genuinely run in this environment — `Solution01.hs` through `Solution05.hs` via `runghc`, and `Solution06.hs` compiled with `ghc -O0` and executed as a binary (needed for its timing comparison to reflect real, compiled-code performance rather than `runghc`'s interpreter overhead). One real, live compile error was hit and fixed during this authoring: `Solution06.hs` originally imported `System.CpuTime`, which does not exist — GHC's own error message pointed at the correct module name, `System.CPUTime` (capital `CPU`), which was substituted before it would compile.

## Problem 1 — Shape Pattern Matching

Solution: [Solution01.hs](Solution01.hs)

```bash
$ runghc Solution01.hs
Circle with area 78.54
Rectangle with area 24.00
Triangle with area 12.00
```

## Problem 2 — Safe Association-List Lookup with `Maybe`

Solution: [Solution02.hs](Solution02.hs)

```bash
$ runghc Solution02.hs
Just 8080
Nothing
Nothing
```

The second `Nothing` is the "key present, value doesn't parse as an `Int`" case (`"not-a-number"`); the third is the "key missing entirely" case — both collapse to the same `Nothing`, exactly the point of chaining two `Maybe`-producing steps with `>>=`/do-notation rather than writing separate error paths for each.

## Problem 3 — Validation Pipeline with `Either`

Solution: [Solution03.hs](Solution03.hs)

```bash
$ runghc Solution03.hs
Right ("Ada",30,"hunter22")
Left EmptyName
Left InvalidAge
Left WeakPassword
```

Each `Left` case demonstrates the pipeline stopping at the *first* failing check (do-notation over `Either` short-circuits on the first `Left`, exactly like `?` in Rust or an early `return Err` in Go) rather than continuing to evaluate later checks against already-invalid data.

## Problem 4 — A Custom Type Class with a Default Method

Solution: [Solution04.hs](Solution04.hs)

```bash
$ runghc Solution04.hs
Learn You a Haskell (9/10)
Details: Learn You a Haskell (9/10)
The Matrix (10/10)
Now showing: The Matrix (10/10) -- a custom override, not the default
```

`Book`'s `longSummary` output (`"Details: ..."`) comes entirely from the type class's default method — `Book`'s instance never defines it. `Movie`'s instance explicitly overrides `longSummary`, and its distinct output (`"Now showing: ..."`) confirms the override took effect instead of the default.

## Problem 5 — Higher-Order Functions and Composition

Solution: [Solution05.hs](Solution05.hs)

```bash
$ runghc Solution05.hs
220
220
True
```

Both the hand-written `myMap`/`myFilter`/`myFoldr` pipeline and the Prelude `map`/`filter`/`foldr` pipeline compute the same result (`220` — the sum of squares of the even numbers in `[1..10]`: `2^2+4^2+6^2+8^2+10^2 = 4+16+36+64+100 = 220`), confirmed by the final `True`.

## Problem 6 — Laziness: Infinite Lists and `foldl` vs `foldl'`

Solution: [Solution06.hs](Solution06.hs)

```bash
$ ghc -O0 -o Solution06.exe Solution06.hs
Solution06.hs:10:34: warning: [GHC-63394] [-Wx-partial]
    In the use of `tail'
    (imported from Prelude, but defined in GHC.List):
    "This is a partial function, it throws an error on empty lists. Replace it with drop 1, or use pattern matching or Data.List.uncons instead. Consider refactoring to use Data.List.NonEmpty."
   |
10 | fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
   |                                  ^^^^

$ ./Solution06.exe
[0,1,1,2,3,5,8,13,21,34,55,89,144,233,377]
foldl  sum = 12500002500000 (2.828s CPU time)
foldl' sum = 12500002500000 (0.125s CPU time)
```

Two genuinely real findings from this run, not paraphrased:

- **`fibs`'s self-referential definition genuinely works lazily** — `take 15 fibs` demanded only the first 15 elements of what is, on paper, an infinite list; nothing about `fibs`'s definition specifies a stopping point, and none was needed.
- **`foldl'` was over 20x faster than `foldl` for a 5-million-element sum in this actual run** (0.125s vs 2.828s CPU time) — `foldl` built up a long chain of unevaluated `(+)` thunks before forcing any of them (lazy in its accumulator), while `foldl'` (`Data.List`) forces the accumulator at every step, running in genuinely constant extra space. This is not a marginal style preference; the observed ~23x difference is a real, reproducible cost of using the wrong fold for a large strict accumulation. (GHC also warned about `tail` being partial on `fibs`'s own definition — noted, but not a bug here since `fibs` itself, by construction, is never empty.)

## Summary

- All six solutions were genuinely executed in this environment (`runghc` for five, a compiled binary for the sixth, specifically to get a meaningful timing comparison), with every "Verified Output" block above coming directly from that real run.
- Problem 6's `foldl` vs `foldl'` timing is the clearest evidence in this course that laziness has real, measurable performance consequences, not just a semantic curiosity — a genuinely large (~23x) difference was observed on the exact same computation.

## Recommended Next Lesson

[22 — Mini-Projects](../22-Mini-Projects/README.md)
