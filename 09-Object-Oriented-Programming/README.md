# 09 — Object-Oriented Programming

[Back to repository root](../README.md)

## What Is Object-Oriented Programming?

Object-Oriented Programming (OOP) is a way of structuring code around **objects** — bundles of data (attributes) and the behavior that operates on that data (methods) — rather than around a sequence of standalone functions acting on loose data. A `BankAccount` object knows its own `balance` and knows how to `deposit()` or `withdraw()`; you don't pass a balance around to free-floating functions and hope every caller updates it consistently.

OOP rests on four pillars, each covered in depth in its own lesson here:

- **Encapsulation** — bundling data with the methods that operate on it, and controlling access to that data.
- **Abstraction** — exposing only what a caller needs to know, hiding implementation detail behind a simple interface.
- **Inheritance** — building new classes from existing ones to reuse and specialize behavior.
- **Polymorphism** — treating objects of different types uniformly through a shared interface, with each type supplying its own behavior.

This module uses **Python** as the reference language (consistent with the rest of this repository's concept modules — see [00-Programming-Fundamentals](../00-Programming-Fundamentals/README.md)). Every idea here transfers directly to Java, C#, C++, TypeScript, Kotlin, Swift, and any other class-based language; only the syntax changes.

## Why It Matters / Where It's Used

- **Large codebases**: OOP gives you a vocabulary (classes, objects, interfaces) for organizing thousands of lines of related behavior so teams can reason about pieces in isolation.
- **Frameworks and libraries**: Django models, Java's standard library, .NET, Qt, and most GUI toolkits are built around class hierarchies you extend.
- **Domain modeling**: when your problem is naturally made of "things with behavior" — users, orders, game entities, UI widgets — objects map cleanly onto that mental model.
- **Interviews**: OOP design questions ("design a parking lot", "design an elevator system") are a staple of software engineering interviews specifically because they test whether you can translate a fuzzy real-world problem into cohesive classes.

## Advantages

- **Encapsulation reduces bugs**: data and the logic that keeps it valid live together, so invalid states are harder to create by accident.
- **Reuse via inheritance and composition**: shared behavior is written once and extended, not copy-pasted.
- **Polymorphism simplifies calling code**: a function that accepts "anything with a `.speak()` method" doesn't need to know or care about the concrete type.
- **Maps naturally onto real-world domains**, which makes designs easier to discuss with non-programmers and easier to onboard new team members onto.

## Disadvantages / Trade-offs

- **Overuse leads to needless ceremony** — wrapping a single function in a class with one method ("classitis") adds indirection with no benefit. Not everything needs to be an object; see [10-Functional-Programming](../10-Functional-Programming/README.md) for the alternative paradigm.
- **Deep inheritance hierarchies become fragile** — a change to a base class can ripple unpredictably through many subclasses ("fragile base class problem"). Lesson 06 covers why composition is usually the safer default.
- **Can obscure control flow** — with virtual dispatch and inheritance, "what code actually runs" requires tracing the type hierarchy, which is harder to grep than a plain function call.
- **State + behavior coupling can hurt testability** if objects reach out to global state or hidden dependencies instead of receiving them explicitly.

## How to Run the Examples

Every lesson folder has a runnable `example.py`. From inside that folder:

```bash
python example.py
```

Requires Python 3.10+ (this module uses modern type-hint syntax like `list[int]` and `X | None`). Verify with `python --version`. No third-party packages are required anywhere in this module — everything uses the standard library (`abc`, `typing`, `dataclasses`).

## Common Beginner Mistakes

- **Confusing a class with an object.** A class is the blueprint (`class Dog:`); an object is a specific thing built from that blueprint (`my_dog = Dog("Rex")`). "Dog" the concept doesn't bark; a specific dog does.
- **Using a mutable default argument in `__init__`** (e.g. `def __init__(self, items=[])`) — the same list gets shared across every instance that doesn't pass its own. Always default to `None` and create the mutable value inside the method.
- **Reaching for inheritance when composition fits better** — modeling "a `Car` is an `Engine`" instead of "a `Car` *has an* `Engine`" (see Lesson 06).
- **Treating `_x` or `__x` as real security** — Python's privacy is a naming convention and a name-mangling trick, not enforcement (see Lesson 02).
- **Forgetting `self`** as the first parameter of instance methods, or forgetting to call `super().__init__()` in a subclass, silently skipping base-class setup.
- **Overriding `__eq__` without `__hash__`** — makes instances unusable in sets/dicts in surprising ways (covered in Lesson 05).

## Best Practices

- Favor composition over inheritance unless there's a genuine "is-a" relationship that will remain true for the life of the design (Lesson 06).
- Keep classes small and focused — a class with a dozen unrelated responsibilities is a sign it should be split.
- Depend on abstractions (`abc.ABC` or `typing.Protocol`), not concrete classes, when writing code that should work with multiple implementations (Lessons 03, 07).
- Use `@property` for validated or computed attributes instead of raw public fields you'd need to migrate later (Lesson 02).
- Prefer `@staticmethod`/`@classmethod` deliberately — a `@staticmethod` that doesn't touch the class at all is often better as a plain module-level function (Lesson 08).

## Interview Questions

1. What are the four pillars of OOP, and can you give a concrete example of each?
2. What's the difference between a class and an object (instance)?
3. What is method resolution order (MRO), and why does Python use C3 linearization instead of simple depth-first search?
4. When would you choose composition over inheritance? Give an example where inheritance actively causes problems.
5. What's the difference between an abstract base class and a `Protocol` in Python? When would you use each?
6. What is polymorphism, and how does Python achieve it without an explicit `interface` keyword?
7. Why does Python not have true private members, and what convention does it use instead?
8. What's the difference between `@staticmethod` and `@classmethod`?

(Detailed answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Classes and Objects](01-Classes-and-Objects/README.md) | `class`, `__init__`, instance vs. class attributes, identity |
| 02 | [Encapsulation](02-Encapsulation/README.md) | Public/protected/private conventions, `@property`, validation |
| 03 | [Abstraction](03-Abstraction/README.md) | `abc.ABC`, `@abstractmethod`, `typing.Protocol` |
| 04 | [Inheritance](04-Inheritance/README.md) | `super()`, method resolution order, when not to inherit |
| 05 | [Polymorphism](05-Polymorphism/README.md) | Duck typing, overriding, operator overloading, dynamic dispatch |
| 06 | [Composition vs. Inheritance](06-Composition-vs-Inheritance/README.md) | "Favor composition" with a before/after refactor |
| 07 | [Interfaces and Abstract Classes](07-Interfaces-and-Abstract-Classes/README.md) | ABC vs. Protocol vs. duck typing — when each fits |
| 08 | [Generics and Static Members](08-Generics-and-Static-Members/README.md) | `TypeVar`/`Generic`, `@staticmethod` vs `@classmethod` |

Also in this module:

- [Exercises/](Exercises/README.md) — 6 problems spanning the whole module.
- [Solutions/](Solutions/README.md) — matching worked solutions.
- [Diagrams/](Diagrams/README.md) — Mermaid class diagrams for the mini-project.
- [Mini-Project/](Mini-Project/README.md) — a full Library Management System console app.

## Suggested Path

Work through 01 → 08 in order — each lesson assumes the previous ones. Do the Exercises after Lesson 08, then read the Diagrams before working through the Mini-Project, which ties every pillar together in one program.

**Next module:** [10-Functional-Programming](../10-Functional-Programming/README.md)
