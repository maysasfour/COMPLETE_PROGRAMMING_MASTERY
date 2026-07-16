# 01 — SOLID Principles

[Back to module overview](../README.md)

## Beginner: What SOLID Is

SOLID is five design principles for writing object-oriented code that's easier to change and extend without breaking existing behavior. Each one is demonstrated below as a real violation, then a real fix — both compiled and run, with the actual (sometimes surprising) output shown.

## S — Single Responsibility Principle

**A class should have exactly one reason to change.**

The violation mixes invoice pricing logic with invoice printing in one class — a change to the print format now requires touching the same class as a change to pricing logic:

```java
class InvoiceViolation {
    double calculateTotal() { ... }
    void printInvoice() { System.out.println("Invoice total: $" + calculateTotal()); }
}
```

The fix splits these into `Invoice` (pricing only) and `InvoicePrinter` (printing only) — each has exactly one reason to change.

## O — Open/Closed Principle

**Open for extension, closed for modification.**

The violation computes area via an `if`/`else instanceof` chain — adding a new shape means *editing* this existing, already-working method:

```java
static double areaViolation(Object shape) {
    if (shape instanceof double[] circle) { ... }
    else if (shape instanceof int[] rectangle) { ... }
    throw new IllegalArgumentException("Unknown shape");
}
```

The fix uses a `Shape` interface with `area()`. Verified live: adding `Triangle` required writing one new class implementing `Shape` — **zero lines of existing code were touched**:

```
Fixed (new Triangle added with ZERO changes to existing code):
  Circle area: 12.57
  Rectangle area: 12.00
  Triangle area: 12.00
```

## L — Liskov Substitution Principle

**Subtypes must be substitutable for their base type without breaking correctness.**

The violation is the classic Rectangle/Square problem: `Square extends Rectangle`, overriding `setWidth`/`setHeight` to keep both dimensions equal. This breaks any code that relies on `Rectangle`'s contract (setting width and height independently). Verified live:

```
Expected area 50, got: 50
Substituting a Square where a Rectangle is expected:   Expected area 50, got: 100
```

Calling the exact same `resizeAndCheck` method — written only against the `Rectangle` contract — produces a **different, wrong result** the moment a `Square` is substituted in. That's Liskov Substitution being violated in a real, observable way, not just in theory.

The fix removes the forced inheritance entirely: `RectangleShape` and `SquareShape` both implement a shared `Quadrilateral` interface with no mutable shared state whose contract can be silently broken.

## I — Interface Segregation Principle

**Clients shouldn't be forced to depend on methods they don't use.**

The violation has one fat `WorkerViolation` interface with both `work()` and `eat()` — forcing `RobotWorker` to implement `eat()`, which makes no sense for a robot:

```java
class RobotWorkerViolation implements WorkerViolation {
    public void eat() { throw new UnsupportedOperationException("Robots don't eat!"); }
}
```

Verified live: calling `eat()` on the robot throws exactly that exception at runtime — a real, working (or rather, deliberately non-working) example of a fat interface forcing a meaningless method implementation.

The fix splits `WorkerViolation` into `Workable` and `Eatable`; `RobotWorker` implements only `Workable` — there is no `eat()` method to call incorrectly at all.

## D — Dependency Inversion Principle

**Depend on abstractions, not concrete implementations.**

The violation hard-wires `NotificationServiceViolation` directly to a concrete `EmailSender`:

```java
class NotificationServiceViolation {
    private final EmailSender sender = new EmailSender(); // concrete dependency
}
```

Switching to SMS later would require editing `NotificationServiceViolation`'s source directly. The fix introduces a `MessageSender` abstraction, injected via the constructor:

```java
class NotificationService {
    NotificationService(MessageSender sender) { this.sender = sender; }
}
```

Verified live: the exact same `NotificationService` class sent both an email and an SMS, depending only on which `MessageSender` implementation was injected — **zero changes to `NotificationService` itself** were needed to add SMS support.

## Detailed Example

See [Example.java](Example.java) — all five principles, each with a real violation and a real fix, fully runnable in one file.

## Run It

