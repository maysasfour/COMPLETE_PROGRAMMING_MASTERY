# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write generic methods and classes with type parameters (`<T>`).
- Constrain a type parameter with `where T : ...`.
- Understand generics are compiled with genuine runtime type specialization for value types (unlike Java's type erasure).

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

C# generics work much like TypeScript's — a type parameter `<T>` lets one method/class work safely across many concrete types. A notable implementation detail worth knowing: for value-type type arguments, the .NET JIT generates **specialized native code per value type** (`Stack<int>` and `Stack<double>` get genuinely different compiled code), whereas for reference types, all instantiations share one compiled implementation — this is different from Java, where generics are erased entirely at compile time and never specialized.

## Generic Methods

```csharp
T First<T>(List<T> items) => items[0];

Console.WriteLine(First(new List<int> { 1, 2, 3 }));       // T inferred as int
Console.WriteLine(First(new List<string> { "a", "b" }));     // T inferred as string
```

## Constraining a Generic with `where`

```csharp
double TotalLength<T>(List<T> items) where T : IHasLength {
    double total = 0;
    foreach (var item in items) total += item.Length;
    return total;
}

interface IHasLength { double Length { get; } }
```

`where T : IHasLength` restricts `T` to types implementing `IHasLength` — other common constraints include `where T : class` (reference types only), `where T : struct` (value types only), `where T : new()` (must have a public parameterless constructor), and `where T : SomeBaseClass`.

## Generic Classes

```csharp
class Stack<T> {
    private readonly List<T> items = new();
    public void Push(T item) => items.Add(item);
    public T Pop() {
        var item = items[^1]; // ^1 = "one from the end" (Index from end operator)
        items.RemoveAt(items.Count - 1);
        return item;
    }
    public int Count => items.Count;
}

var numberStack = new Stack<int>();
numberStack.Push(1);
numberStack.Push(2);
```

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints a generic `First<T>` method correctly inferring `int` and `string`, a constrained generic method computing a total using an interface constraint, and a generic `Stack<T>` used with two different concrete types.

## Common Mistakes

- Forgetting a needed constraint (`where T : ...`), then being unable to call a member on `T` that every *actual* use case has but the compiler can't assume without the constraint.
- Assuming C# generics are erased like Java's — .NET specializes for value-type arguments, meaning reflection can actually observe the concrete type argument at runtime (`typeof(T)` works correctly, unlike Java's type-erased generics).

## Best Practices

- Add the narrowest constraint the method body actually needs.
- Prefer a generic class/method over duplicating near-identical code for each concrete type.

## Real-World Usage

`List<T>`, `Dictionary<K,V>`, and `Task<T>` (Lesson 14) are all built using exactly this generic mechanism; application code regularly defines its own generic repositories (`IRepository<T>`) and result wrappers (`ApiResponse<T>`) in ASP.NET Core codebases.

## Summary

- Generic methods/classes (`<T>`) work safely across many types, fully type-checked per instantiation.
- `where T : ...` constrains a type parameter to types satisfying a given requirement.
- .NET generates specialized code per value-type argument, unlike Java's fully-erased generics.

## Key Terms

- **Generic constraint (`where`)** — restricting a type parameter to types satisfying a given requirement (an interface, a base class, `class`, `struct`, `new()`).

## Interview Questions

1. **How do C# generics differ from Java generics at runtime?**
   C#/.NET generates specialized native code per value-type generic argument (e.g., `List<int>` and `List<double>` are genuinely different compiled implementations), and `typeof(T)` correctly reflects the actual type argument at runtime. Java generics are fully erased at compile time — at runtime, a `List<Integer>` and a `List<String>` are indistinguishable, both just `List`, and the concrete type argument cannot be recovered via reflection.

2. **What does `where T : IHasLength` do?**
   It constrains the generic type parameter `T` to only types implementing the `IHasLength` interface, letting the generic method body safely call any member `IHasLength` requires (like a `.Length` property) on values of type `T`, since every valid `T` is now guaranteed to provide it.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
