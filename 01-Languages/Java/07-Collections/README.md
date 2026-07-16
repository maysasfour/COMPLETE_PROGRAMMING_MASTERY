# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use `List`, `Map`, and `Set` from the Java Collections Framework.
- Use the Stream API (a first look, expanded in Lesson 12) for filter/map/reduce-style transformations.
- Understand generics are required for collections to hold anything but `Object` (a preview of Lesson 13).

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

The **Java Collections Framework** provides `List` (ordered, allows duplicates), `Set` (unique elements), and `Map` (key-value pairs) as interfaces, each with standard implementations (`ArrayList`, `HashSet`, `HashMap` are the everyday defaults). Since collections predate primitives-in-generics support, they can only hold objects — `List<Integer>`, never `List<int>` — relying on autoboxing (Lesson 03) to bridge the gap transparently.

## `List`, `Map`, `Set`

```java
List<Integer> scores = new ArrayList<>();
scores.add(95);
scores.add(88);

Map<String, Integer> ages = new HashMap<>();
ages.put("Ada", 30);
System.out.println(ages.get("Ada"));
System.out.println(ages.getOrDefault("Unknown", -1)); // safe lookup, no exception

Set<String> uniqueTags = new HashSet<>(List.of("js", "css", "js")); // duplicates removed
```

## The Stream API (First Look)

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);

List<Integer> doubled = numbers.stream().map(n -> n * 2).collect(Collectors.toList());
List<Integer> evens = numbers.stream().filter(n -> n % 2 == 0).collect(Collectors.toList());
int total = numbers.stream().mapToInt(Integer::intValue).sum();
boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0);
```

`.stream()` converts a collection into a **Stream**, a lazily-evaluated pipeline of operations (`.map`, `.filter`, and dozens more) terminated by a collecting operation (`.collect(Collectors.toList())`, `.sum()`, `.count()`) — directly analogous to LINQ in the C# course and `map`/`filter`/`reduce` in the JavaScript/TypeScript courses.

## Detailed Example

See [Example.java](Example.java).

## Expected Output

Running `java Example.java` prints `List`/`Map`/`Set` usage (including `getOrDefault`'s safe lookup) and a Stream pipeline mirroring the filter/map/reduce idiom from every other language course.

## Common Mistakes

- Using `map.get(key)` directly instead of `getOrDefault`/checking `containsKey` first when a missing key is a plausible outcome — `.get()` on a missing key returns `null`, not an exception, but treating that `null` as a valid value without checking is its own bug source.
- Forgetting collections need boxed types (`List<Integer>`, never `List<int>`) — a direct consequence of Java's generics being erased and requiring object types (Lesson 13).
- Calling `.stream()` operations without a terminal operation (`.collect`, `.sum`, `.forEach`) — streams are lazy and do nothing until a terminal operation triggers execution.

## Best Practices

- Use `getOrDefault`/`containsKey` for map lookups where a missing key is expected, rather than a bare `.get()` followed by a `null` check that's easy to forget.
- Prefer Stream pipelines for data transformation over manual loops, mirroring the idiom from every other language course.
- Use `List.of(...)`/`Map.of(...)`/`Set.of(...)` (Java 9+) for small, immutable collection literals.

## Real-World Usage

The Stream API is the standard modern way to transform collections throughout Java codebases, directly comparable to LINQ (C#) and `map`/`filter`/`reduce` (JavaScript/TypeScript) — understanding one makes the others immediately recognizable.

## Summary

- `List`/`Set`/`Map` (with `ArrayList`/`HashSet`/`HashMap` as everyday defaults) are Java's core collection interfaces/implementations.
- Collections require boxed object types, never primitives directly, due to generics' object-only requirement (Lesson 13).
- The Stream API provides lazy, chainable filter/map/reduce-style operations, directly analogous to LINQ and JS/TS array methods.

## Key Terms

- **Java Collections Framework** — the standard library's `List`/`Set`/`Map` interfaces and implementations.
- **Stream** — a lazily-evaluated pipeline of collection operations, requiring a terminal operation to actually execute.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Why can't you write `List<int>` in Java?**
   Java generics require reference (object) types as type arguments — primitives like `int` cannot be used directly. `List<Integer>` uses the boxed wrapper type instead, with autoboxing (Lesson 03) transparently converting between `int` and `Integer` as elements are added/retrieved.

2. **Why are Java Streams described as "lazy"?**
   Intermediate operations (`.map`, `.filter`) don't execute anything by themselves — they build up a pipeline description. Execution only happens when a terminal operation (`.collect`, `.sum`, `.forEach`, `.count`) is called, at which point the entire pipeline runs once, element by element, through all the intermediate operations in sequence.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