```bash
cd 11-Design-Principles/01-SOLID-Principles
javac Example.java
java Example
```

## Expected Output

Five sections (S, O, L, I, D), each printing its violation's real (sometimes surprising, as in Liskov's `got: 100`) behavior, followed by the fixed version's correct behavior.

## Common Mistakes

- Treating SOLID as an aesthetic preference rather than a set of principles with concrete, demonstrable failure modes — this lesson deliberately shows the *actual* wrong output (`got: 100` for Liskov, an actual thrown exception for Interface Segregation) rather than just describing the ideas abstractly.
- Applying inheritance based on real-world "is-a" intuition (a square *is* a rectangle, geometrically) without checking whether the *behavioral contract* still holds — Liskov Substitution is about contracts, not taxonomy.
- Over-applying Open/Closed prematurely — introducing an interface and multiple implementations for something that will only ever have one variant adds indirection without benefit; apply it where extension is genuinely anticipated.

## Best Practices

- Give each class one clear, nameable responsibility (Single Responsibility) — if describing a class requires "and," it likely has two responsibilities.
- Design new behavior as new implementations of existing abstractions rather than edits to existing, tested code (Open/Closed).
- Verify that a subtype actually preserves its supertype's behavioral contract before using inheritance, not just structural similarity (Liskov Substitution).
- Split large interfaces along the lines of what different clients actually need (Interface Segregation).
- Inject dependencies as abstractions (interfaces) rather than instantiating concrete classes directly inside a dependent class (Dependency Inversion).

## Real-World Usage

SOLID underlies most modern framework design: dependency injection frameworks (Spring, seen in [04-Backend-Development](../../04-Backend-Development/README.md)) exist specifically to apply Dependency Inversion at scale; plugin architectures rely on Open/Closed; and well-designed test suites depend on Liskov Substitution holding for any mock/stub substituted in for a real dependency.

## Summary

- Single Responsibility: one class, one reason to change — verified by splitting pricing from printing.
- Open/Closed: extend via new classes, not edits to existing ones — verified by adding `Triangle` with zero changes elsewhere.
- Liskov Substitution: a subtype must not break the supertype's contract — verified live by a Square substitution silently producing a wrong area (100 instead of the expected 50).
- Interface Segregation: split fat interfaces so clients aren't forced to implement irrelevant methods — verified live by a thrown exception when violated.
- Dependency Inversion: depend on abstractions, not concrete classes — verified by swapping `EmailMessageSender` for `SmsMessageSender` with zero changes to the dependent class.

## Key Terms

- **SOLID** — Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **Behavioral contract** — the guarantees a type's behavior makes to its callers, independent of its internal implementation.
- **Dependency injection** — supplying a dependency (often as an abstraction) from outside a class, rather than the class constructing it itself.

## Interview Questions

1. **What is the Liskov Substitution Principle, and how was a violation of it demonstrated concretely in this lesson?**
   LSP states that a subtype must be usable anywhere its supertype is expected without altering the correctness of the program. This was demonstrated concretely with the Rectangle/Square example: a method (`resizeAndCheck`) written only against `Rectangle`'s contract (set width, set height, expect `width * height`) produced the correct result (50) for a `Rectangle`, but an incorrect result (100) the moment a `Square` — which silently keeps both dimensions equal — was substituted in, proving the substitution broke the caller's correctness assumption.

2. **How does Dependency Inversion differ from simply "using interfaces," and how was it verified in this lesson?**
   Dependency Inversion specifically means a *higher-level* class (like `NotificationService`) should depend on an abstraction rather than instantiating and directly depending on a *lower-level*, concrete class (like `EmailSender`) itself — the dependency is inverted: the abstraction is defined by/for the higher-level class's needs, and concrete implementations depend on it, not the other way around. This was verified by injecting two different concrete `MessageSender` implementations (`EmailMessageSender`, `SmsMessageSender`) into the exact same `NotificationService` class and confirming both worked correctly with zero changes to `NotificationService` itself.

## Recommended Next Lesson

[02 — DRY, KISS, and YAGNI](../02-DRY-KISS-YAGNI/README.md)
