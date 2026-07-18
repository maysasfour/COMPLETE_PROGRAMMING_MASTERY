# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use fixed-size C arrays and understand their **complete lack of bounds checking**.
- Understand C has **no built-in dynamic/growable array** — unlike C++'s `std::vector`, one must be hand-rolled with `malloc`/`realloc`.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

A C array's size is fixed at compile time and baked into its type — `int scores[5]` genuinely cannot grow to hold 6 elements; there is no method to call, no reallocation happening automatically. There is also **zero bounds checking**: `scores[10]` on a 5-element array compiles and runs, silently reading (or, on a write, corrupting) whatever memory happens to sit past the array — this is undefined behavior, not a caught error, a stark contrast with C++'s `std::vector::at()` (throws) or even Java/C#/Python's mandatory bounds-checked indexing. Most significantly: **C has no built-in dynamic array type at all**. C++'s `std::vector<T>` — growable, size-tracking, automatically reallocating — has no C equivalent in the standard library whatsoever; real C code hand-rolls this pattern with `malloc`/`realloc`, manually tracking `count` and `capacity` as separate variables.

## Syntax

```c
int scores[5] = {90, 85, 77, 92, 88};       /* fixed size, part of the type */
size_t n = sizeof(scores) / sizeof(scores[0]);  /* the idiomatic "how many elements" */

/* Hand-rolled growable array -- no std::vector equivalent exists: */
size_t capacity = 2, count = 0;
int* arr = malloc(capacity * sizeof(int));
if (count == capacity) {
    capacity *= 2;
    int* grown = realloc(arr, capacity * sizeof(int));
    /* always check grown != NULL before reassigning arr, or a failed
       realloc leaks the original block */
    arr = grown;
}
arr[count++] = value;
free(arr);           /* manual -- no destructor does this automatically */
```

## Detailed Example

See [example.c](example.c) — a fixed-size array with `sizeof`-based element counting, plus a hand-rolled dynamic array that grows its capacity via `realloc` as elements are added, printing each growth step.

## Expected Output

```
Fixed-size array (size baked into the type, no growth possible):
scores[0] = 90
scores[1] = 85
scores[2] = 77
scores[3] = 92
scores[4] = 88
sizeof(scores) = 20 bytes, element count = 5

Hand-rolled dynamic array (malloc/realloc, no built-in vector):
  (grew capacity to 4)
  (grew capacity to 8)
dynArr contents (count=6, capacity=8): 1 4 9 16 25 36
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings.

## Contrast With C++'s `std::vector`

| | C array | C `malloc`/`realloc` pattern | C++ `std::vector<T>` |
|---|---|---|---|
| Growable | No | Manual (`realloc`, doubling capacity by hand) | Yes, automatic |
| Bounds checking | None | None | None on `[]`; `.at()` throws |
| Size tracking | `sizeof`-based, manual | Manual `count` variable | `.size()` built in |
| Cleanup | Automatic if stack-allocated | Manual `free()` | Automatic (RAII destructor) |

## Common Mistakes

- **Out-of-bounds access silently "succeeding"** — `scores[10]` on a 5-element array is undefined behavior: it might crash, might silently read garbage, might corrupt an adjacent variable — there is no guarantee of any particular (mis)behavior, which is exactly what makes it dangerous. This lesson does not reproduce this live (unlike Lesson 08's controlled buffer-overflow demonstration) because true out-of-bounds UB has no safe, reliable way to show "what happens" — that unpredictability is the entire point.
- Forgetting `realloc` can return `NULL` on failure **without freeing the original block** — always assign its result to a *temporary* pointer first and check for `NULL` before overwriting your real pointer, exactly as `example.c` does, or a failed reallocation leaks the original allocation.
- Forgetting `free()` on a hand-rolled dynamic array — there is no destructor to do this automatically; every `malloc`/`realloc` must be paired with exactly one `free()` (Lesson 19 covers this discipline in depth).

## Best Practices

- Always validate array indices in your own code before use — the language will not do it for you.
- Always check `realloc`'s return value against `NULL` before reassigning your working pointer.
- Set a pointer to `NULL` immediately after `free()`-ing it, to turn an accidental subsequent use into a clean, detectable null-pointer access rather than a silent use-after-free.

## Real-World Usage

Real C codebases either hand-roll a growable array exactly like `example.c`'s pattern (often wrapped in a small reusable "dynamic array" utility header) or depend on a third-party library (like GLib's `GArray`, or `stb_ds.h`) that does the same `malloc`/`realloc` bookkeeping once, reused everywhere.

## Exercises

See [Exercises/](Exercises/README.md); solutions in [Solutions/](Solutions/README.md).

## Summary

- C arrays are fixed-size, with zero bounds checking — genuinely undefined behavior on out-of-bounds access, not a caught error.
- C has **no built-in dynamic array** — `std::vector`'s growable behavior must be hand-rolled with `malloc`/`realloc`, manually tracking `count`/`capacity`.
- Every `malloc`/`realloc` must be paired with a `free()` — there is no RAII/destructor safety net.

## Key Terms

- **Fixed-size array** — an array whose element count is part of its type, fixed at compile time.
- **`realloc`** — resizes a previously `malloc`'d block, possibly moving it; must always be checked for `NULL` before reassigning the original pointer.

## Interview Questions

1. **Does C provide bounds checking on array access, and what happens on an out-of-bounds access like `arr[10]` on a 5-element array?**
   No — C performs zero bounds checking on `[]` indexing. Accessing `arr[10]` on a 5-element array is undefined behavior: it may read garbage memory, corrupt an unrelated variable, or crash, with no guaranteed outcome and no runtime error thrown, unlike C++'s `std::vector::at()` or virtually every managed language's default indexing.

2. **Does C have a built-in growable array type like C++'s `std::vector`? If not, how do real C programs implement one?**
   No — the C standard library has no growable/dynamic array type at all. Real C code hand-rolls this pattern: allocate an initial block with `malloc`, track `count` (elements used) and `capacity` (elements allocated) as separate variables, and when `count` reaches `capacity`, call `realloc` to grow the block (commonly doubling capacity), always checking `realloc`'s return value for `NULL` before overwriting the working pointer, to avoid leaking the original block on a failed reallocation.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
