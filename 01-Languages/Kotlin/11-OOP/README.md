# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Understand a genuine, verified Kotlin design choice: classes and methods are **final by default** — `open` is required to allow subclassing/overriding, the opposite of Java's default.
- Use `data class` (auto-generated `equals`/`hashCode`/`toString`/`copy`), `sealed class` (Lesson 05), `object` (singletons), and companion objects (`static`-member replacement).

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Kotlin's classes are **final by default** — a genuinely deliberate design choice, the opposite of Java's default-overridable classes/methods, based on the "favor composition over inheritance" and "design for inheritance explicitly, or prohibit it" principles. A class must be explicitly marked `open` to be subclassed at all, and a method must be marked `open` to be overridden; `override` is then mandatory (not optional, unlike Java's `@Override` annotation) at each override site.

## `open`/`override` Are Mandatory, Verified Live

```kotlin
open class Animal(val name: String) {
    open fun speak(): String = "..."
}
class Dog(name: String) : Animal(name) {
    override fun speak(): String = "Woof!" // `override` keyword is REQUIRED, not optional
}
```

Verified live: omitting `open` from a class declaration and then attempting to extend it produces a real compile error:

```
error: this type is final, so it cannot be extended.
```

This is a genuinely different default from Java (where every non-`final` class/method is subclassable/overridable by default) — Kotlin flips the default, requiring an explicit, deliberate opt-in to allow extension at all.

## `data class`: Auto-Generated `equals`/`hashCode`/`toString`/`copy`

```kotlin
data class Point(val x: Int, val y: Int)
val p1 = Point(1, 2)
val p2 = p1.copy(y = 99) // creates a NEW instance with only y changed, everything else copied
p1 == p1.copy()             // true -- structural equality (Lesson 04), auto-generated
```

## `sealed class` + `when` (Recap from Lesson 05)

```kotlin
sealed class Result
data class Success(val value: Int) : Result()
data class Failure(val error: String) : Result()
```

## `object`: Singleton Declaration

```kotlin
object Config {
    val maxRetries = 3
}
Config.maxRetries // accessed directly -- exactly one instance ever exists, created lazily
```

`object` declares a class with exactly one instance, created lazily on first access — Kotlin's built-in, language-level singleton pattern, eliminating the manual double-checked-locking/enum-based singleton boilerplate common in Java.

## Companion Objects: Kotlin's `static` Replacement

```kotlin
class Counter private constructor(val id: Int) {
    companion object {
        private var nextId = 1
        fun create(): Counter = Counter(nextId++) // factory function
    }
}
Counter.create() // called AS IF Counter.create were static, but it's a real object member
```

Kotlin has no `static` keyword at all — a **companion object** is a real, singleton object associated with a class, whose members can be called using the class name directly (`Counter.create()`), providing the same practical effect as Java's `static` members through a genuinely different, object-based mechanism.

## Detailed Example

See [Example.kt](Example.kt) — inheritance with mandatory `open`/`override`, a `data class` with `copy()`, `sealed class` + `when`, an `object` singleton, and a companion-object-based factory pattern with a private primary constructor plus a secondary constructor.

## Run It

```bash
cd 01-Languages/Kotlin/11-OOP
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints polymorphic `speak()` calls (`Generic says ...` and `Rex says Woof!`), the `data class` copy demonstration (`p1=Point(x=1, y=2), p2=Point(x=1, y=99), p1==p1.copy()=true`), both `sealed class` branches, confirmation that `Config` is a genuine singleton (`same instance: true`), and two `Counter` instances created via the companion object's factory function with incrementing IDs (`c1.id=1, c2.id=2`).

## Common Mistakes

- Forgetting `open` on a class or method intended to be subclassed/overridden, then being confused by the resulting "this type is final, so it cannot be extended" compile error — reproduced directly in this lesson.
- Assuming Kotlin has a `static` keyword — it doesn't; a companion object is the real mechanism, and while `Counter.create()` reads like a static call, it's actually calling a method on a genuine (singleton) object instance.
- Manually writing `equals()`/`hashCode()`/`toString()` for a simple data-holding class instead of using `data class`, missing out on the auto-generated, correct implementations (plus `copy()` and `componentN()` destructuring support).

## Best Practices

- Leave classes final (the default) unless subclassing is a deliberate, designed-for part of the class's contract — mark `open` explicitly and thoughtfully, not reflexively.
- Use `data class` for any class whose primary purpose is holding data with value-based equality.
- Use `object` for genuine singletons (configuration holders, stateless utility collections) instead of manually implementing the singleton pattern.
- Use a companion object with a private primary constructor for factory-function patterns that need to control instance creation.

## Real-World Usage

Kotlin's final-by-default classes are widely credited with reducing a class of real-world bugs where a class was subclassed in ways its original author never anticipated or tested, causing subtle behavioral bugs (Java's "fragile base class" problem) — requiring `open` as an explicit, deliberate signal is considered a genuine safety improvement by much of the Kotlin community, despite occasionally requiring more upfront design thought about what should be extensible.

## Summary

- Kotlin classes and methods are final by default — `open` is required for subclassing/overriding, verified live to produce a real compile error otherwise, the opposite of Java's default.
- `override` is mandatory (not optional) when overriding an `open` member.
- `data class` auto-generates `equals`/`hashCode`/`toString`/`copy`/destructuring support.
- `object` provides built-in singletons; companion objects replace Java's `static` with real (singleton) object members.

## Key Terms

- **`open`** — a modifier required to allow a class or method to be subclassed/overridden; without it, both are final.
- **Companion object** — a singleton object associated with a class, providing `static`-member-like access via the class name.

## Interview Questions

1. **Why are Kotlin classes final by default, and what compile error results from trying to subclass one without `open`?**
   Kotlin deliberately inverts Java's default: rather than every non-`final` class being freely subclassable, Kotlin classes require the explicit `open` modifier before they can be extended at all, based on the "design for inheritance explicitly, or prohibit it" principle — subclassing should be a deliberate part of a class's designed contract, not an accident of omission. This was verified directly: attempting to extend a class without `open` produces the compile error "this type is final, so it cannot be extended," failing at compile time rather than allowing potentially unintended/unsafe subclassing.

2. **How does a Kotlin companion object provide functionality similar to Java's `static` members, given that Kotlin has no `static` keyword?**
   A companion object is a genuine singleton object declared inside a class using the `companion` modifier; its members can be accessed directly via the enclosing class's name (`Counter.create()`), which reads exactly like a call to a static method, even though it's actually a call to a method on a real, singleton object instance associated with that class. This was demonstrated in this lesson via a factory-function pattern: `Counter`'s primary constructor is `private` (preventing direct instantiation from outside), and a `companion object` provides a public `create()` factory function with access to the private constructor, tracking and assigning incrementing IDs — a controlled-instantiation pattern achieved entirely through Kotlin's object system, with no `static` keyword involved at all.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
