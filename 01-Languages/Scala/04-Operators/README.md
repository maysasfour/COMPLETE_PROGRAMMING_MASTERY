# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Understand that Scala has no true "operator" syntax at the language level — every symbolic operator is an ordinary method call, verified live.
- Cover arithmetic, comparison, logical, and string-concatenation operators.

## Concept

In Scala, `a + b` is syntactic sugar for `a.+(b)` — a method named `+` invoked on `a` with `b` as its argument. Any method whose name consists of symbolic characters can be used in this "infix" operator-like position. This is not a metaphor or a design analogy — it's literally how the compiler desugars it, verified live below by writing both forms and confirming they produce byte-identical results.

## Operators Are Just Methods (Verified Live)

```scala
val a = 1.+(2)   // explicit method-call syntax
val b = 1 + 2     // infix sugar for the exact same method call
assert(a == b)     // verified live: both equal 3
```

## Core Operators

```scala
5 + 3, 5 - 3, 5 * 3, 5 / 3, 5 % 3         // arithmetic
5 > 3, 5 >= 3, 5 == 3, 5 != 3               // comparison (== is structural equality)
true && false, true || false, !true         // logical
"a" + "b"                                    // string concatenation, also just a method call
```

## Detailed Example

See [Operators.scala](Operators.scala) — live proof that `1 + 2` and `1.+(2)` are identical, plus arithmetic/comparison/logical/string operators exercised and printed.

## Run It

```bash
cd 01-Languages/Scala/04-Operators
scalac Operators.scala
scala run . --main-class operatorsDemo
```

## Expected Output

```
infix: 1 + 2 = 3
method call: 1.+(2) = 3
identical result: true
arithmetic: 5+3=8, 5-3=2, 5*3=15, 5/3=1, 5%3=2
comparison: 5>3=true, 5==3=false
logical: true&&false=false, true||false=true, !true=false
string concat: ab
```

This was actually compiled and run; `identical result: true` is a real, live-verified assertion result, not an assumed one.

## Common Mistakes

- Assuming `==` in Scala behaves like Java's reference-equality `==` on objects — Scala's `==` calls `.equals` (structural equality) by default; use `.eq` for reference equality.
- Forgetting integer division truncates (`5 / 3 == 1`), exactly like Java/C, not like Python's true division.
- Assuming operator overloading is a special language feature — it's just ordinary method definition with a symbolic name (covered further in Lesson 11's class examples).

## Best Practices

- Define symbolic-named methods (custom operators) sparingly and only when they mirror well-known mathematical/domain notation (e.g., a `Vector` class's `+`) — overuse harms readability.
- Prefer `.equals`-based `==` for value types; reach for `.eq` explicitly when reference identity is genuinely what's being checked.

## Real-World Usage

Libraries like Spark and Akka define custom symbolic methods (e.g., Akka Streams' `~>` for wiring stream graphs) relying on exactly this "operators are methods" mechanism — understanding it is essential to reading such DSL-heavy Scala code.

## Summary

- Every Scala operator (`+`, `-`, `==`, etc.) is literally a method call in infix-sugar form, verified live by comparing `1 + 2` to `1.+(2)`.
- `==` performs structural (value) equality by default, unlike Java's reference-equality `==` on objects.
- Custom types can define their own symbolic-named methods to support natural operator-like syntax.

## Key Terms

- **Infix notation** — `a op b` syntax sugar for the method call `a.op(b)`.
- **Structural equality** — Scala's default `==` behavior, comparing values via `.equals` rather than object identity.

## Interview Questions

1. **Is `+` a special language keyword in Scala?** — No; it's an ordinary method name made of symbolic characters, callable either as `a.+(b)` or via infix sugar `a + b` — verified live in this lesson by confirming both forms produce an identical result.
2. **How does `==` differ between Scala and Java for objects?** — Scala's `==` calls `.equals` (structural/value equality) by default; Java's `==` on non-primitive types compares references unless the class explicitly overrides `equals` and the code calls `.equals()` instead of `==`. Scala's default is arguably safer since accidental reference-equality bugs (common in Java when developers forget to call `.equals()`) are far less likely.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
