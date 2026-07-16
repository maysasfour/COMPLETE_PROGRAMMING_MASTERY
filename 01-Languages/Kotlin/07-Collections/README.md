# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Distinguish `List`/`Map`/`Set` (read-only *interfaces*) from `MutableList`/`MutableMap`/`MutableSet` (genuinely mutable).
- Understand a real nuance: a read-only `List` reference is not necessarily an *immutable* object — it can still change if a `MutableList` reference to the same underlying object is mutated elsewhere.
- Use `map`/`filter`/`reduce`/`fold` and destructuring on lists, maps, and data classes.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

Kotlin's collections split read-only interfaces (`List<T>`, `Map<K,V>`, `Set<T>` — no mutating methods exposed at all) from mutable ones (`MutableList<T>`, etc. — genuinely add `add()`/`remove()`/etc.). This is a real, useful distinction for API design (a function can accept `List<T>` to signal "I won't mutate this"), but — verified live in this lesson — it's a distinction about the **reference's type**, not necessarily a guarantee the underlying object itself can never change.

## `listOf` (Read-Only) vs. `mutableListOf` (Mutable)

```kotlin
val readOnly = listOf(1, 2, 3)          // List<Int> -- no add()/remove() in this interface at all
val mutable = mutableListOf(1, 2, 3)    // MutableList<Int> -- has add()/remove()
mutable.add(4)
// readOnly.add(4) // COMPILE ERROR: List<Int> has no add() method
```

## A Genuine, Verified Nuance: Read-Only ≠ Immutable

```kotlin
val backing = mutableListOf(1, 2, 3)
val view: List<Int> = backing // view's TYPE has no mutating methods...
backing.add(4)                    // ...but the underlying object is the SAME one `backing` refers to
println(view) // [1, 2, 3, 4] -- view sees the mutation! It was never a copy.
```

Verified live: `view`, typed as the read-only `List<Int>`, still reflects a mutation performed through `backing`, because `view` and `backing` refer to the exact same underlying list object — only `view`'s *static type* lacks mutating methods, but nothing about the object itself became truly immutable. Genuine immutability in Kotlin requires either never exposing a mutable reference to the same object, or using an explicitly immutable/persistent collection type (not covered by the standard library's default `listOf`, which only returns a read-only *view*, not a deep, defensive copy).

## `Map` and the `to` Infix Function

```kotlin
val map = mapOf("name" to "Ada", "role" to "Engineer") // `to` builds a Pair
map["name"]     // "Ada"
map["missing"] // null -- Map.get returns V?, no exception for a missing key
```

## `map`/`filter`/`reduce`/`fold`

```kotlin
nums.map { it * 2 }
nums.filter { it % 2 == 0 }
nums.reduce { acc, n -> acc + n }        // no initial value -- starts from the first element
nums.fold(100) { acc, n -> acc + n }       // fold: explicit initial value
```

## Destructuring

```kotlin
val (first, second, third) = listOf(1, 2, 3) // works via component1()/component2()/component3()
for ((key, value) in map) { }                   // destructuring Map entries directly in a for-loop
```

## Detailed Example

See [Example.kt](Example.kt) — all of the above, including the live-verified read-only-vs-immutable nuance and `sorted()` (new list) vs. `sort()` (in-place mutation).

## Practice

- [Exercises/Exercise.kt](Exercises/Exercise.kt) — filter/map a list of `Product` data classes to compute total in-stock price and in-stock names.
- [Solutions/Solution.kt](Solutions/Solution.kt) — a worked solution, verified to print `total: 24.98` and `names: [Widget, Gizmo]`.

## Run It

```bash
cd 01-Languages/Kotlin/07-Collections
kotlinc Example.kt -include-runtime -d Example.jar && java -jar Example.jar
kotlinc Solutions/Solution.kt -include-runtime -d Solution.jar && java -jar Solution.jar
```

## Expected Output

`Example.kt` prints the readOnly/mutable list contents, confirms `view` (a read-only-typed reference) still reflects a mutation performed through `backing` (the same underlying object), the Map lookups (`Ada` and `null`), the `map`/`filter`/`reduce`/`fold` results, destructuring output, and both a sorted copy and an in-place-sorted version of the same starting list. `Solutions/Solution.kt` prints `total: 24.98` and `names: [Widget, Gizmo]`.

## Common Mistakes

- Assuming `listOf()` produces a genuinely immutable, defensively-copied object — verified live that it's only a read-only *view*; if any code elsewhere holds a `MutableList` reference to the same object, it can still mutate what the read-only view sees.
- Calling `.sort()` expecting a new, sorted list to be returned — it mutates the receiver in place and returns `Unit`; use `.sorted()` for a new, sorted copy leaving the original untouched.
- Forgetting `Map.get()` (the `map[key]` syntax) returns a nullable value (`V?`) rather than throwing for a missing key — unlike some languages' map/dictionary indexing.

## Best Practices

- Accept `List<T>`/`Map<K,V>` (the read-only interfaces) as function parameters by default, to signal the function won't mutate its input — reserve `MutableList<T>`/etc. parameters for functions that genuinely need to mutate the caller's collection.
- Don't rely on a read-only `List` reference as a substitute for genuine immutability if any other code might hold a mutable reference to the same underlying object — copy defensively (`.toList()`) if true isolation is required.
- Use `.sorted()`/`.filter()`/`.map()` (all of which return new collections) over their in-place-mutating counterparts (`.sort()`) by default, favoring the more functional, side-effect-free style Kotlin's standard library encourages.

## Real-World Usage

The read-only-vs-mutable collection interface split is a widely-used Kotlin API design pattern — exposing a `List<T>` getter backed by an internal `MutableList<T>` the class itself can freely mutate is extremely common, and understanding that this doesn't create true immutability (as verified in this lesson) is important for correctly reasoning about aliasing bugs in real Kotlin codebases.

## Summary

- `List`/`Map`/`Set` are read-only interfaces; `MutableList`/`MutableMap`/`MutableSet` add mutating methods — a real, useful API-design distinction.
- A read-only-typed reference to a mutable underlying object still reflects mutations made through another (mutable-typed) reference to the same object — verified live; read-only is not the same as immutable.
- `map`/`filter`/`reduce`/`fold` and destructuring work across lists, maps, and data classes.

## Key Terms

- **Read-only view** — a reference typed with an interface (`List<T>`) exposing no mutating methods, but not necessarily backed by a genuinely immutable object.
- **`to` infix function** — builds a `Pair`, used to construct `Map` entries concisely (`"key" to "value"`).

## Interview Questions

1. **Does `listOf()` in Kotlin guarantee the resulting list can never change?**
   No — verified directly in this lesson: `listOf()`'s result is typed as the read-only `List<T>` interface, which exposes no mutating methods, but if the same underlying object is also referenced through a `MutableList<T>` variable elsewhere, mutations made through that mutable reference are visible through the read-only one too. True immutability would require either never sharing a mutable reference to the same object, or using a genuinely immutable/persistent collection implementation — Kotlin's standard `listOf()` provides read-only *typing*, not deep immutability guarantees.

2. **What's the difference between `.sort()` and `.sorted()` on a Kotlin `MutableList`?**
   `.sort()` mutates the receiving list in place (rearranging its existing elements) and returns `Unit`; `.sorted()` returns a brand-new list containing the sorted elements, leaving the original list completely untouched. This mirrors the general Kotlin/functional-programming convention of preferring non-mutating operations (`.sorted()`, `.filter()`, `.map()`, all returning new collections) over in-place-mutating ones (`.sort()`), and mixing the two conventions up is a common source of "why did my original list change unexpectedly" (or the reverse) confusion.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
