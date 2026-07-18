# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Understand C has **no default arguments** and **no function overloading** — genuinely absent, with named workarounds.
- Declare and use function pointers as first-class values — the foundation of Lessons 11 and 12.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Functions in C are simpler and more restricted than in C++: no default parameter values, no overloading by parameter type/count (a second function with the same name is a redefinition error, not a distinct overload), and no templates. Two features fill in for what other languages solve differently: **sentinel-value "default" arguments** (a caller passes a special value like `-1` meaning "use the default") and **distinctly-named functions per type** (`addInt`/`addDouble` instead of an overloaded `add`). The one genuinely powerful capability C functions do have, used constantly in real C code: **function pointers** — a variable holding the address of a function, callable through that pointer, and passable as an argument (the "callback" pattern, formalized in Lesson 12).

## Syntax

```c
int connect(const char* host, int retries) {
    if (retries < 0) retries = 3;   /* manual "default" via sentinel value */
    /* ... */
}

int (*opPtr)(int) = square;    /* opPtr: pointer to a function taking int, returning int */
opPtr(4);                       /* calls through the pointer, identical syntax to a direct call */

int applyOperation(int x, int (*operation)(int)) {   /* function pointer as a parameter */
    return operation(x);
}
```

## Detailed Example

See [example.c](example.c) — a sentinel-default connect function, two type-specific `add` functions (no overloading possible), and function pointers assigned, reassigned, and passed as a callback argument.

## Expected Output

```
connecting to example.com with 3 retries
connecting to example.com with 5 retries
addInt(2, 3) = 5
addDouble(2.5, 3.5) = 6.000000
opPtr(4) = 16 (opPtr currently holds square's address)
opPtr(4) = 64 (opPtr now holds cube's address)
applyOperation(5, square) = 25
applyOperation(5, cube) = 125
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings.

## Common Mistakes

- Trying to declare two functions with the same name but different parameter types, expecting C++-style overload resolution — this is a redefinition compile error in C; give them distinct names.
- Forgetting a sentinel-value "default" still requires every caller to pass *something* — there is no syntax to omit the argument entirely the way C++'s `int retries = 3` allows.
- Confusing `int (*opPtr)(int)` (a function pointer variable) with `int *opPtr(int)` (a function returning `int*`) — the parentheses around `*opPtr` are load-bearing and easy to drop by mistake.

## Best Practices

- Name type-specific functions clearly (`addInt`/`addDouble`, not `add1`/`add2`) so the type each handles is obvious from the name alone, compensating for the lack of overloading.
- Use `typedef` for function pointer types with more than one or two parameters — `typedef int (*Operation)(int);` then `Operation opPtr = square;` is far more readable than the raw syntax repeated everywhere.
- Document sentinel "default" values in a comment right where the parameter is declared, since nothing in the signature itself communicates it the way a C++ default argument's `= 3` does.

## Real-World Usage

Every callback-driven C API (```qsort```'s comparator in Lesson 12, GUI toolkit event handlers, signal handlers) is built directly on function pointers — there is no closures/lambda mechanism in C to reach for instead (C++ has both; C has neither).

## Exercises

See [Exercises/](Exercises/README.md); solutions in [Solutions/](Solutions/README.md).

## Summary

- C has no default arguments (sentinel values are the manual substitute) and no function overloading (distinct names are the substitute).
- Function pointers are first-class values in C — assignable, reassignable, and passable as callback arguments — and are the foundation for Lessons 11 (manual polymorphism) and 12 (`qsort`/callbacks).
- `typedef` makes function pointer types far more readable in real code.

## Key Terms

- **Function pointer** — a variable whose value is the address of a function, callable through it.
- **Sentinel value** — a special value (e.g., `-1`) used by convention to signal "use the default," in the absence of real default-argument syntax.

## Interview Questions

1. **Does C support function overloading or default arguments? If not, what are the real-world workarounds?**
   No to both — C has neither feature. Overloading is worked around with distinctly-named functions per type (`addInt`/`addDouble`); default arguments are worked around with a sentinel value (like `-1`) that the function body checks and replaces with an actual default, requiring every caller to pass something explicitly, unlike C++'s `param = defaultValue` syntax.

2. **What is a function pointer in C, and what pattern is it foundational to?**
   A function pointer is a variable that stores the address of a function and can be called through that address using ordinary call syntax. It is the mechanism behind C's callback pattern (a function receiving another function's address as a parameter, e.g., `qsort`'s comparator in Lesson 12) and behind manually simulating polymorphism via a struct of function pointers acting as a hand-rolled vtable (Lesson 11), since C has neither closures nor virtual functions built into the language.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
