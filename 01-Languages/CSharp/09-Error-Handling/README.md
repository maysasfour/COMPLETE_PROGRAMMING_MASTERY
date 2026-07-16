# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally`, including catching specific exception types.
- Write custom exceptions by extending `Exception`.
- Use exception filters (`catch (Ex e) when (condition)`).

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

C#'s exception model is a direct relative of Java's `try`/`catch`/`finally`, with strongly-typed `catch` clauses (unlike JavaScript, where every `catch` receives the same untyped/`unknown` value) — you can catch specific exception types directly, in order from most to least specific, and the runtime picks the first matching clause.

## `try`/`catch`/`finally` with Specific Types

```csharp
try {
    int[] numbers = { 1, 2, 3 };
    Console.WriteLine(numbers[10]);
} catch (IndexOutOfRangeException e) {
    Console.WriteLine($"Index error: {e.Message}");
} catch (Exception e) {
    Console.WriteLine($"Unexpected error: {e.Message}");
} finally {
    Console.WriteLine("Cleanup runs regardless");
}
```

Unlike JavaScript's single untyped `catch (err)`, C# lets you write multiple `catch` clauses for different exception types directly — the runtime checks them top-to-bottom and executes the first one whose type matches (or is a base type of) the thrown exception, so order matters: more specific types must come before more general ones (`Exception` last).

## Custom Exceptions

```csharp
class ValidationException : Exception {
    public string Field { get; }
    public ValidationException(string message, string field) : base(message) {
        Field = field;
    }
}

int ValidateAge(int age) {
    if (age < 0) throw new ValidationException("Age cannot be negative", "age");
    return age;
}

try {
    ValidateAge(-5);
} catch (ValidationException e) {
    Console.WriteLine($"Validation failed on \"{e.Field}\": {e.Message}");
}
```

## Exception Filters (`when`)

```csharp
try {
    throw new InvalidOperationException("temporary failure");
} catch (InvalidOperationException e) when (e.Message.Contains("temporary")) {
    Console.WriteLine("Recoverable, retrying...");
} catch (InvalidOperationException e) {
    Console.WriteLine($"Non-recoverable: {e.Message}");
}
```

An exception filter (`when (condition)`) lets a `catch` clause additionally require a runtime condition beyond just the exception's type, without needing to re-throw and re-catch — if the filter is `false`, C# moves on to the next `catch` clause as if this one's type hadn't matched at all.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints a caught `IndexOutOfRangeException` with `finally` running afterward, a custom `ValidationException` caught and its `Field` property used, and an exception filter correctly routing a "temporary" failure to one `catch` clause and a non-matching one to another.

## Common Mistakes

- Ordering `catch` clauses from general to specific (`catch (Exception)` before a more specific type) — the compiler actually flags this as an error for sibling catch clauses of related types, but it's worth understanding why: the general clause would always win first.
- Forgetting `finally` runs even when an exception isn't caught at all (it still executes before the exception propagates further up the call stack).

## Best Practices

- Order `catch` clauses from most specific to least specific, ending with `Exception` (or omitting a general catch-all entirely if every specific case is truly handled).
- Use custom exception types with meaningful extra properties (like `Field` above) instead of parsing information out of a generic exception's message string.
- Use exception filters (`when`) to avoid catch-then-rethrow patterns for conditionally-recoverable errors.

## Real-World Usage

ASP.NET Core commonly maps specific custom exception types (`NotFoundException`, `ValidationException`) to specific HTTP status codes in centralized exception-handling middleware, exactly mirroring the JavaScript/TypeScript courses' custom-error-class pattern.

## Summary

- C# `catch` clauses are strongly typed and checked in order — most specific first.
- Custom exceptions extend `Exception` and can carry extra typed properties.
- Exception filters (`when`) add a runtime condition to a `catch` clause without needing catch-then-rethrow.

## Key Terms

- **Exception filter (`when`)** — an additional boolean condition on a `catch` clause, evaluated before deciding whether that clause handles the exception.

## Interview Questions

1. **How does C#'s typed `catch` differ from JavaScript's untyped `catch`?**
   C# lets you write multiple `catch` clauses, each for a specific exception type, checked in order — the runtime automatically routes to the first matching clause. JavaScript (and TypeScript) has only one `catch` block per `try`, receiving an `unknown`/untyped value that must be manually narrowed with `instanceof` checks inside a single block.

2. **What does an exception filter (`when`) let you do that you couldn't do with just the exception type?**
   It adds a runtime boolean condition to a `catch` clause — if the condition is false, C# treats that clause as not matching and moves on to the next one, exactly as if the type itself hadn't matched. Without it, you'd have to catch broadly, check the condition manually inside the block, and re-throw if it didn't hold, which is more verbose and loses the "next clause" fallback behavior.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
