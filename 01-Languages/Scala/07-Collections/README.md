# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Understand that `scala.collection.immutable` is imported by default, making `List`/`Map`/`Set` immutable unless explicitly opting into `scala.collection.mutable`.
- Verify this live: prove that mutating operations on default collections return *new* collections rather than mutating in place.
- Contrast with Java, where `ArrayList`/`HashMap` are mutable by default and immutability requires explicit wrapping (`Collections.unmodifiableList`).

## Concept

Unlike Java, where `java.util.ArrayList`/`HashMap` are mutable by default and true immutability requires an explicit wrapper, Scala's default collection types (`List`, `Vector`, `Map`, `Set`) are **immutable by default** — `scala.collection.immutable._` is part of Scala's automatic default imports (`scala.Predef` plus the `scala`/`scala.Predef` package aliases), so writing `List(1,2,3)` with no explicit import already gets the immutable variant. Mutable collections exist (`scala.collection.mutable.ListBuffer`, etc.) but require an explicit import, inverting Java's default.

## Live Proof: Default Collections Are Immutable

```scala
val xs = List(1, 2, 3)
val ys = xs.appended(4) // returns a NEW list; xs is untouched
assert(xs == List(1, 2, 3)) // xs unchanged, verified live
assert(ys == List(1, 2, 3, 4))
```

## Core Immutable Collections

```scala
List(1, 2, 3)               // singly-linked list
Vector(1, 2, 3)              // indexed sequence, efficient random access
Map("a" -> 1, "b" -> 2)       // immutable map
Set(1, 2, 3)                  // immutable set
```

## Mutable Collections (Opt-In)

```scala
import scala.collection.mutable.ListBuffer
val buf = ListBuffer(1, 2, 3)
buf += 4 // buf IS mutated in place -- but only because mutable.ListBuffer was explicitly imported
```

## Detailed Example

See [Collections.scala](Collections.scala) — live proof of default immutability, core collection operations (`map`/`filter`/`fold`), and the explicit mutable opt-in contrast.

## Run It

```bash
cd 01-Languages/Scala/07-Collections
scalac Collections.scala
scala run . --main-class collectionsDemo
```

## Expected Output

```
xs=List(1, 2, 3), ys=List(1, 2, 3, 4)
xs unchanged after appended(): true
map: List(2, 4, 6)
filter: List(2)
foldLeft sum: 6
mutable ListBuffer after += : ListBuffer(1, 2, 3, 4)
```

## Common Mistakes

- Assuming `xs.appended(4)` (or `xs :+ 4`) mutates `xs` in place, out of Java-collections habit — it returns a brand-new collection, leaving `xs` untouched, verified live in this lesson.
- Reaching for `scala.collection.mutable` collections by default out of Java habit, when an immutable collection plus `.map`/`.filter`/`.fold` would express the same logic more safely.
- Confusing `List` (linked list, O(1) prepend, O(n) random access) with `Vector` (indexed, near-O(1) random access) and picking the wrong one for access-pattern-heavy code.

## Best Practices

- Default to immutable collections; import `scala.collection.mutable` explicitly and locally when genuinely needed (e.g., performance-critical tight loops).
- Prefer `Vector` over `List` when random access matters; prefer `List` for simple sequential/recursive processing.

## Real-World Usage

Immutable-by-default collections are foundational to Scala's safety story in concurrent code (Akka actors, Spark's RDD/DataFrame transformations) — sharing an immutable collection across threads has zero risk of a data race from concurrent mutation.

## Exercises / Solutions

See [Exercises/](Exercises/) and [Solutions/](Solutions/).

## Summary

- `scala.collection.immutable` types are the default; live-verified that "mutating" operations return new collections, leaving the original untouched.
- `scala.collection.mutable` requires an explicit import — the inverse of Java's default.
- `List` (linked) and `Vector` (indexed) serve different access-pattern needs.

## Key Terms

- **Persistent collection** — an immutable collection implemented so that derived versions share structure with the original for efficiency, rather than deep-copying.
- **`ListBuffer`** — a mutable, explicitly-opted-into builder collection, useful for efficient in-place accumulation before converting to an immutable `List`.

## Interview Questions

1. **Are Scala collections mutable or immutable by default, and how does this differ from Java?** — Immutable by default: `List`, `Map`, `Set`, and `Vector` resolve to `scala.collection.immutable` variants automatically, without any import, because that package is part of Scala's default imports. This inverts Java's default, where `ArrayList`/`HashMap` are mutable and true immutability requires wrapping via `Collections.unmodifiableList` or similar. This lesson verified it live: appending to a `List` returns a new list, leaving the original provably unchanged.
2. **When would you choose `Vector` over `List` in Scala?** — `Vector` gives near-constant-time random access and update, while `List` (a singly-linked list) is efficient for sequential head/tail processing and O(1) prepend but O(n) random access. Choose `Vector` when indexed access patterns dominate; choose `List` for simple recursive/sequential algorithms.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
