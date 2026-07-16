# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Use default/named parameters, single-expression function syntax, and `vararg`.
- Write extension functions — Kotlin's way of adding methods to existing types (including types you don't own) without inheritance or modifying the original source.
- Use higher-order functions, typed lambda variables, trailing lambda syntax, and the implicit `it` parameter.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Kotlin functions support default values, named arguments, and `vararg` (similar to features covered in this repository's other language courses), plus two genuinely distinctive features: **extension functions** (adding new "methods" to any existing type, including types from external libraries or the standard library, without touching their source) and first-class **lambdas** with concise trailing-lambda call syntax and an implicit `it` parameter name.

## Default/Named Parameters and Single-Expression Functions

```kotlin
fun greet(name: String, greeting: String = "Hello"): String = "$greeting, $name!" // = body, no { }
greet(name = "Linus", greeting = "Hey") // named arguments, order-independent
```

## `vararg`

```kotlin
fun sum(vararg numbers: Int): Int = numbers.sum()
sum(1, 2, 3, 4) // 10
```

## Extension Functions: Adding Methods to Existing Types

```kotlin
fun String.shout(): String = this.uppercase() + "!"
"hello".shout() // "HELLO!" -- called AS IF it were a real method on String
```

An extension function is defined *outside* the type it extends (`String` here, a standard library type Kotlin code doesn't own), yet is called with ordinary method-call syntax. This is resolved statically at compile time (based on the declared type, not runtime dispatch) — it's syntactic sugar for a regular static function taking the receiver as its first parameter, not genuine open-class monkey-patching. This is a real, distinctive Kotlin feature with no direct equivalent in Java, Go, or Rust as covered in this repository (C#'s extension methods are the closest analogue).

## Higher-Order Functions and Lambdas

```kotlin
val multiplier: (Int) -> Int = { x -> x * 3 }   // lambda with an explicit type annotation
multiplier(5) // 15

fun applyTwice(x: Int, f: (Int) -> Int): Int = f(f(x))
applyTwice(2) { it * 2 } // trailing lambda syntax: the last parameter, if a function, moves outside ()

listOf(1, 2, 3).map { it * 2 } // `it` -- implicit name for a lambda's single parameter
```

Trailing lambda syntax (`applyTwice(2) { it * 2 }` instead of `applyTwice(2, { it * 2 })`) is idiomatic Kotlin whenever a function's last parameter is itself a function — this convention is what makes Kotlin DSLs (like Gradle's Kotlin DSL) read naturally.

## Detailed Example

See [Example.kt](Example.kt) — default/named parameters, `vararg`, an extension function on `String`, typed lambda variables, trailing lambda syntax, `it`, and local (nested) functions.

## Practice

- [Exercises/Exercise.kt](Exercises/Exercise.kt) — implement `Int.isPrime()` (an extension function) and a `vararg average()` function.
- [Solutions/Solution.kt](Solutions/Solution.kt) — a worked solution, verified to correctly list primes up to 30 and compute an average of `2.5`.

## Run It

```bash
cd 01-Languages/Kotlin/06-Functions
kotlinc Example.kt -include-runtime -d Example.jar && java -jar Example.jar
kotlinc Solutions/Solution.kt -include-runtime -d Solution.jar && java -jar Solution.jar
```

## Expected Output

`Example.kt` prints three greetings, `10` (vararg sum), `HELLO!` (the extension function), `15` and `8` (the two higher-order function demonstrations), `[2, 4, 6]` (`it`-based `map`), and `local helper: 16`. `Solutions/Solution.kt` prints the correct list of primes up to 30 and `average: 2.5`.

## Common Mistakes

- Assuming an extension function can access a type's *private* members — it can't; it's compiled as an ordinary external function and only has access to the type's public API, unlike a genuine method defined inside the class.
- Forgetting extension function resolution is static (based on the declared/compile-time type), not dynamic — calling an extension function through a variable typed as a supertype uses the supertype's extension function, even if the runtime object is a subtype with its own same-named extension (a genuine, if uncommon, gotcha).
- Writing `applyTwice(2, { it * 2 })` instead of the idiomatic trailing-lambda form `applyTwice(2) { it * 2 }` — functionally identical, but not idiomatic Kotlin style.

## Best Practices

- Use extension functions to add utility behavior to existing types (including standard library or third-party types) instead of writing static utility/helper classes, following Kotlin's idiomatic style.
- Use trailing lambda syntax whenever a function's last parameter is a lambda.
- Use `it` for simple, single-parameter lambdas; switch to an explicit parameter name once a lambda's logic becomes non-trivial, for readability.

## Real-World Usage

Extension functions are pervasive throughout the Kotlin standard library itself (`.filter`, `.map`, `.sum` on collections are all extension functions on top of Java's existing collection types) and are a defining idiom of Kotlin codebases generally — adding domain-specific "methods" to existing types (including Android SDK types, in Android development) without subclassing is extremely common in real Kotlin projects.

## Summary

- Kotlin supports default/named parameters and `vararg`, similar to features in other courses' languages.
- Extension functions add method-call-syntax behavior to existing types without modifying their source or using inheritance — resolved statically, not dynamically.
- Lambdas support typed variable storage, trailing-lambda call syntax, and the implicit `it` parameter for single-argument lambdas.

## Key Terms

- **Extension function** — a function defined outside a type, callable with ordinary method syntax on instances of that type, resolved statically.
- **Trailing lambda syntax** — Kotlin's convention of moving a function's last lambda-typed parameter outside its parentheses at the call site.

## Interview Questions

1. **How does an extension function differ from a genuine method added via inheritance or reopening a class?**
   An extension function is compiled as an ordinary top-level (or member) function taking the "receiver" type as an implicit first parameter, resolved entirely at compile time based on the *declared* (static) type of the expression it's called on — it has no access to the type's private members, and it doesn't participate in dynamic/virtual dispatch the way an overridden method would. This means if a variable is declared with a supertype but holds a subtype instance at runtime, calling an extension function on it resolves based on the supertype, not the actual runtime type — a genuine, if uncommon, difference from real polymorphic method dispatch.

2. **What does trailing lambda syntax provide, and why is `it` significant alongside it?**
   Trailing lambda syntax lets a function's last parameter, if it's a lambda, be written outside the parentheses (`function(arg) { lambdaBody }` instead of `function(arg, { lambdaBody })`), producing more natural-reading code, especially for control-flow-like or DSL-style functions. `it` is Kotlin's implicit name for a lambda's single parameter when no explicit parameter name is declared, letting simple lambdas like `{ it * 2 }` skip naming a parameter entirely — together, these two features are why Kotlin code using higher-order functions (`.filter { it > 0 }`, `.map { it * 2 }`) reads almost like built-in language syntax rather than function calls.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
