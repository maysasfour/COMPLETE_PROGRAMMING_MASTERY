# 11 — Design Principles

[Back to repository root](../README.md)

## What Design Principles Covers

Design principles are the foundational rules that make object-oriented code easier to change, extend, and reason about — independent of any specific design pattern (covered next, in [12-Design-Patterns](../12-Design-Patterns/README.md), if built) or architecture ([13-Software-Architecture](../13-Software-Architecture/README.md)). This module covers SOLID, DRY/KISS/YAGNI, coupling/cohesion, and composition over inheritance — four lessons, each demonstrating a real, verified bug caused by violating the principle, followed by a fix.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md) and [04-Backend-Development](../04-Backend-Development/README.md) for the same reasoning, and per this session's standing directive to prefer Java for modules requiring a language choice). Java's explicit interfaces, access modifiers, and static typing make violations of these principles (a public field enabling tight coupling, a missing interface forcing a fat dependency) especially concrete and visible. No build tool or external dependency is needed for this module — every lesson is a single, self-contained `Example.java` file, compiled and run directly with `javac`/`java`.

## Why It Matters / Where It's Used

- **These principles are the "why" behind design patterns and architecture** — a design pattern is really just a named, reusable way of applying these underlying principles to a recurring problem shape.
- **Code review and refactoring both depend on recognizing these principles' violations** — "this class is doing too much" (Single Responsibility / low cohesion), "this breaks if I change that" (tight coupling), "we don't need this yet" (YAGNI) are some of the most common real code review comments.
- **Interviews**: SOLID, DRY, and composition-vs-inheritance are among the most frequently asked object-oriented design interview topics, directly covered by this module's four lessons.

## Advantages of This Approach

- Every principle in this module is demonstrated as a **real, compiled, and run bug** — a genuinely wrong Liskov Substitution result (`got: 100` instead of `50`), a genuinely drifted discount rate, a genuinely mislabeled temperature, a genuinely nonsensical "Vroom!" from an electric car — not just described in the abstract.
- Each lesson pairs the violation directly against its fix in the same runnable file, making the improvement observable rather than asserted.
- The lessons build on each other conceptually: Lesson 03's coupling/cohesion issues are a lower-level lens on Lesson 01's Single Responsibility; Lesson 04's composition-over-inheritance directly extends Lesson 01's Open/Closed and Interface Segregation.

## Disadvantages / Trade-offs

- These principles can be over-applied — introducing an interface, or splitting a class, for something that will only ever have one variant adds indirection without benefit (directly the tension explored in Lesson 02's YAGNI section).
- Some tradeoffs are genuinely contextual: a small script or prototype reasonably tolerates coupling and duplication that would be a real liability in a large, long-lived codebase — these principles are guidance for maintainable, evolving software, not universal rules for every line of code.

## How to Run the Examples

Each lesson is a single, self-contained Java file — no build tool or dependencies required.

```bash
cd 11-Design-Principles/01-SOLID-Principles
javac Example.java
java Example
```

Requires only a JDK (this module was built and verified against JDK 25). `.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Treating SOLID as a checklist rather than a set of tools for a specific problem** — verified live in Lesson 01 that each principle addresses a specific, concrete failure mode (drifted logic, forced edits to existing code, broken substitutability, forced meaningless method implementations, hard-wired dependencies), not an aesthetic preference.
- **Copy-pasting logic "just this once"** — verified live in Lesson 02 to drift into inconsistent behavior within a single small example.
- **Reaching for "clever" code over obviously-correct code** — verified live in Lesson 02 to hide a real edge-case bug.
- **Building speculative flexibility for hypothetical future needs** — verified live in Lesson 02 to introduce genuinely buggy, entirely unverified code.
- **Exposing internal representation directly (public fields, unconverted getters)** — verified live in Lesson 03 to let a caller misuse that representation with a real, silent bug.
- **Reaching for inheritance whenever two things seem superficially related** — verified live in Lesson 04 to force nonsensical behavior onto a subclass that doesn't actually fit the base class's contract.

## Best Practices

- Give each class one clear, nameable responsibility, using only its own private state.
- Extract genuinely duplicated logic as soon as a second copy appears; favor the simplest correct solution; build only what's actually needed now.
- Depend on abstractions (interfaces) rather than concrete implementations, especially across module/layer boundaries.
- Prefer composition (a HAS-A relationship with an injected, swappable behavior) over inheritance when different variants need genuinely different behavior.

## Interview Questions

1. What are the five SOLID principles, and can you describe a concrete violation of each?
2. What's the difference between DRY, KISS, and YAGNI — and can violating one make another harder to follow?
3. What's the difference between coupling and cohesion?
4. When should composition be preferred over inheritance, and what problem does it solve?
5. How does the Liskov Substitution Principle relate to unit testing (mocks/stubs substituted for real dependencies)?
6. Why is unused, speculative code considered a real liability rather than a harmless placeholder?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [SOLID Principles](01-SOLID-Principles/README.md) | Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion |
| 02 | [DRY, KISS, and YAGNI](02-DRY-KISS-YAGNI/README.md) | Don't Repeat Yourself, Keep It Simple, You Aren't Gonna Need It |
| 03 | [Coupling and Cohesion](03-Coupling-and-Cohesion/README.md) | Tight coupling to internal representation; low cohesion from shared, unrelated state |
| 04 | [Composition over Inheritance](04-Composition-over-Inheritance/README.md) | The fragile base class problem; HAS-A vs. IS-A relationships |

## Suggested Path

Work through 01 → 04 in order — Lesson 01's SOLID principles are referenced directly by Lessons 03 and 04 (coupling/cohesion as a lower-level lens on Single Responsibility; composition over inheritance as an extension of Open/Closed and Interface Segregation). See also [12-Design-Patterns](../12-Design-Patterns/README.md) (if built) for named, reusable applications of these same principles to recurring problem shapes, and [13-Software-Architecture](../13-Software-Architecture/README.md) (if built) for how these principles scale up to whole-system design.

**Previous module:** [07-Databases](../07-Databases/README.md)
