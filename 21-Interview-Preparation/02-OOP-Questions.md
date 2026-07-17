# Object-Oriented Programming Interview Questions

[Back to module overview](README.md)

## 1. What are the four pillars of OOP?

Encapsulation, Abstraction, Inheritance, and Polymorphism. See [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md) for a full, dedicated treatment of each.

## 2. What's the difference between encapsulation and abstraction?

Encapsulation is bundling data with the methods that operate on it, and restricting direct access to that data (private fields, public methods) — it's about *hiding implementation details*. Abstraction is exposing only the relevant, essential behavior of an object while hiding unnecessary complexity — it's about *simplifying what the caller needs to think about*. They're related but distinct: encapsulation is a mechanism; abstraction is a design goal. See [09-Object-Oriented-Programming/02-Encapsulation](../09-Object-Oriented-Programming/02-Encapsulation/README.md) and [03-Abstraction](../09-Object-Oriented-Programming/03-Abstraction/README.md).

## 3. What's the difference between an interface and an abstract class?

An interface defines a contract (method signatures) with no implementation (traditionally), which a class can implement regardless of its position in a class hierarchy — a class can implement multiple interfaces. An abstract class can provide partial implementation and shared state, but a class can only extend one (in most single-inheritance languages). See [09-Object-Oriented-Programming/07-Interfaces-and-Abstract-Classes](../09-Object-Oriented-Programming/07-Interfaces-and-Abstract-Classes/README.md).

## 4. What's the difference between method overloading and overriding?

Overloading is defining multiple methods with the same name but different parameter lists in the same class — resolved at compile time based on argument types. Overriding is a subclass providing its own implementation of a method already defined in its superclass — resolved at runtime based on the object's actual type (dynamic dispatch). See [09-Object-Oriented-Programming/05-Polymorphism](../09-Object-Oriented-Programming/05-Polymorphism/README.md).

## 5. Why is composition often preferred over inheritance?

Inheritance forces a subclass to accept *all* of its superclass's behavior, even parts that don't actually fit — this was demonstrated as a real, concrete bug in [11-Design-Principles/04-Composition-over-Inheritance](../11-Design-Principles/04-Composition-over-Inheritance/README.md), where an `ElectricCar` inheriting `startEngine()` from `Vehicle` produced the nonsensical, verified output "Vroom! Engine started." Composition (a class holding a reference to an interchangeable behavior object) avoids this by only including behavior a class actually needs, and allows behavior to be swapped or extended without touching existing code.

## 6. What is the Liskov Substitution Principle, and can you give a concrete example of violating it?

A subtype must be substitutable for its base type without breaking the correctness of code written against the base type. The classic violation is Rectangle/Square: `Square extends Rectangle` but overrides `setWidth`/`setHeight` to keep both dimensions equal, which breaks any code relying on `Rectangle`'s contract of setting width and height independently. This was verified live in [11-Design-Principles/01-SOLID-Principles](../11-Design-Principles/01-SOLID-Principles/README.md): substituting a `Square` where a `Rectangle` was expected produced a silently wrong area (`100` instead of the expected `50`).

## 7. What is dependency inversion, and why does it matter?

High-level modules should depend on abstractions, not concrete low-level implementations — and low-level implementations should depend on those same abstractions. This was demonstrated in [11-Design-Principles/01-SOLID-Principles](../11-Design-Principles/01-SOLID-Principles/README.md): a `NotificationService` depending directly on a concrete `EmailSender` couldn't add SMS support without editing its own source, while depending on a `MessageSender` interface allowed swapping `EmailMessageSender` for `SmsMessageSender` with zero changes to `NotificationService` itself.

## 8. What's the difference between a class and an object?

A class is a blueprint/template defining the structure (fields) and behavior (methods) that instances will have. An object is a concrete instance of a class, with its own actual data occupying real memory. See [09-Object-Oriented-Programming/01-Classes-and-Objects](../09-Object-Oriented-Programming/01-Classes-and-Objects/README.md).

## 9. What is a design pattern, and can you name one from each GoF category?

A design pattern is a named, reusable solution to a recurring object-oriented design problem. Creational: Singleton, Factory Method, Builder. Structural: Adapter, Decorator. Behavioral: Observer, Strategy, Command. All six were built and verified with real, reproduced bugs in [12-Design-Patterns](../12-Design-Patterns/README.md).

## 10. Why is a naive lazy Singleton not automatically thread-safe?

The classic `if (instance == null) { instance = new Singleton(); }` check-then-act pattern is not atomic — multiple threads can all see `instance == null` before any of them finishes creating it, resulting in multiple instances. This was verified live in [12-Design-Patterns/01-Singleton](../12-Design-Patterns/01-Singleton/README.md): 10 real threads racing to call `getInstance()` created 6-9 distinct instances rather than the intended 1.

## 11. What's the difference between abstract classes/interfaces and generics?

Abstract classes and interfaces define behavioral contracts a class implements. Generics let a class or method operate on a type parameter decided at the point of use, without knowing the concrete type in advance (e.g., a `List<T>` working identically for `List<String>` or `List<Integer>`), enabling type-safe reuse without duplicating code per type. See [09-Object-Oriented-Programming/08-Generics-and-Static-Members](../09-Object-Oriented-Programming/08-Generics-and-Static-Members/README.md).

## 12. What's the N+1 query problem, and how do you fix it in an ORM?

Fetching N parent entities and then lazily loading a related collection for each one individually triggers 1 query for the parents plus N additional queries — one per parent — instead of a single, combined query. This was reproduced with real SQL logs in [07-Databases/05-Using-an-ORM](../07-Databases/05-Using-an-ORM/README.md): fetching all authors and then accessing each one's books triggered 1+N queries, fixed to exactly 1 query using `JOIN FETCH`.

## Recommended Next File

[03 — DSA Questions](03-DSA-Questions.md)
