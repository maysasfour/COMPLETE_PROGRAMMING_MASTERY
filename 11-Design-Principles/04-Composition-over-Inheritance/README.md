# 04 — Composition over Inheritance

[Back to module overview](../README.md) | [Previous: Coupling and Cohesion](../03-Coupling-and-Cohesion/README.md)

## Beginner: The Fragile Base Class Problem

Inheritance forces every subclass to accept *everything* a base class defines, even behavior that doesn't actually make sense for that subclass. This lesson reproduces a real, concrete case of this — "the fragile base class problem" — then fixes it using **composition**: giving a class a reference to a swappable behavior object (a *has-a* relationship) instead of forcing an *is-a* inheritance relationship where it doesn't actually fit.

## The Violation: A Real, Nonsensical Inherited Behavior

```java
class VehicleViolation {
    String startEngine() { return "Vroom! Engine started."; }
}
class ElectricCarViolation extends VehicleViolation {
    // inherits startEngine() unchanged
}
```

Verified live:

```
GasCar:      Vroom! Engine started.
ElectricCar: Vroom! Engine started.  <- WRONG: an electric car has no engine that "vrooms"!
```

`ElectricCarViolation` has no way to express "I don't start like that" without either overriding the method with an awkward exception (similar to the [Interface Segregation](../01-SOLID-Principles/README.md#i--interface-segregation-principle) `RobotWorker`/`eat()` case) or, as shown here, silently inheriting genuinely wrong behavior. This is a real correctness bug, not a stylistic one — an electric car's UI or logs would report "Vroom! Engine started," which is simply false.

## The Fix: Composition — A HAS-A Relationship With a Swappable Behavior

```java
interface PowerSource { String start(); }
class CombustionEngine implements PowerSource { public String start() { return "Vroom! Engine started."; } }
class ElectricMotor implements PowerSource { public String start() { return "Hummm... electric motor engaged silently."; } }

class Vehicle {
    private final PowerSource powerSource; // composition: HAS-A, not IS-A
    Vehicle(PowerSource powerSource) { this.powerSource = powerSource; }
    String start() { return powerSource.start(); }
}
```

Verified live — the exact same `Vehicle` class produces correct, distinct behavior depending purely on which `PowerSource` it's composed with:

```
GasCar:      Vroom! Engine started.
ElectricCar: Hummm... electric motor engaged silently.  <- correct, distinct behavior
```

## Advanced: Extending Behavior Without Touching Existing Code

Verified live, adding a `HybridPowerSource` required writing one new class — **zero changes to `Vehicle` itself** — directly echoing [Open/Closed](../01-SOLID-Principles/README.md#o--openclosed-principle) from Lesson 01:

```
Adding a HybridCar requires ZERO changes to Vehicle -- just a new PowerSource:
  HybridCar:   Vroom + Hummm... hybrid power engaged.
```

All three vehicles can still be treated uniformly through the same `Vehicle` API, confirmed by iterating over a mixed list and calling `.start()` on each without any type-checking.

## Detailed Example

See [Example.java](Example.java) — the full fragile-base-class bug and its composition-based fix.

## Run It

```bash
cd 11-Design-Principles/04-Composition-over-Inheritance
javac Example.java
java Example
```

## Expected Output

The violation section showing an electric car nonsensically reporting "Vroom! Engine started"; the fixed section showing correct, distinct start behavior per vehicle type via injected `PowerSource` implementations; and a hybrid vehicle added with no changes to `Vehicle` itself.

## Common Mistakes

- Reaching for inheritance whenever two classes seem superficially related ("a car is a vehicle"), without checking whether *all* of the base class's behavior actually makes sense for every subclass — verified live to produce a real, nonsensical inherited behavior.
- Fixing an inheritance mismatch by overriding a method to throw an exception or do nothing, rather than questioning whether inheritance was the right relationship in the first place (the same underlying issue as [Interface Segregation](../01-SOLID-Principles/README.md#i--interface-segregation-principle)'s `RobotWorker`).
- Assuming composition is always "more code" than inheritance — in this example, the composition-based fix has roughly the same amount of code, but correctly isolates each behavior and adds new variants without touching existing classes.

## Best Practices

- Prefer composition (a class holding a reference to an interface, injected via its constructor) when different variants of a "parent" concept genuinely need different, swappable behavior — inheritance is appropriate when subclasses genuinely satisfy 100% of the base class's contract.
- Ask "does every subclass actually make sense with everything the base class provides?" before reaching for inheritance — this lesson's `ElectricCarViolation` is the concrete counter-example when the answer is no.
- Design the "swappable part" (`PowerSource` here) as a small, focused interface, so new variants (a `HybridPowerSource`) can be added without touching any existing code — directly the same benefit as [Open/Closed](../01-SOLID-Principles/README.md#o--openclosed-principle).

## Real-World Usage

This exact pattern — composing a class with an injected, swappable behavior interface instead of forcing inheritance — is the foundation of the Strategy design pattern (covered in [12-Design-Patterns](../../12-Design-Patterns/README.md) if built) and is pervasive in real frameworks: dependency-injected services (Spring, seen in [04-Backend-Development](../../04-Backend-Development/README.md)), pluggable authentication providers, and rendering backends are all composition over inheritance in practice.

## Summary

- Forcing an inheritance relationship where subclasses don't share 100% of the base class's real behavior produces genuinely wrong inherited behavior — verified live with an electric car nonsensically "vrooming."
- Composition (a HAS-A relationship with an injected, interface-typed behavior) fixes this correctly and lets new variants be added without touching existing code.
- This is the same underlying principle as Open/Closed and Interface Segregation from Lesson 01, applied specifically to the choice between inheritance and composition.

## Key Terms

- **Fragile base class problem** — bugs or nonsensical behavior caused by subclasses inheriting base-class behavior that doesn't actually fit them.
- **Composition** — building behavior by holding references to other objects (a HAS-A relationship) rather than through inheritance (an IS-A relationship).
- **Strategy pattern** — a design pattern built directly on composition over inheritance: a class holds a reference to an interchangeable "strategy" object implementing a common interface.

## Interview Questions

1. **What is the "fragile base class problem," and how was a real instance of it demonstrated in this lesson?**
   It's the problem of subclasses breaking or behaving incorrectly because they inherit base-class behavior that doesn't actually apply to them, simply because inheritance forces them to accept the entire base class's implementation. This was demonstrated concretely: `ElectricCarViolation` inherited `startEngine()` from `VehicleViolation` unchanged, and calling it produced the literal, nonsensical, verified-wrong output "Vroom! Engine started." for a vehicle that has no combustion engine at all.

2. **How does composition solve this problem, and how was the fix verified to actually work correctly?**
   Composition replaces "is-a" inheritance with "has-a" — `Vehicle` holds a reference to a `PowerSource` interface, injected via its constructor, rather than inheriting one hard-coded implementation. This was verified live: the *same* `Vehicle` class produced correct, distinct output ("Vroom! Engine started." vs. "Hummm... electric motor engaged silently.") purely based on which `PowerSource` implementation was injected, and a third variant (`HybridPowerSource`) was added and verified working with zero changes to the `Vehicle` class itself.

## Recommended Next Lesson

This is the final lesson in the Design Principles module. Continue to [12-Design-Patterns](../../12-Design-Patterns/README.md) if built, or return to the [module overview](../README.md).
