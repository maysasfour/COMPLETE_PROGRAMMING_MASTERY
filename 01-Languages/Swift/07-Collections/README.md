# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift's genuinely important, distinctive design choice: `Array`/`Dictionary`/`Set` are **value types**, not reference types — assignment and function parameters copy them logically, unlike every JVM/reference-type-collection language covered in this repository (Kotlin, Java).
- Contrast this directly with Kotlin's Lesson 07 finding (a read-only-typed reference to a mutable collection can still be affected by external mutation) — in Swift, this specific aliasing problem cannot happen with `Array`/`Dictionary`/`Set` at all.
- Use `map`/`filter`/`reduce`, and distinguish mutating (`sort()`) from non-mutating (`sorted()`) collection operations.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

This is one of the most important, genuine contrasts between Swift and every other language covered in this repository so far: Swift's `Array`, `Dictionary`, and `Set` are **value types** (structs internally, using copy-on-write for performance), not reference types. Assigning an array to another variable, or passing it to a function, creates a logically independent copy — mutating one never affects the other. This directly resolves the exact aliasing gotcha demonstrated in this repository's Kotlin course (Lesson 07 there), where a read-only-*typed* reference to a `MutableList` still reflected mutations made through a separate mutable reference to the *same underlying object* — in Swift, `Array` has no equivalent shared-reference-aliasing risk at all, because assignment and parameter-passing are logical copies by design.

## Value-Type Semantics: Assignment Copies, Doesn't Alias

```swift
var original = [1, 2, 3]
var copy = original // a LOGICAL copy, not a reference to the same array
copy.append(4)
print(original) // [1, 2, 3] -- UNCHANGED
print(copy)        // [1, 2, 3, 4]
```

Contrast this directly with the equivalent Kotlin code (Lesson 07 of that course), where a `List`-typed reference to the *same* `MutableList` object genuinely reflected an external mutation — that specific class of bug is structurally impossible with Swift's value-type `Array`, since there is no shared underlying object to alias in the first place (copy-on-write means an actual memory copy only happens lazily, on the first mutation after a logical copy — but from the *programmer's* perspective, it always behaves as an independent copy).

## Passing an Array to a Function: Still Copy Semantics

```swift
func appendSilently(_ arr: [Int]) -> [Int] {
    var localCopy = arr
    localCopy.append(99)
    return localCopy // the CALLER's array is never affected
}
let callerArray = [1, 2, 3]
let result = appendSilently(callerArray)
// callerArray is unchanged; only `result` has the appended value
```

## Dictionaries and Sets

```swift
let map: [String: Any] = ["name": "Ada", "age": 30]
map["missing"] // nil -- subscript returns an Optional, no exception for a missing key

var uniqueNumbers: Set<Int> = [1, 2, 2, 3, 3, 3]
uniqueNumbers.sorted() // [1, 2, 3] -- duplicates removed automatically
```

## `map`/`filter`/`reduce`, and Mutating vs. Non-Mutating Operations

```swift
nums.map { $0 * 2 }
nums.filter { $0 % 2 == 0 }
nums.reduce(0, +)

var unsorted = [3, 1, 4, 1, 5]
let sortedCopy = unsorted.sorted() // NEW array, unsorted untouched
unsorted.sort()                      // mutates IN PLACE
```

## Detailed Example

