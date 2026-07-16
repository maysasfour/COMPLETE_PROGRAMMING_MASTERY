# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Write functions with default arguments and use overloading.
- Understand pass-by-value vs. pass-by-reference vs. pass-by-const-reference parameters.
- Understand C++ has free (non-member) functions, unlike Java.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Unlike Java (Lesson 06 of the Java course), C++ (like C) has genuine free-standing functions — no class wrapper required. C++ also supports default argument values directly (unlike Java, which simulates them via overloading) and overloading (same name, different parameter lists, resolved at compile time).

## Default Arguments and Overloading

```cpp
std::string greet(std::string name = "World") { // default argument, directly supported
    return "Hello, " + name;
}

int add(int a, int b) { return a + b; }
double add(double a, double b) { return a + b; } // overload: same name, different parameter types
```

## Pass-by-Value vs. Reference vs. Const Reference

```cpp
void incrementByValue(int x) { x++; }        // modifies a LOCAL COPY -- caller's variable unchanged
void incrementByRef(int& x) { x++; }          // modifies the CALLER'S variable directly
void printByConstRef(const std::string& s) {  // avoids copying a potentially large string, read-only
    std::cout << s << std::endl;
}

int counter = 5;
incrementByValue(counter);
std::cout << counter << std::endl; // still 5 -- unaffected
incrementByRef(counter);
std::cout << counter << std::endl; // 6 -- actually incremented
```

This directly extends Lesson 03's value-semantics point to function parameters: a plain value parameter (`int x`, `std::string s`) always **copies** the argument; a reference parameter (`int&`, `std::string&`) operates on the original; `const T&` is the standard idiom for "pass efficiently without copying, but don't allow mutation."

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints default-argument/overload results and demonstrates the pass-by-value vs. pass-by-reference contrast concretely.

## Common Mistakes

- Passing a large object (a `std::string`, `std::vector`, custom class) by plain value in a hot path, causing an unnecessary copy on every call — use `const&` instead unless a copy is genuinely needed.
- Expecting a pass-by-value parameter's modifications to be visible to the caller — they never are; only reference parameters (`T&`) propagate changes back.

## Best Practices

- Use `const T&` for any non-trivially-cheap-to-copy parameter that the function doesn't need to modify.
- Use `T&` only when the function genuinely needs to modify the caller's variable.
- Use plain `T` (by value) for small, cheap-to-copy types (`int`, `double`, `bool`) where a reference would add no benefit.

## Real-World Usage

The `const T&` parameter idiom is one of the most pervasive patterns in real C++ code, appearing in the vast majority of function signatures that accept a `std::string`/`std::vector`/custom class without needing to modify it.

## Summary

- C++ has genuine free functions, no class wrapper required, unlike Java.
- Default arguments are directly supported; overloading is also available and commonly combined with defaults.
- Pass-by-value copies; pass-by-reference (`T&`) modifies the original; `const T&` passes efficiently without allowing mutation — the standard idiom for read-only parameters of non-trivial types.

## Key Terms

- **Pass-by-value** — a function parameter receives a copy of the argument; changes don't propagate to the caller.
- **Pass-by-reference (`T&`)** — a function parameter aliases the caller's variable directly; changes do propagate.
- **`const T&` parameter** — passes a reference (avoiding a copy) while preventing the function from mutating it.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between passing a parameter by value, by reference, and by const reference in C++?**
   By value (`T x`) copies the argument — the function operates on an independent copy, and changes never affect the caller. By reference (`T& x`) lets the function operate directly on the caller's variable, so changes are visible after the call returns. By const reference (`const T& x`) avoids the copy (efficient for large objects) while still preventing the function from modifying the original, combining the efficiency of a reference with the safety of a value parameter.

2. **Does C++ require every function to be a class method, like Java?**
   No — C++ (like C) fully supports free-standing functions outside any class, unlike Java's requirement that everything (including `main`) be a class member. This is a direct contrast worth remembering when comparing the two languages' function models.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
