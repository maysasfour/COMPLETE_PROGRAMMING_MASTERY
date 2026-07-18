# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install/confirm a C compiler and verify it.
- Compile and run a single `.c` file.
- Understand the compile → link → run pipeline (no runtime/VM involved, same as C++).

## Prerequisites

None — entry point of the C course.

## Concept

C compiles directly to native machine code, in the same two stages as this repository's C++ course: the **compiler** translates each `.c` source file into an object file (`.obj`/`.o`), and the **linker** combines object files (plus any libraries) into a final executable. There is no bytecode, no VM, and no managed runtime. C is in fact the *lower* layer here — C++ itself is a superset of C, and this course exists specifically to show what's left when you strip away classes, templates, exceptions, and RAII: pure procedural code, manual memory management with no smart-pointer safety net at all (not even the optional kind C++ has), and a standard library that is a strict subset of C++'s `<cstdio>`/`<cstring>`-style facilities.

## Toolchain Used For This Course

This repository's C++ course uses MSVC (`cl.exe`) via a Visual Studio Developer Command Prompt. This C course uses the exact same installation — confirmed working during course construction:

```powershell
where cl     # empty in a plain shell -- cl.exe is not on PATH by default
where gcc    # not installed in this environment
where clang  # only the Swift toolchain's clang.exe is present, not a general-purpose one
```

`cl.exe` is not on `PATH` until its environment is initialized via `vcvarsall.bat`, found (in this environment) at:

```
C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat
```

```powershell
# From a plain PowerShell/cmd, one line at a time:
& "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
cl /std:c17 example.c
.\example.exe
```

Verified live: `cl` reports **Microsoft (R) C/C++ Optimizing Compiler Version 19.51.36248 for x64** and genuinely supports C mode via `/std:c11`, `/std:c17`, or `/std:clatest` (confirmed with `cl /?`) — this course uses `/std:c17` throughout.

## Syntax

```c
/* example.c */
#include <stdio.h>

int main(void) {
    printf("Hello, C!\n");
    return 0;
}
```

```bash
gcc -std=c17 example.c -o example && ./example    # Linux/macOS or MinGW
cl /std:c17 example.c && example.exe               # MSVC Developer Command Prompt
```

`int main(void)` is the mandatory entry point — `(void)` explicitly means "takes no arguments" (an empty `()` in C, unlike C++, means "unspecified arguments," a real and easy-to-miss difference covered in Lesson 02). Its return value becomes the process's exit code to the OS. `#include <stdio.h>` is the preprocessor pulling in declarations for `printf` from the C standard library's I/O header.

## Detailed Example

See [example.c](example.c) — prints a greeting and the compiler's actual `__STDC_VERSION__` value, confirming which C standard was used, live.

## Expected Output

Compiling and running `example.c` with `/std:c17` prints:

```
Hello, C!
__STDC_VERSION__ = 201710L
```

This was genuinely compiled and run with MSVC 19.51 during course construction — no fabricated output.

## Common Mistakes

- **`int main()` vs. `int main(void)`** — in C (unlike C++), an empty parameter list `()` means "this function's parameters are unspecified," not "this function takes no parameters." `main(void)` is the correct, safe way to declare a no-argument `main` in C. This is covered in depth in Lesson 02.
- **Forgetting `return 0;`** — unlike C++11 onward (where `main` alone gets an implicit `return 0;`), relying on C to do this for you is less universally guaranteed across older standards/compilers; write it explicitly.
- **Assuming `cl.exe` is globally on `PATH`** — it only appears after `vcvarsall.bat` (or opening a "Developer Command Prompt for VS") initializes the shell's environment for that session; a fresh shell needs the script re-run.

## Best Practices

- Always specify an explicit `-std=c17` (or `/std:c17` for MSVC) — compiler defaults vary and older defaults silently disable newer standard-library features (`stdbool.h`'s clean `bool`, `_Static_assert`, etc.).
- Compile with warnings enabled (`-Wall -Wextra` for gcc/clang, `/W4` for MSVC) — C's type system is far more permissive than C++'s (implicit pointer/int conversions, no function overloading to catch signature mismatches), so warnings catch real bugs that the compiler alone will not.
- Prefer `int main(void)` explicitly over `int main()` in new C code.

## Real-World Usage

Real C projects almost always use a build system (Make, CMake, Ninja) rather than invoking the compiler directly per file — but, exactly as this repository's C++ Lesson 01 notes, understanding the raw compile-then-link pipeline is what every one of those tools is ultimately automating underneath.

## Summary

- C compiles directly to native machine code via a compile-then-link pipeline — no VM, no managed runtime, identical model to C++ but without any of C++'s higher-level abstractions layered on top.
- `int main(void)` is the correct, explicit no-argument entry point in C.
- This course's toolchain is MSVC 19.51 via `vcvarsall.bat x64`, using `/std:c17` throughout — confirmed genuinely working, including C11 features like `<threads.h>` (Lesson 14).

## Key Terms

- **Compiler** — translates source code into object code (machine code, not yet linked).
- **Linker** — combines object files and libraries into a final executable.
- **Preprocessor** — a text-substitution pass (`#include`, `#define`, `#ifdef`) that runs *before* compilation proper (Lesson 02).

## Interview Questions

1. **What are the two main stages of building a C program, and is there a runtime step after that?**
   Compilation (each `.c` file becomes an object file of machine code) and linking (object files plus libraries become one executable). There is no further step — the linked executable is native machine code the OS runs directly, with no VM, bytecode interpreter, or managed runtime involved, same as C++ and unlike Java/C#/Python/JavaScript.

2. **Why does `int main()` behave differently in C than in C++?**
   In C, an empty parameter list in a function declaration/definition means the parameters are unspecified (the compiler won't check call-site argument counts against it), whereas in C++ an empty `()` unambiguously means "takes zero arguments" — identical to `(void)`. Writing `main(void)` explicitly in C avoids relying on this legacy ambiguity and matches what most compilers actually implement for `main` specifically, but the general rule matters for every other function you write.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