See [Example.swift](Example.swift) — the core value-type-semantics demonstration (assignment doesn't alias), a function-parameter-copy demonstration, dictionaries, sets, `map`/`filter`/`reduce`, and `sorted()`/`sort()`.

## Practice

- [Exercises/Exercise.swift](Exercises/Exercise.swift) — filter/map/reduce over an array of `Product` structs.
- [Solutions/Solution.swift](Solutions/Solution.swift) — a worked solution (documented expected output included, not verified by execution).

## Run It

```bash
swiftc Example.swift -o example && ./example
swiftc Solutions/Solution.swift -o solution && ./solution
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

`Example.swift` should print `original: [1, 2, 3]` and `copy: [1, 2, 3, 4]` (confirming no aliasing), the dictionary lookups (`Ada` and `not found`), `set: [1, 2, 3]`, the `map`/`filter`/`reduce` results, both a sorted copy and an in-place-sorted version of the starting array, and confirmation that `callerArray` remains `[1, 2, 3]` after being passed to `appendSilently`. `Solutions/Solution.swift` should print `total: 24.98` and `names: ["Widget", "Gizmo"]`.

## Common Mistakes

- Assuming Swift arrays alias the way Kotlin/Java collections do — they don't; assignment and function parameters are logical copies by design, a genuinely different (and, for this specific risk, safer) semantics than every JVM-based language covered in this repository.
- Assuming copy-on-write means every assignment triggers an expensive, immediate memory copy — it doesn't; the copy only actually happens (lazily) the moment either the original or the copy is mutated, making value-type semantics performant in the common case where no mutation occurs.
- Confusing `sort()` (mutates in place) with `sorted()` (returns a new array) — the same distinction as Kotlin's `.sort()`/`.sorted()`, covered in this repository's Kotlin course.

## Best Practices

- Rely on Swift's value-type collection semantics for safety — passing an array to a function or storing it in multiple places doesn't risk the aliasing bugs possible in reference-type-collection languages.
- Use `var` for a collection that will be mutated locally, `let` for one that won't — since `Array`/`Dictionary`/`Set` are structs, a `let`-declared collection is genuinely, fully immutable (no mutating methods can be called on it at all), a stronger guarantee than a reference-type language's "the reference doesn't change" immutability.

## Real-World Usage

Swift's value-type collections are a foundational part of its overall memory-safety design (alongside ARC, covered in Lesson 12, and structs-as-the-default, covered in Lesson 11) — real Swift/iOS code relies heavily on this behavior for predictable state management, especially in SwiftUI, where value-type data flow is central to the framework's entire reactive update model.

## Summary

- Swift's `Array`/`Dictionary`/`Set` are value types (copy-on-write structs), not reference types — assignment and function parameters create logical copies, genuinely eliminating the aliasing risk demonstrated in this repository's Kotlin course.
- `sort()` mutates in place; `sorted()` returns a new array — matching Kotlin's identical distinction.
- Dictionary/Set subscript access returns an `Optional`, with no exception for a missing key.

## Key Terms

- **Value type** — a type (like Swift's `Array`/`Dictionary`/`Set`/`struct`) copied on assignment or parameter passing, rather than shared by reference.
- **Copy-on-write** — an optimization where a logical copy defers the actual memory copy until the first mutation, making value semantics performant.

## Interview Questions

1. **How does Swift's `Array` avoid the exact aliasing bug demonstrated in this repository's Kotlin course, where a read-only-typed collection reference still reflected an external mutation?**
   Because Swift's `Array` (like `Dictionary` and `Set`) is a genuine value type — assigning it to another variable, or passing it to a function, creates a logically independent copy, not a second reference to the same underlying object. In Kotlin, a `List`-typed variable can still point to the exact same underlying object as a separately-held `MutableList` reference, so mutating through the mutable reference is visible through the read-only one too (verified in this repository's Kotlin course). In Swift, there's no equivalent shared-object risk at all for `Array`/`Dictionary`/`Set` — mutating a copy structurally cannot affect the original, by design, regardless of how the copy was typed or obtained.

2. **What is copy-on-write, and why does it matter for Swift's value-type collections' performance?**
   Copy-on-write is an optimization where assigning or passing a value-type collection doesn't immediately perform an expensive full memory copy — instead, both the original and the "copy" initially share the same underlying storage, and an actual, real memory copy only happens lazily, at the moment either one is mutated. This lets Swift provide true value semantics (logical independence, as demonstrated in this lesson) without paying the performance cost of copying a potentially large collection on every assignment or function call — the cost is only paid if and when a mutation actually occurs, keeping the common case (read-only sharing) cheap.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
