# Object-Oriented Programming Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../09-Object-Oriented-Programming/README.md)

## The Four Pillars
| Pillar | One-line definition |
|---|---|
| Encapsulation | Bundle data with the methods that operate on it; hide internal state behind a controlled interface. |
| Abstraction | Expose only relevant behavior; hide unnecessary implementation complexity. |
| Inheritance | A subclass acquires the fields/methods of a superclass. |
| Polymorphism | Objects of different types respond to the same method call according to their own type. |

## Quick Syntax Reference (Java)
```java
public class Animal {
    private final String name;              // encapsulation: private field
    public Animal(String name) { this.name = name; }
    public String getName() { return name; } // controlled access
    public String speak() { return "..."; }  // overridden by subclasses -- polymorphism
}
public class Dog extends Animal {            // inheritance
    public Dog(String name) { super(name); }
    @Override public String speak() { return getName() + " says Woof!"; } // overriding
}
interface Flyable { void fly(); }             // abstraction via contract
```

## Overloading vs. Overriding
- **Overloading**: same method name, different parameters, resolved at **compile time**.
- **Overriding**: subclass redefines a superclass method, resolved at **runtime** (dynamic dispatch).

## Composition over Inheritance
Prefer a HAS-A relationship (a field referencing an interchangeable behavior object) over an IS-A relationship when a subclass wouldn't genuinely fit 100% of its superclass's contract. Verified live in [11-Design-Principles/04](../../11-Design-Principles/04-Composition-over-Inheritance/README.md): an `ElectricCar extends Vehicle` inheriting `startEngine()` produced the nonsensical "Vroom!" for a car with no combustion engine.

## Key Interview Traps
- Liskov Substitution violated by Square-extends-Rectangle — verified live in [11-Design-Principles/01](../../11-Design-Principles/01-SOLID-Principles/README.md) to silently produce a wrong area.
- N+1 query problem from lazy-loaded ORM relationships — verified live in [07-Databases/05](../../07-Databases/05-Using-an-ORM/README.md).
- A naive lazy Singleton is not thread-safe — verified live in [12-Design-Patterns/01](../../12-Design-Patterns/01-Singleton/README.md) to create 6-9 instances out of 10 racing threads.

See the [full OOP module](../../09-Object-Oriented-Programming/README.md), [11-Design-Principles](../../11-Design-Principles/README.md), and [12-Design-Patterns](../../12-Design-Patterns/README.md) for verified, runnable deep dives.
