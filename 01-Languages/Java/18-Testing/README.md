# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with JUnit 5, the standard Java testing framework.
- Use `@Test` for a single test case and `@ParameterizedTest`/`@CsvSource` for parameterized tests.
- Assert on thrown exceptions with `assertThrows`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

JUnit 5 (also called "JUnit Jupiter") is the standard Java testing framework, analogous to xUnit (C#), pytest (Python), and `node:test` (JavaScript). Like the database driver (Lesson 16), it's not part of the JDK — a real project adds it via Maven/Gradle (Lesson 15); this lesson uses the **JUnit Platform Console Standalone** JAR (bundling JUnit Jupiter + its test engine + a command-line runner in one file) to stay runnable without a full build tool, matching this course's single-file-lesson style wherever practical.

## `@Test`: A Single Test Case

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class MathHelpersTest {
    @Test
    void addSumsTwoPositiveNumbers() {
        assertEquals(5, MathHelpers.add(2, 3));
    }
}
```

`@Test` marks a method as a single test case, discovered automatically by the JUnit test engine. `assertEquals(expected, actual)` — note the argument order (expected first) — is JUnit's core equality assertion.

## `@ParameterizedTest`/`@CsvSource`

```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

@ParameterizedTest
@CsvSource({"1,1,2", "0,0,0", "-1,1,0"})
void addParameterizedCases(int a, int b, int expected) {
    assertEquals(expected, MathHelpers.add(a, b));
}
```

`@CsvSource` runs the same test method once per row, parsing each comma-separated string into the method's parameters — JUnit's equivalent of xUnit's `[InlineData]` and pytest's `@pytest.mark.parametrize`.

## Asserting on Exceptions

```java
@Test
void divideThrowsOnDivisionByZero() {
    Exception ex = assertThrows(ArithmeticException.class, () -> MathHelpers.divide(10, 0));
    assertTrue(ex.getMessage().contains("Cannot divide by zero"));
}
```

## Detailed Example

See [MathHelpers.java](MathHelpers.java) (module under test) and [MathHelpersTest.java](MathHelpersTest.java) (JUnit 5 tests).

## Run It

```bash
cd 01-Languages/Java/18-Testing
curl -L -o junit.jar "https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.11.4/junit-platform-console-standalone-1.11.4.jar"
javac -cp junit.jar MathHelpers.java MathHelpersTest.java
java -jar junit.jar execute -cp . --scan-classpath
```

(As with Lesson 16's JDBC driver, `junit.jar` is deliberately not committed — a real project manages this dependency via Maven/Gradle instead; see [15-Modules-and-Packages](../15-Modules-and-Packages/README.md).)

## Expected Output

The JUnit console launcher reports 7 successful tests (4 `@Test` methods plus 3 `@CsvSource` rows from one `@ParameterizedTest`), with a summary showing `7 tests successful`, `0 tests failed`.

## Common Mistakes

- Writing near-duplicate `@Test` methods for the same logic with different inputs instead of a single `@ParameterizedTest`.
- Forgetting `assertThrows` needs a lambda (`() -> riskyCall()`), not the direct result of calling the risky method — the same mistake covered in every other language course's testing lesson.
- Forgetting to compile test classes against the JUnit JAR's classpath (`javac -cp junit.jar ...`) before running them.

## Best Practices

- Use `@ParameterizedTest`/`@CsvSource` (or `@MethodSource` for more complex cases) instead of near-duplicate `@Test` methods.
- Name test methods descriptively enough that a failure alone explains what broke.
- In a real project, manage JUnit via Maven/Gradle rather than a manually-downloaded standalone JAR.

## Real-World Usage

JUnit 5 is the de facto standard testing framework for the JVM ecosystem; `java -jar junit.jar` (or, in a real project, `mvn test`/`gradle test`) is what CI pipelines run to gate merges on passing tests, exactly analogous to `pytest`/`node --test`/`dotnet test` in this repository's other language courses.

## Summary

- JUnit 5 is the standard Java testing framework, not part of the JDK; this lesson uses its standalone console JAR to stay single-file-runnable.
- `@Test` marks a single test case; `@ParameterizedTest`/`@CsvSource` parameterize the same test across multiple input/output pairs.
- `assertThrows(ExceptionType.class, () -> ...)` tests that a lambda throws a specific exception type.

## Key Terms

- **JUnit 5 (JUnit Jupiter)** — the standard Java testing framework.
- **`@ParameterizedTest`** — a JUnit annotation for running the same test method across multiple sets of input data.

## Interview Questions

1. **What's the difference between `@Test` and `@ParameterizedTest` in JUnit 5?**
   `@Test` marks a fixed, parameterless test case that always runs the same way. `@ParameterizedTest` (combined with a source of arguments like `@CsvSource` or `@MethodSource`) runs the same test method once per set of supplied arguments, avoiding near-duplicate test methods that only differ in their literal inputs.

2. **How do you test that a method throws a specific exception in JUnit 5?**
   `assertThrows(ExceptionType.class, () -> methodCall())` — passing a lambda (not the direct result of calling the method) that JUnit invokes under its own control, asserting it throws exactly the specified exception type and returning the caught exception for further assertions on its message or other properties.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
