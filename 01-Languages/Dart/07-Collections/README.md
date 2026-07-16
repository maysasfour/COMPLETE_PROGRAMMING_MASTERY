# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use `List`/`Map`/`Set`, and Dart's `.map()`/`.where()`/`.reduce()` (Dart's names for map/filter/reduce).
- Use collection-if and collection-for inside collection literals — a genuinely distinctive Dart feature building on Lesson 04's spread operator.
- Use `List.unmodifiable()` for genuine, independent immutability.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

Dart's core collections (`List`, `Map`, `Set`) behave similarly to their equivalents in most languages covered in this repository, with two genuinely distinctive features: **collection-if/collection-for** (conditionally or generatively building elements directly inside a collection literal) and `List.unmodifiable()` (producing a truly independent, immutable copy — not merely a read-only-*typed* view of a still-mutable object, the nuance demonstrated in this repository's Kotlin course).

## `.map()`/`.where()`/`.reduce()`

```dart
nums.map((n) => n * 2).toList();     // Dart's "map" -- returns a lazy Iterable, .toList() materializes it
nums.where((n) => n % 2 == 0).toList(); // Dart's "filter"
nums.reduce((a, b) => a + b);
```

## Collection-If and Collection-For: A Distinctive Dart Feature

```dart
var conditionalList = [
  1,
  2,
  if (includeExtra) 3, // collection-if: conditionally includes an element, inline
  4,
];

var generatedList = [
  0,
  for (var x in source) x * 2, // collection-for: generates elements from a loop, inline
  100,
];
```

Verified live: `conditionalList` included `3` because `includeExtra` was `true`, and `generatedList` correctly interleaved a loop-generated sequence (`source.map((x) => x * 2)`) with manually-specified surrounding elements — all inside a single collection literal, with no separate imperative construction step needed. This combines naturally with the spread operator (Lesson 04) for building collections declaratively, a pattern especially prominent in Flutter's widget-tree-as-a-list style UI code.

## `List.unmodifiable()`: Genuine, Independent Immutability

```dart
var mutableSource = [1, 2, 3];
var trulyImmutable = List.unmodifiable(mutableSource); // an actual, separate, immutable copy
mutableSource.add(4);
print(mutableSource);   // [1, 2, 3, 4] -- the original changed
print(trulyImmutable);   // [1, 2, 3]    -- UNCHANGED, genuinely independent
trulyImmutable.add(99); // throws UnsupportedError
```

