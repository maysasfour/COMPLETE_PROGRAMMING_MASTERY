# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Use lambda expressions and built-in functional interfaces (`Function`, `Predicate`, `Consumer`, `Supplier`).
- Write a higher-order method wrapping a functional interface.
- Use the Stream API in depth (extending Lesson 07's first look).

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Java has no true first-class functions the way JavaScript/Python do — instead, lambdas are syntactic sugar for implementing a **functional interface** (an interface with exactly one abstract method) inline. `java.util.function` provides the everyday built-in ones: `Function<T,R>` (takes a `T`, returns an `R`), `Predicate<T>` (takes a `T`, returns `boolean`), `Consumer<T>` (takes a `T`, returns nothing), `Supplier<T>` (takes nothing, returns a `T`).

## Lambdas and Built-In Functional Interfaces

```java
import java.util.function.*;

Function<Integer, Integer> square = n -> n * n;
Predicate<Integer> isEven = n -> n % 2 == 0;
Consumer<String> log = message -> System.out.println("LOG: " + message);
Supplier<String> getGreeting = () -> "Hello!";

System.out.println(square.apply(5));
System.out.println(isEven.test(4));
log.accept("hello");
System.out.println(getGreeting.get());
```

## A Higher-Order Method

```java
static Function<Integer, Integer> withLogging(Function<Integer, Integer> fn) {
    return n -> {
        System.out.println("Calling with " + n);
        int result = fn.apply(n);
        System.out.println("Returned " + result);
        return result;
    };
}
```

## Stream API in Depth

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);
int result = numbers.stream()
    .filter(n -> n % 2 == 0)
    .map(n -> n * n)
    .reduce(0, Integer::sum); // reduce: fold to a single value with a starting point + combiner
```

`Integer::sum` is a **method reference** — shorthand for `(a, b) -> Integer.sum(a, b)`, used wherever a lambda would just forward its arguments directly to an existing method.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints usage of all four core functional interfaces, a logged higher-order wrapper, and a Stream pipeline using `filter`/`map`/`reduce` together with a method reference.

## Common Mistakes

- Writing a custom functional interface when a built-in one (`Function`, `Predicate`, `Consumer`, `Supplier`, or their two-argument `BiX` variants) already covers the exact signature needed.
- Forgetting `.reduce()` needs an identity/starting value as its first argument for the common (non-`Optional`-returning) overload.

## Best Practices

- Default to `java.util.function`'s built-in interfaces over custom ones unless a named interface genuinely improves clarity.
- Use method references (`ClassName::methodName`, `instance::methodName`) instead of a lambda that just forwards to an existing method.
- Prefer Stream pipelines for data transformation over manual loops.

## Real-World Usage

`Function`/`Predicate`/`Consumer`/`Supplier` and Stream pipelines are pervasive throughout modern Java codebases (Spring, Java collections, Optional chaining) — this is the single most transferable functional-programming skill across the modern JDK ecosystem.

## Summary

- Lambdas implement a functional interface (one abstract method) inline; `java.util.function` provides the everyday built-in ones.
- Method references (`Class::method`) shorten lambdas that just forward to an existing method.
- The Stream API's `filter`/`map`/`reduce` mirror the same idiom from every other language course in this repository.

## Key Terms

- **Functional interface** — an interface with exactly one abstract method, implementable inline via a lambda.
- **Method reference (`::`)** — shorthand for a lambda that just calls an existing method.

## Interview Questions

1. **What is a functional interface in Java?**
   An interface with exactly one abstract method (it may have any number of `default`/`static` methods). Lambdas in Java are syntactic sugar for providing an inline implementation of a functional interface's single abstract method — a lambda's type is always inferred as whatever functional interface the context expects.

2. **What's the difference between `Function<T,R>` and `Predicate<T>`?**
   `Function<T,R>` takes a `T` and returns an `R` (any type) via `.apply(t)`. `Predicate<T>` takes a `T` and always returns a `boolean` via `.test(t)` — effectively a specialized `Function<T, Boolean>` with a more semantically clear name and method, used pervasively for filtering (e.g., `Stream.filter` takes a `Predicate`).

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
