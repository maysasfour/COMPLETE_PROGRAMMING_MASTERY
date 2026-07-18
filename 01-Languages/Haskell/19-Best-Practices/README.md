# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Understand purity as a discipline, not just a language feature: referential transparency, why it matters for reasoning/testing/refactoring, and `IO` as the explicit boundary where effects are allowed to happen.
- Recognize partial functions (`head`, `fromJust`, incomplete pattern matches) as a real, live anti-pattern — see a genuine runtime crash caused by one, then the total-function fix.
- Weigh point-free style's readability-vs-concision tradeoff with real, compiled examples, rather than treating "more point-free" as an unconditional goal.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept: Purity as a Discipline

Every earlier lesson in this course has quietly relied on purity — Lesson 09's `Maybe`/`Either` work as ordinary values *because* the functions returning them have no hidden side effects, and Lesson 18's Hspec tests were trivial to write *because* the functions under test are pure (Lesson 18's own closing note said this directly). This lesson makes the discipline explicit.

A pure function is **referentially transparent**: calling it twice with the same arguments always produces the same result, and the call can be replaced by its result anywhere in the program without changing behavior. This is what makes equational reasoning, safe refactoring, and mock-free testing all possible at once — none of it is Haskell being fussy for its own sake, it is a direct consequence of "no hidden `IO`."

`IO` (Lesson 10) is not merely one type among many — it is the explicit, compiler-checked boundary between the pure core of a program and the effectful shell around it (file access, networking, mutation, randomness, the current time). A function with no `IO` in its signature is *guaranteed* by the type system not to do any of that, not just conventionally assumed to avoid it. The practical discipline this lesson is about: **push `IO` to the edges** — keep as much logic as possible in plain, pure functions, and let a thin `main`/`IO` layer call them, exactly the shape [22-Mini-Projects](../22-Mini-Projects/README.md)'s Task Tracker follows (pure list-manipulation functions for the task list, a thin `IO` layer for reading/writing the persistence file and talking to the user).

```haskell
-- PURE -- no IO in the signature, the compiler guarantees no hidden side effects:
applyDiscount :: Double -> Double -> Double
applyDiscount pct price = price * (1 - pct / 100)

-- IMPURE -- IO in the signature is a visible, compiler-checked admission
-- that this function may read a file, print, hit the network, etc.:
loadPriceFromFile :: FilePath -> IO Double
loadPriceFromFile path = read <$> readFile path
```

## Avoiding Partial Functions — A Real Crash, Reproduced

A **partial function** is one that isn't defined for every value of its argument type — `head :: [a] -> a` has no sensible result for `[]`, so GHC's implementation simply throws a runtime error. This was reproduced for real in this environment, not paraphrased from documentation:

```haskell
-- crash1.hs
main :: IO ()
main = print (head ([] :: [Int]))
```

```bash
$ runghc crash1.hs
crash1.hs:2:15: warning: [GHC-63394] [-Wx-partial]
    In the use of `head'
    (imported from Prelude, but defined in GHC.List):
    "This is a partial function, it throws an error on empty lists. Use pattern matching or Data.List.uncons instead. Consider refactoring to use Data.List.NonEmpty."
  |
2 | main = print (head ([] :: [Int]))
  |               ^^^^
crash1.hs: Prelude.head: empty list
CallStack (from HasCallStack):
  error, called at libraries\base\GHC\List.hs:2004:3 in base:GHC.List
  errorEmptyList, called at libraries\base\GHC\List.hs:90:11 in base:GHC.List
  badHead, called at libraries\base\GHC\List.hs:84:28 in base:GHC.List
  head, called at crash1.hs:2:15 in main:Main
```

Two genuinely notable things about this real output: GHC 9.8.2 now emits a compile-time `-Wx-partial` **warning** for `head` even before the program runs (a relatively recent GHC addition specifically to nudge programmers away from this exact mistake), and the program still crashes at runtime with a non-zero exit code (`runghc` reported exit status 1) since a warning doesn't stop compilation.

### The Fix: `Data.List.uncons` and `Maybe`

```haskell
import Data.List (uncons)

-- TOTAL: every possible input, including [], produces a well-defined Maybe result --
-- exactly the Lesson 09 discipline applied to this specific, extremely common trap.
safeFirst :: [a] -> Maybe a
safeFirst xs = case uncons xs of
  Nothing     -> Nothing
  Just (x, _) -> Just x
```

`fromJust` (`Data.Maybe`) is the same trap in different clothes — it is `head` for `Maybe` instead of `[]`, throwing on `Nothing` instead of returning it. The fix is identical in spirit: pattern-match on the `Maybe` (or use `maybe`/`fromMaybe`, Lesson 09) instead of asserting the value must be present.

## Point-Free Style — A Real Readability/Concision Tradeoff

"Point-free" (or "tacit") style defines a function by composing other functions, without ever naming its argument (a "point" here means an explicit argument, not a coding style pun — the term comes from point-free topology). Both styles below were compiled and produce identical results:

```haskell
-- POINT-FUL: the argument xs is named and threaded through explicitly.
sumOfSquaresPointful :: [Int] -> Int
sumOfSquaresPointful xs = sum (map (\x -> x * x) xs)

-- POINT-FREE: the same function, defined purely by composition -- no argument named.
sumOfSquaresPointfree :: [Int] -> Int
sumOfSquaresPointfree = sum . map (^ 2)
```

At this size, point-free is arguably *more* readable — `sum . map (^2)` reads almost like English ("sum of the squares"). But it does not scale unconditionally:

```haskell
-- Technically correct, genuinely harder to read at a glance than naming
-- an argument would be -- included to show the tradeoff, not to imitate:
overdonePointfree :: [[Int]] -> Int
overdonePointfree = sum . map (sum . map (^ 2)) . filter (not . null)
```

The idiomatic Haskell guideline (not a hard rule) is: prefer point-free for short, clearly-named compositions (`sum . map f`, `length . filter p`), and switch back to naming arguments once the composition chain requires the reader to mentally "un-flatten" more than two or three stages to see what is happening — concision that costs comprehension is not actually a win.

## Detailed Example

See [BestPractices.hs](BestPractices.hs) — all functions above, actually compiled and run together with `runghc`.

## Verified Output

```bash
$ runghc BestPractices.hs
BestPractices.hs:6:15: warning: [GHC-63394] [-Wx-partial]
    In the use of `head'
    (imported from Prelude, but defined in GHC.List):
    "This is a partial function, it throws an error on empty lists. Use pattern matching or Data.List.uncons instead. Consider refactoring to use Data.List.NonEmpty."
  |
6 | unsafeFirst = head
  |               ^^^^
first element: 10
empty list, no crash
30
30
0
14
```

The `-Wx-partial` warning fires here merely because `BestPractices.hs` *defines* `unsafeFirst = head` (to name the anti-pattern for this lesson) — that definition is never actually called with `[]` in `main`, so the program itself does not crash; `crash1.hs` above is the file that demonstrates the real runtime crash.

## Common Mistakes

- **Calling `head`/`tail`/`fromJust`/`!!` on values that might be empty/`Nothing`/out of range** — all are partial functions that throw at runtime rather than returning a `Maybe`; GHC 9.8+ now warns about several of these (`-Wx-partial`) at compile time, but the warning does not stop the program from crashing if the unsafe call is actually reached.
- **Reaching for point-free style unconditionally** — `overdonePointfree` above is a real example of composition chains that technically work but cost more to read than they save to write; point-free is a readability tool, not a purity/correctness requirement.
- **Letting `IO` creep into logic that doesn't need it** — e.g., writing a function that both computes a result *and* prints it, rather than returning the result and letting a thin `IO`-layer caller decide whether/how to print it; this quietly makes the function untestable without capturing stdout, discarding the exact testing benefit Lesson 18 demonstrated.

## Best Practices

- Push `IO` to the outermost edges of a program; keep the actual logic in pure functions with no `IO` in their type, exactly as [22-Mini-Projects](../22-Mini-Projects/README.md)'s Task Tracker structures its pure task-list functions versus its thin `IO` persistence/CLI layer.
- Prefer total functions (`Maybe`/`Either`-returning, or pattern-matched over every constructor) to partial ones; treat a GHC `-Wx-partial` warning as something to actually fix, not silence.
- Use point-free style where it genuinely improves readability (short compositions with well-named component functions); switch back to named arguments once a composition chain stops being immediately legible.
- Enable `-Wall` during development — it surfaces incomplete pattern matches, unused bindings, and (as seen above) partial-function usage before they become runtime surprises.

## Real-World Usage

Production Haskell codebases lint for and reject partial-function usage routinely (via `-Wall`/`-Wx-partial`, `hlint`, or code review convention), and structure real applications as a pure "core" (business logic, no `IO`) surrounded by a thin `IO` "shell" (HTTP handlers, database calls, CLI parsing) — often called the "functional core, imperative shell" pattern, which is really just this lesson's purity discipline applied at the architecture level rather than the single-function level.

## Summary

- Purity (no `IO` in a function's type) is a compiler-checked guarantee, not a convention — it is what made Lesson 18's tests trivial to write and is what [22-Mini-Projects](../22-Mini-Projects/README.md) structures its Task Tracker around.
- A real crash from `head []` was reproduced with `runghc` in this environment, including GHC 9.8.2's live `-Wx-partial` compile warning; `Data.List.uncons` plus `Maybe` is the total-function fix.
- Point-free style is a genuine readability/concision tradeoff, demonstrated with real compiled examples of both a clear case (`sum . map (^2)`) and an overdone one.

## Key Terms

- **Referential transparency** — a pure function call can always be replaced by its result without changing program behavior; the defining property of purity.
- **Partial function** — a function not defined for every value of its argument type (`head`, `fromJust`); throws at runtime on an out-of-domain input rather than returning a `Maybe`/`Either`.
- **Point-free (tacit) style** — defining a function via composition of other functions, without naming its argument explicitly.

## Interview Questions

1. **What does it mean for a Haskell function to be "pure," and why does the type system make this a guarantee rather than a convention?**
   A pure function has no `IO` in its type signature, meaning it cannot perform side effects (file access, networking, mutation, printing) — calling it twice with the same arguments always produces the same result. Because `IO` in Haskell is a real type that must appear in a function's signature the moment it performs any effect, and non-`IO` code cannot call `IO`-returning functions without itself becoming `IO`, the absence of `IO` in a signature is checked by the compiler, not merely a team convention that can silently be violated.

2. **Why is `head` considered a real anti-pattern in idiomatic Haskell, and what's the fix?**
   `head :: [a] -> a` is a partial function — it has no defined result for `[]` and throws a runtime error (`Prelude.head: empty list`) when called on one, a genuine crash reproduced live in this lesson. GHC 9.8+ even emits a compile-time `-Wx-partial` warning on `head` usage specifically because of how common this mistake is. The fix is a total function: `Data.List.uncons :: [a] -> Maybe (a, [a])`, which returns `Nothing` for `[]` instead of throwing, forcing the caller to handle the empty case explicitly via pattern matching or `Maybe` combinators (Lesson 09).

3. **When is point-free style a readability win, and when does it become a liability?**
   Point-free style is a win for short compositions of clearly-named functions — `sum . map (^2)` reads almost like the English description of what it computes, with no argument-threading boilerplate. It becomes a liability once a composition chain grows long enough that a reader has to mentally "un-flatten" several stages to figure out what's happening (`sum . map (sum . map (^ 2)) . filter (not . null)` above is a real example) — at that point, naming the argument and writing the computation as an explicit sequence of steps is more readable, not less idiomatic.

## Recommended Next Lesson

[20 — Exercises](../20-Exercises/README.md)
