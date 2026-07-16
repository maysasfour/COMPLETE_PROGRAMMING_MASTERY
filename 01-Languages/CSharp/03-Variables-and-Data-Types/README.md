# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Distinguish value types (`struct`) from reference types (`class`) and explain the copy-semantics difference.
- Use `var` for type inference and know when an explicit type is clearer.
- Use nullable reference types (`string?` vs `string`) and nullable value types (`int?`).

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

C# is statically typed: every variable has a fixed, compile-time-known type. Its most important type distinction — more consequential day-to-day than in most languages in this repository — is **value types vs. reference types**. Value types (`int`, `double`, `bool`, `struct`, all built-in numerics) live inline wherever they're declared and are **copied by value** on assignment. Reference types (`class`, `string`, arrays, `object`) live on the heap, and a variable holds a **reference** to that heap location — assignment copies the reference, not the underlying data.

## Value vs. Reference Semantics

```csharp
// Value type: each variable gets an independent copy
int a = 5;
int b = a;
b = 10;
Console.WriteLine($"a={a}, b={b}"); // a=5, b=10 -- independent

// Reference type: both variables point to the SAME object
var listA = new List<int> { 1, 2, 3 };
var listB = listA;
listB.Add(4);
Console.WriteLine($"listA.Count={listA.Count}"); // 4 -- listA sees listB's mutation too
```

## `var` and Explicit Types

```csharp
var name = "Ada";        // inferred as string
int age = 30;             // explicit -- fine, no initializer-based ambiguity here either
var scores = new List<int>(); // inferred as List<int> -- avoids repeating the type twice
```

`var` requires an initializer (the compiler must have something to infer from) and is purely a compile-time convenience — the variable's type is still fully static and fixed; `var` is not remotely like JavaScript's dynamic typing.

## Nullable Reference Types and Nullable Value Types

```csharp
string name = "Ada";       // non-nullable by default (with nullable reference types enabled)
string? nickname = null;   // explicitly nullable -- must be checked before dereferencing

int age = 30;               // value types are non-nullable by default
int? optionalAge = null;    // Nullable<int> -- an explicit "value or no value" wrapper

if (nickname != null) {
    Console.WriteLine(nickname.Length); // safe -- narrowed
}
Console.WriteLine(optionalAge ?? -1); // ?? provides a fallback for a null Nullable<T>
```

Nullable reference types (`string?`) are a compile-time-only analysis (like TypeScript's `strictNullChecks`) — the compiler warns if a possibly-null reference is dereferenced without a check, but this doesn't change runtime behavior; a bug can still produce a `NullReferenceException` if warnings are ignored. `int?` (`Nullable<int>`) is different — it's a genuine runtime wrapper type (`Nullable<T>`) around a value type, since value types can't normally be `null` at all.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints the value-type-independence vs. reference-type-sharing contrast, `var`-inferred variables, and nullable reference/value type usage including the `??` fallback.

## Common Mistakes

- Assuming a `class`-typed variable assignment copies the object — it copies only the reference; both variables alias the same underlying object.
- Treating `var` as dynamic typing — it's purely inferred static typing; the variable's type is fixed at compile time exactly as if written explicitly.
- Dereferencing a `string?` without a null check, relying on the compiler's warning being "probably fine" — warnings don't prevent a `NullReferenceException` at runtime, they only flag the risk during development.

## Best Practices

- Enable nullable reference types on every project (default in modern templates) and treat nullability warnings as bugs to fix, not noise to ignore.
- Use `var` when the type is obvious from the right-hand side (`var user = new User();`); use an explicit type when it materially improves readability (e.g., a numeric literal whose type isn't obvious).
- Use `int?`/`Nullable<T>` for value types that genuinely have a "no value" state (an optional numeric field), and `??`/`??=` to handle the fallback concisely.

## Real-World Usage

The value/reference distinction directly affects how method parameters behave — passing a `List<T>` into a method lets that method mutate the caller's list (reference semantics), while passing an `int` does not (value semantics) — a frequent source of confusion for developers coming from a language without this distinction (like Python or JavaScript, where nearly everything non-primitive behaves like C#'s reference types).

## Summary

- Value types (`struct`, built-in numerics) copy by value; reference types (`class`, arrays, `string`) copy by reference.
- `var` is compile-time type inference, not dynamic typing.
- Nullable reference types (`string?`) are a compile-time-only null-safety analysis; `int?`/`Nullable<T>` is a genuine runtime wrapper for value types.

## Key Terms

- **Value type** — a type copied by value on assignment (`struct`, built-in numerics, `bool`).
- **Reference type** — a type copied by reference on assignment (`class`, arrays, `string`, `object`).
- **Nullable reference type** — a compile-time-only annotation (`string?`) distinguishing possibly-null from guaranteed-non-null references.

## Review Questions

1. Why does mutating a `List<T>` through one variable affect a second variable it was assigned to, while mutating an `int` through one variable does not affect a copy?
2. Why is `var` not the same as dynamic typing?
3. What's the practical difference between `string?` and `int?`?

## Interview Questions

1. **What's the difference between a value type and a reference type in terms of method parameters?**
   Passing a value type (like `int`) to a method passes a copy — changes inside the method don't affect the caller's variable. Passing a reference type (like a `List<T>` or any `class` instance) passes a copy of the *reference* — both the caller and the method refer to the same underlying object, so mutations made inside the method (adding to the list, changing a field) are visible to the caller after the method returns.

2. **Is `var` the same as JavaScript's dynamically-typed variables?**
   No — `var` only tells the compiler to infer the variable's static type from its initializer at compile time; the resulting type is completely fixed afterward, exactly as if it had been written explicitly, and cannot later hold a value of a different type. This is fundamentally different from JavaScript's `let`/`const`, where the variable's type can change at runtime because JavaScript has no static type system at all.

3. **Why does `int?` need a special wrapper type while `string?` doesn't?**
   `string` is already a reference type, and reference types can naturally be `null` at runtime — `string?` is purely a compile-time nullability *annotation* layered on top of behavior that already exists. `int` is a value type and cannot naturally be `null` (there's no "reference" to set to null) — `int?` is shorthand for `Nullable<int>`, a genuine wrapper struct that adds an explicit "has a value or doesn't" flag around the underlying `int`.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
