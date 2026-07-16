# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators.
- Use `nullptr` (not `NULL`/`0`) for null pointers, and the ternary operator.
- Use pointer arithmetic and understand its risks.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

C++'s operators are C-family familiar. `nullptr` (C++11+) is the modern, type-safe null-pointer literal, replacing the older C-style `NULL` macro (which was often just `0`, causing ambiguity in overload resolution between pointer and integer parameters).

## Comparison and `nullptr`

```cpp
int* ptr = nullptr; // type-safe null -- prefer over NULL or 0
if (ptr == nullptr) {
    std::cout << "ptr is null" << std::endl;
}

int a = 5, b = 10;
std::cout << (a == b) << std::endl;   // value comparison for primitives
std::cout << (a < b ? "a is smaller" : "b is smaller or equal") << std::endl; // ternary
```

## Pointer Arithmetic

```cpp
int arr[] = {10, 20, 30};
int* p = arr;       // decays to a pointer to the first element
std::cout << *p << std::endl;       // 10
std::cout << *(p + 1) << std::endl;  // 20 -- pointer arithmetic advances by sizeof(int)
p++;                  // now points to arr[1]
std::cout << *p << std::endl;        // 20
```

Pointer arithmetic advances by the pointee type's size, not by raw bytes — `p + 1` on an `int*` moves 4 bytes (on most platforms), not 1. This is powerful but dangerous: advancing a pointer past the end of its array's bounds and dereferencing it is undefined behavior, with no automatic bounds checking.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints `nullptr` usage, comparison/ternary results, and pointer arithmetic advancing through an array.

## Common Mistakes

- Using `NULL` or a bare `0` instead of `nullptr` in modern C++ — `nullptr` is type-safe and avoids overload-resolution ambiguity between pointer and integer parameters that plagued older C++ code.
- Advancing a pointer past the bounds of its array and dereferencing it — undefined behavior, not a caught exception; the program may crash, silently corrupt memory, or "work" unreliably depending on what happens to be in adjacent memory.

## Best Practices

- Always use `nullptr` for null pointers in C++11 and later.
- Prefer range-based `for` loops and `std::vector`/iterators (Lesson 07) over raw pointer arithmetic wherever possible — reserve manual pointer arithmetic for genuinely low-level code.

## Real-World Usage

Pointer arithmetic underlies how arrays and `std::vector` work internally, but application-level C++ code today rarely needs to write it directly — `std::vector`, iterators, and range-based `for` (Lessons 05/07) cover the vast majority of everyday cases far more safely.

## Summary

- `nullptr` is the type-safe modern null-pointer literal, preferred over `NULL`/`0`.
- Pointer arithmetic advances by the pointee type's size and has zero automatic bounds checking — going out of bounds is undefined behavior.
- Modern C++ style minimizes direct pointer arithmetic in favor of higher-level abstractions.

## Key Terms

- **`nullptr`** — the type-safe null pointer literal (C++11+).
- **Undefined behavior** — a category of program behavior the C++ standard places no requirements on; the compiler/runtime may do anything, including crash, silently corrupt data, or appear to "work."

## Interview Questions

1. **Why is `nullptr` preferred over `NULL` or `0` in modern C++?**
   `nullptr` has its own distinct type (`std::nullptr_t`), making it unambiguous in overload resolution — a function overloaded for both a pointer type and an integer type can correctly resolve `nullptr` to the pointer overload, whereas passing `NULL` (often literally `0`) could ambiguously match either, a real source of bugs in pre-C++11 code.

2. **What happens if you dereference a pointer that's been advanced past the end of its array?**
   Undefined behavior — the C++ standard makes no guarantees about what happens; it might crash immediately, silently read/corrupt unrelated memory, or appear to work by chance depending on what's adjacent in memory. There is no automatic bounds checking the way there is with `std::vector::at()` or managed-language arrays.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
