# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use pointer arithmetic correctly (scaled by the pointee's `sizeof`, not raw bytes).
- Understand that C has **zero operator overloading** — every operator has exactly one fixed meaning per built-in type, with no mechanism to redefine it for a struct.
- Use bitwise operators, which C code reaches for far more often than typical C++ code (no `std::bitset`).

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

C's operators (arithmetic, relational, logical, bitwise, pointer `*`/`&`) are the same set C++ inherited unchanged. The one absolute, structural difference: **C has no operator overloading mechanism at all** — not a smaller version of it, not a workaround, genuinely none. `struct Point a, b; a + b;` is a compile error in C with no way to make it legal short of writing a plain function (`addPoints(a, b)`) and calling it explicitly. C++'s `operator+` (and every other overloadable operator) simply does not exist as a language concept in C.

## Pointer Arithmetic

```c
int numbers[5] = {10, 20, 30, 40, 50};
int* p = numbers;        /* array decays to &numbers[0] */

*(p + 1)                  /* == numbers[1] == 20 -- advances by sizeof(int) bytes, not 1 byte */
p[2]                       /* identical to *(p + 2) -- array indexing IS pointer arithmetic in C */
end - p                    /* pointer subtraction: counts ELEMENTS apart, not bytes, for two
                              pointers into the same array */
```

Pointer arithmetic is scaled automatically by `sizeof(*p)` because the compiler knows the pointee's type — advancing an `int*` by 1 moves 4 bytes (on this platform), while advancing a `double*` by 1 moves 8. This is identical to C++, but C code reaches for it directly far more often, since C has no `std::vector`/iterator abstraction to hide it behind (Lesson 07).

## Detailed Example

See [example.c](example.c) — arithmetic/pointer arithmetic/bitwise operators, all genuinely compiled and run.

## Expected Output

```
Arithmetic: 7 / 2 = 3 (integer division truncates), 7 % 2 = 1
Arithmetic (float): 7.0 / 2 = 3.500000
p points to 10
p + 1 points to 20
p[2] (same as *(p + 2)) = 30
end - p = 4 elements apart
flags = 10, flags | 0b0101 = 15, flags & 0b1100 = 8, flags << 1 = 20
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings. One incidental finding worth noting honestly: `0b1010`-style binary integer literals (standardized in C23, not C17) compiled without any warning under MSVC 19.51's `/std:c17` — MSVC accepts this as a compiler extension even in strict C17 mode, so don't rely on it compiling on gcc/clang without `-std=gnu17` or a C23 flag; it isn't portable C17.

## Common Mistakes

- Forgetting pointer arithmetic is scaled — `p + 1` is **not** "one byte past `p`," it is "one element past `p`," a frequent source of off-by-one memory bugs for C beginners coming from languages without raw pointers.
- Expecting `a + b` to work on structs — there is no operator overloading in C at all; write an explicit function (`addPoints(a, b)`) instead, and expect every operator's meaning to be exactly what the language specifies for that operand's built-in type, never customizable.
- Integer division truncation surprises (`7 / 2 == 3`, not `3.5`) — identical to C++, but worth restating since C's weaker type checking (no function overloading, more implicit conversions) makes this kind of silent truncation easier to introduce by accident elsewhere in a codebase.

## Best Practices

- Prefer indexing (`arr[i]`) over raw pointer arithmetic (`*(arr + i)`) for readability wherever both are equally correct — they compile to identical code, so this is a pure readability choice.
- When you do need "operator-overloading-like" behavior for a struct, write clearly-named functions (`addPoints`, `pointEquals`) rather than trying to fake operator syntax with macros — macros can't achieve real operator overloading either and only obscure the code.
- Be explicit about signed vs. unsigned in bitwise/shift operations — shifting a signed negative value is implementation-defined/undefined in older standards; prefer `unsigned` types for bit manipulation.

## Real-World Usage

Embedded/systems C code (device drivers, network protocol parsers, bitfield-heavy binary formats) leans on bitwise operators and pointer arithmetic constantly, since there is no higher-level abstraction (no `std::bitset`, no iterator) standing between the code and the raw bytes.

## Summary

- Pointer arithmetic is scaled by the pointee's `sizeof`, not raw bytes — `p + 1`, `p[i]`, and `end - p` (element count, not byte count) are all pointer arithmetic under the hood.
- C has zero operator overloading, structurally — not a restricted version, genuinely none; every operator means exactly one fixed thing per built-in type.
- Bitwise operators are used far more directly in idiomatic C than in idiomatic C++, for lack of higher-level standard-library alternatives.

## Key Terms

- **Pointer arithmetic** — arithmetic on a pointer, automatically scaled by `sizeof` of its pointee type.
- **Array decay** — an array used in most expressions automatically converts ("decays") to a pointer to its first element.

## Interview Questions

1. **If `int* p` points to the start of an `int[10]` array, what does `p + 1` actually point to, in terms of bytes?**
   `p + 1` points `sizeof(int)` bytes past `p` (4 bytes on this platform), i.e., `&arr[1]` — not one raw byte past `p`. Pointer arithmetic is always scaled by the pointee type's size, which is also exactly why `arr[i]` is defined as shorthand for `*(arr + i)`.

2. **Can you overload `+` for a custom struct type in C, the way C++ allows `operator+`?**
   No — C has no operator overloading mechanism at all, for any operator, on any user-defined type. The only way to get "`+`-like" behavior for a struct is to write and call an explicitly-named function (e.g., `addPoints(a, b)`); there is no syntax that makes `a + b` itself legal for two struct operands.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
