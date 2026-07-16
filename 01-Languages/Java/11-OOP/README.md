# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes with fields, constructors, and inheritance (`extends`, method overriding).
- Use `interface`s (including default methods) and abstract classes.
- Use `record` types (Java 16+) for immutable data with generated equality.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md) and [10-File-Handling](../10-File-Handling/README.md)

## Concept

Java is a purely class-based OOP language (there is no free-standing anything, per Lesson 02). Every non-`static` method is implicitly polymorphic/overridable by default (unlike C#, which requires explicit `virtual`) — use `final` on a method to explicitly *prevent* overriding, the inverse of C#'s opt-in model.

## Classes and Inheritance

```java
class Animal {
    private final String name;
    public Animal(String name) { this.name = name; }
    public String getName() { return name; }
    public String speak() { return name + " makes a sound"; } // overridable by default
}

class Dog extends Animal {
    public Dog(String name) { super(name); }
    @Override
    public String speak() { return getName() + " says Woof"; }
}

Animal a = new Dog("Rex");
System.out.println(a.speak()); // "Rex says Woof" -- polymorphic dispatch
```

`@Override` is not strictly required by the compiler but is strongly conventional — it causes a compile error if the annotated method doesn't actually override anything (a typo'd method name, mismatched parameters), catching a whole class of silent bugs.

## Interfaces (with Default Methods) and Abstract Classes

```java
interface Shape {
    double area();
    default String describe() { return "Area: " + area(); } // default method -- has a body
}

abstract class ShapeBase implements Shape {
    public abstract double area(); // still must be implemented by concrete subclasses
}

class Circle extends ShapeBase {
    private final double radius;
    public Circle(double radius) { this.radius = radius; }
    public double area() { return Math.PI * radius * radius; }
}
```

Java interfaces can have **default methods** (a body, since Java 8) — a genuine capability gap-closer versus older Java, letting an interface evolve with new methods without breaking every existing implementer, as long as a sensible default behavior exists.

## `record` Types

```java
record Point(double x, double y) {} // generates fields, constructor, equals/hashCode/toString

Point p1 = new Point(1, 2);
Point p2 = new Point(1, 2);
System.out.println(p1.equals(p2)); // true -- value equality, auto-generated

class PointClass { double x, y; }
PointClass c1 = new PointClass();
PointClass c2 = new PointClass();
System.out.println(c1.equals(c2)); // false -- default Object.equals is reference equality
```

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints polymorphic dispatch through a base-typed reference, an interface's default method used alongside an abstract-class hierarchy, and a `record`/plain-class equality contrast.

## Common Mistakes

- Forgetting `@Override` and silently creating a new, unrelated overload instead of actually overriding a base method (a typo in the method signature) — `@Override` turns this into a compile error instead of a silent bug.
- Assuming a plain `class`'s `.equals()` compares content by default — it uses `Object`'s default reference-equality implementation unless explicitly overridden (which `record` does automatically).

## Best Practices

- Always annotate overriding methods with `@Override`.
- Use `record` for immutable data-carrying types; use `class` for types with identity, mutable state, or behavior beyond plain data.
- Use interface default methods sparingly, mainly for genuinely optional/common behavior with a sensible fallback — don't use them as a substitute for a proper abstract base class.

## Real-World Usage

`record` types are now standard for DTOs in modern Java (Spring Boot's request/response bodies, JDBC row projections); interface default methods are how the JDK itself evolved `Collection`/`List`/`Map` with new methods (like `List.of(...)`, `Map.forEach`) without breaking every pre-existing custom implementation.

## Summary

- Methods are overridable by default in Java (opposite of C#'s explicit `virtual`); `@Override` catches accidental non-overrides at compile time.
- Interfaces can have default methods with a body (Java 8+); abstract classes can mix concrete and abstract members.
- `record` (Java 16+) generates fields, a constructor, and value-based `equals`/`hashCode`/`toString` automatically.

## Key Terms

- **`@Override`** — an annotation (not strictly required, but strongly conventional) causing a compile error if the annotated method doesn't actually override a base method.
- **Default method** — an interface method with a body (Java 8+), providing a fallback implementation implementers can optionally override.

## Interview Questions

1. **Is method overriding opt-in or opt-out in Java, compared to C#?**
   Opt-out — every non-`static`, non-`final`, non-`private` instance method is overridable by default; `final` explicitly prevents it. This is the reverse of C#, where a method must be explicitly marked `virtual` to be overridable at all.

2. **What is a default method in a Java interface, and why was it added?**
   A method declared in an interface with an actual body (Java 8+), providing a fallback implementation that implementing classes can use as-is or override. It was added specifically to let the JDK (and other library authors) add new methods to widely-implemented interfaces (like `Collection`) without breaking every existing class that implements them — without default methods, adding any new interface method would be a breaking change for every implementer.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
