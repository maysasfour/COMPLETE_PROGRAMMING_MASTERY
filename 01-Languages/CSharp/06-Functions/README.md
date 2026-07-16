# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Write methods with optional/default parameters, `params` arrays, and `out`/`ref` parameters.
- Write expression-bodied methods and local functions.
- Understand C#'s pass-by-value default and when `ref`/`out` change that.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

C#'s methods are always declared with an explicit return type (or `void`). Parameters are passed by value by default — even for reference types, meaning the *reference itself* is copied (Lesson 03's distinction applies at the parameter level too) — with `ref`/`out` available to explicitly pass by reference when a method needs to modify the caller's variable directly.

## Basic Methods and Default Parameters

```csharp
int Add(int a, int b) => a + b; // expression-bodied method

string Greet(string name = "World") => $"Hello, {name}";
Console.WriteLine(Greet());       // "Hello, World"
Console.WriteLine(Greet("Ada"));  // "Hello, Ada"
```

## `params` (Variadic Parameters)

```csharp
int Sum(params int[] numbers) => numbers.Sum(); // Sum() is a LINQ extension method, Lesson 12

Console.WriteLine(Sum(1, 2, 3, 4)); // called with any number of arguments
Console.WriteLine(Sum());           // also valid -- an empty array
```

## `out` and `ref` Parameters

```csharp
bool TryParseAge(string input, out int age) {
    return int.TryParse(input, out age);
}

if (TryParseAge("30", out int parsedAge)) {
    Console.WriteLine($"Parsed: {parsedAge}");
}

void Increment(ref int value) {
    value += 1;
}
int counter = 5;
Increment(ref counter);
Console.WriteLine(counter); // 6 -- the method modified the caller's variable directly
```

`out` requires the method to assign the parameter before returning (the compiler enforces this) and is the standard C# pattern for "return a value, plus a success/failure flag" (`int.TryParse`, `Dictionary.TryGetValue`, and much of the BCL follow this convention). `ref` requires the *caller* to already have an initialized variable and lets the method both read and modify it directly — this is one of the few ways in C# to let a method mutate a value type through a parameter, since value types are normally passed by value.

## Local Functions

```csharp
int Factorial(int n) {
    int Helper(int n, int acc) => n <= 1 ? acc : Helper(n - 1, n * acc); // local function
    return Helper(n, 1);
}
Console.WriteLine(Factorial(5)); // 120
```

A local function is defined inside another method/function and can only be called from within it — useful for a helper that's only meaningful in one specific context, without polluting the surrounding class/namespace with a separate private method.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints results from default parameters, a `params` array sum, `out`-based `TryParse` and a manual `TryParseAge`, a `ref`-based increment showing the caller's variable actually changed, and a recursive local function computing a factorial.

## Common Mistakes

- Forgetting `ref`/`out` must be specified at **both** the method signature and every call site — C# never implicitly passes by reference, unlike some languages where it can be inferred.
- Assuming passing a `class` instance by value (the default) means the method can't mutate it — it can mutate the object's *contents* freely (reference semantics, Lesson 03); only *reassigning the parameter itself to a different object* fails to propagate back to the caller without `ref`.
- Confusing `out` (must be assigned before the method returns, doesn't need to be initialized by the caller) with `ref` (must already be initialized by the caller, assignment is optional).

## Best Practices

- Use `out` for the "value plus success flag" pattern (mirroring `TryParse`/`TryGetValue` conventions); use `ref` only when a method genuinely needs to reassign the caller's variable to a different value.
- Prefer expression-bodied members (`=>`) for simple one-expression methods; use a full `{ }` body once a method has multiple statements.
- Use local functions for helpers meaningful only within one specific method, rather than adding a same-purpose private method to the whole class.

## Real-World Usage

The `out`-based `TryX` pattern (`int.TryParse`, `Dictionary<K,V>.TryGetValue`) is pervasive throughout the .NET BCL specifically to avoid throwing exceptions for routine, expected failures (an invalid string, a missing key) — mirroring the `Result<T,E>` pattern from the TypeScript course's Lesson 09, just expressed via an output parameter instead of a discriminated union.

## Summary

- Methods pass parameters by value by default, including for reference types (the reference itself is copied); `ref`/`out` opt into pass-by-reference explicitly.
- `params` allows a variable number of arguments, collected into an array.
- `out` is the standard "value plus success flag" BCL convention; `ref` lets a method reassign the caller's variable directly.
- Local functions are helpers scoped to a single enclosing method.

## Key Terms

- **`params`** — a parameter modifier allowing a variable number of arguments, collected into an array.
- **`out` parameter** — a parameter the method must assign before returning; the caller doesn't need to initialize it first.
- **`ref` parameter** — a parameter passed by reference; the caller must initialize it, and the method can reassign it, with the change visible to the caller.
- **Local function** — a function defined inside another function/method, callable only from within it.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `out` and `ref` parameters?**
   `out` parameters do not need to be initialized by the caller before the call, but the method is required to assign them before returning — used for the "return a value plus success flag" pattern (`TryParse`). `ref` parameters must already be initialized by the caller, and the method may read and/or reassign them, with any reassignment visible to the caller after the call returns.

2. **Does passing a `List<T>` to a method allow the method to mutate the caller's list?**
   Yes — because `List<T>` is a reference type and parameters are passed by value by default, the method receives a copy of the *reference*, which still points to the same underlying list object. The method can freely mutate that object's contents (add/remove items). It cannot, however, make the caller's variable point to a completely different list object without the parameter being marked `ref`.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
