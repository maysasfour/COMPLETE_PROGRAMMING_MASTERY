# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Distinguish `val` (immutable) from `var` (mutable) bindings.
- Understand Scala's type inference and the core primitive types.
- Understand `Unit` as Scala's "no meaningful value" type (Java's `void`, but an actual type).

## Concept

`val` declares an immutable binding — once assigned, it cannot be reassigned (though if it refers to a mutable object, that object's *internal* state can still change). `var` declares a mutable binding, reassignable like a normal variable. Scala's convention, in contrast to Java's typical mutable-by-default style, is to reach for `val` first and only use `var` when reassignment is genuinely needed.

## `val` vs `var`

```scala
val x = 5
// x = 6  // compile error: reassignment to val
var y = 5
y = 6      // fine
```

## Type Inference and Core Types

```scala
val i: Int = 42
val d = 3.14        // inferred Double
val s = "hello"     // inferred String
val b = true        // inferred Boolean
val u: Unit = ()     // Unit's single value is the empty tuple `()`
```

`Int`/`Long`/`Double`/`Float`/`Boolean`/`Char` are all genuine classes in Scala (`AnyVal` subtypes), not primitives in the Java sense — the compiler transparently maps them to JVM primitives for performance, but they support method calls like any object (`5.toString`, proven in Lesson 04).

## Detailed Example

See [Variables.scala](Variables.scala) — `val`/`var`, type inference across core types, and a live proof that reassigning a `val` is a compile error (commented out, with the actual compiler error captured in this README).

## Run It

```bash
cd 01-Languages/Scala/03-Variables-and-Data-Types
scalac Variables.scala
scala run . --main-class variablesDemo
```

## Expected Output

```
x=5, y=5 (before reassignment)
y=6 (after reassignment)
inferred types: d=3.14, s=hello, b=true
Unit value: ()
```

Uncommenting `x = 6` in the source and recompiling produces the real captured compiler error: `Reassignment to val x`.

## Common Mistakes

- Defaulting to `var` out of Java habit — Scala idiom strongly prefers `val`.
- Assuming `val` makes the referenced object immutable — it only prevents *rebinding* the variable itself; a `val` holding a mutable collection can still have its contents mutated unless the collection type is itself immutable (Lesson 07).
- Forgetting `Unit`'s literal value is `()`, not `null` or `void`.

## Best Practices

- Default to `val`; justify every `var` explicitly (e.g., a loop accumulator, a genuinely mutable counter).
- Let type inference work for local variables; add explicit type annotations on public API signatures for clarity/documentation.

## Real-World Usage

Idiomatic Scala style guides (including Databricks' and Twitter's internal ones, both influential in the Scala community) treat pervasive `var` usage as a code smell — immutability-first design is core to how production Scala is written.

## Summary

- `val` is immutable, `var` is mutable; prefer `val`.
- Type inference covers most local bindings; core types (`Int`, `Double`, etc.) are real classes, not raw JVM primitives from the language's perspective.
- `Unit` is Scala's `void`-equivalent, with an actual single value: `()`.

## Key Terms

- **`val`** — an immutable, single-assignment binding.
- **`Unit`** — the type representing "no meaningful value returned," with one value, `()`.

## Interview Questions

1. **Why does Scala prefer `val` over `var`?** — Immutable bindings eliminate a whole class of bugs around unexpected mutation and make code easier to reason about in concurrent contexts (no risk of another thread observing a half-updated variable), which is why idiomatic Scala style defaults to `val` and treats pervasive `var` as a smell.
2. **Is `Int` a primitive in Scala the way it is in Java?** — Not from the language's perspective — `Int` is a real class (`AnyVal` subtype) supporting method calls like `5.toString`; the compiler transparently compiles it down to the JVM's primitive `int` for performance where possible, giving Scala both a uniform object model and Java-primitive-level performance.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