Verified live: `trulyImmutable` remained `[1, 2, 3]` even after `mutableSource` was mutated, and attempting to mutate `trulyImmutable` itself threw a genuine `UnsupportedError`. This is a stronger, more explicit guarantee than simply typing a variable as a read-only interface (the exact gotcha demonstrated in this repository's Kotlin course, where a read-only-*typed* reference could still reflect mutations through a separately-held mutable reference to the *same* object) — `List.unmodifiable()` produces a genuinely separate, permanently-locked copy.

## Detailed Example

See [example.dart](example.dart) — `List`/`Map`/`Set`, `.map()`/`.where()`/`.reduce()`, both collection-if and collection-for demonstrated live, `List.unmodifiable()`'s independence and mutation-rejection verified live, and Dart 3 record destructuring.

## Practice

- [Exercises/exercise.dart](Exercises/exercise.dart) — filter/map/reduce over a list of `Map`-based "products."
- [Solutions/solution.dart](Solutions/solution.dart) — a worked solution, run and verified to print `total: 24.98` and `names: [Widget, Gizmo]`.

## Run It

```bash
cd 01-Languages/Dart/07-Collections
dart run example.dart
dart run Solutions/solution.dart
```

## Expected Output

`example.dart` prints the `List`/`Map`/`Set` contents, the `.map()`/`.where()`/`.reduce()` results, `conditionalList: [1, 2, 3, 4]`, `generatedList: [0, 20, 40, 60, 100]`, confirmation that `mutableSource` changed while `trulyImmutable` didn't, a caught `UnsupportedError` for the attempted mutation, and the destructured record output. `Solutions/solution.dart` prints `total: 24.98` and `names: [Widget, Gizmo]`.

## Common Mistakes

- Forgetting `.map()`/`.where()` return a lazy `Iterable`, not a `List` — `.toList()` (or `.toSet()`) must be called to materialize a concrete, indexable collection.
- Assuming a read-only-typed reference to a `List` is genuinely immutable — as demonstrated in this repository's Kotlin course, that's only true if the underlying object is never exposed as mutable elsewhere; `List.unmodifiable()` (or the `const`/immutable collection literals) provides Dart's actual, independent immutability guarantee.
- Forgetting collection-if requires the condition itself to be a `bool` expression evaluated at the point the literal is constructed, not some kind of deferred/lazy condition re-evaluated later.

## Best Practices

- Use collection-if/collection-for to build collections declaratively wherever it improves readability over a separately-constructed, imperatively-built list — a common, idiomatic pattern in Flutter widget trees.
- Use `List.unmodifiable()` (or `const` collection literals, where every element is itself a compile-time constant) when genuine, independent immutability is required, not just a read-only-typed reference.
- Remember to materialize lazy `Iterable` chains (`.map()`, `.where()`) with `.toList()`/`.toSet()` when a concrete collection (not just an iterable sequence) is needed.

## Real-World Usage

Collection-if/collection-for are heavily used in real Flutter code for conditionally including widgets in a list (e.g., `children: [Widget1(), if (showExtra) Widget2()]`) — a genuinely idiomatic Dart/Flutter pattern for declarative UI construction, distinctive among the languages covered in this repository.

## Summary

- Dart's `.map()`/`.where()`/`.reduce()` mirror map/filter/reduce from every other language covered in this repository, with `.map()`/`.where()` returning lazy `Iterable`s requiring `.toList()` to materialize.
- Collection-if and collection-for allow conditional/generative element construction directly inside a collection literal — a genuinely distinctive Dart feature, verified live.
- `List.unmodifiable()` provides genuine, independent immutability — verified live to be a stronger guarantee than a merely read-only-typed reference to a still-mutable object (the exact gap demonstrated in this repository's Kotlin course).

## Key Terms

- **Collection-if/collection-for** — Dart syntax for conditionally or generatively including elements directly inside a collection literal.
- **`List.unmodifiable()`** — produces a genuinely independent, permanently immutable copy of a list.

## Interview Questions

1. **What do collection-if and collection-for provide, and where are they most commonly used in real Dart code?**
   Collection-if (`if (condition) element`) and collection-for (`for (var x in source) expression`) let a collection literal conditionally include an element or generate a sequence of elements directly inline, without needing to build the collection imperatively in separate statements beforehand. Verified live in this lesson: a list literal correctly included an element only when a boolean flag was true, and another literal correctly interleaved loop-generated elements with manually-specified ones, all within the literal itself. These are most commonly used in real Flutter code for building widget-tree children lists declaratively — conditionally including a widget, or generating a list of widgets from a data source, directly within a `children: [...]` list literal.

2. **How does `List.unmodifiable()` provide a stronger immutability guarantee than simply typing a variable as a read-only `List` interface, given the Kotlin course's finding on this exact topic?**
   In Kotlin (covered in this repository's Kotlin course), a variable typed as the read-only `List<T>` interface can still reflect mutations if the *same underlying object* is also referenced through a separately-held `MutableList<T>` reference elsewhere — the read-only typing prevents mutation *through that specific reference*, but doesn't guarantee the underlying data can never change at all. `List.unmodifiable()` in Dart instead creates a genuinely separate, independent copy that is permanently locked against mutation — verified live in this lesson: mutating the original source list afterward had no effect on the `List.unmodifiable()`-derived copy, and attempting to mutate the unmodifiable copy directly threw a real `UnsupportedError`. This is a structurally different, stronger guarantee than merely restricting a reference's declared type.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
