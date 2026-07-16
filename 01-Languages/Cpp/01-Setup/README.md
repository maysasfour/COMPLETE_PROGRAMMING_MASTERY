# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install a C++ compiler and verify it.
- Compile and run a single `.cpp` file.
- Understand the compile → link → run pipeline (no runtime/VM involved).

## Prerequisites

None — entry point of the C++ course.

## Concept

C++ compiles directly to native machine code in two stages: the **compiler** translates each source file into an object file (`.o`/`.obj`), and the **linker** combines object files (plus any libraries) into a final executable. There is no intermediate bytecode, no VM, and no managed runtime — the compiled executable runs directly on the CPU, which is the fundamental reason for C++'s performance ceiling and its complete lack of automatic memory management.

## Syntax

```cpp
// example.cpp
#include <iostream>

int main() {
    std::cout << "Hello, C++" << std::endl;
    return 0;
}
```

```bash
g++ -std=c++20 example.cpp -o example && ./example
```

`int main()` is the mandatory entry point — its return value (`0` here) becomes the program's exit code to the OS, where `0` conventionally means success. `#include <iostream>` pulls in declarations for `std::cout` (standard output) from the standard library's header.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints a greeting and the value of the `__cplusplus` macro, confirming which C++ standard version was used to compile.

## Common Mistakes

- Forgetting `return 0;` at the end of `main` — technically optional for `main` specifically (C++ implicitly returns `0` if omitted), but required for every other function with a non-`void` return type, and a good habit to make explicit regardless.
- Forgetting to link/compile with a modern standard flag (`-std=c++20` or similar) — some compilers default to an older standard, silently disabling newer language features.
- **MSVC-specific gotcha, reproduced while writing this lesson:** compiling with `/std:c++20` alone still reports `__cplusplus` as `199711L` (the pre-C++11 value) — MSVC keeps this macro frozen for backward compatibility unless you *also* pass `/Zc:__cplusplus`. Any code that branches on `__cplusplus` to detect available language features will silently take the wrong path under plain MSVC without this flag, even though the newer standard is genuinely active.

## MSVC's `__cplusplus` Trap

```bash
cl /EHsc /std:c++20 example.cpp                  # __cplusplus reports 199711L -- WRONG, misleading
cl /EHsc /std:c++20 /Zc:__cplusplus example.cpp  # __cplusplus reports 202002L -- correct
```

This is a genuine, documented MSVC compatibility quirk (not a hypothetical) — g++/clang++ do not have this problem and report the correct value with just `-std=c++20`. Always add `/Zc:__cplusplus` when compiling with MSVC if any code (yours or a third-party header) inspects `__cplusplus` for feature detection.

## Best Practices

- Always specify an explicit `-std=c++XX` (or `/std:c++XX` for MSVC) flag rather than relying on a compiler's default.
- Compile with warnings enabled (`-Wall -Wextra` for g++/clang++) — C++ has many subtle undefined-behavior traps that warnings catch early.

## Real-World Usage

Real C++ projects use a build system (CMake, Lesson 15) rather than invoking the compiler directly per file, but understanding the raw compile-then-link pipeline is what CMake (and every other build tool) is ultimately automating.

## Summary

- C++ compiles directly to native machine code via a compile-then-link pipeline — no VM, no managed runtime.
- `int main()` is the mandatory entry point; its return value is the process's exit code.
- Always specify an explicit `-std=c++XX` standard version flag.

## Key Terms

- **Compiler** — translates source code into object code (machine code, not yet linked into an executable).
- **Linker** — combines object files and libraries into a final executable.

## Interview Questions

1. **What are the two main stages of building a C++ program?**
   Compilation (translating each `.cpp` source file into an object file of machine code) and linking (combining all object files, plus any needed libraries, into a single executable). Unlike managed languages, there is no further runtime translation step — the linked executable is native machine code the OS runs directly.

2. **Why does C++ have no garbage collector, unlike Java/C#/Python/JavaScript?**
   C++ compiles to native code with no managed runtime at all — there's no runtime process to run a garbage collector inside, and the language's core design goal (zero-overhead abstraction, maximum control, predictable performance) is fundamentally at odds with a collector's unpredictable pause times and background overhead.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
