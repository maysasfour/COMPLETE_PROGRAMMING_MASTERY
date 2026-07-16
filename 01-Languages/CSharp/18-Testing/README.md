# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with xUnit, the most common .NET testing framework.
- Use `[Fact]` for a single test case and `[Theory]`/`[InlineData]` for parameterized tests.
- Assert on thrown exceptions with `Assert.Throws<T>()`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Unlike lessons 01-17 (single file-based apps), this lesson uses a real xUnit test project (`dotnet new xunit`), since test projects need the test framework's NuGet packages and `dotnet test` tooling. xUnit is the most widely-used .NET testing framework (alongside NUnit and MSTest) and is Microsoft's own default for new project templates.

## `[Fact]`: A Single Test Case

```csharp
public class MathHelpersTests {
    [Fact]
    public void Add_SumsTwoPositiveNumbers() {
        Assert.Equal(5, MathHelpers.Add(2, 3));
    }
}
```

`[Fact]` marks a parameterless method as a single test case, discovered and run automatically by the xUnit test runner. `Assert.Equal(expected, actual)` is xUnit's core equality assertion — note the argument order (expected first), which produces clearer failure messages than the reverse.

## `[Theory]`/`[InlineData]`: Parameterized Tests

```csharp
[Theory]
[InlineData(1, 1, 2)]
[InlineData(0, 0, 0)]
[InlineData(-1, 1, 0)]
public void Add_ParameterizedCases(int a, int b, int expected) {
    Assert.Equal(expected, MathHelpers.Add(a, b));
}
```

A `[Theory]` runs the same test method once per `[InlineData(...)]` row, avoiding three near-identical `[Fact]` methods that only differ in their literal input/expected values.

## Asserting on Exceptions

```csharp
[Fact]
public void Divide_ThrowsOnDivisionByZero() {
    var ex = Assert.Throws<ArgumentException>(() => MathHelpers.Divide(10, 0));
    Assert.Contains("Cannot divide by zero", ex.Message);
}
```

`Assert.Throws<T>(() => ...)` — like TypeScript's/JavaScript's `assert.throws`/`assert.Throws` — takes a delegate to invoke and asserts it throws exactly the specified exception type, returning the caught exception so its properties (like `.Message`) can be asserted further.

## Detailed Example

See [MathHelpers.cs](MathHelpers.cs) (module under test) and [MathHelpersTests.cs](MathHelpersTests.cs) (xUnit tests), with [MathTests.csproj](MathTests.csproj) as the project file.

## Run It

```bash
cd 01-Languages/CSharp/18-Testing
dotnet test
```

## Expected Output

`dotnet test` reports 7 passing tests (4 `[Fact]`s plus 3 `[InlineData]` cases from one `[Theory]`), with a summary line: `Passed! - Failed: 0, Passed: 7, ...`.

## Common Mistakes

- Writing near-duplicate `[Fact]` methods for the same logic with different inputs instead of a single `[Theory]` with multiple `[InlineData]` rows.
- Getting `Assert.Equal`'s argument order backwards (`actual, expected` instead of `expected, actual`) — tests still catch the mismatch, but failure messages read confusingly ("expected: 5, actual: 3" vs. the reverse).
- Forgetting `Assert.Throws<T>` needs a delegate (`() => riskyCall()`), not the direct result of calling the risky method — the same mistake covered in the JavaScript/TypeScript courses' equivalent lessons, applying equally here.

## Best Practices

- Use `[Theory]`/`[InlineData]` for testing the same logic across multiple input/output pairs.
- Name test methods descriptively: `MethodName_Scenario_ExpectedBehavior` is a common, readable convention.
- Keep the module under test and its test file separate but co-located, matching this lesson's layout.

## Real-World Usage

xUnit (or NUnit/MSTest) is the standard testing framework for ASP.NET Core backend logic; `dotnet test` is what CI pipelines run to gate merges on passing tests, exactly analogous to `pytest`/`node --test` in the Python/JavaScript courses.

## Summary

- xUnit test projects (`dotnet new xunit`) are a real project, unlike this course's other file-based-app lessons, since testing needs the framework's NuGet packages.
- `[Fact]` marks a single test case; `[Theory]`/`[InlineData]` parameterize the same test logic across multiple input/output pairs.
- `Assert.Throws<T>(() => ...)` tests that a delegate throws a specific exception type.

## Key Terms

- **`[Fact]`** — an xUnit attribute marking a method as a single, parameterless test case.
- **`[Theory]`/`[InlineData]`** — xUnit attributes for running the same test method across multiple sets of input data.

## Interview Questions

1. **What's the difference between `[Fact]` and `[Theory]` in xUnit?**
   `[Fact]` marks a test method that always runs the same way with no parameters — a single, fixed test case. `[Theory]` marks a parameterized test method, run once per `[InlineData(...)]` (or other data source) supplying a different set of arguments each time, avoiding near-duplicate test methods that only differ in their literal inputs.

2. **How do you test that a method throws a specific exception in xUnit?**
   `Assert.Throws<ExceptionType>(() => methodCall())` — passing a delegate (not the direct result of calling the method) that xUnit invokes under its own control, asserting it throws exactly the specified exception type and returning the caught exception instance for further assertions (e.g., checking its `.Message`).

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
