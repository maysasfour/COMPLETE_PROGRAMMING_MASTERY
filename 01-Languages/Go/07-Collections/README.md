# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Distinguish arrays (fixed-size, rarely used directly) from slices (Go's everyday dynamic-array type).
- Use maps for key-value storage, including the "comma ok" idiom for safe lookups.
- Understand a slice is a "view" over an underlying array, with real aliasing implications.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

Go arrays have a **fixed size baked into their type** (`[3]int` and `[4]int` are different, incompatible types) and are rarely used directly. **Slices** (`[]int`, no size in the type) are Go's everyday dynamic-array type — a slice is a lightweight "view" (a pointer, length, and capacity) over an underlying array, which has real, sometimes-surprising aliasing implications distinct from every other language's collection semantics covered in this repository.

## Arrays vs. Slices

```go
var arr [3]int = [3]int{1, 2, 3} // fixed size, part of the type itself
slice := []int{1, 2, 3}            // slice: dynamic, no size in the type
slice = append(slice, 4)            // append() can grow a slice, returning a (possibly new) slice
```

`append()` returns a slice — you must reassign it (`slice = append(slice, 4)`) since appending can require allocating a new, larger underlying array if the current one lacks capacity, in which case the original slice variable would otherwise still point to the old array.

## Slice Aliasing (A Genuine Gotcha)

```go
original := []int{1, 2, 3, 4, 5}
view := original[1:3] // a slice of original -- SHARES the same underlying array
view[0] = 999           // this mutates original too!
fmt.Println(original)   // [1 999 3 4 5] -- original was changed through view
```

Slicing an existing slice (`original[1:3]`) does **not** copy the data — the new slice shares the same underlying array, so mutating elements through one slice is visible through the other, similar in spirit to a reference but specific to Go's slice mechanics (not a general "everything is a reference" model).

## Maps and the "Comma Ok" Idiom

```go
ages := map[string]int{"Ada": 30}
value, ok := ages["Ada"]      // ok is true if the key exists
value2, ok2 := ages["Unknown"] // ok2 is false; value2 is the zero value (0), NOT an error
```

The "comma ok" idiom (`value, ok := m[key]`) is Go's standard safe-lookup pattern — a missing key returns the zero value plus `ok = false`, never a panic, letting you distinguish "key present with a zero value" from "key genuinely absent."

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints array vs. slice usage, a concrete demonstration of slice aliasing (mutating through one view visibly changes the original), and map usage including the comma-ok idiom.

## Common Mistakes

- Forgetting `append()`'s return value must be reassigned — `append(slice, x)` alone (discarding the result) does nothing useful and may silently not reflect the appended element in the original variable.
- Assuming a sub-slice (`original[1:3]`) is an independent copy — it shares the underlying array; mutating it can surprise you by also changing the original.
- Accessing a map key directly (`ages["Unknown"]`) without checking `ok`, and being unable to distinguish "the value happens to be the zero value" from "the key doesn't exist."

## Best Practices

- Always reassign `append()`'s result: `slice = append(slice, item)`.
- Use `copy()` (or `append([]T{}, source...)`) explicitly when you need an independent copy of a slice, rather than assuming a sub-slice is one.
- Use the comma-ok idiom for map lookups whenever a missing key is a meaningful, distinct case from a zero-valued present key.

## Real-World Usage

Slice aliasing is a well-known Go gotcha specifically relevant when passing sub-slices between functions — a function that mutates a slice it was passed a sub-slice of can silently affect the caller's original data, a behavior worth understanding deeply before working with large data pipelines in Go.

## Summary

- Arrays have a fixed size in their type and are rarely used directly; slices are Go's everyday dynamic-array type.
- A slice is a view over an underlying array — sub-slicing shares data, not copies it, with real aliasing implications.
- The comma-ok idiom (`value, ok := m[key]`) is Go's standard safe map-lookup pattern.

## Key Terms

- **Slice** — a dynamically-sized view (pointer + length + capacity) over an underlying array, Go's everyday collection type.
- **Comma ok idiom** — `value, ok := m[key]`, Go's pattern for distinguishing a present-but-zero-valued key from a genuinely missing one.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between a Go array and a Go slice?**
   An array's size is part of its type (`[3]int` and `[4]int` are distinct, incompatible types) and is fixed at declaration. A slice (`[]int`) has no size in its type — it's a dynamically-sized view (a pointer, length, and capacity) over an underlying array, and is what Go code uses for dynamic collections in virtually all everyday cases; plain arrays are rarely used directly.

2. **Why must you reassign the result of `append()`?**
   `append()` may need to allocate a new, larger underlying array if the existing one lacks capacity for the additional element(s) — in that case, it returns a slice pointing to the new array, and the original slice variable (if not reassigned) would still point to the old, un-appended array. Always writing `slice = append(slice, item)` ensures you get the correct, possibly-reallocated slice regardless of whether reallocation actually happened.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
