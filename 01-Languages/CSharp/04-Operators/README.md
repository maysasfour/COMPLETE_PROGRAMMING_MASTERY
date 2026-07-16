# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators.
- Use `??`/`??=` (null-coalescing) and `?.` (null-conditional).
- Use `is`/`as` for type checking and safe casting.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

C#'s operators are close to Java/JavaScript's, with one major addition given the language's strong nullability focus: null-coalescing (`??`) and null-conditional (`?.`) operators, added specifically to make null-handling concise, plus `is`/`as` for runtime type checks that integrate with pattern matching (Lesson 05).

## Null-Coalescing and Null-Conditional

```csharp
string? nickname = null;
string display = nickname ?? "Anonymous"; // "Anonymous" -- fallback only for null

nickname ??= "Guest"; // assigns only if nickname is currently null

User? user = null;
int? nameLength = user?.Name?.Length; // null-conditional: short-circuits to null instead of throwing
```

`?.` short-circuits an entire chain to `null` the moment any link is `null`, avoiding a `NullReferenceException` — directly analogous to TypeScript's `?.` (and by extension JavaScript's).

## `is` and `as`

```csharp
object value = "hello";

if (value is string s) { // pattern-matching `is`: checks AND casts/binds in one step
    Console.WriteLine(s.ToUpper());
}

object maybeNumber = 42;
string? asString = maybeNumber as string; // `as`: safe cast, returns null instead of throwing on mismatch
Console.WriteLine(asString ?? "not a string");
```

`is` with a pattern (`value is string s`) both checks the type and, if it matches, binds the checked value to a new, correctly-typed variable in one expression — this is C#'s version of the type-narrowing pattern seen throughout the JavaScript/TypeScript courses. `as` performs a safe cast that yields `null` on failure instead of throwing (unlike a direct cast, `(string)value`, which throws `InvalidCastException` on a mismatch).

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints null-coalescing/null-conditional results and both an `is`-pattern check and an `as` safe cast, including the safe cast's `null` result for a genuine type mismatch.

## Common Mistakes

- Using a direct cast (`(string)value`) instead of `as` when the value's type is uncertain — throws `InvalidCastException` instead of returning `null`.
- Forgetting `??=` only assigns when the left side is currently `null` — it is not a general "assign if falsy" operator the way `||=` might be in some languages.

## Best Practices

- Prefer `is` pattern matching over a separate `is` check followed by a manual cast — it combines both into one safer, more concise expression.
- Use `as` (not a direct cast) when a mismatch is a plausible, recoverable outcome; use a direct cast only when a mismatch would represent a genuine bug that should throw loudly.

## Real-World Usage

`?.`/`??` chains are the standard way to navigate potentially-incomplete object graphs (a user that may or may not have a profile that may or may not have a bio) without verbose nested null checks, exactly mirroring the equivalent JavaScript/TypeScript idiom.

## Summary

- `??`/`??=` provide concise null-coalescing; `?.` short-circuits a member-access chain to `null`.
- `is` pattern matching checks and casts/binds in one step; `as` performs a safe cast returning `null` on failure instead of throwing.

## Key Terms

- **Null-coalescing operator (`??`)** — returns the right operand only if the left is `null`.
- **Null-conditional operator (`?.`)** — short-circuits a member access chain to `null` if any link is `null`.
- **Pattern matching (`is`)** — checking a value's type and binding it to a new variable in one expression.

## Interview Questions

1. **What's the difference between `as` and a direct cast?**
   `as` attempts the cast and yields `null` if it fails, without throwing — appropriate when a type mismatch is a plausible, recoverable outcome. A direct cast (`(Type)value`) throws `InvalidCastException` immediately on a mismatch, appropriate when a mismatch indicates a genuine bug that should fail loudly.

2. **What does `nickname ??= "Guest";` do?**
   It assigns `"Guest"` to `nickname` only if `nickname` is currently `null`; if `nickname` already holds a non-null value, the assignment is skipped entirely. It's shorthand for `nickname = nickname ?? "Guest";`.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
