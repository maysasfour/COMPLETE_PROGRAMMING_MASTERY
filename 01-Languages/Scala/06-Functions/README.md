# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Distinguish **methods** (`def`, bound to a class/object) from **function values** (first-class objects assignable to variables).
- Use default and named parameters.
- Use **currying** (multiple parameter lists) and understand where it's useful.

## Concept

A `def` is a method — invoked by name, not itself directly a value (though it can be converted to one via eta-expansion). A function *value* (e.g., `val f: Int => Int = x => x * 2`) is a genuine object, an instance of a `FunctionN` trait, that can be passed around, stored, and passed as an argument to a higher-order function. Methods are generally more efficient and are the default way to define behavior; function values are needed when a function itself must be treated as data (e.g., passed into `.map`).

## Methods vs. Function Values

```scala
def double(x: Int): Int = x * 2       // a method
val doubleFn: Int => Int = x => x * 2  // a function value (an actual object)
val fromMethod: Int => Int = double     // eta-expansion: converts a method reference to a function value
```

## Default and Named Parameters

```scala
def greet(name: String, greeting: String = "Hello"): String = s"$greeting, $name!"
greet("Ada")                              // uses default greeting
greet(name = "Ada", greeting = "Hi")       // named arguments, any order
```

## Currying (Multiple Parameter Lists)

```scala
def add(a: Int)(b: Int): Int = a + b
val add5 = add(5) _   // partially applied: add5: Int => Int
add5(3)                 // 8
```

Currying is especially useful for defining functions that read naturally with a trailing block argument (e.g., `withResource(conn) { r => ... }`) and for partial application, building specialized functions from general ones.

## Detailed Example

See [Functions.scala](Functions.scala).

## Run It

```bash
cd 01-Languages/Scala/06-Functions
scalac Functions.scala
scala run . --main-class functionsDemo
```

## Expected Output

```
method call: double(5) = 10
function value call: doubleFn(5) = 10
eta-expanded: fromMethod(5) = 10
default param: Hello, Ada!
named params: Hi, Ada!
curried: add(5)(3) = 8
partially applied add5(3) = 8
```

## Common Mistakes

- Assuming a `def` can be passed directly wherever a function value is expected without any conversion — Scala performs this (eta-expansion) automatically in most contexts, but understanding it's happening avoids confusion when it doesn't apply (e.g., overloaded methods sometimes need an explicit `_` or type ascription).
- Forgetting default parameter values are evaluated at the *call site* each time, not once at definition time — relevant if a default is an expensive/impure expression.
- Overusing currying where a simple multi-parameter method would be clearer — reserve it for genuine partial-application or trailing-lambda-block use cases.

## Best Practices

- Use plain multi-parameter `def`s by default; reach for currying specifically to enable partial application or a trailing-block calling style.
- Use named parameters for calls with several same-typed parameters to avoid positional-argument mistakes.

## Real-World Usage

Currying underlies Scala's `implicit`/`using` parameter lists and is the mechanism enabling libraries to offer trailing-lambda "DSL-like" APIs, e.g., `Future { ... }`-style block syntax.

## Exercises / Solutions

See [Exercises/](Exercises/) and [Solutions/](Solutions/).

## Summary

- Methods (`def`) and function values are related but distinct; eta-expansion converts one to the other.
- Default/named parameters reduce call-site boilerplate and improve clarity.
- Currying (multiple parameter lists) enables partial application and trailing-block call syntax.

## Key Terms

- **Eta-expansion** — the compiler's automatic conversion of a method reference into a function value.
- **Currying** — splitting a function's parameters across multiple parameter lists, enabling partial application.

## Interview Questions

1. **What's the practical difference between a Scala method and a function value?** — A method (`def`) is invoked by name and isn't itself an object; a function value is a genuine instance of a `FunctionN` trait that can be stored in a variable, passed as an argument, or returned from another function. Scala automatically converts a method reference into a function value (eta-expansion) in most contexts where one is expected, which is why the distinction is often invisible in practice but matters when reasoning about what's actually passed around at runtime.
2. **Why would you curry a function instead of using a normal multi-parameter method?** — Currying (multiple parameter lists) enables partial application — fixing some arguments early to produce a more specialized function — and enables a trailing-lambda calling convention (`fn(arg) { block }`) that reads like a built-in control structure, which is how many Scala DSL-style APIs are built.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
