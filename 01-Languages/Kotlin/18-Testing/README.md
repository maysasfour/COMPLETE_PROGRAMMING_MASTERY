# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write tests using `kotlin.test` — Kotlin's framework-agnostic assertion library, running on top of a real test engine (JUnit 5 here).
- Use `@Test`/`@BeforeTest`/`assertEquals`/`assertFailsWith` and table-driven-style testing with `Triple`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Kotlin's standard distribution bundles `kotlin.test`, a thin, framework-agnostic assertion/annotation API (`@Test`, `assertEquals`, etc.) that delegates to an actual underlying test engine chosen at compile/link time — this lesson uses the JUnit 5 binding (`kotlin-test-junit5`), so `kotlin.test.Test` is literally a type alias for `org.junit.jupiter.api.Test` underneath. This lets Kotlin test code use consistent, idiomatic `kotlin.test` naming while still running on JUnit 5's mature test engine and tooling.

## A `kotlin.test` Test Class

```kotlin
class CalculatorTest {
    private lateinit var calc: Calculator // non-null property, initialized later (not at declaration)

    @BeforeTest
    fun setUp() {
        calc = Calculator() // runs before EVERY test method -- fresh instance each time
    }

    @Test
    fun addsTwoPositiveNumbers() {
        assertEquals(5, calc.add(2, 3))
    }
}
```

`lateinit var` declares a non-null property whose initialization is deferred past the point of declaration — appropriate here since `calc` is genuinely non-null by the time any test runs (`@BeforeTest`'s `setUp()` always runs first), but can't be initialized inline at the property declaration itself.

## Table-Driven Testing with `Triple`

```kotlin
@Test
fun dividesCorrectly() {
    val cases = listOf(Triple(10.0, 2.0, 5.0), Triple(9.0, 3.0, 3.0), Triple(-6.0, 2.0, -3.0))
    for ((a, b, expected) in cases) {
        assertEquals(expected, calc.divide(a, b), "divide($a, $b) failed")
    }
}
```

Kotlin has no dedicated "table test" construct (JUnit 5's `@ParameterizedTest` is available but adds its own annotation complexity) — a plain `List<Triple<...>>` destructured in a `for` loop achieves the same effect concisely, mirroring the array-of-tuples pattern from this repository's Rust course.

## Testing Thrown Exceptions

```kotlin
val exception = assertFailsWith<IllegalArgumentException> {
    calc.divide(5.0, 0.0)
}
assertEquals("division by zero", exception.message)
```

## Detailed Example

See [src/Calculator.kt](src/Calculator.kt) (the code under test) and [tests/CalculatorTest.kt](tests/CalculatorTest.kt) (5 tests: two plain assertions, one table-driven division test, one exception test, and one palindrome test covering four cases).

## Run It

```bash
cd 01-Languages/Kotlin/18-Testing
# Requires kotlin-test.jar + kotlin-test-junit5.jar (bundled with kotlinc's lib/ directory)
# and junit-platform-console-standalone.jar (downloaded separately, not committed) --
# an argfile sidesteps a real, encountered issue where kotlinc's .bat wrapper mis-splits
# a semicolon-separated -cp value passed directly on the command line.
kotlinc "@args.txt" # args.txt: -cp "<3 jars, semicolon-separated>" -d out tests/*.kt src/*.kt
java -jar junit-platform-console-standalone.jar execute \
    --classpath "out;<kotlin-stdlib.jar>;<kotlin-test.jar>;<kotlin-test-junit5.jar>" \
    --scan-classpath --details=tree
```

## Expected Output

Running the JUnit console launcher prints a tree of all 5 discovered tests under `CalculatorTest`, ending with `5 tests successful` and `0 tests failed`.

## Common Mistakes

- Passing a multi-entry, semicolon-separated `-cp` value directly to `kotlinc` on Windows — this environment's `kotlinc.bat` wrapper was found to mis-split it, treating later classpath entries as source file arguments instead (`error: source entry is not a Kotlin file`); an `@argfile` (a text file containing the arguments, passed as `kotlinc @args.txt`) sidesteps this specific issue.
- Forgetting both `kotlin-test.jar` and `kotlin-test-junit5.jar` are needed together — `kotlin-test.jar` alone provides the `kotlin.test` package but not the actual `@Test`/`@BeforeTest` annotation bindings, which come from the framework-specific binding JAR (`kotlin-test-junit5.jar` here).
- Using `lateinit var` for a property that legitimately might never be initialized before use — accessing an uninitialized `lateinit` property throws `UninitializedPropertyAccessException` at that access point, not at declaration time.

## Best Practices

- Use `@BeforeTest` to reset test fixtures before every test method, avoiding shared mutable state leaking between tests.
- Use `lateinit var` (not a nullable `var calc: Calculator? = null`) for test fixtures guaranteed to be set up before every test runs — it avoids unnecessary null-checking noise in every test method.
- Prefer plain data structures (`Triple`, data classes) with a `for` loop for table-driven tests over more elaborate parameterization machinery, unless the added structure of `@ParameterizedTest` genuinely earns its complexity.

## Real-World Usage

Real Kotlin projects almost always use Gradle to manage JUnit 5 and `kotlin-test` dependencies declaratively (rather than manually downloading and combining JARs, as this install-free lesson does) — `kotlin.test`'s framework-agnostic API is specifically designed so test code doesn't need to hardcode JUnit-specific imports directly, in case a project's underlying test engine ever changes.

## Summary

- `kotlin.test` is a thin, framework-agnostic assertion/annotation layer that delegates to a real test engine (JUnit 5 here) via a separate binding JAR.
- `@BeforeTest`/`@Test`/`assertEquals`/`assertFailsWith` provide familiar, JUnit-like testing idioms with Kotlin-native naming.
- A genuine environment quirk was found and worked around: `kotlinc.bat`'s handling of multi-entry classpath strings required an `@argfile` rather than a direct command-line `-cp` argument.

## Key Terms

- **`kotlin.test`** — Kotlin's framework-agnostic test assertion/annotation API, requiring a separate binding JAR (e.g., `kotlin-test-junit5`) to actually run.
- **`lateinit var`** — a non-null property whose initialization is deferred past its declaration point.

## Interview Questions

1. **Why does a Kotlin test file need both `kotlin-test.jar` and `kotlin-test-junit5.jar` on the classpath, rather than just one?**
   `kotlin-test.jar` provides the `kotlin.test` package itself — but its `Test`/`BeforeTest` annotations and assertion functions are designed to be framework-agnostic, meaning the actual concrete implementations come from a separate binding JAR specific to whichever test engine is being used underneath. `kotlin-test-junit5.jar` provides that binding for JUnit 5, making `kotlin.test.Test` resolve to (literally, a type alias for) `org.junit.jupiter.api.Test`. Without the binding JAR, `kotlin.test`'s annotations exist as unresolved references with no concrete backing implementation, verified directly in this lesson when compiling with only `kotlin-test.jar` failed until the JUnit5 binding was added.

2. **What's the purpose of `lateinit var`, and what happens if a `lateinit` property is accessed before being initialized?**
   `lateinit var` declares a non-null property whose value will be assigned sometime after declaration, rather than requiring immediate initialization — commonly used for test fixtures set up in a `@BeforeTest` method, dependency-injected fields, or Android UI elements bound after a view is created. If a `lateinit` property is accessed before ever being assigned a value, Kotlin throws `UninitializedPropertyAccessException` at that specific access point — a clear, specific runtime failure rather than a silent `null` (since `lateinit` properties can't be `null` at all) or a misleading, unrelated error.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
