# 11 — OOP and Traits

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define classes with constructor-parameter fields, inheritance, and overriding.
- Use `case class` for auto-generated `equals`/`hashCode`/`toString`/`copy`, verified live.
- Use `trait`s as multiple-inheritance-capable interfaces that can carry concrete (default) implementations and state.
- Use `object` for singletons.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Scala classes are open (subclassable) by default, unlike Kotlin's final-by-default classes covered in this repository's Kotlin course — closer to Java's default. Where Scala genuinely diverges from both is **traits**: a class may mix in any number of traits (`extends A, B, C` in Scala 3), and each trait can supply concrete method bodies and even state, not just abstract signatures — a real form of multiple inheritance that Java's interfaces (even with default methods) and Kotlin's interfaces approximate less fully. `case class` gives structural equality and immutable-update (`copy`) for free, and `object` provides a language-level singleton.

## Classes and Overriding

```scala
class Animal(val name: String):
  def speak(): String = "..."          // overridable; Scala classes are open by default

class Dog(name: String) extends Animal(name):
  override def speak(): String = s"$name says Woof!"
```

## `case class`: Free Equality, `toString`, and `copy`

```scala
case class Point(x: Int, y: Int)
val p1 = Point(1, 2)
val p2 = p1.copy(y = 99)   // new instance, only y changed
p1 == p1.copy()             // true -- structural (value) equality, auto-generated
```

## Traits: Real Multiple Inheritance of Behavior

```scala
trait Greeter:
  def greeting: String
  def greet(name: String): String = s"$greeting, $name!"  // concrete default method

trait Loud:
  def shout(msg: String): String = msg.toUpperCase + "!!!"

class Robot(val greeting: String) extends Greeter, Loud   // mixes in BOTH
```

Neither `Greeter` nor `Loud` is a superclass — both are mixed in side by side, each contributing concrete behavior, and `Robot` gets both `greet` and `shout` for free.

## `object`: Singleton Declaration

```scala
object Registry:
  private var count = 0
  def register(): Int = { count += 1; count }
```

Exactly one `Registry` instance ever exists, created lazily on first access — no manual singleton boilerplate.

## Detailed Example

See [OOPAndTraits.scala](OOPAndTraits.scala) — inheritance/overriding, a `case class` with live-verified equality and `copy`, a class mixing in two traits, and an `object` singleton whose state persists across calls.

## Run It

```bash
cd 01-Languages/Scala/11-OOP-and-Traits
scalac OOPAndTraits.scala
scala run . --main-class oopAndTraitsDemo
```

## Expected Output

```
--- classes and overriding ---
Rex says Woof!

--- case class: auto equality and copy ---
p1 = Point(1,2)
p2 = Point(1,99)
p1 == p1.copy() : true
p1 == p2        : false

--- traits: multiple mix-ins on one class ---
Hello, Ada!
ATTENTION!!!

--- object singleton ---
register() -> 1
register() -> 2
register() -> 3
```

## Common Mistakes

- Using a plain `class` for a simple data holder and hand-writing `equals`/`toString` instead of reaching for `case class`, which generates correct versions for free.
- Assuming a trait is "just an interface" and can't hold state or concrete method bodies — Scala traits can do both, which is exactly what enables real multiple inheritance of behavior.
- Forgetting that mixing in two traits that both define a method with the same signature requires an explicit `override` in the class to resolve the conflict.

## Best Practices

- Reach for `case class` by default for any type whose purpose is holding immutable data.
- Use traits to compose small, focused units of behavior (mixins) rather than deep single-inheritance class hierarchies.
- Reserve `object` for genuine singletons: configuration, registries, stateless utility groupings, and companion objects for factory functions.

## Real-World Usage

Scala library code (e.g. Cats, the standard collections library itself) leans heavily on trait mixins to compose behavior — a collection type mixes in `Iterable`, `Seq`, and other traits rather than inheriting from one monolithic base class, letting behavior be assembled à la carte.

## Summary

- Scala classes are open by default; traits provide genuine multiple inheritance of both interface and concrete behavior.
- `case class` auto-generates `equals`/`hashCode`/`toString`/`copy`, verified live to behave correctly.
- `object` is a language-level singleton, created lazily.

## Key Terms

- **`case class`** — a class with auto-generated structural equality, hashing, string representation, and an immutable-update `copy` method.
- **Trait** — an interface-like construct that can hold concrete method implementations and state; a class may mix in multiple traits.
- **`object`** — a singleton declaration; exactly one instance exists, created lazily.

## Interview Questions

1. **How do Scala traits differ from Java interfaces, and what does that enable?** — Scala traits can carry concrete method bodies *and* state (`var`/`val` fields), not just method signatures, and a class can mix in any number of them (`extends A, B, C`). This gives genuine multiple inheritance of behavior: two unrelated traits can each supply working default methods to the same class, which was demonstrated directly with `Robot` gaining both `greet` (from `Greeter`) and `shout` (from `Loud`) without either becoming a superclass.
2. **What does `case class` generate automatically, and why does that matter?** — `equals`/`hashCode` (structural, value-based equality instead of reference equality), a readable `toString`, a `copy` method for immutable updates, and a companion object with an `apply` factory. This was verified live: `p1 == p1.copy()` is `true` because equality compares field values, not object identity, and `p1.copy(y = 99)` produced a new `Point` with only `y` changed.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
