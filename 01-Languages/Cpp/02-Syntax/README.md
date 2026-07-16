# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand `#include` directives and the preprocessor.
- Write statements, comments, and understand mandatory semicolons.
- Understand header vs. source file conventions (previewed here, expanded in Lesson 15).

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

C++ source is processed in two conceptual phases: the **preprocessor** (handling `#include`, `#define`, and other `#`-prefixed directives, textually) runs first, then the actual compiler processes the resulting expanded source. `#include <iostream>` literally pastes the contents of the `iostream` header in at that point, before compilation proper begins.

## Syntax

```cpp
#include <iostream> // preprocessor directive: textually includes this header's contents

// single-line comment
/* multi-line
   comment */

int main() {
    int x = 5;                 // statement
    int y = x + 1;               // `x + 1` is an expression
    std::cout << y << std::endl; // statement containing a stream-insertion expression
    return 0;
}
```

Semicolons are mandatory for every statement — there is no ASI-equivalent fallback, same as Java/C#.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints a computed value.

## Common Mistakes

- Forgetting `<iostream>` (or another needed header) before using its declarations — unlike Java/C#, there's no automatic "core library always available" set; each standard library facility needs its own `#include`.
- Confusing `<header>` (angle brackets, for standard library / system headers) with `"header.h"` (quotes, conventionally for your own project's headers) — both work in most compilers but have different search-path semantics.

## Best Practices

- Include only the headers a file actually uses (avoids unnecessary compile-time dependencies and slower builds).
- Use `<iostream>` sparingly in performance-critical code — `std::cout` has more overhead than C's `printf` in some scenarios, though this is rarely a practical concern outside hot loops.

## Real-World Usage

Every C++ translation unit begins with a block of `#include` directives; large projects invest significant effort in minimizing unnecessary includes to keep compile times manageable, since C++ compile times scale with the total (transitively included) code processed per file.

## Summary

- The preprocessor runs first, textually expanding `#include`/`#define` directives before compilation.
- Semicolons are mandatory; there is no ASI equivalent.
- Each standard library facility needs its own explicit `#include`.

## Key Terms

- **Preprocessor** — the phase that textually expands `#`-prefixed directives before compilation proper.
- **Translation unit** — one `.cpp` file plus everything textually included into it after preprocessing, the actual unit the compiler processes.

## Interview Questions

1. **What does the preprocessor do, and when does it run?**
   It runs before the actual compiler, performing textual substitutions: `#include` pastes in a header file's contents at that point, `#define` performs macro substitution, and conditional directives (`#ifdef`, etc.) can include/exclude code based on compile-time conditions. The compiler proper never sees the original unexpanded source — only the fully preprocessed result.

2. **What is a translation unit?**
   One `.cpp` source file plus everything textually pulled in via `#include` (recursively) after preprocessing — this is the actual unit the compiler processes and produces one object file from, which is why understanding include structure matters for both compile times and avoiding duplicate-definition errors.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
