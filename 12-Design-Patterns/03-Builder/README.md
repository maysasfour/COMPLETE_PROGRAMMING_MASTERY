# 03 — Builder

[Back to module overview](../README.md) | [Previous: Factory Method and Abstract Factory](../02-Factory-Method-and-Abstract-Factory/README.md)

## Beginner: The Telescoping Constructor Problem

When a class has several parameters (especially several of the same type, like two separate `int`s), a plain constructor forces callers to remember the exact positional order — and the compiler cannot catch it if two same-typed arguments get swapped. This lesson demonstrates that real, silent bug, then fixes it with the Builder pattern.

## The Violation: A Real, Compiling, Silently Wrong Result

```java
class PizzaViolation {
    PizzaViolation(int sizeInches, boolean cheese, boolean pepperoni, int quantity) { ... }
}
```

```java
PizzaViolation intended = new PizzaViolation(12, true, false, 2); // correct order
PizzaViolation swapped  = new PizzaViolation(2, true, false, 12); // sizeInches and quantity SWAPPED
```

Both lines compile perfectly — `sizeInches` and `quantity` are both plain `int`s, so the compiler has no way to know they were swapped. Verified live:

```
Intended:      2x 12-inch pizza (cheese=true, pepperoni=false)
Actually built: 12x 2-inch pizza (cheese=true, pepperoni=false)  <- BUG: compiles fine, but this is nonsense (2-inch pizza x12)!
```

The "swapped" call silently produced an order for twelve 2-inch pizzas instead of two 12-inch pizzas — a real, compiling, wrong result that would only surface as a confusing production/business bug, not a compile error.

## The Fix: Builder — Named Methods Eliminate Positional Ambiguity

```java
Pizza correct = new Pizza.Builder()
        .sizeInches(12)
        .cheese(true)
        .quantity(2)
        .build();
```

Verified live — the result is correct, and self-documenting regardless of the order the builder methods are called in:

```
2x 12-inch pizza (cheese=true, pepperoni=false)  <- correct, and self-documenting regardless of call order
2x 12-inch pizza (cheese=true, pepperoni=false)  <- same result, even with methods called in a different order
```

Because every value is set through a named method (`.sizeInches(12)`, `.quantity(2)`), there is no longer any positional slot for two same-typed values to be silently swapped into — the class of bug demonstrated in the violation is now structurally impossible, not just less likely.

## Detailed Example

See [Example.java](Example.java) — the real swapped-argument bug and the Builder-based fix.

## Run It

```bash
cd 12-Design-Patterns/03-Builder
javac Example.java
java Example
```

## Expected Output

The violation section showing a correctly-ordered pizza alongside a silently swapped, nonsensical one (both compiling without error); the fixed section showing the Builder producing the correct result regardless of method call order.

## Common Mistakes

- Using positional constructor arguments for objects with several parameters of the same type — verified live to allow a silent, compiling, wrong result when two are swapped.
- Adding a new "telescoping" constructor overload (e.g., a 3-argument version, a 5-argument version) for every combination of optional parameters, rather than one flexible Builder.
- Making a Builder's `build()` method skip validation — a well-designed Builder should still validate that required fields were actually set before constructing the final object.

## Best Practices

- Reach for Builder when a class has more than a handful of constructor parameters, especially several optional ones or several of the same type.
- Give builder methods clear, named verbs/nouns (`.sizeInches(12)`, not `.setA(12)`) so a builder chain reads as self-documenting.
- Make the built object immutable (`final` fields, no setters) once `build()` has produced it, so the Builder's job is clearly finished at that point.

## Real-World Usage

Builder is extremely common in real Java code — `StringBuilder`, HTTP client request builders, and Stream API collectors all follow this same pattern, specifically because it avoids ambiguous positional arguments and reads clearly at the call site, exactly as demonstrated in this lesson's `Pizza.Builder` example.

## Summary

- A constructor with multiple same-typed parameters allows a real, compiling, silently wrong result if two arguments are swapped — verified live with a 2x12-inch order silently becoming 12x2-inch.
- Builder replaces positional arguments with named methods, verified live to produce the correct result regardless of the order those methods are called in, making the swapped-argument bug structurally impossible.

## Key Terms

- **Telescoping constructor problem** — the difficulty of managing a class with many constructor parameters (especially many overloads for optional combinations), where positional arguments become error-prone.
- **Builder** — a design pattern that constructs an object step by step via named methods, then finalizes it with a `build()` call.
- **Fluent interface** — a coding style (used here) where methods return `this`, allowing calls to be chained together.

## Interview Questions

1. **Why can't the compiler catch a bug where two constructor arguments of the same type are accidentally swapped, and how was this demonstrated concretely?**
   The compiler only checks that argument *types* match a constructor's parameter types, not that the values are in the intended logical order — two `int` parameters are interchangeable from the compiler's point of view. This was demonstrated concretely: `new PizzaViolation(2, true, false, 12)` compiled without any error or warning, despite `sizeInches` and `quantity` being swapped, producing a nonsensical "12x 2-inch pizza" instead of the intended "2x 12-inch pizza" — a real, silent, wrong result verified by the actual printed output.

2. **How does the Builder pattern make the swapped-argument bug structurally impossible rather than just less likely?**
   Builder replaces positional arguments with named methods (`.sizeInches(12)`, `.quantity(2)`), so there is no longer any positional slot where two same-typed values could be silently swapped — each value is explicitly labeled by the method used to set it, and calling the methods in any order produces the identical, correct result. This was verified live: the same `Pizza.Builder` chain, with `.quantity(2)` and `.sizeInches(12)` called in a different order in a second example, produced the exact same, correct pizza both times.

## Recommended Next Lesson

[04 — Adapter and Decorator](../04-Adapter-and-Decorator/README.md)
