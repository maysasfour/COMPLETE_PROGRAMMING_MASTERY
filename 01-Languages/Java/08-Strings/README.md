# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use common `String` methods and know `String` is immutable.
- Use `StringBuilder` for efficient repeated concatenation.
- Use text blocks (Java 15+) for multi-line strings.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

`String` in Java is immutable — every method returns a new `String`, exactly like every other language course in this repository. Java strings additionally benefit from **interning** for literals (Lesson 04), but that's an optimization detail, not a change to the immutability model itself.

## Common Methods and Immutability

```java
String name = "Ada";
System.out.println("  hello  ".trim());
System.out.println("hello".toUpperCase());
System.out.println("hello world".contains("wor"));
System.out.println(String.join("-", "a", "b", "c"));
System.out.println("hello".replace("l", "L")); // replaces ALL occurrences

String result = "";
for (int i = 0; i < 5; i++) {
    result += i; // creates a NEW String object each iteration -- O(n^2) overall
}
```

## `StringBuilder`

```java
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 5; i++) {
    sb.append(i); // mutates an internal buffer -- O(1) amortized per append
}
String built = sb.toString();
```

## Text Blocks (Java 15+)

```java
String json = """
    {
      "name": "Ada"
    }
    """; // no escaping needed for embedded quotes; indentation is stripped intelligently
```

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints common string methods, a demonstration of string-concatenation-in-a-loop creating new objects each time, `StringBuilder` used efficiently instead, and a text block.

## Common Mistakes

- Concatenating strings with `+=` in a loop instead of `StringBuilder`, causing O(n²) performance.
- Assuming `.replace()` only replaces the first match (as some other languages' `.replace()` defaults do) — Java's always replaces every occurrence.

## Best Practices

- Use `StringBuilder` for any loop performing many string concatenations.
- Use text blocks for embedded JSON/SQL/HTML samples to avoid escaping noise.

## Real-World Usage

`StringBuilder` is standard in any code building up a large string incrementally; text blocks are increasingly used for embedding SQL queries and JSON payloads directly in Java source.

## Summary

- `String` is immutable; every method returns a new string.
- Repeated `+=` concatenation is O(n²); `StringBuilder` makes it O(n).
- Text blocks (`"""`) provide multi-line strings with minimal escaping (Java 15+).

## Key Terms

- **`StringBuilder`** — a mutable string-building buffer, avoiding O(n²) performance from repeated concatenation.
- **Text block** — a Java 15+ multi-line string literal requiring minimal escaping.

## Interview Questions

1. **Why is repeated string concatenation in a loop inefficient in Java, and what's the fix?**
   `String` is immutable, so every `+=` concatenation allocates a new `String` object and copies all prior content into it — O(n²) total work for `n` concatenations. `StringBuilder` maintains a mutable internal buffer with amortized O(1) appends, making the equivalent loop O(n) overall.

2. **What is a text block, and what problem does it solve?**
   A Java 15+ multi-line string literal (`""" ... """`) that requires minimal escaping — embedded double quotes don't need escaping, and indentation is intelligently stripped based on the closing delimiter's position. It solves the readability problem of embedding multi-line content (JSON, SQL, HTML) in Java source without a wall of `\n` and `\"` escape sequences.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
