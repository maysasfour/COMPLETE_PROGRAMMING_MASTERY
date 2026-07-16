# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Prefer smart pointers (`std::unique_ptr`, `std::shared_ptr`) over raw `new`/`delete`.
- Understand the Rule of Three/Five for classes managing their own resources.
- Apply a consistent, defensible C++ style across the value-semantics, RAII, and generics themes threaded through lessons 01–18.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material.

## Smart Pointers Over Raw `new`/`delete`

```cpp
// BAD: manual, error-prone -- must remember delete on every path, including exception paths
Resource* r = new Resource("leaked");
r->use();
delete r; // skipped entirely if an exception is thrown between new and here -- a leak

// GOOD: RAII via std::unique_ptr -- automatically deleted, even if an exception propagates through
auto r = std::make_unique<Resource>("RAII-managed");
r->use();
// no explicit delete needed, ever
```

`std::unique_ptr<T>` expresses **exclusive ownership** (cannot be copied, only moved) and is the default choice for any dynamically-allocated resource with one clear owner. `std::shared_ptr<T>` expresses **shared ownership** via reference counting — the underlying resource is destroyed only when the last `shared_ptr` referencing it is destroyed. Prefer `unique_ptr` unless genuine shared ownership is needed; `shared_ptr` has real overhead (atomic reference counting) that `unique_ptr` doesn't.

## The Rule of Three / Rule of Five

If a class manages a raw resource directly (rare in modern C++, given smart pointers, but foundational to understand), it must define **all** of: destructor, copy constructor, copy assignment operator (the "Rule of Three"), plus move constructor and move assignment operator (the "Rule of Five", added in C++11) — defining only some of these five special member functions for a resource-owning class is a common source of double-frees, leaks, or unwanted copies. In modern C++, the practical version of this rule is: **prefer the "Rule of Zero"** — don't manage raw resources directly at all; compose your class from members (like `std::unique_ptr`, `std::vector`, `std::string`) that already correctly implement RAII and the Rule of Five themselves, so your class needs to define none of these five special members manually.

## Detailed Example

See [example.cpp](example.cpp) — contrasts raw `new`/`delete` with `std::unique_ptr`, and demonstrates `std::shared_ptr`'s reference-counted shared ownership concretely (two objects sharing one underlying resource, both seeing the same mutations).

## Expected Output

Running the example prints a resource acquired-and-released manually (working correctly in this simple case, but fragile — an exception between `new` and `delete` would leak it), the same pattern via `std::unique_ptr` (automatic, exception-safe), and two `SharedCounter` instances sharing one underlying `int` via `std::shared_ptr`, both `increment()` calls visible through either instance, with `use_count()` confirming two owners.

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" apply collectively, with the value-semantics-vs-reference distinction (Lesson 03), slicing (Lesson 11), and manual resource management (this lesson) being C++'s most consequential, most distinctly-C++ recurring themes — none of the other 19 language courses in this repository need to think about any of these three at all.

## Best Practices (Meta)

- Default to `std::unique_ptr` for owned dynamic resources; reach for `std::shared_ptr` only when genuine shared ownership is needed.
- Follow the Rule of Zero: compose classes from RAII-correct members rather than managing raw resources directly.
- Use references (not pointers) for non-owning, non-null parameters; use `const T&` for efficient read-only access to non-trivial types.
- Always use references/pointers (never by-value) for polymorphic types, to avoid slicing.
- Write Catch2/Google Test tests (Lesson 18) for behavior that matters — the compiler cannot catch a wrong formula, only a test can.

## Real-World Usage

Modern C++ style guides (Google's, the C++ Core Guidelines) universally recommend smart pointers and the Rule of Zero as the default; raw `new`/`delete` in application-level code (as opposed to inside a low-level allocator or smart-pointer implementation itself) is treated as a code smell in most professional C++ codebases today.

## Summary

- This lesson has no new syntax beyond smart pointers — it's a checklist synthesizing lessons 01–18's individual practices, centered on C++'s most distinctive recurring themes: value semantics, RAII, and manual memory management.
- `std::unique_ptr` (exclusive ownership) is the default smart pointer; `std::shared_ptr` (reference-counted shared ownership) is for genuine shared-ownership cases.
- The Rule of Zero (compose from RAII-correct members) is the modern, practical answer to the Rule of Three/Five.

## Key Terms

- **Rule of Zero** — the modern C++ guideline to avoid managing raw resources directly, instead composing classes from members that already correctly implement RAII.
- **`std::unique_ptr`** — a smart pointer expressing exclusive, non-copyable ownership of a dynamically-allocated resource.
- **`std::shared_ptr`** — a smart pointer expressing reference-counted shared ownership.

## Interview Questions

1. **Why prefer `std::unique_ptr` over raw `new`/`delete`?**
   `std::unique_ptr` is RAII — its destructor automatically deletes the owned resource when the `unique_ptr` goes out of scope, whether the function returns normally or an exception propagates through. Raw `new`/`delete` requires manually matching every `new` with exactly one `delete` on every possible code path, including exception paths — easy to get wrong, and a common source of memory leaks and double-frees in older C++ code.

2. **What is the "Rule of Zero," and why is it preferred over manually implementing the Rule of Five?**
   The Rule of Zero says a class should avoid managing raw resources directly at all, instead composing itself from members (smart pointers, `std::vector`, `std::string`) that already correctly implement RAII, copy/move semantics, and cleanup themselves. This means the class itself needs to define none of the five special member functions (destructor, copy constructor/assignment, move constructor/assignment) manually — the compiler-generated defaults, which just call each member's own correct behavior, are already correct. This is strictly safer than manually implementing all five special members correctly for a class managing a raw resource directly (the Rule of Five), which is easy to get subtly wrong.

## Recommended Next Lesson

This completes the core C++ course (lessons 01–19), matching the depth of Python, JavaScript, TypeScript, C#, and Java. Lessons 20–22 (Exercises, Solutions, Mini-Projects as standalone folders) are not yet built — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). From here, continue to [Go](../../Go/README.md) (per this repository's specified language order).
