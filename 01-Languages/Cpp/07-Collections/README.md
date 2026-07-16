# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use `std::vector`, `std::map`, and `std::set` — the STL's core containers.
- Use `<algorithm>` header functions (`std::sort`, `std::find`, `std::count_if`) for transformations, mirroring every other language course's `map`/`filter`/`reduce`.
- Understand `operator[]` performs no bounds checking, unlike `.at()`.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

The **STL** (Standard Template Library) provides C++'s core generic containers: `std::vector<T>` (a dynamic array, the everyday default), `std::map<K,V>` (an ordered key-value map, typically a red-black tree), and `std::set<T>` (an ordered collection of unique elements). The `<algorithm>` header provides generic, container-agnostic functions (`std::sort`, `std::find`, `std::count_if`, `std::accumulate` from `<numeric>`) that work via iterators across any compatible container.

## `std::vector`, `std::map`, `std::set`

```cpp
#include <vector>
#include <map>
#include <set>

std::vector<int> scores = {95, 88, 76};
scores.push_back(100);
std::cout << scores[0] << std::endl;     // NO bounds checking -- undefined behavior if out of range
std::cout << scores.at(0) << std::endl;   // bounds-checked -- throws std::out_of_range if invalid

std::map<std::string, int> ages = {{"Ada", 30}};
std::cout << ages["Ada"] << std::endl;
std::cout << ages.count("Unknown") << std::endl; // 0 -- safe existence check, no exception

std::set<std::string> uniqueTags = {"js", "css", "js"}; // duplicates removed automatically
```

## `<algorithm>` for Transformations

```cpp
#include <algorithm>
#include <numeric> // for std::accumulate

std::vector<int> numbers = {1, 2, 3, 4, 5};

std::sort(numbers.begin(), numbers.end(), std::greater<int>()); // sort descending, in place
int total = std::accumulate(numbers.begin(), numbers.end(), 0);   // like reduce, with a starting value
int evenCount = std::count_if(numbers.begin(), numbers.end(), [](int n) { return n % 2 == 0; }); // like filter().length
bool hasEven = std::any_of(numbers.begin(), numbers.end(), [](int n) { return n % 2 == 0; });
```

Unlike every other language course's `.filter()`/`.map()` (which return a new collection), many STL `<algorithm>` functions operate **in place** via iterator ranges (`std::sort` mutates its range directly) — a genuinely different, more C-like style than the fluent, chainable methods of the JavaScript/C#/Java courses.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints vector/map/set usage (including the `operator[]`-vs-`.at()` bounds-checking contrast) and `<algorithm>` functions used for sorting, counting, and existence checks.

## Common Mistakes

- Using `vec[i]` for an out-of-range `i` — silently undefined behavior (often a crash, but not guaranteed), unlike `.at(i)`, which throws a catchable `std::out_of_range`.
- Forgetting `std::sort` (and many other `<algorithm>` functions) mutate their range in place, unlike the copy-returning `.map()`/`.filter()` idiom from other language courses.

## Best Practices

- Use `.at()` instead of `operator[]` whenever an out-of-range index is a plausible, recoverable scenario you want to catch rather than crash on.
- Use `<algorithm>` functions over hand-written loops for standard operations (sorting, searching, counting) — they're well-tested and often more efficient than a naive manual implementation.

## Real-World Usage

`std::vector` is the default container for the overwhelming majority of real C++ code needing a dynamic array; `<algorithm>` functions combined with lambdas (Lesson 12) are the idiomatic modern C++ way to express filter/transform/reduce-style logic.

## Summary

- `std::vector`/`std::map`/`std::set` are the STL's core generic containers.
- `operator[]` performs no bounds checking (undefined behavior if out of range); `.at()` is the bounds-checked, exception-throwing alternative.
- `<algorithm>` functions operate on iterator ranges, often mutating in place, unlike the copy-returning methods of most other language courses.

## Key Terms

- **STL (Standard Template Library)** — C++'s standard library of generic containers, iterators, and algorithms.
- **Iterator** — an object generalizing a pointer, used by `<algorithm>` functions to traverse any compatible container.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `operator[]` and `.at()` on a `std::vector`?**
   `operator[]` performs no bounds checking at all — accessing an out-of-range index is undefined behavior, which might crash, silently corrupt memory, or appear to work depending on circumstances. `.at()` performs bounds checking and throws a catchable `std::out_of_range` exception for an invalid index, at a small performance cost from the check itself.

2. **How do `<algorithm>` functions like `std::sort` typically differ from `.map()`/`.filter()` in JavaScript/C#/Java?**
   Many `<algorithm>` functions operate directly on an iterator range and mutate it in place (`std::sort` reorders the actual elements of the range you pass it) rather than returning a new collection, which is the default behavior of `.map()`/`.filter()` in most other language courses in this repository. This reflects C++'s general preference for explicit control over allocation and copying.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
