# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`throw` with standard exception types.
- Write custom exceptions by extending `std::exception`.
- Understand RAII as C++'s primary resource-safety mechanism — more fundamental here than in any other language course.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

C++ exceptions work syntactically like Java/C#'s, but C++'s *primary* resource-safety mechanism is **RAII** (Resource Acquisition Is Initialization), not `finally`/`try`-with-resources as an afterthought — C++ doesn't even have a `finally` keyword. Instead, a resource-owning object's destructor runs automatically when it goes out of scope, whether via normal return or exception unwinding, making cleanup automatic and exception-safe by construction rather than requiring a separate cleanup block.

## `try`/`catch`/`throw`

```cpp
#include <stdexcept>

double divide(double a, double b) {
    if (b == 0) throw std::invalid_argument("Cannot divide by zero");
    return a / b;
}

try {
    divide(10, 0);
} catch (const std::invalid_argument& e) {
    std::cout << "Caught: " << e.what() << std::endl;
} catch (const std::exception& e) {
    std::cout << "Unexpected: " << e.what() << std::endl;
}
```

Always catch exceptions **by const reference** (`const std::exception& e`), never by value — catching by value copies the exception object and, for polymorphic exception types, can slice it (Lesson 11's slicing problem, applied to exceptions specifically).

## Custom Exceptions

```cpp
class ValidationError : public std::exception {
    std::string message;
public:
    ValidationError(const std::string& msg) : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
};
```

## RAII: No `finally` Needed

```cpp
class FileGuard {
public:
    FileGuard() { std::cout << "Resource acquired" << std::endl; }
    ~FileGuard() { std::cout << "Resource released (automatically)" << std::endl; } // runs on scope exit
};

void doWork() {
    FileGuard guard; // acquired here
    throw std::runtime_error("something went wrong");
} // guard's destructor STILL runs here, even though an exception is propagating
```

There is no `finally` keyword in C++ — RAII (a resource-owning object whose destructor releases the resource) makes it unnecessary: the destructor runs automatically during **stack unwinding** (the process of exception propagation cleaning up local objects), whether the function returns normally or an exception passes through, with zero explicit cleanup code needed.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints a caught standard exception, a custom exception's message, and RAII demonstrating that a resource is released automatically even when an exception propagates through the scope that acquired it.

## Common Mistakes

- Catching exceptions by value instead of `const&` — copies (and potentially slices) the exception object unnecessarily.
- Looking for a `finally` keyword — C++ has none; RAII (a destructor-owning object) is the idiomatic replacement, and is more fundamental to C++'s design than `finally` ever was to Java/C#'s.
- Forgetting `what()` must be `const noexcept` when overriding `std::exception::what()`.

## Best Practices

- Always catch by `const&`.
- Prefer RAII (smart pointers, guard objects) over manual cleanup in a catch/finally-equivalent block — this is the single most important C++-specific error-handling idiom, expanded further in Lesson 19.
- Derive custom exceptions from `std::exception` (or a more specific standard subclass like `std::runtime_error`) for interoperability with generic `catch (const std::exception&)` handlers.

## Real-World Usage

RAII is arguably C++'s most distinctive contribution to programming language design — smart pointers (`std::unique_ptr`, Lesson 19), lock guards (`std::lock_guard` for mutexes), and file streams (`std::ifstream`, Lesson 10) all rely on it to guarantee cleanup without a `finally`/`using`/`with` block anywhere.

## Summary

- `try`/`catch`/`throw` syntax resembles Java/C#; always catch by `const&` to avoid copying/slicing.
- C++ has no `finally` keyword — RAII (destructors running automatically on scope exit, including during exception propagation) is the idiomatic, more fundamental replacement.
- Custom exceptions should derive from `std::exception` and override `what() const noexcept`.

## Key Terms

- **RAII (Resource Acquisition Is Initialization)** — C++'s core resource-safety idiom: a resource is tied to an object's lifetime, released automatically by its destructor.
- **Stack unwinding** — the process of destroying local objects (running their destructors) as an exception propagates up the call stack.

## Interview Questions

1. **Why does C++ have no `finally` keyword, unlike Java/C#?**
   Because RAII makes it largely unnecessary: a resource-owning object's destructor runs automatically when it goes out of scope, whether the function returns normally or an exception is propagating through (during stack unwinding) — this achieves the same guaranteed-cleanup goal `finally` provides, but tied to object lifetime rather than a separate syntactic block, and works even for cleanup logic scattered across many different local objects in the same scope.

2. **Why should you always catch C++ exceptions by `const&` instead of by value?**
   Catching by value copies the exception object, which is wasteful, and for a polymorphic exception hierarchy can **slice** it (Lesson 11) — if a `DerivedException` is thrown but caught as `catch (Exception e)` by value, only the base `Exception` portion is copied into `e`, discarding any derived-specific data or overridden virtual behavior. Catching by `const&` avoids both problems.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
