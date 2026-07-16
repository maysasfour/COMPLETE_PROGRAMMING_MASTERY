# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Understand that Kotlin closures **can mutate captured local variables** — a genuine, verified difference from Java's lambdas, which require captured locals to be "effectively final."
- Use function composition, function references (`::`), and Kotlin's standard scope functions (`let`, `apply`).

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Kotlin lambdas capture their enclosing scope by reference in a genuinely fuller sense than Java's lambdas: a Kotlin closure can both read *and mutate* a captured local `var`, while Java requires any local variable captured by a lambda to be "effectively final" (never reassigned after initialization) — attempting to capture and mutate a local variable in a Java lambda is a compile error.

## Closures Can Mutate Captured Local Variables

```kotlin
fun makeCounter(): () -> Int {
    var count = 0            // a local var
    return { count++ }         // the returned lambda MUTATES count directly
}

val counter = makeCounter()
counter() // 0
counter() // 1
counter() // 2 -- genuinely incrementing the SAME captured variable across calls
```

Verified live: calling the returned closure repeatedly produces `0`, `1`, `2` — each call genuinely mutates the same captured `count` variable, which persists across calls since the closure holds a live reference to it (implemented internally via a boxed reference, since the JVM itself has no native support for mutable captured variables — this is a Kotlin-compiler-generated mechanism). A second, independently-created closure (`makeCounter()` called again) has its own separate captured `count`, confirmed to start again from `0`.

## Function Composition

```kotlin
fun compose(f: (Int) -> Int, g: (Int) -> Int): (Int) -> Int = { x -> f(g(x)) }
val addThenSquare = compose(square, addOne)
addThenSquare(4) // (4+1)^2 = 25
```

## Function References (`::`)

```kotlin
fun isEven(n: Int): Boolean = n % 2 == 0
nums.filter(::isEven) // equivalent to nums.filter { isEven(it) }, but references the function directly
```

## Standard Scope Functions: `let`, `apply`

```kotlin
val result = "hello".let { it.uppercase() } // let: transforms a value, RETURNS the lambda's result

val built = Builder().apply {   // apply: configures `this`, RETURNS the receiver itself
    name = "Ada"
    age = 30
}
```

`let` and `apply` are two of Kotlin's five standard "scope functions" (`let`, `run`, `with`, `apply`, `also`), each differing in what they return and whether the lambda receives its argument as `it` or as `this` — `apply` is especially idiomatic for object configuration/builder-style code, since it returns the configured receiver itself, letting the whole block read as a fluent initialization.

## Detailed Example

See [Example.kt](Example.kt) — the live-verified mutable-closure-capture demonstration (including confirming two separate closures have independent state), function composition, a function reference with `::`, and `let`/`apply`.

## Run It

```bash
cd 01-Languages/Kotlin/12-Functional-Concepts
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints `0`, `1`, `2` (the mutating closure, confirming genuine state persistence across calls), `0` (a second, independent closure starting fresh), `25` (the composed function), `[2, 4, 6]` (the function-reference-based filter), `HELLO` (from `let`), and `Builder(name=Ada, age=30)` (from `apply`).

## Common Mistakes

- Assuming Kotlin lambdas have the same "effectively final" capture restriction as Java's — they don't; Kotlin closures can freely mutate captured local `var`s, verified live in this lesson, a genuine language-level difference.
- Confusing `let` and `apply` — `let` returns the lambda's result (useful for transforming a value into something else); `apply` returns the original receiver itself (useful for configuring an object and continuing to use it, builder-style).
- Forgetting `::functionName` syntax for passing an existing named function as a value, instead writing a redundant wrapping lambda (`{ isEven(it) }`) when `::isEven` says the same thing more directly.

## Best Practices

- Use `::functionName` function references instead of trivial wrapping lambdas whenever passing an existing function directly.
- Use `apply` for object configuration/builder-style initialization; use `let` when a value needs to be transformed or conditionally processed and the *result* (not the original object) is what's needed afterward.
- Be deliberate about closures that mutate captured state — while Kotlin allows it, the same reasoning that makes shared mutable state risky in any language still applies; prefer immutable captures (`val`) where the logic allows it.

## Real-World Usage

Kotlin's scope functions (`let`, `apply`, `run`, `with`, `also`) are pervasive throughout real Kotlin codebases and Android development specifically, used for null-safe chaining (`nullable?.let { ... }`), object configuration, and concise scoped operations — recognizing which of the five is appropriate for a given situation is considered a core Kotlin idiom fluency marker.

## Summary

- Kotlin closures can mutate captured local `var`s, verified live to produce genuinely persistent, incrementing state across calls — a real difference from Java's effectively-final lambda capture restriction.
- Function composition and function references (`::`) work as first-class values, same as in any functional-capable language.
- `let` (returns transformed result) and `apply` (returns the configured receiver) are two of Kotlin's five idiomatic scope functions.

## Key Terms

- **Mutable closure capture** — a Kotlin lambda's ability to both read and reassign a captured local variable, unlike Java's effectively-final restriction.
- **Scope function** — one of Kotlin's five standard higher-order functions (`let`/`run`/`with`/`apply`/`also`) for concise, scoped operations on a value.

## Interview Questions

1. **How does Kotlin's lambda variable capture differ from Java's, and what does this enable?**
   Kotlin lambdas can capture a local `var` and both read and mutate it freely across multiple invocations of the closure — verified directly in this lesson, where a returned closure incremented the same captured `count` variable across three separate calls (`0`, `1`, `2`). Java's lambdas, by contrast, can only capture local variables that are "effectively final" (assigned exactly once) — attempting to mutate a captured local variable inside a Java lambda is a compile error. This Kotlin capability directly enables patterns like the counter-factory shown here (a closure carrying private, persistent, mutable state) without needing a wrapping object or an array/box workaround, which is exactly the pattern Java code must use to simulate the same effect.

2. **What's the practical difference between Kotlin's `let` and `apply` scope functions?**
   `let` takes the receiver as its lambda parameter (accessed via `it` by default) and returns the lambda's *result* — useful for transforming a value into something else or performing a null-safe operation on it. `apply` takes the receiver as `this` inside the lambda (member access without an explicit prefix) and returns the *original receiver itself* — useful for configuring an object's properties and continuing to use that same object afterward, a very common builder-style pattern (demonstrated in this lesson configuring a `Builder` data class instance and getting the same, now-configured instance back).

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
