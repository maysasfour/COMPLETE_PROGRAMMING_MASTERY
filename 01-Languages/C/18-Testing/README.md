# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Understand C ships with **zero** built-in or de-facto-standard test framework — no JUnit/pytest/xUnit/Catch2 equivalent at all.
- Build and use a minimal, hand-rolled, macro-based assert harness (`minitest.h`).
- See a genuinely failing assertion (not just passing ones) to confirm the harness actually detects bugs.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Every other language course in this repository reaches for an established test framework (pytest, JUnit, xUnit, `node:test`, Catch2/GoogleTest for C++). C has no standard-library testing support and no single de-facto framework the way C++ leans on Catch2 — real C projects either pull in a third-party library (Unity, CMocka, `check`) or, extremely commonly for small-to-medium codebases, write a small `assert`-and-`printf`-based harness by hand, exactly as this lesson does. `minitest.h` is that harness: a handful of macros wrapping `printf` and two global counters — no test discovery, no runner binary, no reflection. Every "test" is just an ordinary `static void` function; `TEST_CASE` is a naming-convention macro, not a registration mechanism, and every test must be invoked explicitly via `RUN_TEST` inside `main`.

## Syntax

```c
#include "minitest.h"

TEST_CASE(test_add) {
    ASSERT_EQ_INT(5, add(2, 3));
}

int main(void) {
    RUN_TEST(test_add);
    MINITEST_SUMMARY();
    return MINITEST_EXIT_CODE();
}
```

`ASSERT_EQ_INT`/`ASSERT_EQ_STR`/`ASSERT_TRUE` each increment a global pass/fail counter and print a `FAIL:` line (with the failing expression and line number) on failure, but — unlike a real framework — never stop the enclosing test function early; a test with three failing assertions runs and reports all three, not just the first.

## Detailed Example

See [example.c](example.c) and [minitest.h](minitest.h) — four tests against `add`, `isEven`, and two versions of a `clamp` function: `clampFixed` (correct) and `clampBuggy` (a deliberately real bug — missing the upper-bound check). The buggy version's test is written to genuinely fail, not just be described as buggy.

## Run It

```bash
cd 01-Languages/C/18-Testing
cl /std:c17 /nologo example.c
example.exe
```

## Expected Output

```
Running test_add...
Running test_isEven...
Running test_clamp_buggy_version_genuinely_fails...
  FAIL: 10 == clampBuggy(15, 0, 10) (line 45): expected 10, got 15
Running test_clamp_fixed_version_passes...

9 passed, 1 failed, 10 total
```

Genuinely compiled and run with MSVC 19.51 (`cl /std:c17 /nologo example.c`, then `example.exe`) during course construction — the exit code is `1` (via `MINITEST_EXIT_CODE()`), matching the real failed assertion; this is not a fabricated all-green run.

## Common Mistakes

- Assuming C has *some* built-in `assert`-based test runner beyond `<assert.h>`'s `assert()` macro — `assert()` exists (it aborts the process on a false condition) but is a debugging aid, not a test framework: it can't report "9 passed, 1 failed," and a failed `assert()` terminates the whole process rather than continuing to the next test.
- Writing a `TEST_CASE` function and forgetting to add a matching `RUN_TEST` call in `main` — since there is no test discovery, an un-called test function silently never runs and reports nothing, with no warning.
- Not returning `MINITEST_EXIT_CODE()` from `main` — without it, a CI script checking the process exit code would see `0` (success) even when assertions genuinely failed, since the printed `FAIL:` lines alone don't affect the exit code.

## Best Practices

- Return `MINITEST_EXIT_CODE()` from `main` so failures are machine-detectable (exit code), not just human-readable in scrollback.
- Keep each `TEST_CASE` function testing one logical behavior — since assertions don't stop a test function, a test that silently swallows an early failure and keeps testing unrelated things afterward produces confusing multi-line `FAIL:` output.
- For real projects beyond a repository-scale example, prefer an established framework (Unity or CMocka) over reinventing one — this lesson's hand-rolled harness is deliberately minimal to show what "no framework" looks like, not a recommendation to always roll your own.

## Real-World Usage

SQLite itself (the library used in Lesson 16) ships with its own enormous hand-rolled C test harness (`TH3`/`testfixture`) rather than a third-party framework — this lesson's `minitest.h` is a miniature version of the exact same real-world pattern: `printf`-based assertions, manual test registration, counters tracked in plain variables.

## Summary

- C has no built-in or de-facto-standard test framework — `minitest.h` shows what a minimal hand-rolled one looks like: macros, global counters, and manual `RUN_TEST` registration.
- `assert()` from `<assert.h>` is a debugging aid (aborts the process), not a substitute for a real pass/fail-counting test harness.
- Genuinely compiled and run, including a real failing assertion (`clampBuggy`), proving the harness detects actual bugs rather than only displaying passing tests.

## Key Terms

- **Test harness** — the surrounding machinery (assertion macros, counters, a runner) that executes test functions and reports results; here, entirely hand-rolled.
- **Assertion macro** — a macro that checks a condition, records pass/fail, and prints diagnostic detail on failure, without stopping execution (unlike `assert()`, which aborts).

## Interview Questions

1. **Does C have a built-in test framework? What does `assert()` from `<assert.h>` actually do, and why isn't it one?**
   No — C has no built-in test framework and no single de-facto-standard one. `assert()` checks a condition and, if false, prints a diagnostic and calls `abort()`, immediately terminating the whole process. That makes it a debugging aid for catching invariant violations during development, not a test framework: it can't continue past a failure to run remaining tests, can't accumulate a pass/fail count, and is typically compiled out entirely in release builds via `NDEBUG`.

2. **In `minitest.h`, why does `RUN_TEST` need to be called explicitly for every test, and what happens if you forget?**
   There is no test discovery mechanism in C — no reflection, no annotations like JUnit's `@Test` that a runner scans for at startup. Every `TEST_CASE` is just an ordinary function; it only executes if something calls it, which here is `RUN_TEST` inside `main`. Forgetting a `RUN_TEST` call means the test function is compiled into the binary but never invoked — it silently contributes nothing to the pass/fail counts and produces no output at all, with no error or warning to flag the omission.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
