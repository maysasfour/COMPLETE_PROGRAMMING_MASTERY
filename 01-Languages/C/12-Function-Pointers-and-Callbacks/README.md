# 12 — Function Pointers and Callbacks

[Back to course overview](../README.md) | [Previous: Structs and Unions](../11-Structs-and-Unions/README.md)

## Learning Objectives

- Use the standard library's `qsort` with a custom comparator function pointer.
- Build a generic callback ("for each") pattern — C's substitute for higher-order functions, since C has no lambdas/closures.

## Prerequisites

[11-Structs-and-Unions](../11-Structs-and-Unions/README.md)

## Concept

Lesson 06 introduced function pointers as first-class values; this lesson uses them for real, through the standard library's `qsort` — a genuinely generic sort function, made generic entirely through `void*` type erasure plus an explicit `sizeof` for element size (Lesson 13 explores this `void*`-based pattern as C's actual substitute for real generics). `qsort`'s comparator contract is a real, memorizable convention: return negative if the first argument sorts before the second, zero if equal, positive otherwise. Since C has no lambda/closure syntax at all, every callback must be a separately-defined, named function — there is no way to write an inline anonymous function the way C++11's lambdas or Python's `lambda` allow.

## Syntax

```c
int compareInts(const void* a, const void* b) {
    int ia = *(const int*)a;    /* qsort passes each element as const void* --
    int ib = *(const int*)b;       must cast back to the real type manually */
    return (ia > ib) - (ia < ib);
}

qsort(numbers, count, sizeof(int), compareInts);   /* array, count, element size, comparator */

void forEachInt(const int* array, size_t count, void (*action)(int)) {
    for (size_t i = 0; i < count; i++) action(array[i]);
}
forEachInt(numbers, count, printDoubled);            /* callback pattern -- no lambdas exist */
```

## Detailed Example

See [example.c](example.c) — `qsort` with an ascending comparator, then a descending one built by simply swapping argument order in a reused comparator, plus a generic `forEachInt` callback applying a named function to every array element.

## Expected Output

```
original: 5 2 8 1 9 3 
ascending: 1 2 3 5 8 9 
descending: 9 8 5 3 2 1 

doubled via callback: 18 16 10 6 4 2
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, after fixing one bug found while writing this lesson (see below).

## A Bug Found and Fixed While Writing This Lesson

The same category of mistake as Lesson 11: a comment reading `-- fully generic via void*/sizeof,` contained a literal `*/` in its own explanatory text (`void*` immediately followed by `/sizeof`), which closed the block comment three words early and produced a cascade of confusing syntax errors (`C2059`, `C2001: newline in string literal`) on the following lines, since the parser then tried to parse the rest of the comment's prose as real code. Fixed by rewording to avoid the accidental `*/` sequence. Worth restating from Lesson 11: **any literal `*/` inside a C block comment's own text ends the comment immediately** — a surprisingly easy mistake to make when a comment is explaining pointer syntax (`void*`) right before punctuation that happens to include a `/`.

## Common Mistakes

- Getting the comparator's sign convention backwards — `qsort` expects negative/zero/positive for less-than/equal/greater-than; reversing this silently sorts in the wrong direction rather than erroring.
- Using `a - b` instead of `(a > b) - (a < b)` for integer comparators — subtraction can silently overflow for values near `INT_MIN`/`INT_MAX`, producing an incorrect sign; the compare-and-subtract-booleans idiom avoids this entirely.
- Forgetting to cast the `const void*` parameters back to the real element type before dereferencing — attempting to use them as `void*` directly (e.g., comparing pointers themselves rather than pointed-to values) silently compares the wrong thing.

## Best Practices

- Always use the `(a > b) - (a < b)` idiom (or explicit `if`/`else` chains) for numeric comparators, never bare subtraction, to avoid the overflow trap.
- Give comparator functions clear, direction-indicating names (`compareIntsAscending`/`compareIntsDescending`) rather than a single ambiguous `compare`.
- For any callback-heavy C code, consider `typedef`-ing the function pointer type (Lesson 06) to keep signatures readable across multiple call sites.

## Real-World Usage

`qsort` (and `bsearch`, its binary-search sibling, built on the same comparator-function-pointer contract) are genuinely used throughout real C codebases as the standard-library's only built-in generic sorting/searching mechanism — there is no template-based `std::sort` equivalent, so this pattern is unavoidable in idiomatic C.

## Summary

- `qsort` achieves generic sorting via `void*` type erasure plus an explicit element `sizeof` and a caller-supplied comparator function pointer.
- The comparator contract (negative/zero/positive for less/equal/greater) is a real, memorizable convention worth knowing cold.
- C has no lambdas/closures — every callback must be a separately-defined, named function.

## Key Terms

- **Comparator** — a function (or function pointer) implementing the negative/zero/positive less-than/equal/greater-than contract used by `qsort`/`bsearch`.
- **Callback** — a function passed by pointer to another function, to be invoked by that function later.

## Interview Questions

1. **What contract must a `qsort` comparator function satisfy, and why is `(a > b) - (a < b)` preferred over `a - b` for integers?**
   It must return a negative value if the first element sorts before the second, zero if they're equal, and a positive value if the first sorts after the second. `a - b` can silently overflow for values near the integer type's limits (e.g., `INT_MIN - 1` wraps around), producing an incorrect sign and a subtly wrong sort order; `(a > b) - (a < b)` avoids this entirely since it only ever produces `-1`, `0`, or `1` from two boolean comparisons.

2. **Why does C need a callback pattern like `forEachInt` at all, instead of writing an inline lambda the way C++ or Python could?**
   C has no lambda/closure syntax whatsoever — there is no way to define an anonymous, inline function value. Every callback must therefore be a separately-defined, named function whose address is passed as a function pointer, which is exactly what `qsort`'s comparator parameter and this lesson's `forEachInt` both require.

## Recommended Next Lesson

[13 — No Generics](../13-No-Generics/README.md)
