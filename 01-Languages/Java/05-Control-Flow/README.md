# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else`, traditional `switch` statements, and modern `switch` **expressions** (Java 14+).
- Use enhanced `for` (for-each) loops.
- Use pattern matching in `switch` (Java 21+).

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Java's control flow is C-family familiar. Its `switch` has evolved significantly since Java 14: modern **switch expressions** (`->` arrow syntax) evaluate to a value with no fall-through and no `break` needed, and Java 21 added full pattern matching in `switch` — directly comparable to the C# and TypeScript courses' equivalent evolution of their own `switch` constructs.

## Traditional `switch` vs. Switch Expressions

```java
int day = 3;

// Traditional switch statement -- requires break to avoid fall-through
switch (day) {
    case 6:
    case 7:
        System.out.println("Weekend");
        break;
    default:
        System.out.println("Weekday");
        break;
}

// Switch EXPRESSION (Java 14+) -- evaluates to a value, arrow syntax, no fall-through
String description = switch (day) {
    case 6, 7 -> "Weekend";
    default -> "Weekday";
};
```

## Pattern Matching in `switch` (Java 21+)

```java
Object value = 42;
String result = switch (value) {
    case Integer i when i < 0 -> "negative number";
    case Integer i -> "non-negative number: " + i;
    case String s -> "a string of length " + s.length();
    case null -> "null value";
    default -> "something else";
};
```

This directly mirrors the C# course's type-pattern `switch` and, more distantly, the TypeScript course's discriminated-union narrowing — each arm can match a type, bind a variable, and optionally add a `when` guard, checked top-to-bottom.

## Enhanced `for` (for-each)

```java
for (int i = 0; i < 3; i++) { System.out.println(i); } // classic counter loop

for (String fruit : new String[]{"apple", "banana"}) { // enhanced for -- iterates VALUES
    System.out.println(fruit);
}
```

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints traditional-switch, switch-expression, and pattern-matching-switch results, plus both loop forms.

## Common Mistakes

- Forgetting `break` in a traditional `switch` statement, causing fall-through — switch *expressions* have no such risk since each arm is a single value/block with no fall-through at all.
- Ordering pattern-matching `switch` arms so a more general pattern shadows a more specific one placed after it — like the TypeScript/C# courses, the first matching arm wins.

## Best Practices

- Prefer switch expressions over switch statements when producing a single value — more concise, and the compiler enforces exhaustiveness for sealed/enum types.
- Order pattern-matching arms from most specific to least specific.

## Real-World Usage

Pattern-matching switch expressions are increasingly the idiomatic way to handle sealed class hierarchies (Java's `sealed` keyword, a closed-set-of-subtypes feature) in modern Java, directly analogous to the discriminated-union pattern from the TypeScript course.

## Summary

- Switch expressions (`->`, Java 14+) evaluate to a value with no fall-through; switch statements execute code per case and need `break`.
- Pattern matching in `switch` (Java 21+) checks types, binds variables, and supports `when` guards, checked top-to-bottom.
- Enhanced `for` iterates values directly, like every other language course's `for-each`/`for...of`.

## Key Terms

- **Switch expression** — a `switch` form (`->` syntax) that evaluates to a value with no fall-through.
- **Pattern matching in `switch`** — matching a value's type (and optionally a `when` guard) per arm, binding a correctly-typed variable.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between a traditional `switch` statement and a switch expression in Java?**
   A traditional `switch` statement executes code per matching `case` and requires `break` to prevent fall-through into subsequent cases. A switch expression (Java 14+, `->` syntax) evaluates directly to a value from whichever arm matches, has no fall-through at all, and the compiler can enforce exhaustiveness for enums/sealed types.

2. **How does Java's pattern-matching `switch` compare to the equivalent features in C# and TypeScript?**
   All three let a `switch` branch based on a value's type/shape rather than plain equality, binding a correctly-typed variable per matching arm. Java (since 21) and C# both match directly against a value's runtime type with optional guard clauses; TypeScript instead narrows based on a shared literal discriminant field across a union of interfaces — different mechanisms converging on a similar practical capability.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
