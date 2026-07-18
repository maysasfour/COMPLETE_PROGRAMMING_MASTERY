# Haskell

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Haskell Is

Haskell is a statically-typed, **purely functional** programming language with lazy evaluation. "Purely functional" is not just a marketing description here — Haskell's type system (via the `IO` type) makes side effects (printing, file I/O, networking, mutation) a visible, compiler-checked part of a function's signature, rather than something any function might silently do. This is a genuinely different mental model from every imperative/OOP language in this repository (Python, JavaScript, Java, C#, Go, Rust's non-`unsafe` code still allows mutation freely) — a function with no `IO` in its type is *guaranteed*, not just conventionally expected, to be a pure, deterministic computation.

## Why / Where It's Used

- **Financial and blockchain systems** — Haskell's strong correctness guarantees (no null, exhaustive pattern matching, explicit effects) make it attractive where bugs are expensive; Standard Chartered, IOHK (Cardano), and several trading firms use it in production.
- **Compilers and language tooling** — Haskell's own compiler (GHC) is written in Haskell, and its algebraic data types plus pattern matching are a natural fit for writing parsers/interpreters/compilers generally.
- **Academic research and teaching** — Haskell is the most common vehicle for teaching functional programming and type theory concepts that later show up (in weaker form) across mainstream languages (Rust's `Option`/`Result` are directly descended from Haskell's `Maybe`/`Either`, seen firsthand in [09-Error-Handling](09-Error-Handling/README.md)).
- **High-assurance and formally-adjacent software** — Haskell's type system is expressive enough to encode real invariants at compile time, appealing where correctness matters more than raw development speed.

## Advantages

- A genuinely different, powerful guarantee: functions with no `IO` in their type cannot have hidden side effects, checked by the compiler, not just assumed by convention — this is what made [18-Testing](18-Testing/README.md)'s tests trivial to write with no mocking.
- Exhaustive pattern matching (checked with `-Wincomplete-patterns`) catches "forgot to handle a case" bugs at compile time rather than at runtime.
- Laziness by default enables genuinely infinite data structures ([14-Laziness-and-Concurrency](14-Laziness-and-Concurrency/README.md)) and can eliminate whole categories of "computed but never used" waste — though it is also a real, non-trivial source of its own pitfalls (see [21-Solutions](21-Solutions/README.md) Problem 6's `foldl` vs `foldl'` timing).
- A famously expressive, powerful type system (type classes, `Maybe`/`Either`, algebraic data types) that catches entire bug categories — null-pointer-style errors, unhandled-case errors — before the program ever runs.

## Disadvantages

- A steep learning curve for programmers coming from imperative languages — laziness, purity, and monadic `IO` are genuinely different mental models, not just new syntax over familiar concepts.
- Reasoning about performance (especially with laziness — thunk buildup, space leaks) requires understanding evaluation order in a way strict languages don't demand nearly as often.
- A smaller production ecosystem and hiring pool than mainstream languages in this repository, and (as seen firsthand in this course) no prebuilt Windows binary packages on Hackage — every dependency in Lessons 16–18 and 22 had to be compiled from source in this environment, a real, observed cost documented honestly in each of those lessons.

## How to Install

This course was built and verified in an environment with **no admin rights and no prebuilt Windows Hackage binaries** — see [01-Setup](01-Setup/README.md) for the full, honestly-documented account of what was tried (Chocolatey's `ghc`/`cabal` packages genuinely failed here) and what actually worked (direct GHC/`cabal-install` bindist downloads, extracted with no installer). On a normal machine, use **[GHCup](https://www.haskell.org/ghcup/)** instead — it is the officially recommended installer and manages GHC/Cabal/Stack versions for you:

```bash
# Recommended on a normal machine:
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghc --version
cabal --version
```

This course was written and verified against **GHC 9.8.2** and **cabal-install 3.10.2.0**.

## How to Run the Examples

Lessons 01–15 are single `.hs` files with no external dependencies — run them directly:

```bash
cd 01-Languages/Haskell/05-Control-Flow
runghc ControlFlow.hs        # interpret directly, no artifacts left behind
# or:
ghc -o ControlFlow ControlFlow.hs && ./ControlFlow.exe
# or, interactively:
ghci ControlFlow.hs
```

Lessons 16, 17, 18, and 22 depend on external packages (`sqlite-simple`, `http-conduit`+`aeson`, `hspec`) and are real Cabal projects — `cd` into their project subfolder and use `cabal build`/`cabal run`/`cabal test`, exported PATH first (see [01-Setup](01-Setup/README.md) for the exact PATH export this environment needed).

## Common Beginner Mistakes

- **Assuming Haskell has exceptions for everyday error handling** — idiomatic Haskell uses `Maybe`/`Either` as ordinary values ([09-Error-Handling](09-Error-Handling/README.md)) for "this might fail," reserving real exceptions for genuinely exceptional situations (a missing file, a network failure).
- **Calling partial functions (`head`, `fromJust`, `!!`) without checking they're safe for the input** — a real, reproduced runtime crash and its fix are documented in [19-Best-Practices](19-Best-Practices/README.md).
- **Forgetting `OverloadedStrings`** when a library expects its own string-like newtype (`sqlite-simple`'s `Query`, `http-conduit`'s URL argument) — hit live and documented in both [16-Database-Access](16-Database-Access/README.md) and [17-API-Integration](17-API-Integration/README.md).
- **Assuming `httpLBS`/`fetch`-style HTTP calls throw on a 404/500** — they don't by default; checking the status code explicitly is the caller's job ([17-API-Integration](17-API-Integration/README.md)).
- **Treating laziness as "free," with no performance cost** — `foldl` on a large list can build a long chain of unevaluated thunks before ever adding anything; `Data.List.foldl'` forces the accumulator instead, a real ~23x speed difference was observed for a 5-million-element sum in this course's own testing ([21-Solutions](21-Solutions/README.md)).

## Best Practices

- Push `IO` to the edges of a program; keep the actual logic in pure functions with no `IO` in their type ([19-Best-Practices](19-Best-Practices/README.md)) — this is what makes Hspec testing this simple ([18-Testing](18-Testing/README.md)).
- Prefer total functions (`Maybe`/`Either`-returning, or exhaustive pattern matches) over partial ones; treat GHC's `-Wx-partial`/`-Wincomplete-patterns` warnings as real signals to fix, not noise to silence.
- Always use parameterized queries for database access ([16-Database-Access](16-Database-Access/README.md)) and check HTTP status codes explicitly ([17-API-Integration](17-API-Integration/README.md)) — the same cross-language disciplines this repository's other courses establish, just verified here for Haskell's own libraries.
- Use `foldl'` (not `foldl`) for strict accumulation over large lists; use `foldr` when the combining function can short-circuit or the result is itself lazily consumable.

## Interview Questions

1. **What makes Haskell "purely functional," and why does that matter in practice?**
   A function with no `IO` in its type signature is guaranteed by the compiler to have no hidden side effects — no file access, printing, mutation, or networking — meaning calling it twice with the same arguments always produces the same result (referential transparency). This matters practically because it makes equational reasoning, safe refactoring, and mock-free testing all possible ([18-Testing](18-Testing/README.md), [19-Best-Practices](19-Best-Practices/README.md)) — a benefit other languages can only get by convention/discipline, since their type systems don't distinguish pure from effectful functions.

2. **How do `Maybe` and `Either` replace exceptions for everyday error handling, and what are their closest analogues elsewhere?**
   `Maybe a` (`Nothing | Just a`) represents a value that might be absent; `Either e a` (`Left e | Right a`) represents a value or an explanation of failure. Both are ordinary values, pattern-matched or chained with `>>=`/do-notation, forcing the caller to handle the failure case explicitly rather than an exception silently propagating past unaware code. Rust's `Option<T>`/`Result<T, E>` were explicitly modeled on these ([09-Error-Handling](09-Error-Handling/README.md)); Haskell keeps real exceptions (`Control.Exception`) for genuinely exceptional situations only.

3. **What's the practical downside of Haskell's laziness, and how is it mitigated?**
   Laziness means expressions aren't evaluated until their result is actually demanded, which enables genuinely infinite structures ([14-Laziness-and-Concurrency](14-Laziness-and-Concurrency/README.md)) but can also cause "thunk buildup" — unevaluated computations accumulating in memory instead of being computed and discarded, sometimes called a space leak. `Data.List.foldl'` (strict left fold) is the standard mitigation for accumulation over large lists, forcing the accumulator at each step instead of deferring it; this course measured a real ~23x speed difference between `foldl` and `foldl'` summing five million integers ([21-Solutions](21-Solutions/README.md)).

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing GHC/Cabal, `runghc`/`ghci`/`ghc`, this environment's no-admin-rights bindist workaround |
| 02 | [Syntax](02-Syntax/README.md) | `main :: IO ()`, expressions, indentation-based layout, comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Immutability by default, `Int`/`Integer`/`Double`/`Char`/`Bool`, type inference |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/boolean operators, no implicit conversions |
| 05 | [Control Flow](05-Control-Flow/README.md) | `if`/guards/`case`, pattern matching as control flow |
| 06 | [Functions](06-Functions/README.md) | Currying, partial application, point-free style |
| 07 | [Collections](07-Collections/README.md) | Lists, infinite lists, list comprehensions, tuples |
| 08 | [Strings](08-Strings/README.md) | `String` as `[Char]`, `Data.Text` for real performance |
| 09 | [Error Handling](09-Error-Handling/README.md) | `Maybe`, `Either`, partial functions as an anti-pattern |
| 10 | [File Handling](10-File-Handling/README.md) | `IO`, `readFile`/`writeFile`, `IO` as the effect boundary |
| 11 | [Type Classes](11-Type-Classes/README.md) | `Eq`/`Ord`/`Show`, `deriving`, custom type classes |
| 12 | [Higher-Order Functions](12-Higher-Order-Functions/README.md) | `map`/`filter`/`fold`, function composition (`.`) |
| 13 | [Type System and Generics](13-Type-System-and-Generics/README.md) | Parametric polymorphism, algebraic data types |
| 14 | [Laziness and Concurrency](14-Laziness-and-Concurrency/README.md) | Lazy evaluation, infinite structures, `Control.Concurrent` |
| 15 | [Modules](15-Modules/README.md) | `module`/`import`, exposing/hiding names |
| 16 | [Database Access](16-Database-Access/README.md) | SQLite via `sqlite-simple`, parameterized queries, `OverloadedStrings` |
| 17 | [API Integration](17-API-Integration/README.md) | HTTP via `http-conduit`, JSON via `aeson`, `Generic`-derived `FromJSON` |
| 18 | [Testing](18-Testing/README.md) | Hspec, `describe`/`it`/`shouldBe`, library + test-suite Cabal structure |
| 19 | [Best Practices](19-Best-Practices/README.md) | Purity as discipline, a real reproduced partial-function crash, point-free tradeoffs |
| 20 | [Exercises](20-Exercises/README.md) | 6 standalone problems: pattern matching, `Maybe`/`Either`, type classes, HOFs, laziness |
| 21 | [Solutions](21-Solutions/README.md) | Verified, actually-run solutions to all 6 exercises, including a real `foldl`/`foldl'` timing comparison |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — `sqlite-simple` persistence, pure core/`IO` shell, Hspec test suite |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order — Lesson 03's immutability and Lesson 09's `Maybe`/`Either` are foundational to almost everything after them, and Lesson 10's `IO` boundary is a prerequisite for understanding Lessons 16–18's real Cabal projects. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs of their own. After 19, [20-Exercises](20-Exercises/README.md) → [21-Solutions](21-Solutions/README.md) → [22-Mini-Projects](22-Mini-Projects/README.md) close out the course with cross-cutting practice problems and a complete CLI Task Tracker application.

**Previous language:** see the [Languages overview](../README.md) for the full course list.
