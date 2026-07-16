# 12 — Design Patterns

[Back to repository root](../README.md)

## What Design Patterns Covers

Design patterns are named, reusable solutions to recurring object-oriented design problems — concrete applications of the principles covered in [11-Design-Principles](../11-Design-Principles/README.md) to specific problem shapes. This module covers six of the most commonly used Gang-of-Four patterns across all three categories (creational, structural, behavioral), each demonstrated as a real, verified bug caused by *not* using the pattern, followed by a fix.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [11-Design-Principles](../11-Design-Principles/README.md) for the same reasoning, and this session's standing directive to prefer Java where a language choice is needed). As with Design Principles, no build tool or external dependency is needed — every lesson is a single, self-contained `Example.java` file, compiled and run directly with `javac`/`java`.

## Why It Matters / Where It's Used

- **Design patterns give teams a shared vocabulary** — saying "just use a Strategy here" communicates an entire design approach instantly to anyone familiar with the pattern.
- **Every pattern in this module solves a real, recurring bug category** — a race condition (Singleton), copy-paste drift in object creation (Factory Method/Abstract Factory), a swapped-argument bug (Builder), a forgotten unit conversion (Adapter), a duplicated pricing formula (Decorator), a silently-unwired dependent (Observer), a shadowed branch (Strategy), and a wrong undo (Command) — all reproduced live, not just described.
- **Interviews**: "explain the Singleton pattern and its pitfalls," "when would you use Strategy vs. Factory," and "how does Observer work" are extremely common object-oriented design interview questions, directly covered by this module's six lessons.

## Advantages of This Approach

- Every pattern is paired against a **real, compiled, and run bug**: a measured race condition creating 6-9 duplicate "singleton" instances out of 10 threads, a real SMS silently sent as an Email, a real pizza order silently swapped to nonsense, a real 100x under-charge, a real drifted coffee price, a real stale mobile display, a real mis-taxed country, and a real wrong undo value.
- Each lesson pairs the violation directly against its fix in the same runnable file, making the improvement observable rather than asserted.
- The lessons are cross-referenced directly with [11-Design-Principles](../11-Design-Principles/README.md) — Strategy and Command are shown as concrete applications of composition and encapsulation; Observer and Adapter/Decorator directly demonstrate Open/Closed in action.

## Disadvantages / Trade-offs

- Design patterns can be over-applied — introducing a Factory, Strategy, or Observer for something with only ever one fixed variant adds indirection without benefit, the same YAGNI caution raised throughout [11-Design-Principles](../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#yagni--you-arent-gonna-need-it).
- Some patterns solve problems that modern language features address more directly in certain contexts (e.g., Java's `enum` for a simple Singleton, or `Comparator` lambdas in place of a full Strategy class hierarchy) — knowing the classic pattern is still valuable for recognizing the underlying problem shape wherever it appears.

## How to Run the Examples

Each lesson is a single, self-contained Java file — no build tool or dependencies required.

```bash
cd 12-Design-Patterns/01-Singleton
javac Example.java
java Example
```

Requires only a JDK (this module was built and verified against JDK 25). `.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Assuming a "lazy" singleton with a simple null-check is automatically thread-safe** — verified live in Lesson 01 to actually create multiple instances (6-9 out of 10 concurrent threads) under real concurrent access.
- **Duplicating object-creation logic across call sites** — verified live in Lesson 02 to drift apart when only some copies are updated.
- **Using positional constructor arguments for classes with several same-typed parameters** — verified live in Lesson 03 to allow a silent, compiling, wrong result when two are swapped.
- **Letting every call site convert between incompatible interfaces itself** — verified live in Lesson 04 to allow a forgotten conversion and a real 100x under-charge.
- **Reimplementing shared logic across subclasses for different combinations of optional behavior** — verified live in Lesson 04 to let that logic drift apart between subclasses.
- **Hard-coding notification calls to specific dependents** — verified live in Lesson 05 to let a genuinely added dependent silently never receive updates.
- **Using order-dependent `if`/`else if` chains for selection logic** — verified live in Lesson 06 to let one branch accidentally shadow another.
- **Implementing undo by remembering only an action's type, not its actual previous state** — verified live in Lesson 06 to restore a hardcoded, wrong default.

## Best Practices

- Verify concurrency-sensitive code (like Singleton) with an actual concurrent test, not just reasoning in the abstract.
- Centralize object-creation and algorithm-selection logic in one place (Factory Method, Strategy) rather than scattering or branching it.
- Use named builder methods instead of positional arguments for classes with several parameters.
- Wrap incompatible APIs in a single Adapter; compose optional behaviors via Decorator rather than subclassing every combination.
- Notify dependents through a uniform, registered list (Observer) rather than hard-coded calls.
- Have Command objects capture their own state needed for undo, rather than assuming or hardcoding it.

## Interview Questions

1. Why isn't a naive lazy Singleton automatically thread-safe, and what's a correct, verified fix?
2. What's the difference between Factory Method and Abstract Factory?
3. What problem does Builder solve that a plain constructor doesn't?
4. When would you use Adapter vs. Decorator?
5. How does Observer relate to the Open/Closed Principle?
6. How does Command support undo/redo, and what must a Command capture to do so correctly?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Singleton](01-Singleton/README.md) | A real, measured race condition in a naive singleton; the initialization-on-demand holder idiom fix |
| 02 | [Factory Method and Abstract Factory](02-Factory-Method-and-Abstract-Factory/README.md) | Centralizing object creation; guaranteeing consistent families of related objects |
| 03 | [Builder](03-Builder/README.md) | Fixing a real swapped-argument bug with named builder methods |
| 04 | [Adapter and Decorator](04-Adapter-and-Decorator/README.md) | Fixing a real unit-conversion bug and a real drifted-pricing bug |
| 05 | [Observer](05-Observer/README.md) | Fixing a real stale-data bug from hard-coded notification calls |
| 06 | [Strategy and Command](06-Strategy-and-Command/README.md) | Fixing a real order-dependent branching bug and a real wrong-undo bug |

## Suggested Path

Work through 01 → 06 in order — this module builds directly on [11-Design-Principles](../11-Design-Principles/README.md): Strategy and Command extend composition over inheritance ([Lesson 04](../11-Design-Principles/04-Composition-over-Inheritance/README.md)); Observer and Adapter/Decorator directly demonstrate Open/Closed in practice ([Lesson 01](../11-Design-Principles/01-SOLID-Principles/README.md)). See also [13-Software-Architecture](../13-Software-Architecture/README.md) (if built) for how these object-level patterns scale up to whole-system design.

**Previous module:** [11-Design-Principles](../11-Design-Principles/README.md)
