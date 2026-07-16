# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators.
- Explain why `==` never does content comparison for objects, and use `.equals()` correctly.
- Use `instanceof` pattern matching (Java 16+).

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Java's operators are C-family familiar, with one absolute rule more consequential here than in most other languages in this repository: **`==` is reference equality for every object type, with zero exceptions** — not even `String` gets special-cased operator behavior (its apparent "it just works" behavior with literals is due to *string interning*, not `==` doing content comparison).

## `==` vs. `.equals()`

```java
String a = "hello";
String b = "hello";
System.out.println(a == b); // true -- BOTH literals are interned to the SAME pooled object

String c = new String("hello");
System.out.println(a == c);        // false -- c is a genuinely new, distinct object
System.out.println(a.equals(c));    // true -- content comparison, correctly true
```

String literals are automatically **interned** — the JVM maintains a pool of unique literal strings, so two identical literals share one object, making `==` misleadingly "work" for literals specifically. `new String("hello")` deliberately creates a fresh, non-pooled object, breaking that illusion — this is precisely why `.equals()`, not `==`, is the only correct way to compare `String` (or any object) content.

## `instanceof` Pattern Matching

```java
Object value = "hello";

if (value instanceof String s) { // pattern match: checks type AND binds `s` in one step
    System.out.println(s.toUpperCase());
}
```

Java 16+'s `instanceof` pattern matching (`value instanceof String s`) checks the type and binds a correctly-typed variable in one expression — before this feature, the idiom was `if (value instanceof String) { String s = (String) value; ... }`, a manual cast after a separate check.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints the `==`-vs-`.equals()` contrast for interned vs. non-interned strings, and an `instanceof` pattern match correctly binding and using a narrowed variable.

## Common Mistakes

- Using `==` to compare `String`s, relying on interning "happening to work" for literals — breaks the moment either string comes from a non-literal source (user input, `new String(...)`, string concatenation at runtime).
- Believing `==` on `String` is ever safe "because Java optimizes it" — the optimization (interning) applies only to compile-time literals, not runtime-constructed strings.

## Best Practices

- Always use `.equals()` for `String`/object content comparison; never `==`.
- Use `instanceof` pattern matching over the older check-then-manually-cast idiom.

## Real-World Usage

The `==`-vs-`.equals()` distinction is one of the most frequently asked Java interview questions precisely because it's such a common real-world bug source, especially for developers coming from languages where `==` does content comparison for strings/primitives-that-look-like-values.

## Summary

- `==` is always reference equality for objects in Java, with zero exceptions; `.equals()` is content equality.
- String literals are interned (pooled), making `==` misleadingly appear to work for them specifically — never rely on this.
- `instanceof` pattern matching (Java 16+) checks a type and binds a variable in one step.

## Key Terms

- **String interning** — the JVM's pooling of unique string literals, so identical literals share one object.
- **`instanceof` pattern matching** — checking a type and binding a correctly-typed variable in one expression (Java 16+).

## Interview Questions

1. **Why does `"hello" == "hello"` return `true` in Java, if `==` is reference equality?**
   Both are string literals, and Java interns string literals — the JVM maintains a pool of unique literal strings, so two identical literals in source code are compiled to reference the exact same pooled object. This is a specific optimization for compile-time literals, not a general property of `==` on strings — `new String("hello") == "hello"` is `false`, since `new String(...)` deliberately creates a non-pooled object.

2. **What's the correct way to compare two `String`s for content equality in Java?**
   Always `.equals()` (or `Objects.equals()` if either might be `null`) — never `==`, which only ever compares references and only "happens to work" for the special case of two literal strings due to interning, a fact that breaks the moment either string is constructed at runtime.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
