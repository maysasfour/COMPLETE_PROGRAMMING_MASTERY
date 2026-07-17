# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Apply a consistent, defensible Java style across equality, exceptions, and generics.
- Recognize and avoid the specific footguns covered throughout lessons 01–18, collected here as one reference.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material.

## The Central, Recurring Theme: `==` vs. `.equals()`

This is Java's single most consequential recurring gotcha, threading through Lessons 03, 04, and 11:

- `==` is **always** reference equality for objects — no exceptions, not even for `String`.
- String literal interning (Lesson 04) makes `==` misleadingly "work" for literal strings specifically — never rely on this.
- Boxed `Integer` caching (Lesson 03) makes `==` misleadingly "work" for small values (-128 to 127) specifically — never rely on this either.
- Plain `class`es use `Object`'s default reference-equality `.equals()` unless explicitly overridden; `record` (Lesson 11) generates correct value equality automatically.

**The rule with zero exceptions: always use `.equals()` for object content comparison.** `==` is only ever correct for primitives and genuine reference-identity checks (rare).

## Exceptions

- Prefer unchecked (`RuntimeException`-based) custom exceptions for most cases; reserve checked exceptions for where forcing callers to handle a failure explicitly is genuinely valuable (Lesson 09).
- Always use try-with-resources for `AutoCloseable` resources.

## Generics

- Remember type erasure's practical limits: no `new T()`, no `instanceof List<String>` (Lesson 13).
- Use bounded type parameters (`<T extends Comparable<T>>`) and PECS wildcards (`? extends`/`? super`) appropriately.

## Detailed Example

See [Example.java](Example.java) — a direct "before" (String `==` mistake, plain-class reference-equality mistake) versus "after" (`.equals()`, `record` value equality) contrast, both run so the difference is demonstrated, not just described, plus a final reminder of the boxed-`Integer` caching gotcha and honoring an intentional `0` value.

## Expected Output

Running the example prints the "before" version's two reference-equality bugs (a non-interned `String` comparison and a plain `class`'s default equality), then the "after" version's correct `.equals()`/`record` behavior, followed by the `Integer` caching gotcha reproduced once more for emphasis, and a discounted-price calculation correctly honoring an intentional `0%` discount when using a primitive `int` (side-stepping the `null`-ambiguity that a boxed `Integer` parameter would introduce).

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" sections apply collectively — this lesson doesn't introduce new footguns, it collects the recurring ones, with `==` vs. `.equals()` as the single most important one to internalize.

## Best Practices (Meta)

- Always use `.equals()` for object content comparison — no exceptions, including `String` and boxed types.
- Prefer `record` for immutable data-carrying types to get correct equality for free.
- Write JUnit tests (Lesson 18) for behavior that matters — the compiler cannot catch a wrong formula, only a test can.
- Understand type erasure's practical limits before designing a generic API around assumptions that only hold in a reified-generics language like C#.

## Real-World Usage

Every Java code review at any serious shop will flag `==` used on `String`/boxed types/plain objects as an immediate concern; this is consistently one of the top few most common real-world Java bugs across the entire industry, precisely because of the interning/caching illusions described above.

## Summary

- This lesson has no new syntax — it's a checklist synthesizing lessons 01–18's individual practices into one reference.
- `==` vs. `.equals()` is Java's most consequential recurring gotcha — string interning and Integer caching create misleading illusions of `==` "working," which is precisely why the rule has zero exceptions.
- `record` types (Lesson 11) are the modern default for getting correct equality without manually overriding `.equals()`/`.hashCode()`.

## Key Terms

No new terms — this lesson synthesizes concepts from Lessons 03, 04, 09, 11, and 13.

## Interview Questions

1. **Why does Java's `==`-vs-`.equals()` distinction cause so many real-world bugs?**
   Because two specific JVM optimizations — string literal interning and boxed `Integer` caching for small values — make `==` *appear* to work correctly for certain common cases (literal strings, small integers), creating a false sense that `==` is safe for content comparison. The moment a string is constructed at runtime, or an integer value falls outside the -128..127 cached range, the illusion breaks and `==` silently does the wrong thing instead of raising any kind of error.

2. **What is the single most important rule this course's Java content emphasizes?**
   Always use `.equals()` for comparing the content of any object (including `String` and boxed primitive wrapper types) — `==` should be reserved exclusively for primitives and genuine reference-identity checks, with no exceptions carved out for "convenient" cases that happen to work due to JVM-internal optimizations.

## Recommended Next Lesson

This completes the core Java course (lessons 01–19), matching the depth of Python, JavaScript, TypeScript, and C#. Continue to [20-Exercises](../20-Exercises/README.md) for 7 standalone cross-cutting practice problems, then [21-Solutions](../21-Solutions/README.md) and the [22-Mini-Projects](../22-Mini-Projects/README.md) CLI Expense Tracker. From there, continue to [C++](../../Cpp/README.md) (per this repository's specified language order) or [04-Backend-Development](../../../04-Backend-Development/) (Spring Boot).
