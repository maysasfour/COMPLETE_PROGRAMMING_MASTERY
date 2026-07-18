# 13 — No Generics

[Back to course overview](../README.md) | [Previous: Function Pointers and Callbacks](../12-Function-Pointers-and-Callbacks/README.md)

## Learning Objectives

- Understand C has **no generics/templates at all** — genuinely absent, not a restricted version.
- Use `void*` + explicit casting, the traditional (unsafe) workaround.
- Use `_Generic` (C11) — the closest thing C has to type-based dispatch, and understand precisely how it differs from a real template.

## Prerequisites

[12-Function-Pointers-and-Callbacks](../12-Function-Pointers-and-Callbacks/README.md)

## Concept

C has no generics, no templates, and no way to write one function/type definition that the compiler specializes for multiple types the way C++ templates, Java/C# generics, or Rust's generics do. The two real workarounds, both used throughout actual C code: **`void*` type erasure** (a container/function stores or accepts `void*`, with *zero* compile-time type safety — the caller must remember and correctly cast back to the real type themselves, exactly as `qsort` itself does in Lesson 12), and **`_Generic`** (C11) — a compile-time selection expression that picks among *already fully written* type-specific branches based on the type of its controlling expression. It is critical to understand `_Generic` is **not** a template: every branch (`int: maxInt, double: maxDouble`) must already exist as a separately-written, complete function; `_Generic` only chooses which one to call, at compile time, based on type — it generates no new code the way a template instantiation does.

## Syntax

```c
/* Workaround 1: void* -- all type safety gone, caller must cast back correctly */
typedef struct { void* value; } Box;
Box b = boxWrap(&someInt);
int recovered = *(int*)b.value;    /* nothing stops a WRONG cast from compiling */

/* Workaround 2: _Generic (C11) -- compile-time dispatch among pre-written branches */
#define describe(x) _Generic((x), \
    int: "int", double: "double", char*: "char*", default: "unknown type")

int maxInt(int a, int b) { return a > b ? a : b; }
double maxDouble(double a, double b) { return a > b ? a : b; }
#define genericMax(x, y) _Generic((x), int: maxInt, double: maxDouble)(x, y)
```

## Detailed Example

See [example.c](example.c) — a `void*`-based "box" demonstrating both the technique and its lack of type safety, plus `_Generic`-based type description and a `genericMax` macro dispatching to a separately-written `maxInt`/`maxDouble` at compile time.

## Expected Output

```
boxedInt: 42
boxedDouble: 3.140000

_Generic type dispatch (compile-time selection, not template code generation):
describe(anInt) = int (anInt = 7)
describe(aDouble) = double (aDouble = 2.500000)
describe(aString) = char* (aString = hello)

genericMax(3, 9) = 9 (dispatches to maxInt at compile time)
genericMax(3.5, 1.5) = 3.500000 (dispatches to maxDouble at compile time)
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, after one genuine, non-obvious finding described below.

## A Genuine Gotcha Found While Writing This Lesson

The first draft called `describe(anInt)` etc. without also printing each variable's own value, and MSVC's `/W4` flagged all three (`anInt`, `aDouble`, `aString`) with `C4189: local variable is initialized but not referenced` — despite each one being passed directly to `describe(...)`. The reason, confirmed by checking the C11 standard: **`_Generic`'s controlling expression is used only to inspect its type at compile time and is never actually evaluated at runtime** (C11 §6.5.1.1p3). So `describe(anInt)` genuinely never "reads" `anInt`'s value — only its type — which is exactly why the compiler correctly considered it unreferenced. Fixed by also printing each variable's actual value alongside `describe(...)`'s result, which is both a legitimate fix and a good illustration of this real, easy-to-miss `_Generic` semantic.

## Common Mistakes

- Casting a `void*` back to the *wrong* type — nothing in the language catches this; it compiles cleanly and silently misinterprets the underlying bytes at runtime, exactly the danger `void*`-based "generics" carry that a real template's compile-time type checking would catch.
- Assuming `_Generic` generates new code for types you didn't explicitly list — it doesn't; an unlisted type either matches `default` (if provided) or fails to compile (if not), unlike a template which can implicitly instantiate for any type satisfying its (unconstrained, or C++20 concept-constrained) requirements.
- Forgetting `_Generic`'s controlling expression is never evaluated at runtime — passing an expression with a side effect (e.g., `describe(i++)`) will **not** perform that side effect, a real and surprising trap if not understood.

## Best Practices

- Prefer `_Generic` over bare `void*` type erasure wherever the full set of supported types is known and small — it at least gets compile-time type checking on which branch is selected, unlike `void*`, which gets none.
- Document `void*`-based APIs' expected types extremely clearly (in comments and naming) since the compiler provides zero help catching a mismatched cast.
- Keep `_Generic` macros' branch lists exhaustive and include a `default` case that produces a clear compile error (e.g., via `_Static_assert` or an intentionally-undeclared function) rather than silently misbehaving for an unexpected type.

## Real-World Usage

`<tgmath.h>`'s type-generic math macros (e.g., a single `sqrt(x)` that dispatches to `sqrtf`/`sqrt`/`sqrtl` depending on `x`'s type) are a real standard-library use of exactly this `_Generic`-style dispatch pattern, and C11's `_Generic` keyword was in fact added partly to give the standard library a portable way to implement `<tgmath.h>` without compiler-specific extensions.

## Summary

- C has no generics/templates at all — `void*` type erasure (no compile-time type safety) and `_Generic` (C11, compile-time dispatch among pre-written branches) are the two real workarounds.
- `_Generic` is not a template — every type-specific branch must already exist as separately-written code; `_Generic` only selects among them at compile time.
- `_Generic`'s controlling expression is never evaluated at runtime — only its type is inspected, confirmed live via a real MSVC warning in this lesson.

## Key Terms

- **Type erasure (`void*`)** — discarding compile-time type information, requiring the caller to track and correctly cast back to the real type manually.
- **`_Generic`** — a C11 keyword selecting one of several pre-written expressions/functions at compile time, based on the type of a controlling expression that is itself never evaluated at runtime.

## Interview Questions

1. **Is `_Generic` the same thing as a C++ template? Why or why not?**
   No. `_Generic` performs compile-time *selection* among branches that must already exist as separately, fully written code for each type — it generates no new code. A C++ template, by contrast, is instantiated by the compiler to *generate* a new specialized version of the templated code for each type it's used with, from a single generic definition. `_Generic` is closer to a type-based `switch` resolved at compile time than to real generic programming.

2. **Is a `_Generic` macro's controlling expression evaluated at runtime? What's a concrete consequence of the answer?**
   No — per the C11 standard, `_Generic`'s controlling expression is used only to determine its type at compile time and is never evaluated at runtime. A concrete, confirmed consequence from this lesson: passing a plain variable to a `_Generic`-based macro does not count as "using" that variable's value, so the compiler can (and, confirmed live with MSVC's `/W4`, does) still warn that the variable is "unreferenced" even though it visually appears inside the macro call.

## Recommended Next Lesson

[14 — Threads and Concurrency](../14-Threads-and-Concurrency/README.md)
