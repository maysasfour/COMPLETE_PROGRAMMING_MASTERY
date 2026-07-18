# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone problems spanning the whole course, deliberately in different domains from Lessons 05/06/07's own `Exercises/`/`Solutions/` pairs. Each exercises something distinctive to C specifically: manual memory management, raw pointer arithmetic, struct-based "objects," function pointers/callbacks, and header/source organization. Solutions live in [../21-Solutions](../21-Solutions/README.md) — solve these first.

## 1. Pointer-Arithmetic Array Reverser

Write `void reverseInPlace(int* arr, size_t n)` that reverses an array **using only pointer arithmetic** (two moving pointers, one from each end, no `arr[i]` indexing syntax anywhere in the function body). Test it on an array of at least 6 ints and print before/after.

## 2. Dynamic Growable Array ("Vector")

C has no built-in resizable array (unlike C++'s `std::vector`). Implement a minimal one: a struct holding `int* data`, `size_t length`, `size_t capacity`, plus `vecPush(Vec*, int)` (doubling capacity via `realloc` when full) and `vecFree(Vec*)`. Push at least 10 values (forcing at least one grow) and print the final contents. Verify with an allocation counter (as in Lesson 19) that every `malloc`/`realloc` is eventually matched by exactly one `free`.

## 3. Struct-Based "Object": A Bank Account

C has no classes, but a `struct` plus functions that take a pointer to it as their first argument is the idiomatic stand-in (the same pattern SQLite's own C API uses for `sqlite3*`). Define `typedef struct { char owner[64]; double balance; } Account;` plus `accountDeposit`, `accountWithdraw` (returns an error code on insufficient funds — no exceptions, per Lesson 09), and `accountPrint`. Demonstrate both a successful and a failing withdrawal.

## 4. Function-Pointer Callback: Generic `forEach`

Write `void intArrayForEach(const int* arr, size_t n, void (*callback)(int))` that calls `callback` once per element. Write two different callback functions (e.g., one that prints, one that accumulates a running sum via a `static` file-scope variable) and pass each to the same `forEach` in turn.

## 5. Singly Linked List with Manual Memory Management

Implement a singly linked list of `int`s: a `Node` struct with `int value; struct Node* next;`, plus `listPush`, `listPrint`, and — critically — `listFreeAll` that walks the list freeing every node without leaking or double-freeing. Build a list of at least 5 values, print it, free it, and use an allocation counter (as in Exercise 2) to prove the free count matches the allocation count.

## 6. Header/Source Split: A Small Geometry Module

Following Lesson 15's convention, split a small "shapes" module into `shapes.h` (declarations for a `Circle` struct and `circleArea`/`circlePerimeter` functions) and `shapes.c` (definitions), then a separate `main.c` that `#include`s the header and links against the compiled source. Compile all files together in one `cl` invocation and print the area/perimeter of a circle with radius 5.

## 7. String Tokenizer Using `strtok`

Write a function that takes a comma-separated string (e.g., `"apples,bread,milk,eggs"`) and prints each token on its own line, using `strtok`. Note in a comment why `strtok` mutates its input string (it writes `'\0'` bytes into it in place) and is not safe to call on a string literal — pass a modifiable buffer.

## Recommended Next

[21 — Solutions](../21-Solutions/README.md)
