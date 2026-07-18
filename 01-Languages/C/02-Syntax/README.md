# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand the preprocessor as a distinct, text-substitution pass before compilation.
- Understand that C has **no top-level statements** — every executable statement must live inside a function, and `main` is mandatory.
- Understand the `int main()` vs. `int main(void)` distinction precisely.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

C's syntax is deliberately minimal compared to every other language course in this repository. There are no classes, no modules-as-a-language-construct (Lesson 15 covers the header/`.c` file convention that stands in for them), no top-level statements outside a function, and — critically — a **preprocessor**: a separate, dumb, text-substitution pass (`#include`, `#define`, `#ifdef`/`#endif`) that runs entirely before the compiler ever parses a token. C++ inherits this same preprocessor essentially unchanged, but most of its higher-level equivalents (`constexpr`, templates, `using` aliases) reduce a C++ programmer's day-to-day reliance on it; in C, the preprocessor is still doing real, everyday work (conditional compilation, header guards in Lesson 15, simple constants before `const` was idiomatic).

## Syntax

```c
#include <stdio.h>        /* preprocessor directive: textually inline stdio.h's declarations here */
#define MAX_SIZE 100       /* preprocessor macro: pure textual substitution, no type, no scope */

int main(void) {            /* mandatory entry point; (void) = explicitly zero parameters */
    printf("size limit: %d\n", MAX_SIZE);
    return 0;                /* exit code to the OS */
}
```

## Detailed Example

See [example.c](example.c) — demonstrates `#define`, conditional compilation (`#if`/`#else`/`#endif`), and the `(void)` parameter-list convention.

## Expected Output

```
Hello from the preprocessor
Build mode: VERBOSE
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings.

## The `main()` vs. `main(void)` Trap, Confirmed

Unlike every other language in this repository so far, C's function-parameter syntax has a real, non-obvious ambiguity: an empty parameter list `()` in a function *declaration* does not mean "no parameters" — it means "parameters unspecified," so the compiler will not flag a call site that passes the wrong number/type of arguments. `(void)` is the unambiguous, correct way to say "this function truly takes nothing." (C++ silently redefines `()` to always mean "no parameters," which is why this trap doesn't exist in the C++ course.)

## Common Mistakes

- Writing `int main()` out of C++ habit — works in practice on most compilers for `main` specifically (which has special-cased handling), but the general `()`-means-unspecified rule still applies to every *other* function you declare this way, silently disabling argument-count checking.
- Forgetting that macros (`#define`) are **pure text substitution with no type checking** — `#define SQUARE(x) x*x` expands `SQUARE(1+2)` to `1+2*1+2` (= 5, not 9) because there's no implicit parenthesization; always parenthesize macro parameters and the whole expansion: `#define SQUARE(x) ((x)*(x))`.
- Expecting statements to run at file scope the way a Python/JavaScript script does — nothing outside a function body ever executes in C; only declarations, macros, and type definitions can appear there.

## Best Practices

- Always fully parenthesize macro parameters and macro bodies if you use function-like macros at all — modern C favors `static`/`inline` functions or `const` values over macros wherever either would work identically, precisely to avoid this class of bug.
- Always write `int main(void)` explicitly in new C code.
- Keep `#include` directives at the top of the file, standard headers before project headers, by convention.

## Real-World Usage

Header guards (`#ifndef`/`#define`/`#endif`, Lesson 15) and conditional compilation for platform-specific code (`#ifdef _WIN32` / `#ifdef __linux__`) are two places every real C codebase leans on the preprocessor daily — far more than a typical modern C++ codebase does.

## Summary

- The preprocessor runs before compilation and is pure text substitution — no types, no scope.
- C has no top-level statements; `int main(void)` is the mandatory, unambiguous entry point.
- `()` in a C function signature means "unspecified parameters," not "no parameters" — always write `(void)` explicitly.

## Key Terms

- **Preprocessor directive** — a line starting with `#` (`#include`, `#define`, `#ifdef`), resolved before compilation.
- **Macro** — a preprocessor-defined text substitution, with no type or scope of its own.

## Interview Questions

1. **What does an empty parameter list `()` mean in a C function declaration, and how does `(void)` differ?**
   In C, `()` means the function's parameter list is unspecified — the compiler will not check argument counts/types at call sites. `(void)` explicitly declares zero parameters and *does* get checked. This is a genuine C-specific footgun; C++ treats `()` as always meaning zero parameters, so the ambiguity doesn't exist there.

2. **Why can a macro like `#define SQUARE(x) x*x` produce a wrong result, and how do you fix it?**
   Macros are pure text substitution with no operator precedence awareness — `SQUARE(1+2)` expands to the literal text `1+2*1+2`, which evaluates via normal C operator precedence to `5`, not the intended `9`. The fix is full parenthesization: `#define SQUARE(x) ((x)*(x))`, which expands safely regardless of what expression is passed in.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
