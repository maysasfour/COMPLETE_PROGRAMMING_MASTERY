# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Explain C++'s default value semantics — unlike Java/C#/Python/JavaScript, **everything** copies by value by default, including objects.
- Distinguish references (`T&`) from pointers (`T*`).
- Use `auto` for type inference and `const` for immutability.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

This is the single biggest conceptual shift coming from every other language course in this repository: in C++, **objects (not just primitives) have value semantics by default** — assigning one object to another, or passing one by value to a function, copies the entire object, not a reference to it. Java/C#/Python/JavaScript's "everything except primitives is a reference" model has no equivalent here; you must explicitly opt into reference-like behavior using references (`T&`) or pointers (`T*`).

## Value Semantics by Default

```cpp
#include <vector>

std::vector<int> a = {1, 2, 3};
std::vector<int> b = a; // COPIES the entire vector -- b is now an independent copy
b.push_back(4);
// a is UNCHANGED: still {1, 2, 3} -- unlike every other language course's collections
```

This is fundamentally different from every prior language course, where `var b = a;` for a list/array would make `b` an alias for the same underlying object.

## References vs. Pointers

```cpp
int x = 5;
int& ref = x;   // reference: an alias for x, must be initialized, cannot be reseated or null
ref = 10;        // this changes x itself
std::cout << x;  // 10

int* ptr = &x;   // pointer: holds x's address, CAN be null, CAN be reassigned
*ptr = 20;        // dereference to modify the pointed-to value
std::cout << x;   // 20
ptr = nullptr;     // pointers can be reassigned, including to null
```

A reference must be bound at declaration and forever refers to that same variable — there is no way to "reseat" it afterward, and it can never be null. A pointer is far more flexible (reassignable, nullable) but requires explicit `&` (address-of) to create and `*` (dereference) to use, and using an uninitialized or null pointer is undefined behavior, not a caught exception.

## `auto` and `const`

```cpp
auto count = 42;           // inferred as int -- still fully static
auto name = std::string("Ada"); // inferred as std::string

const int maxRetries = 3;   // cannot be reassigned
const int& constRef = x;     // a reference through which x cannot be modified (x itself still can be, elsewhere)
```

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints a demonstration that copying a `std::vector` produces an independent copy (unlike every other language course), a reference modifying its target, a pointer's dereference and reassignment, and `auto`/`const` usage.

## Common Mistakes

- Assuming `std::vector<int> b = a;` aliases `a`, expecting mutations through `b` to be visible via `a` — this is the single most disorienting habit to unlearn coming from any other language in this repository.
- Confusing `T&` (reference) with `T*` (pointer) — a reference needs no dereference operator and can't be null; a pointer needs `*` to access its value and can be null or reassigned.
- Dereferencing a null or uninitialized pointer — undefined behavior (often a crash, but not guaranteed to be caught the way `NullPointerException`/`NullReferenceException` are in managed languages).

## Best Practices

- Prefer references over pointers wherever null isn't a meaningful state and reseating isn't needed — references are safer by construction.
- Prefer passing large objects by `const&` (const reference) to avoid an unnecessary copy while still preventing the callee from mutating the caller's object.
- Use `auto` for obviously-typed variables to reduce verbosity, especially with long template type names (Lesson 13).

## Real-World Usage

Understanding value-vs-reference semantics is the single most important prerequisite for reasoning about C++ performance and correctness — an accidentally-copied large object in a hot loop (instead of a `const&` parameter) is one of the most common real-world C++ performance bugs.

## Summary

- C++ objects copy by value by default — assigning or passing a `std::vector`/`std::string`/custom object copies it entirely, unlike every other language course in this repository.
- References (`T&`) are non-null, non-reseatable aliases; pointers (`T*`) are nullable, reassignable addresses requiring explicit dereference.
- `auto` infers a fully static type; `const` prevents reassignment/mutation as declared.

## Key Terms

- **Value semantics** — assignment/pass-by-value copies the entire object, not a reference to it.
- **Reference (`T&`)** — a non-null, non-reseatable alias for an existing variable.
- **Pointer (`T*`)** — a nullable, reassignable variable holding a memory address, requiring explicit dereference (`*`).

## Review Questions

1. Why does `std::vector<int> b = a;` NOT behave like the equivalent assignment in Java/Python/JavaScript?
2. Why can't a reference be null, while a pointer can?
3. When would you prefer a `const&` parameter over a plain value parameter?

## Interview Questions

1. **How does C++'s default object copy behavior differ from Java/C#/Python/JavaScript?**
   In C++, assigning or passing an object (like `std::vector`, `std::string`, or a custom class) by value copies the entire object — the original and the copy are completely independent afterward. In Java/C#/Python/JavaScript, the equivalent operation on a non-primitive typically copies only a reference, leaving both variables pointing to the same underlying object. This is the single most consequential mental-model difference for someone coming from those languages.

2. **What's the difference between a reference and a pointer in C++?**
   A reference (`T&`) must be bound to a variable at declaration, can never be null, and can never be reseated to refer to something else afterward — it behaves exactly like the underlying variable with no special access syntax. A pointer (`T*`) holds a memory address, can be null, can be reassigned to point elsewhere at any time, and requires explicit `*` to dereference and `&` to obtain an address in the first place.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
