# C

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What C Is

C is a statically-typed, compiled, procedural systems language — the direct ancestor of C++ (and, through it, indirectly of Java, C#, JavaScript's syntax family). It compiles straight to native machine code with no virtual machine, no managed runtime, and no garbage collector — the same execution model as this repository's C++ course, but with every higher-level feature C++ adds (classes, exceptions, templates, RAII, smart pointers) stripped away. What remains is exactly what this course teaches: functions, structs, raw pointers, manual memory management, and a standard library small enough to read in an afternoon.

## Why / Where It's Used

- **Operating systems and kernels** — Linux, Windows, and macOS all have C at their core; the Linux kernel is written almost entirely in C.
- **Embedded systems and firmware** — microcontrollers, IoT devices, and anything with tight memory/performance constraints and no room for a runtime.
- **Foundational libraries** — SQLite, zlib, OpenSSL, and most language runtimes' own C extension interfaces (Python's C API, Node's native addons) are written in or expose a C ABI, because C's calling convention is the universal cross-language interop standard.
- **Performance-critical, resource-constrained software** — anywhere C++'s abstractions (even zero-cost ones) or a managed runtime's overhead are unacceptable.

## Advantages

- The smallest, most stable language surface in this repository — the entire language fits in roughly 32 keywords, with a standard library small enough to have not meaningfully grown since C99.
- Direct, total control over memory layout and allocation, with a predictable, minimal-overhead execution model — no hidden allocations, no hidden virtual dispatch, no hidden exception-unwinding machinery.
- Universal binary interoperability — nearly every other language in this repository can call into a C library directly (FFI), because the C ABI is the de facto standard every platform and language agrees on.
- Decades of maturity: the toolchains, debuggers, and static analyzers for C are exceptionally mature and battle-tested.

## Disadvantages

- Zero memory safety net of any kind — not even C++'s optional RAII/smart pointers (Lesson 19). Every `malloc` needs a manually paired `free`; every buffer access needs manually verified bounds. This is the single largest source of real-world security vulnerabilities in C code (buffer overflows, use-after-free, double-free).
- No exceptions (Lesson 09) — error handling is a return-code convention with no compiler enforcement that a caller actually checks it.
- No generics of any kind (Lesson 13) — not even C++'s templates; reusable "generic" code in C relies on `void*` and manual type-unsafety, or code duplication via macros.
- No built-in database access, no built-in HTTP client, no built-in test framework, no built-in dynamic array/hash map — this course's later lessons show what filling each of those gaps by hand (or via a third-party C library) actually looks like.

## How to Install

```powershell
where cl      # MSVC, via a Visual Studio Developer Command Prompt
where gcc     # MinGW-w64 (Windows) or your Linux/macOS package manager
where clang   # Xcode Command Line Tools (macOS) or LLVM (Linux/Windows)
```

This course was written and verified against **MSVC 19.51 (Visual Studio 2026)**, using `/std:c17`, initialized via `vcvarsall.bat` since `cl.exe` is not on `PATH` by default:

```powershell
& "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
cl /std:c17 example.c
.\example.exe
```

Everything in this course also works with `gcc -std=c17` or `clang -std=c17` on Linux/macOS unless a lesson says otherwise (Lesson 16's SQLite amalgamation and Lesson 22's mini-project are the two places most likely to need a platform-specific tweak to the compile command).

## How to Run the Examples

Every lesson folder has a `README.md` and a compilable `example.c`. From the repository root:

```bash
cd 01-Languages/C/03-Variables-and-Data-Types
gcc -std=c17 example.c -o example && ./example        # gcc/clang
# or, from an MSVC Developer Command Prompt:
cl /std:c17 example.c && example.exe
```

Lessons with a header/source split (15, and the Lesson 22 mini-project) compile multiple `.c` files in one invocation, e.g. `cl /std:c17 main.c shapes.c /Fe:app.exe`. Lesson 16 and the Lesson 22 mini-project additionally require downloading the SQLite amalgamation first — see their own READMEs for the exact `curl`/`unzip` commands.

## Common Beginner Mistakes

- **`int main()` vs. `int main(void)`** — in C, an empty parameter list means "unspecified parameters," not "zero parameters," unlike C++. Always write `main(void)` explicitly (Lesson 01).
- **Assuming `malloc`'d memory is zeroed** — it isn't; only `calloc` zero-initializes. Reading a `malloc`'d block before writing to it reads garbage.
- **Forgetting a matching `free` on every exit path**, including early returns and error branches — this is the single most common source of real C memory leaks (Lesson 19).
- **Comparing C strings with `==`** — this compares pointer addresses, not contents; always use `strcmp` (Lesson 08).
- **Off-by-one buffer writes** — `strcpy`/`sprintf` perform no bounds checking at all; a buffer declared `char buf[8]` will silently accept (and corrupt memory with) a longer write (Lesson 19).

## Best Practices

- Compile with warnings enabled (`-Wall -Wextra` for gcc/clang, `/W4` for MSVC) at all times — C's permissive type system lets far more real bugs through silently than C++'s does.
- Pair every `malloc`/`calloc`/`realloc` with exactly one `free`, on every code path; make the pairing visually obvious in code review (Lesson 19).
- Prefer `strncpy`/`snprintf` (with explicit NUL-termination) over `strcpy`/`sprintf` for anything not provably bounded (Lesson 19).
- Mark every pointer parameter that only reads through it as `const` — it's free at runtime and turns accidental-mutation bugs into compile errors (Lesson 19).
- Check every return code that can signal failure — nothing in the language forces this, unlike an uncaught exception (Lesson 09).

## Interview Questions

1. **Why does C have no exceptions, and how do real C programs handle errors?**
   C has no exception mechanism at the language level at all — no `try`/`catch`/`throw`. Error handling is a return-code convention: functions signal failure through their return value (a sentinel like `-1`/`NULL`, or a status code with an out-parameter), and it is entirely the caller's responsibility to check it, with nothing in the compiler enforcing that. The standard library additionally exposes the global `errno`, readable via `strerror()`.

2. **What is the difference between `malloc` and `calloc`, and why does it matter?**
   `malloc(size)` allocates `size` bytes of uninitialized memory — reading it before writing produces garbage (indeterminate) values. `calloc(count, size)` allocates `count * size` bytes and zero-initializes every byte. This matters because code that assumes `malloc`'d memory starts at zero (a common Java/C#/Python habit carried over incorrectly) has a real, live bug reading uninitialized memory.

3. **Why does C have no generics, and how do real C libraries write reusable, type-independent code?**
   C has no template/generic mechanism of any kind, not even C++'s compile-time templates. Real C code reaches for `void*` (with the caller tracking the actual type out-of-band, as `qsort`'s comparator does) for type-erased generic containers, or uses macros to generate near-duplicate type-specific code at preprocessing time (the technique behind many "generic container" C libraries) — both are workarounds, not a language feature.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Compiler install (MSVC via `vcvarsall.bat`), compile-then-link pipeline |
