# 15 — Modules and Header Files

[Back to course overview](../README.md) | [Previous: Threads and Concurrency](../14-Threads-and-Concurrency/README.md)

## Learning Objectives

- Split a project across multiple `.c`/`.h` files with header guards.
- Understand C has **no module/package language construct at all** — header/source splitting plus separate compilation is the entire mechanism.
- Genuinely compile multiple `.c` files separately, then link them into one executable.

## Prerequisites

[14-Threads-and-Concurrency](../14-Threads-and-Concurrency/README.md)

## Concept

Unlike languages with a real module system (Python's `import`, Java's packages, C#'s namespaces/assemblies), C has **no module keyword or construct whatsoever** — not even the header/package split C++ still layers `namespace` on top of. C's entire answer to organizing code across files is a convention: put function/type **declarations** in a `.h` header (what other files need to know exists), put the actual **definitions** in a matching `.c` source file (compiled once, independently, into its own object file), and `#include` the header wherever the declarations are needed. **Header guards** (`#ifndef X_H / #define X_H / ... / #endif`) prevent a header's contents from being processed twice if it's `#include`d more than once (directly or transitively) in the same translation unit — a real, easy-to-hit problem without them (a "redefinition" compile error).

## Syntax

```c
/* mathutils.h */
#ifndef MATHUTILS_H
#define MATHUTILS_H
int addInts(int a, int b);   /* declaration only -- no body */
#endif

/* mathutils.c */
#include "mathutils.h"
int addInts(int a, int b) { return a + b; }   /* the actual definition */

/* main.c */
#include "mathutils.h"
addInts(3, 4);   /* calls the definition in mathutils.c, linked in separately */
```

```bash
# One-step: compile and link all three .c files together
cl /std:c17 main.c mathutils.c stringutils.c /Fe:app.exe

# Two-step, explicit: compile each to its OWN object file first, THEN link
cl /std:c17 /c main.c mathutils.c stringutils.c    # produces main.obj, mathutils.obj, stringutils.obj
link main.obj mathutils.obj stringutils.obj /out:app.exe
```

## This Lesson's Project

A genuine three-`.c`-file project (plus two headers):

```
15-Modules-and-Header-Files/
├── mathutils.h / mathutils.c       -- addInts, multiplyInts, average
├── stringutils.h / stringutils.c   -- countVowels, toUppercase
└── main.c                          -- #includes both headers, calls into both modules
```

## Detailed Example

See [main.c](main.c), [mathutils.h](mathutils.h)/[mathutils.c](mathutils.c), and [stringutils.h](stringutils.h)/[stringutils.c](stringutils.c) — a genuine multi-file project, not a single-file example with a header appended for show.

## Expected Output

```
-- mathutils.c --
addInts(3, 4) = 7
multiplyInts(3, 4) = 12
average(scores, 5) = 86.40

-- stringutils.c --
countVowels("Hello, Modular C!") = 5
toUppercase result: HELLO, MODULAR C!
```

Genuinely compiled and run **two different ways**, both confirmed to produce identical, correct output: the one-step `cl main.c mathutils.c stringutils.c /Fe:app.exe` combined compile-and-link command, and the explicit two-step `cl /c ...` (compile each file to its own `.obj` with no linking) followed by a separate `link main.obj mathutils.obj stringutils.obj /out:app2.exe` invocation — proving the compile-then-link pipeline (Lesson 01's concept) is genuinely two separable stages, not just a conceptual description.

## Common Mistakes

- Forgetting header guards — including the same header twice (directly, or transitively through two other headers that both include it) without guards causes a "redefinition" compile error for every declaration in it.
- Putting a function **definition** (with a body) directly in a header instead of just its declaration — if that header is included by more than one `.c` file, the linker sees the same function defined multiple times ("multiply defined symbol") when all the object files are linked together.
- Forgetting to pass **every** `.c` file the project needs to the compiler/linker — a missing source file produces "unresolved external symbol" linker errors for anything it was supposed to define.

## Best Practices

- Always use header guards (`#ifndef`/`#define`/`#endif`) — or, as a widely-supported (though not 100%-standard) alternative, `#pragma once`.
- Keep headers to declarations, `typedef`s, macros, and `struct`/`enum` definitions — never function bodies (except genuinely small `static inline` helpers, a deliberate, narrow exception).
- Name each header/source pair after the cohesive piece of functionality it represents (`mathutils`, `stringutils`), mirroring how a real multi-file C project (or, later, a Makefile/CMake target) organizes its object files.

## Real-World Usage

Every real C project beyond a trivial single-file program uses this exact header/source split, typically automated by Make/CMake rather than invoked by hand as shown here — but the underlying separate-compilation-then-link model is identical to what those build tools generate under the hood.

## Summary

- C has no module/package language construct — header/source splitting plus separate compilation is the entire mechanism, unlike Python/Java/C#'s real module systems.
- Header guards prevent a header's contents from being processed more than once per translation unit.
- Compile-then-link is genuinely two separable stages — confirmed here by building the same project both as one combined command and as explicit separate compile and link steps, with identical results.

## Key Terms

- **Header guard** — `#ifndef`/`#define`/`#endif` wrapping a header's contents to prevent double-processing.
- **Translation unit** — a single `.c` file after preprocessing (all its `#include`s expanded), the actual unit the compiler compiles into one object file.

## Interview Questions

1. **What happens if you omit header guards and a header ends up `#include`d twice in the same file (directly or transitively)?**
   Every declaration/definition in that header is processed twice by the preprocessor for that translation unit, producing "redefinition" compile errors for anything that can't legally be declared twice (most struct/type definitions, for instance). Header guards (`#ifndef X_H`/`#define X_H`/`#endif`) prevent this by making the header's contents a no-op the second time the same translation unit tries to include it.

2. **Does C have a language-level module or package system? What does a real multi-file C project use instead?**
   No — C has no module/package keyword or construct at all. Real multi-file C projects rely entirely on the header/source convention: declarations in a `.h` file, definitions in a matching `.c` file compiled as its own separate translation unit, with `#include` pulling in the declarations wherever needed and the linker resolving calls across the separately-compiled object files afterward — confirmed in this lesson by building the exact same three-file project both as one combined `cl` invocation and as explicit separate `/c` compilation followed by a distinct `link` step.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
