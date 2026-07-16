# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write function templates and class templates.
- Understand templates are resolved entirely at **compile time**, generating a separate specialized version per concrete type used.
- Contrast C++ templates with Java's erasure and C#'s reification — three genuinely different generics implementations across this repository's courses.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

C++ templates are C++'s generics, but conceptually closer to a compile-time code generator than to Java/C#'s runtime type parameters: the compiler generates a completely separate, fully-specialized function/class for **every distinct type** a template is instantiated with — `Stack<int>` and `Stack<std::string>` become two entirely independent compiled types with no shared runtime representation at all. This is a third, genuinely distinct approach compared to Java's full erasure (one shared implementation, no runtime type info) and C#'s reification (shared implementation for reference types, specialized for value types, with runtime type info preserved either way).

## Function Templates

```cpp
template <typename T>
T first(const std::vector<T>& items) {
    return items[0];
}

std::cout << first(std::vector<int>{1, 2, 3}) << std::endl;       // T deduced as int
std::cout << first(std::vector<std::string>{"a", "b"}) << std::endl; // T deduced as std::string
```

## Class Templates

```cpp
template <typename T>
class Stack {
    std::vector<T> items;
public:
    void push(const T& item) { items.push_back(item); }
    T pop() {
        T item = items.back();
        items.pop_back();
        return item;
    }
    size_t size() const { return items.size(); }
};

Stack<int> numberStack;
numberStack.push(1);
numberStack.push(2);
```

## Constraining Templates: `concepts` (C++20) vs. Older SFINAE

```cpp
#include <concepts>

template <typename T>
requires std::totally_ordered<T> // C++20 concept: T must support <, >, ==, etc.
T max(const T& a, const T& b) {
    return (a > b) ? a : b;
}
```

C++20's `concepts` provide a much clearer, better-error-message way to constrain a template parameter than older techniques (SFINAE, `std::enable_if`) — directly analogous in *purpose* to Java's `<T extends Comparable<T>>` and C#'s `where T : IComparable<T>`, though C++ compiles a fully separate implementation per concrete type rather than checking against one shared, erased/reified implementation.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints a function template correctly deducing `int` and `std::string`, a class template `Stack<T>` used with two concrete types, and a concept-constrained `max` template.

## Common Mistakes

- Assuming C++ templates behave like Java's erased generics or C#'s reified ones — templates generate genuinely separate compiled code per type, with real compile-time cost (longer builds, larger binaries with many instantiations) that neither Java nor C# incurs the same way.
- Getting confusing, deeply-nested template error messages from unconstrained templates — a large part of why C++20 `concepts` were added, to produce clearer errors at the point of misuse rather than deep inside a template's implementation.

## Best Practices

- Use `concepts` (C++20+) to constrain template parameters where the compiler version supports it — dramatically better error messages than unconstrained templates or older SFINAE techniques.
- Keep template implementations in header files (Lesson 15 will explain why) since the compiler needs the full template definition at every instantiation site.

## Real-World Usage

The entire STL (Lesson 07's `std::vector`, `std::map`, etc.) is implemented using exactly this template mechanism; understanding function/class templates is prerequisite to reading almost any modern C++ library's source or generic API.

## Summary

- C++ templates are resolved at compile time, generating a fully separate specialized implementation per concrete type — a third, distinct generics model compared to Java's full erasure and C#'s reification.
- C++20 `concepts` constrain template parameters with clear, direct error messages, analogous in purpose to Java's bounded generics and C#'s `where` constraints.
- The entire STL is built on templates — understanding them explains how `std::vector<T>` works for any `T`.

## Key Terms

- **Template** — C++'s compile-time generics mechanism, generating a separate specialized implementation per concrete type instantiated.
- **Concept (C++20)** — a named, checkable constraint on a template parameter, replacing older, less readable SFINAE techniques.

## Interview Questions

1. **How do C++ templates differ from Java generics and C# generics at a fundamental level?**
   C++ templates are resolved entirely at compile time — the compiler generates a fully separate, independently-compiled implementation for every distinct type a template is used with (`Stack<int>` and `Stack<std::string>` share no runtime code or representation at all). Java generics are fully erased — one shared implementation exists at runtime, with no way to recover the type argument. C# generics are reified for value types (specialized code per value type, like C++) but shared for reference types, while always preserving the type argument at runtime (unlike both C++ and Java in different ways). All three achieve "one generic implementation, many types," but through fundamentally different mechanisms with different trade-offs (compile time and binary size for C++, runtime type-erasure limitations for Java, a middle ground for C#).

2. **What problem do C++20 concepts solve?**
   Prior to concepts, constraining a template parameter (e.g., "T must support comparison operators") required SFINAE techniques (`std::enable_if`, expression-based tricks) that produced extremely long, hard-to-read compiler error messages when misused, often pointing deep inside the template's implementation rather than at the actual call site. Concepts let you name a constraint directly (`requires std::totally_ordered<T>`) and get a clear, direct error message when a type doesn't satisfy it, at the point of instantiation.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
