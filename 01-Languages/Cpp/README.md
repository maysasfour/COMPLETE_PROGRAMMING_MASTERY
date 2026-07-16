# C++

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What C++ Is

C++ is a statically-typed, compiled, multi-paradigm systems language — a superset of C with added OOP, generics (templates), and (since C++11) substantial modern conveniences (`auto`, lambdas, smart pointers, ranged `for`). Unlike every other language in this repository so far, C++ compiles **directly to native machine code** with no managed runtime, no garbage collector, and no virtual machine — you are responsible for memory management, mitigated in modern C++ by RAII and smart pointers (Lesson 19) rather than manual `malloc`/`free`.

## Why / Where It's Used

- **Performance-critical software** — game engines (Unreal Engine), high-frequency trading, real-time audio/video processing, and anything where garbage-collection pauses or managed-runtime overhead are unacceptable.
- **Systems programming** — operating system components, device drivers, embedded systems.
- **Large desktop applications** — Chrome, Adobe's Creative Suite, and most major native desktop software have substantial C++ codebases.
- **Foundational infrastructure** — many other languages' runtimes (Python's CPython, Node's V8) are themselves written in C++.

## Advantages

- No runtime overhead — no garbage collector pauses, no JIT warmup, direct hardware access when needed.
- Complete control over memory layout and allocation, essential for real-time and resource-constrained systems.
- Templates (Lesson 13) provide genuine zero-cost-abstraction generics, resolved entirely at compile time.
- Decades of mature tooling, an enormous existing codebase, and the highest achievable raw performance ceiling of any language in this repository.

## Disadvantages

- Manual memory management (even with RAII/smart pointers) is a real, ongoing source of bugs (dangling pointers, use-after-free, memory leaks) that garbage-collected languages simply don't have.
- Compile times can be significant for large projects; no single canonical build tool (CMake is the closest to a standard, but far from universal).
- A famously large, complex language surface area — this course covers the essentials, not the full breadth of modern C++'s features.
- No built-in package manager, JSON library, or HTTP client in the standard library — third-party libraries and a package manager (vcpkg/Conan) are needed for common tasks, more so than any other language course in this repository.

## How to Install

```bash
# Windows: Visual Studio (MSVC) or MinGW-w64 (g++)
# macOS: Xcode Command Line Tools (clang++) or Homebrew's gcc
# Linux: g++ or clang++ via your package manager

g++ --version    # or clang++ --version, or (on Windows) cl.exe via a Developer Command Prompt
```

This course was written and verified against **MSVC 19.51 (Visual Studio 2026)** targeting the **C++20** standard, but everything in it works with any C++17-or-later compiler (g++, clang++, or MSVC) unless a lesson says otherwise.

## How to Run the Examples

Every lesson folder has a `README.md` and a compilable `example.cpp`. From the repository root:

```bash
cd 01-Languages/Cpp/03-Variables-and-Data-Types
g++ -std=c++20 example.cpp -o example && ./example       # g++/clang++
# or, from an MSVC Developer Command Prompt:
cl /EHsc /std:c++20 example.cpp && example.exe
```

## Common Beginner Mistakes

- **Assuming C++ has a garbage collector** — it doesn't; forgetting to `delete` manually-allocated memory leaks it, and modern C++ solves this with RAII/smart pointers (Lesson 19), not automatic collection.
- **Confusing a reference (`T&`) with a pointer (`T*`)** — a reference cannot be null and cannot be reseated after initialization; a pointer can be either (Lesson 03).
- **Off-by-one/out-of-bounds access on `std::vector`/arrays** — unlike Python/JavaScript/Java, `operator[]` performs **no bounds checking** by default; use `.at()` for a checked, exception-throwing alternative.
- **Slicing** — assigning a derived-class object to a base-class-by-value variable copies only the base portion, silently discarding derived-specific data (Lesson 11) — use references/pointers for polymorphism, never pass-by-value.

## Best Practices

- Prefer smart pointers (`std::unique_ptr`, `std::shared_ptr`) over raw `new`/`delete` for owned resources (Lesson 19).
- Prefer references over pointers when null isn't a valid state and reseating isn't needed.
- Use `const` aggressively for anything that shouldn't be mutated — the compiler enforces it.
- Use range-based `for` and the `<algorithm>` header's functions over manual index-based loops wherever they fit.

## Interview Questions

1. **Why doesn't C++ have a garbage collector, and how does modern C++ manage memory safely without one?**
   C++ is designed for zero-overhead abstractions and predictable performance, which a garbage collector's pauses and overhead would compromise — this is a deliberate design trade-off for the control systems/performance-critical software need. Modern C++ (post-C++11) manages memory safely primarily through RAII (Resource Acquisition Is Initialization) and smart pointers (`unique_ptr`/`shared_ptr`), which automatically release resources when they go out of scope, without needing a separate collector process.

2. **What's the difference between a reference and a pointer in C++?**
   A reference (`T&`) must be initialized when declared, can never be null, and can never be reseated to refer to a different object afterward. A pointer (`T*`) can be null, can be reassigned to point elsewhere, and requires explicit dereferencing (`*ptr`) to access the pointed-to value, whereas a reference is used exactly like the underlying variable with no special syntax.

3. **What is "slicing" in C++, and how do you avoid it?**
   When a derived-class object is assigned or passed by value to a base-class variable/parameter, only the base-class portion is copied — any derived-specific data and the object's actual polymorphic behavior are lost ("sliced off"). The fix is to always use references or pointers (`Base&`, `Base*`) for polymorphic behavior, never pass-by-value for a type meant to be used polymorphically.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Compiler install, compiling and running a single file |
| 02 | [Syntax](02-Syntax/README.md) | `#include`, `main`, statements, comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Value semantics, references vs. pointers, `auto`, `const` |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/logical, pointer dereference, `nullptr` |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/switch, range-based `for`, structured bindings |
| 06 | [Functions](06-Functions/README.md) | Overloading, default arguments, references vs. value parameters |
| 07 | [Collections](07-Collections/README.md) | `std::vector`, `std::map`, `std::set`, `<algorithm>` |
| 08 | [Strings](08-Strings/README.md) | `std::string`, mutability, `std::string_view` |
| 09 | [Error Handling](09-Error-Handling/README.md) | try/catch, exceptions, RAII |
| 10 | [File Handling](10-File-Handling/README.md) | `<fstream>`, no built-in JSON |
| 11 | [OOP](11-OOP/README.md) | Classes, inheritance, virtual functions, abstract classes, slicing |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Lambdas, `std::function`, `<algorithm>` with lambdas |
| 13 | [Generics](13-Generics/README.md) | Templates: compile-time generics, contrasted with Java erasure and C# reification |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | `std::thread`, `std::async`, `std::future` |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Headers, translation units, namespaces, CMake |
| 16 | [Database Access](16-Database-Access/README.md) | SQLite C API |
| 17 | [API Integration](17-API-Integration/README.md) | No built-in HTTP client; libcurl overview |
| 18 | [Testing](18-Testing/README.md) | Assertion-based testing and a look at Catch2 |
| 19 | [Best Practices](19-Best-Practices/README.md) | RAII, smart pointers, the Rule of Three/Five, synthesis |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-07* |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs.

**Previous language:** [Java](../Java/README.md) | **Next:** [Go](../Go/README.md)
