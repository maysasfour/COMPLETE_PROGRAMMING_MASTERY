# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Use generic classes and functions with bounds (`<T extends Comparable<T>>`).
- Understand and verify live a genuinely important contrast with Java (covered earlier in this repository): **Dart generics are reified at runtime, not erased** — `is List<int>` genuinely works and distinguishes type arguments, something Java's erasure-based generics cannot do at all.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Unlike Java (covered in this repository's Java course), whose generics are erased at compile time — meaning `List<Integer>` and `List<String>` are indistinguishable at runtime, and `list instanceof List<Integer>` is a compile error — **Dart's generics are reified**: the actual type argument is preserved and checkable at runtime via `is`, and visible directly via `.runtimeType`. This is a genuinely significant, verified difference in how the two languages implement generics.

## Generic Classes and Bounded Type Parameters

```dart
class Stack<T> {
  final List<T> _items = [];
  void push(T item) => _items.add(item);
  T? pop() => _items.isEmpty ? null : _items.removeLast();
}

T maxOf<T extends Comparable<T>>(T a, T b) => a.compareTo(b) > 0 ? a : b;
```

## Reified Generics, Verified Live

```dart
var intList = <int>[1, 2, 3];
print(intList is List<int>);      // true
print(intList is List<String>);    // false -- genuinely distinguishes type arguments at runtime
print(intList.runtimeType);          // List<int> -- the ACTUAL type argument is visible
```

Verified live: `intList is List<int>` returned `true` and `intList is List<String>` returned `false` — Dart's runtime genuinely knows and checks the list's actual type argument. `intList.runtimeType` printed `List<int>`, confirming the type argument is present and inspectable at runtime, not discarded. The exact same test in Java would either not compile at all (`instanceof` with a parameterized type is a compile error there, precisely because the information doesn't exist at runtime to check against) or would require an unchecked, unsafe workaround.

## Detailed Example

See [example.dart](example.dart) — a generic `Stack<T>` class, a bounded generic function, and the live-verified reified-generics demonstration contrasting directly with Java's erasure, including a `Box<T>` class confirming `is Box<String>`/`is Box<int>` genuinely distinguish at runtime.

## Run It

```bash
cd 01-Languages/Dart/13-Generics
dart run example.dart
```

## Expected Output

Running `dart run example.dart` prints `2` (the generic stack's popped value), `7` and `banana` (the bounded generic function), then `true`, `false`, `List<int>`, `Box<String>`, `true`, `false` (the reified-generics demonstration) — all confirmed by actual execution, directly proving Dart's generics retain their type arguments at runtime.

## Common Mistakes

- Assuming Dart generics are erased the way Java's are, out of habit — verified live that they're not; `is`-based type checks against a specific generic instantiation genuinely work in Dart, unlike Java where the equivalent check is a compile error.
- Forgetting bounded type parameters (`<T extends Comparable<T>>`) restrict what operations are available on `T` inside the generic function/class — without the bound, `a.compareTo(b)` wouldn't be recognized as valid, since a plain, unbounded `T` has no guaranteed methods beyond `Object`'s.

## Best Practices

- Take advantage of Dart's reified generics for genuinely runtime-type-aware logic (e.g., checking a collection's element type dynamically) — a capability Java code covered elsewhere in this repository would need a separate mechanism (like passing a `Class<T>` token) to approximate.
- Use bounded type parameters (`<T extends SomeType>`) whenever a generic function/class needs to call specific methods on values of type `T`.

## Real-World Usage

Dart's reified generics matter in real Flutter/Dart code particularly for runtime type-checking and reflection-adjacent patterns (e.g., certain dependency-injection or serialization libraries that need to distinguish `List<int>` from `List<String>` at runtime) — a capability that would require significantly more workaround code in Java, where such information is simply unavailable after compilation due to type erasure.

## Summary

- Dart generic classes/functions support bounded type parameters (`<T extends Comparable<T>>`), similar to generics in other languages covered in this repository.
- Dart generics are **reified** at runtime — verified live via `is List<int>`/`is List<String>` and `.runtimeType`, a genuinely important, checked difference from Java's erasure-based generics.

## Key Terms

- **Reified generics** — a generics implementation where type arguments are preserved and checkable at runtime, as Dart's are.
- **Type erasure** — a generics implementation (like Java's, covered elsewhere in this repository) where type arguments exist only at compile time and are discarded before runtime.

## Interview Questions

1. **How do Dart's generics differ from Java's regarding runtime type information, and how was this verified rather than assumed?**
   Verified directly in this lesson: `var intList = <int>[1, 2, 3]; print(intList is List<int>);` printed `true`, and checking `is List<String>` on the same list printed `false` — Dart's runtime genuinely retains and checks the list's actual type argument. In Java (covered in this repository's Java course), generics are erased at compile time: `List<Integer>` and `List<String>` are represented identically at runtime (just `List`), and writing `list instanceof List<Integer>` is a compile error, since the type argument simply doesn't exist anymore by the time the check would run. This is a genuine, meaningful implementation difference between the two languages' generics systems, not just a syntax difference.

2. **What does a bounded type parameter like `<T extends Comparable<T>>` provide, and why is it necessary?**
   It restricts a generic type parameter `T` to only types that implement (or extend) `Comparable<T>`, which in turn guarantees that any value of type `T` has a `.compareTo()` method available. Without this bound, a generic function or class couldn't call `.compareTo()` (or any method beyond what's guaranteed on Dart's root `Object` type) on a value of type `T`, since the compiler has no way to know what operations are actually available on an arbitrary, unconstrained type parameter. This mirrors the same bounded-generics concept covered in this repository's other statically-typed language courses (Java's `<T extends Comparable<T>>`, Kotlin's `<T : Comparable<T>>`, Rust's trait bounds), all serving the identical purpose with each language's own syntax.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
