# 11 — Structs and Unions

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Use `struct` (plain data grouping) and `union` (memory-sharing) correctly.
- Understand C has **no classes, no inheritance, no virtual functions** — and build the real substitute: manual "polymorphism" via a struct of function pointers.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

C's `struct` is exactly what C++ inherited as its own struct/class data layout — fields laid out contiguously in memory — but with **no methods, no access control (`private`/`public`), no inheritance, and no virtual functions**. This is the single biggest structural gap between C and C++: C has genuinely no OOP mechanism at the language level. What real C code uses instead, and what this lesson builds live: a struct holding both data (via a `void*` to the concrete type) **and function pointers** acting as a hand-rolled "vtable" — each concrete "subtype" supplies its own function implementations, and calling code goes through the uniform struct interface without needing to know which concrete type it's actually calling. This is precisely the technique C++ compilers themselves use *internally* to implement `virtual` functions (a real vtable) — this lesson just does it by hand, explicitly, in source code.

A `union` is different from a `struct` in one fundamental way: all of a union's members occupy the **same memory**, so writing one member and reading a different one reinterprets those exact same bytes as the new type (`sizeof(union)` is the size of its *largest* member, not the sum of all members — unlike a struct).

## Syntax

```c
typedef struct { int x, y; } Point;               /* plain data, no methods */

typedef union { int asInt; float asFloat; } IntOrFloat;  /* shared memory */

/* Manual "vtable": a struct holding a void* to concrete data plus
   function pointers implementing each "virtual method". */
typedef struct Shape {
    void* self;
    double (*area)(const struct Shape*);
    const char* (*name)(const struct Shape*);
} Shape;

Shape s = { .self = &circleData, .area = circleArea, .name = circleName };
s.area(&s);    /* calls THROUGH the function pointer -- uniform call site,
                  the SAME line works regardless of which concrete type
                  s.self actually points to */
```

## Detailed Example

See [example.c](example.c) — a plain `Point` struct, a `IntOrFloat` union demonstrating shared memory live (writing `asInt`, reading the same bytes back as `asBytes`, then overwriting with `asFloat` and showing `asInt` now reads garbage), and a full manual-polymorphism demo: an array of `Shape` holding both a `Circle` and a `Rectangle`, each called through the exact same uniform loop.

## Expected Output

```
Point: (3, 4)

Union: wrote asInt = 65, sizeof(union) = 4 bytes (size of its largest member)
Reading the SAME memory as asBytes[0] = 65 (== 'A' == 65, same bits, reinterpreted)
After writing asFloat = 3.14, asInt now reads as 1078523331 (garbage as an int -- same bits, different type)

Manual polymorphism via function-pointer struct (C's vtable substitute):
  Circle: area = 78.54
  Rectangle: area = 24.00
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, after fixing one real bug found while writing this lesson (see below).

## A Genuine Bug Found and Fixed While Writing This Lesson

The first draft of `example.c` failed to compile with a cascade of confusing syntax errors (`C2061: syntax error: identifier 'Rectangle'`, several `missing ')' before '*'`). The root cause: an inline comment explaining the `void* self` field read `/* pointer to the concrete data (Circle*/Rectangle*) */` — the comment's own *text* contained a literal `*/`, which prematurely closed the block comment three characters into the intended note, leaving `Rectangle*) */` as live, uncommented code that the parser choked on. Fixed by rewording the comment to avoid embedding `*/` in its prose (`(a Circle or Rectangle)` instead). This is itself a genuine, easy-to-make C/C++ mistake worth knowing: **block comments do not nest, and any literal `*/` inside a comment's own text ends it early**, regardless of intent.

## Common Mistakes

- Writing `*/` inside a block comment's own explanatory text (as this lesson's own first draft did) — it ends the comment immediately, silently turning the rest of the intended comment into live code.
- Forgetting a union's members share memory — reading a member you didn't most recently write reinterprets those bytes as the new type, which is correct/intentional in low-level code (e.g., type punning) but a bug if done by accident.
- Trying to reach for `virtual`/`inheritance`/`private` keywords out of C++ habit — none exist in C; the function-pointer-struct pattern shown here is the actual, real substitute, not an approximation of one.

## Best Practices

- Use `typedef struct TagName { ... } TypeName;` consistently so the type can be used without repeating `struct` everywhere.
- When building a manual vtable pattern, keep the "interface" struct (`Shape`) and each concrete type (`Circle`, `Rectangle`) in separate, clearly-named files/sections, exactly like a real polymorphic type hierarchy would be organized in C++.
- Use unions deliberately and narrowly (type punning, tagged unions with a separate discriminant field) — never as a way to "save space" by accident without a clear, documented reason.

## Real-World Usage

The function-pointer-struct "manual vtable" pattern is genuinely how large real-world C codebases implement polymorphism — the Linux kernel's `file_operations` struct (a table of function pointers implementing `read`/`write`/`open` for each device driver) is a canonical, widely-cited real example of exactly this pattern.

## Summary

- `struct` groups data with no methods, access control, or inheritance — genuinely, structurally absent from C, not just discouraged.
- `union` members share memory; `sizeof(union)` equals its largest member's size, not the sum.
- Manual polymorphism via a struct of function pointers (a hand-rolled vtable) is C's real substitute for virtual functions — the exact technique the Linux kernel itself uses (`file_operations`) and the same mechanism C++ compilers use internally to implement `virtual`.

## Key Terms

- **Manual vtable** — a struct holding data plus function pointers, used to achieve polymorphic dispatch without language-level virtual functions.
- **Type punning** — reinterpreting the same bytes as a different type via a union, a legitimate low-level technique when done deliberately.

## Interview Questions

1. **C has no classes or virtual functions. How does real C code achieve polymorphic behavior, and where is this pattern used in practice?**
   By combining a struct holding a `void*` to the concrete data with function pointers acting as a hand-rolled vtable — each concrete "subtype" supplies its own function implementations, and calling code invokes them through the uniform struct interface without knowing the concrete type. This is not a theoretical technique: the Linux kernel's `file_operations` struct (function pointers for `read`/`write`/`open` etc., supplied differently by each device driver) is a widely-cited real-world example, and it's the same underlying mechanism C++ compilers use internally to implement `virtual` functions.

2. **What's the difference between how `struct` and `union` members are laid out in memory, and what's a real risk of using a union incorrectly?**
   A struct's members each get their own distinct memory (with possible padding for alignment); a union's members all share the *same* memory, so `sizeof(union)` equals its largest member's size, not the sum. The real risk: reading a union member other than the one most recently written reinterprets those exact bytes as the new type — correct and intentional for deliberate type punning, but a genuine bug (reading garbage) if done without realizing the members alias the same storage, as this lesson's example demonstrates live by writing `asFloat` and then reading `asInt` as clearly nonsensical garbage.

## Recommended Next Lesson

[12 — Function Pointers and Callbacks](../12-Function-Pointers-and-Callbacks/README.md)
