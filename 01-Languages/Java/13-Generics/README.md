# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write generic methods and classes.
- Use bounded type parameters (`<T extends Comparable<T>>`) and wildcards (`? extends`/`? super`).
- Understand type erasure and its concrete practical limitations.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Java generics are checked at compile time but **fully erased** at runtime — `List<Integer>` and `List<String>` are the exact same class (`List`) once compiled, and there is no way to recover the type argument via reflection. This is fundamentally different from C#'s generics (Lesson 13 of the C# course), which specialize and preserve type information for value types at runtime. Erasure has concrete practical consequences: no `new T()`, no `instanceof List<String>`, and arrays of generic types are disallowed.

## Generic Methods

```java
static <T> T first(List<T> items) {
    return items.get(0);
}

System.out.println(Example.<Integer>first(List.of(1, 2, 3))); // explicit type witness (usually inferred)
System.out.println(first(List.of("a", "b")));                  // inferred as String
```

## Bounded Type Parameters

```java
static <T extends Comparable<T>> T max(List<T> items) {
    T result = items.get(0);
    for (T item : items) {
        if (item.compareTo(result) > 0) result = item;
    }
    return result;
}
```

`<T extends Comparable<T>>` restricts `T` to types implementing `Comparable<T>` (i.e., naturally orderable types like `Integer`, `String`), letting the method body safely call `.compareTo()` — Java's `extends` in a generic bound covers both class inheritance and interface implementation, unlike its normal meaning restricted to class inheritance.

## Wildcards

```java
static double sumOfList(List<? extends Number> list) { // accepts List<Integer>, List<Double>, etc.
    double total = 0;
    for (Number n : list) total += n.doubleValue();
    return total;
}
```

`? extends Number` ("upper bounded wildcard") means "a list of some unknown subtype of `Number`" — you can safely *read* `Number`s out of it, but cannot safely *add* to it (the compiler can't guarantee what specific subtype it actually holds). `? super T` ("lower bounded wildcard") is the mirror case, safe to *write* `T`s into, unsafe to read as anything more specific than `Object`.

## Type Erasure's Practical Limits

```java
// static <T> T createInstance() {
//     return new T(); // COMPILE ERROR -- T is erased, the JVM has no idea what to `new` at runtime
// }

List<String> strings = List.of("a", "b");
// if (strings instanceof List<String>) { } // COMPILE ERROR -- erased, can't check the type argument
if (strings instanceof List<?>) { } // fine -- checking for "some kind of List" is allowed
```

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints a generic `first<T>` method with inference, a bounded-type `max` method finding the largest element, and a wildcard-accepting `sumOfList` method used with both `List<Integer>` and `List<Double>`.

## Common Mistakes

- Assuming Java generics behave like C#'s at runtime — attempting `new T()` or `instanceof List<String>`, both compile errors due to erasure.
- Confusing `<T extends X>` (a bound, restricting what `T` can be) with wildcard `<? extends X>` (used at a *use site*, not a declaration) — they solve related but distinct problems.

## Best Practices

- Use bounded type parameters (`<T extends Comparable<T>>`) when a generic method's body needs to call specific methods on `T`.
- Use `? extends T` for read-only generic parameters and `? super T` for write-only ones (the mnemonic is "PECS": Producer `extends`, Consumer `super`).

## Real-World Usage

Bounded generics and wildcards are pervasive throughout the Collections Framework itself (`Collections.max(Collection<? extends T>)`, `Comparator<? super T>`) — understanding PECS is what lets you read and correctly use much of the JDK's own generic API signatures.

## Summary

- Java generics are compile-time-checked but fully erased at runtime — no `new T()`, no `instanceof List<String>`.
- `<T extends X>` bounds a type parameter to types implementing/extending `X`.
- Wildcards (`? extends`/`? super`) at use sites express "some unknown subtype/supertype," following the PECS mnemonic.

## Key Terms

- **Type erasure** — Java generics being compile-time-only; the compiled bytecode has no runtime record of the specific type argument used.
- **Bounded type parameter** — `<T extends X>`, restricting a generic type parameter to types satisfying `X`.
- **Wildcard (`?`)** — `? extends T`/`? super T`, expressing an unknown type at a use site rather than a declaration.

## Interview Questions

1. **What is type erasure, and what are its practical consequences?**
   Java generics are checked by the compiler but erased from the compiled bytecode — at runtime, `List<Integer>` and `List<String>` are both just `List`, with no way to recover the original type argument via reflection. Practical consequences include: you cannot write `new T()` (the JVM has no runtime type to instantiate), cannot check `instanceof List<String>` (only `instanceof List<?>`), and cannot create an array of a generic type directly.

2. **What does "PECS" mean, and how does it apply to wildcards?**
   "Producer `extends`, Consumer `super`" — use `? extends T` when a generic parameter only needs to be **read from** (produces `T`s for you to consume), and `? super T` when it only needs to be **written to** (consumes `T`s you produce). This lets a method accept a wider range of compatible generic types than requiring an exact type match.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
