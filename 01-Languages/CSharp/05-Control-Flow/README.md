# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else`, `switch` statements, and modern `switch` **expressions**.
- Use pattern matching in `switch` (type patterns, relational patterns, `when` guards).
- Use `for`, `foreach`, and `while` loops.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

C#'s control flow is C-family familiar (`if`/`else`, `for`, `while`), plus a `switch` that has evolved far beyond a simple value-equality dispatch: modern C# `switch` **expressions** support type patterns, relational patterns, and guard clauses, making them closer to a full pattern-matching construct (similar in spirit to the discriminated-union `switch` narrowing from the TypeScript course) than a traditional C-style `switch`.

## `if`/`else` and Traditional `switch`

```csharp
int temperature = 15;
if (temperature > 30) {
    Console.WriteLine("hot");
} else if (temperature > 15) {
    Console.WriteLine("warm");
} else {
    Console.WriteLine("cool");
}

switch (temperature) {
    case > 30:
        Console.WriteLine("hot (switch statement with a relational pattern)");
        break;
    default:
        Console.WriteLine("not hot");
        break;
}
```

## `switch` Expressions

```csharp
string DescribeTemperature(int temp) => temp switch {
    > 30 => "hot",
    > 15 => "warm",
    _ => "cool", // `_` is the discard pattern -- the default case
};
```

A `switch` **expression** (`x switch { pattern => value, ... }`) evaluates to a value directly, rather than executing statements — no `break` is needed (each arm is a single expression), and the compiler warns if the arms aren't exhaustive, similar in spirit to TypeScript's `never`-based exhaustiveness checks, though C#'s warning is less strict by default.

## Pattern Matching with Types and `when` Guards

```csharp
string Describe(object value) => value switch {
    int n when n < 0 => "negative number",
    int n => $"non-negative number: {n}",
    string s => $"a string of length {s.Length}",
    null => "null value",
    _ => "something else",
};
```

Each arm's pattern can check a type (`int n`) and bind a variable in one step (identical to `is`-pattern matching from Lesson 04), optionally refined further with a `when` clause for an additional condition — arms are checked top-to-bottom, and the first matching pattern wins.

## `for`, `foreach`, `while`

```csharp
for (int i = 0; i < 3; i++) { Console.WriteLine(i); }

foreach (var fruit in new[] { "apple", "banana" }) { Console.WriteLine(fruit); } // iterates VALUES

int count = 0;
while (count < 3) { Console.WriteLine(count); count++; }
```

`foreach` is C#'s equivalent of JavaScript's `for...of` — it iterates values directly over any `IEnumerable<T>` (arrays, `List<T>`, and any custom type implementing that interface), never indices.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints results from `if`/`else`, a `switch` expression with relational patterns, a type-pattern-matching `switch` with a `when` guard, and all three loop forms.

## Common Mistakes

- Forgetting `break` in a traditional `switch` **statement** — required per non-empty case (C# does not allow fall-through the way C/JavaScript do, except for explicitly grouped empty cases) — a `switch` **expression** has no `break` at all, which is a different construct entirely.
- Ordering `switch` expression arms incorrectly — since the first matching pattern wins, a more general pattern placed before a more specific one can silently shadow it.

## Best Practices

- Prefer `switch` expressions over `switch` statements when producing a single value — more concise, and the compiler flags non-exhaustive matches.
- Order pattern-matching arms from most specific to least specific, ending with `_` as an explicit catch-all.

## Real-World Usage

Type-pattern `switch` expressions are the idiomatic C# way to handle a small closed set of possible types (e.g., different shapes, different event types) — directly analogous to the discriminated-union pattern from the TypeScript course, just expressed through C#'s type system and pattern matching instead of a literal `kind` discriminant field.

## Summary

- `switch` **expressions** (`x switch {...}`) evaluate to a value with pattern-matching arms; `switch` **statements** execute code per case and require `break`.
- Patterns can check types and bind variables in one step, optionally refined with `when` guards.
- `foreach` iterates values over any `IEnumerable<T>`, analogous to JavaScript's `for...of`.

## Key Terms

- **Switch expression** — a `switch` form that evaluates to a value, using pattern-matching arms with no `break` needed.
- **Discard pattern (`_`)** — the catch-all pattern in a `switch` expression, matching anything not matched by earlier arms.
- **`when` guard** — an additional boolean condition refining a pattern-matching arm.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between a `switch` statement and a `switch` expression in C#?**
   A `switch` statement executes a block of code per matching `case` and requires `break` (or another jump statement) to avoid fall-through. A `switch` expression (`x switch { pattern => value }`) evaluates directly to a single value from whichever arm matches, requires no `break`, and the compiler can warn if the patterns don't cover every possibility.

2. **How does pattern matching in a C# `switch` compare to a discriminated union `switch` in TypeScript?**
   Both let a `switch` branch based on a value's specific type/shape rather than plain equality, with the matched branch getting a correctly narrowed/bound value to work with. TypeScript's version narrows based on a shared literal discriminant field across a union of interfaces; C#'s type-pattern `switch` matches directly against a value's runtime type (`int n`, `string s`), which is a different mechanism arriving at a similar practical outcome.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
