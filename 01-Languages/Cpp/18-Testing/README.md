# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with Catch2, a popular C++ testing framework.
- Use `TEST_CASE`/`REQUIRE` for assertions and `GENERATE` for parameterized tests.
- Assert on thrown exceptions with `REQUIRE_THROWS_AS`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

C++ has no built-in testing framework — like Java's JUnit and C#'s xUnit, Catch2 (or Google Test, another popular option) is a third-party library. This lesson uses Catch2's **amalgamated** distribution (a single header + single source file, the same "no complex build setup" pattern as Lesson 16's SQLite and Lesson 17's cpp-httplib), keeping this lesson runnable without a package manager.

## `TEST_CASE`/`REQUIRE`

```cpp
#define CATCH_CONFIG_MAIN // exactly one file in the project must define this -- it supplies main()
#include "catch_amalgamated.hpp"
#include "mathutils.hpp"

TEST_CASE("add sums two positive numbers", "[math]") {
    REQUIRE(add(2, 3) == 5);
}
```

`TEST_CASE("description", "[tag]")` defines a single test; `REQUIRE(condition)` is Catch2's core assertion — the tag (`[math]`) lets you selectively run subsets of tests later via the command line.

## `GENERATE` for Parameterized Tests

```cpp
TEST_CASE("add parameterized cases", "[math]") {
    auto [a, b, expected] = GENERATE(table<int, int, int>({
        {1, 1, 2},
        {0, 0, 0},
        {-1, 1, 0}
    }));
    REQUIRE(add(a, b) == expected);
}
```

`GENERATE(table<...>({...}))` runs the same `TEST_CASE` body once per row — Catch2's equivalent of xUnit's `[InlineData]`, JUnit's `@CsvSource`, and pytest's `@parametrize`.

## Asserting on Exceptions

```cpp
TEST_CASE("divideValues throws on division by zero", "[math]") {
    REQUIRE_THROWS_AS(divideValues(10, 0), std::invalid_argument);
}
```

## Detailed Example

See [mathutils.hpp](mathutils.hpp)/[mathutils.cpp](mathutils.cpp) (module under test) and [test_mathutils.cpp](test_mathutils.cpp) (Catch2 tests).

## Run It

```bash
cd 01-Languages/Cpp/18-Testing
curl -L -o catch_amalgamated.hpp "https://raw.githubusercontent.com/catchorg/Catch2/v3.7.1/extras/catch_amalgamated.hpp"
curl -L -o catch_amalgamated.cpp "https://raw.githubusercontent.com/catchorg/Catch2/v3.7.1/extras/catch_amalgamated.cpp"
g++ -std=c++20 test_mathutils.cpp mathutils.cpp catch_amalgamated.cpp -o tests && ./tests
# or, from an MSVC Developer Command Prompt:
cl /EHsc /std:c++20 /Zc:__cplusplus test_mathutils.cpp mathutils.cpp catch_amalgamated.cpp /Fe:tests.exe && tests.exe
```

(As with Lesson 16's SQLite files, the Catch2 amalgamated files are deliberately not committed — downloaded on demand and covered by `.gitignore`.)

## Expected Output

Catch2 reports `All tests passed (7 assertions in 5 test cases)` (4 `TEST_CASE`s plus 3 `GENERATE`-driven rows from one parameterized case).

## Common Mistakes

- Defining `CATCH_CONFIG_MAIN` in more than one file — it supplies the actual `main()` function; only one translation unit in the whole test binary should define it.
- Forgetting `REQUIRE_THROWS_AS` needs the risky call as an argument expression, not pre-evaluated — Catch2 evaluates it internally under its own exception-catching machinery.

## Best Practices

- Use `GENERATE`/`table<...>` for testing the same logic across multiple input/output pairs instead of near-duplicate `TEST_CASE`s.
- Use tags (`"[math]"`) to organize tests into runnable subsets as a test suite grows.

## Real-World Usage

Catch2 (and Google Test) are the two dominant C++ testing frameworks; CI pipelines run the compiled test binary directly (there's no separate `pytest`/`dotnet test`-style command — the test framework's `main()` *is* the test runner), exactly analogous to running any other compiled executable.

## Summary

- Catch2 (or Google Test) is a third-party testing framework — C++ has no built-in equivalent to JUnit/xUnit/pytest.
- `TEST_CASE`/`REQUIRE` define tests and assertions; `GENERATE`/`table<...>` parameterizes a test across multiple input sets.
- `REQUIRE_THROWS_AS` tests that an expression throws a specific exception type.

## Key Terms

- **Catch2** — a popular, header-only C++ testing framework.
- **`GENERATE`** — Catch2's mechanism for running the same test body across multiple sets of input data.

## Interview Questions

1. **Does C++ have a built-in testing framework, like Java's JUnit or C#'s xUnit?**
   No — C++ has no built-in testing framework at all. Catch2 and Google Test are the two dominant third-party options; this lesson uses Catch2's single-header-plus-source "amalgamated" distribution specifically to avoid needing a package manager for a lesson-sized example.

2. **How does Catch2's test binary get run, compared to `pytest`/`dotnet test`/`node --test`?**
   Exactly one source file defines `CATCH_CONFIG_MAIN`, which causes Catch2 to supply the program's actual `main()` function — compiling the tests produces a genuine standalone executable that, when run directly, discovers and executes every `TEST_CASE` in the binary and reports results. There's no separate external test-runner command the way `pytest`/`dotnet test` are; the compiled test binary itself is the runner.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
