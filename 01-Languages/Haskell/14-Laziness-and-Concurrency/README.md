# 14 — Laziness and Concurrency

[Back to course overview](../README.md) | [Previous: Type System and Generics](../13-Type-System-and-Generics/README.md)

## Learning Objectives

- Understand lazy evaluation in depth: expressions are not evaluated until their value is actually demanded.
- Verify **live** that an expression which would error if evaluated eagerly genuinely never runs, because nothing ever demands its value.
- Use `forkIO`/`MVar` for basic concurrency, and understand how immutability (Lesson 03) makes concurrent code safer by construction.

## Prerequisites

[13-Type-System-and-Generics](../13-Type-System-and-Generics/README.md)

## Concept: Lazy Evaluation, In Depth

Every earlier lesson in this course has *relied* on laziness without fully naming it: Lesson 07's infinite lists, Lesson 12's `foldr` short-circuiting on an infinite list, Lesson 07's `fibs` self-reference. The underlying principle, stated plainly: **an expression in Haskell is not evaluated until its value is actually needed**, and if it's never needed, it is never evaluated at all — not "evaluated late," but genuinely never touched.

This is a stronger guarantee than most languages' "short-circuit evaluation" (like `&&`/`||` in nearly every language here, which only apply to those two specific operators) — in Haskell, *every* function argument, every `let` binding, every field of a data structure is lazy by default (there are ways to force strictness where wanted, but laziness is the default, everywhere).

## A Real, Verified-Live Proof: An Error That Never Runs

```haskell
crashes :: Int
crashes = error "this should never actually run!"

-- `const` ignores its SECOND argument entirely -- it never even looks at it:
constDemo :: Int
constDemo = const 42 crashes    -- `crashes` is passed in, but NEVER EVALUATED

-- Building a pair with a "poisoned" second element that's never touched:
firstOnly :: (Int, Int)
firstOnly = (1, crashes)

-- fst never looks at its second component, so this fully succeeds:
proofFst :: Int
proofFst = fst firstOnly
```

[LazinessAndConcurrency.hs](LazinessAndConcurrency.hs) verifies this directly: `constDemo` and `proofFst` are printed successfully, with **no crash and no `error` message ever appearing**, even though both expressions genuinely contain a call to `error` in their construction — because nothing ever demands that particular sub-expression's value, it is never forced, and `error`'s crash-on-evaluation behavior simply never triggers. This is not "the error is caught" — it's that the erroring code path is **never run at all**, a fundamentally different (and stronger) claim, verified by the program's own successful, non-crashing execution.

## `seq` and `$!` — Forcing Strictness Where It's Wanted

```haskell
-- seq :: a -> b -> b  -- forces its FIRST argument to WHNF before returning the second
forcedDemo :: Int
forcedDemo = 5 `seq` 42     -- forces `5` (trivially, it's already a value) then returns 42

-- $! forces its argument before applying the function -- useful to avoid
-- excessive lazy thunk buildup in tight accumulation loops (recall Lesson 12's
-- foldl vs. foldl' distinction, which is built on exactly this mechanism):
strictApply :: Int
strictApply = id $! (2 + 2)
```

## `forkIO`/`MVar` — Basic Concurrency

```haskell
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar

demo :: IO ()
demo = do
    mvar <- newEmptyMVar
    _ <- forkIO $ do
        threadDelay 10000        -- simulate some work (microseconds)
        putMVar mvar "done from another thread"
    result <- takeMVar mvar      -- blocks until the forked thread calls putMVar
    putStrLn result
```

