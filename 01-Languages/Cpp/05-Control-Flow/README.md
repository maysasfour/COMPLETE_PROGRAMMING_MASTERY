# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else`, `switch`, and loops.
- Use range-based `for` (C++11+) over collections.
- Use structured bindings (C++17+) to unpack pair/tuple-like values.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Control flow is C-family familiar. Range-based `for` (C++11+) is C++'s equivalent of JavaScript's `for...of`/Python's `for x in`, iterating elements directly without manual indexing. Structured bindings (C++17+) let you unpack a `pair`/`tuple`/struct into named variables in one line.

## `if`/`else` and `switch`

```cpp
int temperature = 20;
if (temperature > 30) {
    std::cout << "hot" << std::endl;
} else if (temperature > 15) {
    std::cout << "warm" << std::endl;
} else {
    std::cout << "cool" << std::endl;
}

switch (temperature) {
    case 30:
        std::cout << "exactly 30" << std::endl;
        break;
    default:
        std::cout << "not exactly 30" << std::endl;
        break;
}
```

`switch` in C++ falls through by default (like C/JavaScript) — `break` is required to prevent it, unlike Java's/C#'s newer switch-expression alternatives.

## Range-Based `for`

```cpp
std::vector<int> numbers = {1, 2, 3};
for (int n : numbers) {          // copies each element
    std::cout << n << " ";
}
for (const auto& n : numbers) {  // reference -- avoids copying, read-only
    std::cout << n << " ";
}
```

Using `const auto&` (a const reference) in a range-based `for` avoids copying each element — important for anything larger than a primitive, directly connecting back to Lesson 03's value-semantics point.

## Structured Bindings (C++17+)

```cpp
std::pair<int, std::string> entry = {1, "Ada"};
auto [id, name] = entry; // unpacks into two named variables in one line
std::cout << id << " " << name << std::endl;
```

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints `if`/`switch` results, a range-based `for` using `const auto&` to avoid copies, and a structured-binding unpack of a `std::pair`.

## Common Mistakes

- Forgetting `break` in a `switch`, causing fall-through (same C-family footgun as JavaScript).
- Using `for (auto n : numbers)` (copying) in a hot loop over large elements instead of `const auto&`, needlessly copying every element.

## Best Practices

- Prefer `const auto&` in range-based `for` loops unless you specifically need to mutate elements in place (in which case use `auto&`, a non-const reference) or genuinely need an independent copy.
- Use structured bindings to unpack `pair`/`tuple`/struct-like return values instead of `.first`/`.second` or manual field access.

## Real-World Usage

Range-based `for` with `const auto&` is the default idiom for iterating any STL container without unnecessary copies; structured bindings are commonly used to unpack `std::map` iteration (`for (const auto& [key, value] : myMap)`).

## Summary

- `switch` falls through by default in C++, requiring explicit `break`.
- Range-based `for` iterates elements directly; `const auto&` avoids unnecessary copies of non-trivial elements.
- Structured bindings (C++17+) unpack `pair`/`tuple`/struct values into named variables in one line.

## Key Terms

- **Range-based `for`** — a `for` loop form (C++11+) iterating elements of a container directly.
- **Structured binding** — unpacking a `pair`/`tuple`/struct into multiple named variables in one declaration (C++17+).

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Why is `for (const auto& x : container)` generally preferred over `for (auto x : container)`?**
   `auto x` copies each element as the loop iterates, which is wasteful for anything beyond a cheap-to-copy primitive. `const auto& x` binds a read-only reference to each element instead, avoiding the copy entirely — the default choice unless the loop body specifically needs to mutate elements (use `auto&` then) or genuinely needs an independent copy.

2. **What is a structured binding, and what problem does it solve?**
   A C++17+ feature letting you unpack a `pair`/`tuple`/aggregate struct's members into separate named variables in one declaration (`auto [a, b] = someStdPair;`), replacing the more verbose and less readable `.first`/`.second` (or `std::get<0>`/`std::get<1>`) member access.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