| 02 | [Syntax](02-Syntax/README.md) | `#include`, preprocessor, `main(void)` vs. `main()` |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Primitive types, `sizeof`, `const`, pointers |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/logical/bitwise, pointer arithmetic |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/switch/loops — Exercises/Solutions included |
| 06 | [Functions](06-Functions/README.md) | Declarations, pass-by-value, pointer parameters for output — Exercises/Solutions included |
| 07 | [Collections](07-Collections/README.md) | Fixed-size arrays, no built-in dynamic array — Exercises/Solutions included |
| 08 | [Strings](08-Strings/README.md) | NUL-terminated `char*`, `<string.h>`, no `std::string` |
| 09 | [Error Handling](09-Error-Handling/README.md) | Return codes, `errno`/`strerror`, `setjmp`/`longjmp` |
| 10 | [File Handling](10-File-Handling/README.md) | `<stdio.h>` `FILE*`, `fopen`/`fread`/`fwrite` |
| 11 | [Structs and Unions](11-Structs-and-Unions/README.md) | `struct`/`union`, C's stand-in for objects |
| 12 | [Function Pointers and Callbacks](12-Function-Pointers-and-Callbacks/README.md) | Raw function pointers, C's stand-in for higher-order functions |
| 13 | [No Generics](13-No-Generics/README.md) | Why C has none, `void*`-based and macro-based workarounds |
| 14 | [Threads and Concurrency](14-Threads-and-Concurrency/README.md) | C11 `<threads.h>` |
| 15 | [Modules and Header Files](15-Modules-and-Header-Files/README.md) | Header/source split, include guards, translation units |
| 16 | [Database Access](16-Database-Access/README.md) | Raw SQLite C API |
| 17 | [API Integration](17-API-Integration/README.md) | No built-in HTTP client |
| 18 | [Testing](18-Testing/README.md) | No built-in test framework; a hand-rolled `minitest.h` harness |
| 19 | [Best Practices](19-Best-Practices/README.md) | Manual memory discipline, buffer safety, const-correctness |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone problems: pointer arithmetic, dynamic array, struct-object, callbacks, linked list, header/source split, `strtok` |
| 21 | [Solutions](21-Solutions/README.md) | Worked, compiled-and-run solutions to all 7 exercises |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — raw SQLite C API, header/source split, `minitest.h` test suite |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 22 in order. Lessons 05, 06, and 07 have their own `Exercises/`/`Solutions/` pairs; 20-22 are standalone, course-spanning Exercises/Solutions/Mini-Project folders to tackle after finishing 01-19.

**Previous language:** [C++](../Cpp/README.md)
