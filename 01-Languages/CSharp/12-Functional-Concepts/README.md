# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Use `Func<>`/`Action<>` delegates and lambda expressions.
- Write a higher-order method that wraps another method with extra behavior.
- Use LINQ as C#'s primary functional-style data-transformation tool (recap/extension of Lesson 07).

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

C# supports functions as first-class values via **delegates** — typed function references. `Func<T1,...,TResult>` and `Action<T1,...>` are built-in generic delegate types covering the vast majority of everyday cases (a function returning a value vs. one that doesn't), avoiding the need to declare a custom delegate type for most purposes.

## `Func<>`, `Action<>`, and Lambdas

```csharp
Func<int, int, int> add = (a, b) => a + b; // takes two ints, returns an int
Console.WriteLine(add(2, 3));

Action<string> log = message => Console.WriteLine($"LOG: {message}"); // takes a string, returns nothing
log("hello");

Func<int, bool> isEven = n => n % 2 == 0;
```

## A Higher-Order Method (the "Decorator" Pattern)

```csharp
Func<int, int, int> WithLogging(Func<int, int, int> fn) {
    return (a, b) => {
        Console.WriteLine($"Calling with {a}, {b}");
        int result = fn(a, b);
        Console.WriteLine($"Returned {result}");
        return result;
    };
}

var loggedAdd = WithLogging(add);
loggedAdd(2, 3);
```

This mirrors the JavaScript/TypeScript courses' `withLogging` pattern exactly — a method taking and returning a `Func<>`/`Action<>` delegate, wrapping the original with extra behavior around the call.

## LINQ as Functional-Style Transformation (Recap)

```csharp
var numbers = new List<int> { 1, 2, 3, 4, 5 };
var result = numbers.Where(n => n % 2 == 0).Select(n => n * n).Sum(); // filter, then map, then reduce
```

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints `Func`/`Action` usage, a logged higher-order wrapper around a delegate, and a LINQ chain combining filter/map/reduce in one expression.

## Common Mistakes

- Declaring a custom delegate type when `Func<>`/`Action<>` already cover the exact signature needed — usually unnecessary ceremony.
- Confusing `Func<int,int,int>`'s type parameter order — the **last** type parameter is always the return type; all preceding ones are parameter types.

## Best Practices

- Default to `Func<>`/`Action<>` over custom delegate types unless a named delegate type genuinely improves clarity (e.g., a widely-reused event handler signature).
- Prefer LINQ chains over manual loops for data transformation, mirroring the `map`/`filter`/`reduce` idiom from the JavaScript/TypeScript courses.

## Real-World Usage

`Func<>`/`Action<>` parameters are pervasive in the BCL and ASP.NET Core (middleware pipelines, LINQ itself, event callbacks) — understanding them is prerequisite to reading almost any modern C# codebase.

## Summary

- `Func<T1,...,TResult>` and `Action<T1,...>` are built-in generic delegate types covering "returns a value" and "returns nothing" respectively.
- Higher-order methods (taking/returning `Func`/`Action`) implement the same decorator-style wrapping pattern seen in the JavaScript/TypeScript courses.
- LINQ remains C#'s primary functional-style data-transformation tool.

## Key Terms

- **Delegate** — a type-safe reference to a method, enabling functions as first-class values.
- **`Func<>`/`Action<>`** — built-in generic delegate types for "returns a value" and "returns nothing" respectively.

## Interview Questions

1. **What's the difference between `Func<>` and `Action<>`?**
   `Func<T1,...,TResult>` represents a delegate that returns a value of type `TResult` (the last type parameter); `Action<T1,...>` represents a delegate that returns nothing (`void`). Both cover an arbitrary number of parameters via generic overloads, avoiding the need for custom delegate type declarations in most everyday cases.

2. **How would you implement a "decorator" pattern (wrapping a function with extra behavior) in C#?**
   Write a method that accepts a `Func<>`/`Action<>` delegate and returns a new delegate of the same signature that calls the original, adding behavior before/after — exactly the same higher-order function pattern used in the JavaScript/TypeScript courses, expressed through C#'s delegate types instead of plain function values.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