`forkIO` spawns a lightweight, GHC-runtime-managed thread (not a full OS thread per fork — GHC's runtime multiplexes many green threads onto fewer OS threads). `MVar` is a mutable, single-slot box used for safe communication between threads — `takeMVar` blocks until a value is available, `putMVar` fills it. Because ordinary Haskell values are immutable (Lesson 03), the *data* being passed between threads can never be mutated out from under either side — only the deliberate, explicitly-typed `MVar`/`IORef` mutation points need any concurrency discipline at all, a much smaller surface area than a language where every variable is mutable by default.

## Detailed Example

See [LazinessAndConcurrency.hs](LazinessAndConcurrency.hs).

## A Real Gotcha Found Live: `runghc` Hangs on `forkIO`, Compiled `-threaded` Doesn't

Every other lesson in this course runs fine with `runghc`. This one doesn't: running `runghc LazinessAndConcurrency.hs` in this environment prints every line of output correctly, then **hangs indefinitely** rather than exiting — genuinely reproduced, not assumed, confirmed by a `timeout`-wrapped run that printed all six expected lines and then had to be killed. Compiling it properly instead, with the `-threaded` runtime flag GHC's own documentation recommends for any program using `forkIO`, exits cleanly and promptly:

```bash
$ ghc -threaded -o LazinessAndConcurrency LazinessAndConcurrency.hs
[1 of 2] Compiling Main             ( LazinessAndConcurrency.hs, LazinessAndConcurrency.o )
[2 of 2] Linking LazinessAndConcurrency.exe
$ ./LazinessAndConcurrency.exe
constDemo (const 42 crashes) = 42
proofFst (fst (1, crashes)) = 1
No crash happened -- the `error` calls above were genuinely never evaluated.
forcedDemo = 42
strictApply = 4
concurrency demo result: done from another thread
$ echo $?
0
```

The output is identical either way — only the runtime's clean-exit behavior differs. The takeaway for real use: `runghc`/plain `ghc` (non-`-threaded`) is fine for every earlier lesson in this course, but **any program that uses `forkIO`/concurrency should be compiled with `-threaded`** rather than run interpreted, both because that's GHC's own documented recommendation for real concurrent programs and because it visibly avoids this exact hang in this environment.

## Verified Output

```bash
$ ./LazinessAndConcurrency.exe
constDemo (const 42 crashes) = 42
proofFst (fst (1, crashes)) = 1
No crash happened -- the `error` calls above were genuinely never evaluated.
forcedDemo = 42
strictApply = 4
concurrency demo result: done from another thread
```

## Common Mistakes

- **Assuming laziness means "slower" or "deferred but eventually all evaluated anyway"** — it specifically means expressions whose values are never demanded are never evaluated *at all*, not merely delayed; this is a genuine behavioral difference, not just a performance characteristic, as directly demonstrated above.
- **Building up large lazy thunks through repeated (non-strict) accumulation** (echoing Lesson 12's `foldl` vs. `foldl'`) — this is laziness's real practical downside: unevaluated computation can pile up in memory rather than being immediately reduced, sometimes causing space leaks; `seq`/`$!`/`foldl'`/`BangPatterns` are the tools for forcing strictness where profiling shows it's needed.
- **Assuming `forkIO` creates a full OS thread** — it creates a lightweight, GHC-runtime-managed "green" thread; many thousands of `forkIO` threads can coexist cheaply, multiplexed onto a much smaller number of actual OS threads by the runtime scheduler.

## Best Practices

- Rely on laziness for its real, practical wins (infinite/self-referential structures, avoiding computing values that turn out to be unneeded) but reach for strictness annotations (`seq`, `$!`, `foldl'`, `BangPatterns`) once profiling shows a genuine space leak from excessive thunk buildup — don't add strictness reflexively without evidence it's needed.
- Prefer `MVar` for simple one-shot or single-slot producer/consumer communication between threads; reach for more advanced tools (`STM`, `Chan`, `async`) for anything more elaborate than this lesson's scope.
- Remember immutability (Lesson 03) is what makes concurrent Haskell code fundamentally safer by default — there's simply less shared mutable state to race over than in a language where every variable is mutable unless marked otherwise.

## Real-World Usage

Laziness underlies genuinely practical patterns in production Haskell: defining a large or infinite search space declaratively and only computing as much as a consumer (`take`, `find`, short-circuiting `foldr`) actually needs, without manually bounding the computation up front. `forkIO`/`MVar` (and the richer `async`/`STM` libraries built on similar foundations) back real concurrent servers and pipelines, benefiting throughout from immutability's reduced need for locking discipline.

## Summary

- Lazy evaluation means an expression is evaluated only when its value is actually demanded — and genuinely never evaluated if it's never demanded, verified live with an `error`-containing expression that never crashes because nothing ever forces it.
- `seq`/`$!` force strictness where it's specifically wanted, addressing laziness's real downside (potential thunk/space-leak buildup) without abandoning laziness as the default.
- `forkIO` spawns a lightweight, runtime-managed thread; `MVar` is a single-slot mutable box for safe inter-thread communication — both made simpler to reason about by Haskell's pervasive immutability.

## Key Terms

- **Lazy evaluation** — an expression is evaluated only when its value is demanded, and never evaluated at all if it never is.
- **Thunk** — an unevaluated, deferred computation, the internal representation of a not-yet-forced lazy value.
- **`seq`/`$!`** — force an expression to (weak head normal form) evaluation before proceeding, the tools for opting into strictness where laziness's default isn't wanted.
- **`forkIO`/`MVar`** — spawn a lightweight thread / a single-slot mutable box for safe inter-thread communication.

## Interview Questions

1. **How would you prove, not just claim, that Haskell's laziness means an unneeded expression is genuinely never evaluated?**
   Construct an expression that would visibly crash if evaluated (e.g., containing `error "..."`), embed it somewhere a consuming function provably never looks (`const 42 crashingExpr`, or as the second element of a pair only ever accessed via `fst`), and run the program. If it completes successfully with no crash or error output at all, that's direct, live proof — not an inference from documentation — that the crashing sub-expression was never forced. This course's own [LazinessAndConcurrency.hs](LazinessAndConcurrency.hs) does exactly this.

2. **Why is concurrent programming generally considered safer in Haskell than in a language with pervasive mutable variables?**
   Ordinary Haskell values are immutable by default (Lesson 03) — there's no shared mutable state for two threads to race over unless a program deliberately introduces one via `MVar`/`IORef`/`STM`, all of which are visibly typed and narrowly scoped. This shrinks the surface area for data races dramatically compared to a language where every variable is mutable unless explicitly marked otherwise, since most of a Haskell program's data literally cannot change out from under a concurrently-running thread.

## Recommended Next Lesson

[15 — Modules](../15-Modules/README.md)
