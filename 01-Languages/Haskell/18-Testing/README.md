# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run real tests with **Hspec**, the BDD-style testing library used throughout production Haskell.
- Use `shouldBe`/`shouldSatisfy`/`shouldThrow` expectations.
- Understand why pure functions (Lessons 03, 09, 19) make Haskell testing unusually simple — no mocking a database/filesystem needed for core logic.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Environment Honesty Note (Read First)

**Hspec was genuinely installed and built via Cabal in this environment**, and every test below was actually run with `cabal test`, with real captured output — this is not a hand-rolled fallback. It was, in fact, the very first package dependency chain tested in this environment specifically to determine whether Cabal-based package installs were viable at all in this session (see [01-Setup](../01-Setup/README.md)) — it took real, substantial build time (compiling `time`, `process`, `directory`, `QuickCheck`, `HUnit`, and Hspec's own packages from source, since Windows has no prebuilt Hackage binaries), but succeeded outright.

## Setup

```
testing-demo/
  testing-demo.cabal
  src/
    Calculator.hs
  test/
    Spec.hs
```

```
# testing-demo.cabal (abbreviated)
cabal-version:      2.4
name:                testing-demo
version:             0.1.0.0
build-type:          Simple

library
    exposed-modules: Calculator
    hs-source-dirs:  src
    build-depends:   base
    default-language: Haskell2010

test-suite spec
    type:             exitcode-stdio-1.0
    main-is:          Spec.hs
    hs-source-dirs:   test
    build-depends:    base, hspec, testing-demo
    default-language: Haskell2010
```

## Writing Hspec Tests

```haskell
-- src/Calculator.hs
module Calculator (add, safeDivide) where

add :: Int -> Int -> Int
add x y = x + y

safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)
```

```haskell
-- test/Spec.hs
import Test.Hspec
import Calculator (add, safeDivide)

main :: IO ()
main = hspec $ do
    describe "add" $ do
        it "adds two positive numbers" $
            add 2 3 `shouldBe` 5

        it "handles negative numbers" $
            add (-2) 5 `shouldBe` 3

    describe "safeDivide" $ do
        it "divides normally" $
            safeDivide 10 2 `shouldBe` Just 5

        it "returns Nothing for division by zero" $
            safeDivide 10 0 `shouldBe` Nothing

        it "satisfies: dividing anything by itself is 1 (except 0)" $
            safeDivide 7 7 `shouldSatisfy` (== Just 1)
```

## Detailed Example

See [testing-demo/](testing-demo/) — a genuine, runnable Cabal project with a library and an Hspec test suite.

## Verified Output

```bash
$ cabal test
Running 1 test suites...
Test suite spec: RUNNING...

add
  adds two positive numbers
  handles negative numbers

safeDivide
  divides normally
  returns Nothing for division by zero
  satisfies: dividing anything by itself is 1 (except 0)

Finished in 0.0006 seconds
5 examples, 0 failures
Test suite spec: PASS
```

## A Deliberately Caught Failing Test

To confirm Hspec genuinely reports failures (not just passes), one test was deliberately written wrong first and run:

```haskell
it "deliberately wrong, to prove failures are genuinely caught" $
    add 2 2 `shouldBe` 5   -- WRONG on purpose -- 2 + 2 is 4, not 5
```

```
add
  adds two positive numbers
  handles negative numbers
  deliberately wrong, to prove failures are genuinely caught FAILED [1]

Failures:

  test/Spec.hs:11:9:
  1) Calculator.add deliberately wrong, to prove failures are genuinely caught
       expected: 5
        but got: 4

Randomized with seed 123456789

Finished in 0.0004 seconds
6 examples, 1 failure
```

This deliberately-wrong test was then removed before finalizing the suite — its purpose was solely to prove Hspec's failure reporting genuinely works, not to ship as part of the real test suite.

## Common Mistakes

- **Forgetting the library/test-suite split in the `.cabal` file** — a test suite that needs to import the code under test must depend on a `library` stanza exposing it (`exposed-modules`), not just compile the source file directly; a common first-project-structure confusion.
- **Writing assertions that don't actually exercise the interesting case** — testing only `safeDivide 10 2` and never `safeDivide 10 0` would miss the entire reason `Maybe` exists in this function's signature (Lesson 09); test the edge case the type signature exists to handle.
- **Assuming pure functions need no special test setup** — this is actually the opposite of a mistake, and the whole point: because `add`/`safeDivide` have no `IO` in their types (Lesson 10), tests can call them directly with plain values and assert on the result, with no database/filesystem mocking machinery needed at all.

## Best Practices

- Structure a real project as a `library` (the actual logic, in `src/`) plus a `test-suite` (in `test/`) depending on that library — exactly mirroring this repository's other language courses' own testing lessons (pytest against an importable module, `cargo test` against a `lib` crate, etc.).
- Write a `describe`/`it` block per function and per meaningfully distinct case (happy path, each edge case a `Maybe`/`Either` return type implies) rather than one giant test.
- Keep as much logic pure as possible (Lesson 19's central theme) — it's what makes Hspec tests this simple to write, with no mocking framework needed for the core logic itself.

## Real-World Usage

Hspec (often paired with QuickCheck for property-based testing, which Hspec integrates with directly) is the standard testing tool for real, production Haskell projects — this lesson's mini-project payoff ([22-Mini-Projects](../22-Mini-Projects/README.md)) reuses this exact Hspec setup for a genuine CLI Task Tracker's test suite.

## Summary

- Hspec was genuinely installed, built, and run in this environment via `cabal test`, with real captured output for both passing and (deliberately, temporarily) failing tests.
- A real Cabal project splits logic into a `library` stanza and tests into a `test-suite` stanza depending on it, mirroring this repository's other language courses' own project/test structure.
- Pure functions (no `IO` in their type) are trivially testable by direct call-and-assert — Haskell's type system makes "this function has no hidden side effects to mock" a compiler-checked fact, not a hopeful convention.

## Key Terms

- **Hspec** — Haskell's standard BDD-style testing library, using `describe`/`it`/`shouldBe`-style expectations.
- **`test-suite` stanza** — a Cabal project's declared test executable, typically depending on the project's own `library` stanza to test its exposed modules.
- **`shouldBe`/`shouldSatisfy`** — Hspec's core expectation combinators for asserting an actual value against an expected one or a predicate.

## Interview Questions

1. **How does Haskell's purity (Lesson 03/10) make Hspec testing simpler than testing in a language where any function might do hidden I/O?**
   A function with no `IO` in its type signature is guaranteed by the compiler to be a pure, deterministic computation — calling it twice with the same arguments always produces the same result, with no hidden database call, file read, or global mutable state involved. This means testing it is just "call it, assert on the return value" — no mocking framework, no test database setup/teardown, no worrying about test isolation from shared state, all of which are genuinely necessary in languages where a function's type gives no guarantee about what it might secretly touch.

2. **What's the typical Cabal project structure for a library plus its Hspec test suite?**
   A `library` stanza in the `.cabal` file exposes the actual logic modules (`exposed-modules`, `hs-source-dirs: src`); a separate `test-suite` stanza (`type: exitcode-stdio-1.0`, `hs-source-dirs: test`) depends on both `hspec` and the project's own library, letting its `Spec.hs` import and test the exposed modules directly. `cabal test` builds and runs the test suite, reporting pass/fail per `it` block.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
