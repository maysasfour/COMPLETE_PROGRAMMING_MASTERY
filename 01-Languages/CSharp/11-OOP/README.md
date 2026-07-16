# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes with properties, constructors, and `virtual`/`override` inheritance.
- Use `interface`s and abstract classes.
- Use `record` types for immutable, value-equality data.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md) and [10-File-Handling](../10-File-Handling/README.md)

## Concept

C# is a class-based OOP language with real access modifiers (`public`/`private`/`protected`) enforced by the runtime (unlike TypeScript's compile-time-only equivalents) — access control is genuine here, not erasable. C# also has `record` types (C# 9+), a distinct kind of type optimized for immutable data with automatic **value-based** equality, contrasted with `class`'s default reference equality.

## Classes, Properties, Inheritance

```csharp
class Animal {
    public string Name { get; }
    public Animal(string name) { Name = name; }
    public virtual string Speak() => $"{Name} makes a sound";
}

class Dog : Animal {
    public Dog(string name) : base(name) {}
    public override string Speak() => $"{Name} says Woof";
}

Animal a = new Dog("Rex");
Console.WriteLine(a.Speak()); // "Rex says Woof" -- virtual dispatch, even through the base type
```

`virtual`/`override` must both be explicit — a method is only polymorphic (dispatched based on the actual runtime type) if the base declares it `virtual` and the derived class declares `override`; without both, C# resolves the call statically based on the declared (compile-time) type instead.

## Interfaces and Abstract Classes

```csharp
interface IShape {
    double Area();
}

abstract class ShapeBase : IShape {
    public abstract double Area(); // no body -- subclasses must implement

    public string Describe() => $"Area: {Area()}"; // concrete, shared implementation
}

class Circle : ShapeBase {
    private readonly double radius;
    public Circle(double radius) { this.radius = radius; }
    public override double Area() => Math.PI * radius * radius;
}
```

## `record` Types: Value Equality by Default

```csharp
record Point(double X, double Y);

var p1 = new Point(1, 2);
var p2 = new Point(1, 2);
Console.WriteLine(p1 == p2);       // True -- records compare by VALUE automatically
Console.WriteLine(p1.Equals(p2));   // True

class PointClass { public double X, Y; }
var c1 = new PointClass { X = 1, Y = 2 };
var c2 = new PointClass { X = 1, Y = 2 };
Console.WriteLine(c1 == c2); // False -- classes compare by REFERENCE by default
```

A `record`'s primary constructor (`record Point(double X, double Y)`) automatically generates properties, a constructor, value-based `Equals`/`GetHashCode`, and a `ToString()` — all the boilerplate a hand-written immutable data class would otherwise require, directly comparable to how the JavaScript/TypeScript courses used plain object literals/interfaces for similar data-carrying purposes, but with real, enforced immutability and generated equality.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints polymorphic `Speak()` dispatch through a base-typed reference, an interface-implementing abstract-class hierarchy computing area, and a `record`/`class` equality contrast proving records compare by value while classes compare by reference.

## Common Mistakes

- Forgetting `override` on a derived method even when the base is `virtual` — without it, the base's version still runs when called through a base-typed reference (this is what `new` does instead of `override`, hiding rather than overriding).
- Using a `class` where a `record` would be more appropriate for immutable data — losing automatic value equality and a generated `ToString()` for no benefit.
- Assuming `record`s are always fully immutable — a `record` with mutable (non-`init`-only) properties can still be changed after construction; true immutability requires `init`-only or positional (constructor-only) properties.

## Best Practices

- Use `record` for data-carrying types (DTOs, value objects); use `class` for types with identity, mutable behavior, or a meaningful lifecycle.
- Always pair `virtual` (base) with `override` (derived) explicitly for intentional polymorphism.
- Prefer `interface`s for defining a contract multiple unrelated classes can implement; use `abstract class` when subclasses should share real, concrete behavior alongside the contract.

## Real-World Usage

`record` types are now the standard choice for DTOs (data transfer objects) in ASP.NET Core APIs and Entity Framework Core query projections, specifically for their automatic value equality and concise syntax; `interface`-based contracts remain the standard for dependency injection (a `IPaymentProcessor` interface with `StripeProcessor`/`PayPalProcessor` implementations, resolved by DI at runtime).

## Summary

- `virtual`/`override` must both be explicit for polymorphic dispatch; access modifiers are runtime-enforced, unlike TypeScript's compile-time-only equivalents.
- `interface` defines a pure contract; `abstract class` can mix concrete shared behavior with abstract members.
- `record` types get automatic value-based equality and a generated `ToString()`, contrasted with `class`'s default reference equality.

## Key Terms

- **`virtual`/`override`** — the pair of modifiers required for polymorphic method dispatch based on runtime type.
- **`record`** — a type with automatic value-based equality, contrasted with a `class`'s default reference equality.

## Interview Questions

1. **What's the difference between a `class` and a `record` in C#?**
   Both can hold data and behavior, but `record`s automatically generate value-based `Equals`/`GetHashCode` (two records with identical property values are equal) and a readable `ToString()`, and are conventionally used for immutable data. `class`es use reference equality by default (two instances with identical field values are still unequal unless you override `Equals` yourself) and are conventionally used for types with identity or mutable behavior.

2. **What happens if a derived class overrides a base method without the base method being marked `virtual`?**
   It's a compile error (or, using `new` explicitly, produces member *hiding* rather than overriding) — without `virtual` on the base and `override` on the derived class, C# has no polymorphic dispatch mechanism to use; calling the method through a base-typed reference would always invoke the base's implementation regardless of the object's actual runtime type.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
