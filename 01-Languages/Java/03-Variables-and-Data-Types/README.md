# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Distinguish primitives from objects (reference types), and explain autoboxing.
- Use `var` for local type inference (Java 10+).
- Use `final` for non-reassignable variables.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Java has exactly 8 **primitive types** (`int`, `long`, `double`, `float`, `boolean`, `char`, `byte`, `short`) that are true value types living directly wherever they're declared — not objects, no methods on them directly. Every other type (`String`, arrays, custom classes, and the boxed wrapper types `Integer`/`Double`/`Boolean`/etc.) is a reference type living on the heap. **Autoboxing** automatically converts between a primitive and its boxed wrapper (`int` ↔ `Integer`) where needed, which is convenient but has a well-known equality gotcha (Lesson 04).

## Primitives vs. Objects

```java
int a = 5;        // primitive -- an actual value, not an object
Integer b = 5;      // boxed -- autoboxed into an Integer object automatically

String name = "Ada"; // reference type -- "name" holds a reference to a String object
int[] numbers = {1, 2, 3}; // arrays are reference types too
```

## `var` and `final`

```java
var city = "Berlin";        // inferred as String (Java 10+) -- still fully statically typed
final int maxRetries = 3;    // cannot be reassigned after initialization
```

`var` only works for **local variables** with an initializer — it cannot be used for fields, method parameters, or return types, which is more restrictive than C#'s `var` or JavaScript's `let`.

## The Autoboxing Equality Gotcha

```java
Integer x = 200;
Integer y = 200;
System.out.println(x == y);        // false -- different objects, outside the cached range
System.out.println(x.equals(y));    // true -- content equality

Integer p = 100;
Integer q = 100;
System.out.println(p == q); // true -- Java caches boxed Integers from -128 to 127
```

Java caches boxed `Integer` objects for the range -128 to 127 (an internal JVM optimization), so `==` on two boxed integers *in that range* happens to return `true` — but this is an implementation detail, not a guarantee, and relying on it is a classic Java bug source. Always use `.equals()` for boxed-type content comparison.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints primitive vs. object usage, `var`/`final`, and the autoboxing equality gotcha demonstrated at both an in-cache-range and out-of-cache-range value.

## Common Mistakes

- Using `==` to compare boxed types (`Integer`, `Long`, etc.) or `String`s, expecting content equality — it compares references, and boxed-integer caching makes small values misleadingly "work" while larger ones don't.
- Assuming `var` works everywhere `int`/`String` would — it's local-variable-only.

## Best Practices

- Always use `.equals()` for object content comparison, including boxed primitives and `String`s.
- Use `final` for variables that shouldn't be reassigned — documents intent and lets the compiler catch accidental reassignment.
- Use `var` for obviously-typed local variables to reduce verbosity, matching modern Java style.

## Real-World Usage

The `Integer` caching gotcha is one of the most common "worked in testing, failed in production" Java bugs, precisely because small test values (like `1`, `2`, `100`) happen to fall within the cached range and mask a genuine `==`-instead-of-`.equals()` bug until a larger value appears in real data.

## Summary

- Java has 8 true primitive types; everything else (including boxed wrappers) is a reference type.
- Autoboxing converts between primitives and their wrapper types automatically, but boxed-type equality still needs `.equals()`, not `==`.
- `var` is local-variable-only type inference; `final` prevents reassignment.

## Key Terms

- **Autoboxing** — automatic conversion between a primitive (`int`) and its wrapper object (`Integer`).
- **Integer cache** — the JVM's internal caching of boxed `Integer` objects from -128 to 127, making `==` misleadingly appear to work for small values.

## Interview Questions

1. **Why does `Integer.valueOf(100) == Integer.valueOf(100)` return `true` but `Integer.valueOf(200) == Integer.valueOf(200)` return `false`?**
   The JVM caches boxed `Integer` objects for values from -128 to 127 as a memory optimization — both `100`s come from that shared cache, so they're the same object reference. `200` falls outside the cached range, so each `valueOf(200)` call creates a genuinely new, distinct `Integer` object, and `==` (reference equality) correctly reports them as different objects, even though their values are equal.

2. **What's the difference between a primitive and a boxed wrapper type?**
   A primitive (`int`) is a true value type — it lives directly wherever declared, has no methods, and cannot be `null`. Its boxed wrapper (`Integer`) is a full reference-type object wrapping that value, living on the heap, capable of being `null`, and required wherever Java's generics (Lesson 13) or collections need an object (`List<Integer>`, never `List<int>`).

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
