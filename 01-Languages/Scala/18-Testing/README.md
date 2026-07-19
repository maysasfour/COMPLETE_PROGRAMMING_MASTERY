# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write unit tests using MUnit (Scala's most common lightweight test framework), obtained directly via Coursier.
- Assert equality (`assertEquals`), booleans (`assert`), and expected exceptions (`intercept`).
- Run a real test suite and get a genuine pass/fail summary without a full build tool.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

**MUnit was obtainable via Coursier** (`org.scalameta:munit_3:1.0.0`) and is used here rather than a hand-rolled harness — it fetched cleanly, along with its transitive dependencies (`munit-diff_3`, a JUnit test-interface bridge, JUnit itself, and Hamcrest), exactly as `sqlite-jdbc` did in Lesson 16. The one real wrinkle: MUnit's *usual* entry point is a build tool's `test` task (sbt, or `scala-cli test`), which drives it through the sbt test-interface. Since this course invokes `scalac`/`scala` directly with no build tool, this lesson instead calls MUnit's own public `munitTests()` method by hand — every `test(...)` block in a `munit.FunSuite` becomes a runnable `Test` value in that sequence — and drives them with a small custom runner that prints a real pass/fail summary, functionally equivalent to what a build tool's test reporter would show.

## The Module Under Test

```scala
object Calculator:
  def add(a: Int, b: Int): Int = a + b
  def divide(a: Int, b: Int): Int =
    if b == 0 then throw ArithmeticException("cannot divide by zero") else a / b
  def isEven(n: Int): Boolean = n % 2 == 0
```

## A Real MUnit Suite

```scala
class CalculatorSuite extends munit.FunSuite:
  test("add: two positive numbers") {
    assertEquals(Calculator.add(2, 3), 5)
  }

  test("divide: by zero throws ArithmeticException") {
    intercept[ArithmeticException] {
      Calculator.divide(1, 0)
    }
  }

  test("isEven: true for even numbers") {
    assert(Calculator.isEven(4))
  }
```

## Running It Without a Build Tool

```scala
val suite = new CalculatorSuite()
val tests = suite.munitTests()          // MUnit's own public API: every `test(...)` as a runnable Test
for t <- tests do
  Await.result(t.body(), 10.seconds)    // each test body returns a Future[Any]; failure = a thrown exception
```

## Detailed Example

See [Calculator.scala](Calculator.scala) (the module under test), [CalculatorSuite.scala](CalculatorSuite.scala) (six real MUnit tests: equality assertions, a boolean assertion, and an expected-exception assertion), and [RunTests.scala](RunTests.scala) (the standalone runner printing a genuine pass/fail summary).

## Run It

```bash
cd 01-Languages/Scala/18-Testing

# Fetch MUnit and its dependencies (once) via Coursier:
cs fetch org.scalameta:munit_3:1.0.0
# note ALL the JAR paths it prints: munit_3, munit-diff_3, junit-interface, test-interface, junit, hamcrest-core

# Compile the module, suite, and runner together against that classpath:
scalac -classpath "<all the munit JARs, semicolon-separated>" Calculator.scala CalculatorSuite.scala RunTests.scala

# Run with java directly (java -cp), including the Scala runtime JARs alongside the MUnit JARs:
java -cp ".;<munit JARs>;<scala3-library_3-jar>;<scala-library-2.13-jar>" runTests
```

## Expected Output

```
PASS  add: two positive numbers
PASS  add: negative numbers
PASS  divide: exact division
PASS  divide: by zero throws ArithmeticException
PASS  isEven: true for even numbers
PASS  isEven: false for odd numbers

6 tests run, 6 passed, 0 failed
```

## Common Mistakes

- Assuming MUnit requires sbt to run at all — it's driven through the sbt test-interface *by convention*, but its `munitTests()` method is public API, usable standalone exactly as shown here.
- Forgetting a test's body in MUnit returns `Future[Any]` (supporting async tests naturally) — a synchronous assertion still needs to be awaited (or otherwise resolved) by the runner, not merely invoked and ignored.
- Writing assertions that don't actually exercise failure paths (like `divide`'s divide-by-zero case) — a suite that only tests the "happy path" misses exactly the bugs most likely to matter.

## Best Practices

- Test both success and failure paths for any function that can fail (as done here for `divide`), using `intercept` for expected exceptions rather than a separate manual `try`/`catch`.
- Keep test names descriptive of the specific behavior under test (`"divide: by zero throws ArithmeticException"`), not just the method name — this reads as living documentation.
- In a real (non-teaching) project, use sbt's `test` task (or `scala-cli test`) to run MUnit — the standalone runner here exists purely because this course is deliberately build-tool-free, not because it's the normal way to run MUnit.

## Real-World Usage

MUnit is one of the two most common Scala test frameworks (alongside ScalaTest) and is what many modern Scala projects (including parts of the Scala 3 compiler's own test suite) use for exactly this style of equality/boolean/exception assertions — run in real projects via `sbt test`, not a hand-rolled runner like this lesson's.

## Summary

- MUnit was successfully obtained via Coursier and used directly (not a hand-rolled harness) — verified live with a real 6-test suite, all passing.
- MUnit's public `munitTests()` API lets it run standalone without sbt, which this lesson does via a small custom runner.
- `assertEquals`, `assert`, and `intercept` cover equality, boolean, and expected-exception assertions respectively.

## Key Terms

- **MUnit** — a lightweight Scala test framework, providing `FunSuite` with `test(...)` blocks and `assertEquals`/`assert`/`intercept` assertions.
- **`munitTests()`** — MUnit's public API exposing every declared test as a runnable `Test` value, used here to drive tests without sbt.
- **`intercept[E]`** — asserts that a block throws an exception of type `E`, failing the test if it doesn't.

## Interview Questions

1. **Was MUnit actually usable in this dependency-minimal, build-tool-free course, and how was it run?** — Yes: MUnit (`org.scalameta:munit_3:1.0.0`) was fetched cleanly via Coursier along with its transitive dependencies, the same mechanism used for `sqlite-jdbc` in Lesson 16. Since this course has no sbt project to drive MUnit through its usual `test` task, a small standalone runner was written that calls MUnit's own public `munitTests()` method to get every `test(...)` block as a runnable `Test`, awaits each one's `Future[Any]` body, and prints a pass/fail summary — verified live with a real 6-test suite that reported "6 tests run, 6 passed, 0 failed."
2. **How does `intercept[E]` differ from a manual `try`/`catch` for testing that code throws, and why prefer it?** — `intercept[E] { ... }` runs the block and asserts that it throws specifically an exception of type `E`, failing the test both if nothing is thrown *and* if the wrong exception type is thrown — a manual `try`/`catch` that merely catches and ignores an exception would incorrectly pass even if no exception occurred at all (silently missing a broken code path), unless carefully written to fail explicitly in the no-exception case. This lesson's `intercept[ArithmeticException] { Calculator.divide(1, 0) }` fails loudly if `divide` stops throwing on zero, exactly the protection a manual catch-and-ignore would miss.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
