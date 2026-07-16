# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Understand the header (`.hpp`)/source (`.cpp`) split and why templates break this convention (Lesson 13's callback).
- Use `namespace` to organize code.
- Use include guards (`#pragma once`) to prevent double-inclusion errors.
- Understand CMake and vcpkg/Conan as the closest things C++ has to a standard build tool and package manager.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

C++ splits a component's **declaration** (what exists — function signatures, class definitions, going in a `.hpp`/`.h` header) from its **definition** (how it works — going in a `.cpp` source file, compiled once into its own object file). Other `.cpp` files that need to call into it `#include` the header (getting the declarations) and the **linker** resolves the actual calls to whichever object file contains the real implementation — genuinely different from every other language in this repository, none of which separate declaration from definition this way.

## Header/Source Split

```cpp
// mathutils.hpp -- declarations only
#pragma once
namespace mathutils {
    int add(int a, int b);
}
```

```cpp
// mathutils.cpp -- the actual implementation, compiled once into its own object file
#include "mathutils.hpp"
namespace mathutils {
    int add(int a, int b) { return a + b; }
}
```

```cpp
// main.cpp -- a different file, sees only the DECLARATION at compile time
#include "mathutils.hpp"
int main() {
    return mathutils::add(2, 3); // resolved by the LINKER to mathutils.cpp's compiled implementation
}
```

```bash
g++ -std=c++20 main.cpp mathutils.cpp -o app && ./app
```

`#pragma once` (a near-universal, though non-standard, alternative to old-style `#ifndef`/`#define`/`#endif` include guards) prevents a header's contents from being pasted in more than once into the same translation unit — without it, `#include`-ing the same header from two different places (directly and transitively) would cause duplicate-definition compile errors.

## Namespaces

```cpp
namespace mathutils {
    int add(int a, int b);
}

mathutils::add(2, 3); // fully qualified
using namespace mathutils; // brings all names into scope -- use sparingly, avoid in headers
add(2, 3);              // now unqualified, but riskier (name collisions)
```

## CMake and Package Managers

```cmake
# CMakeLists.txt (simplified)
cmake_minimum_required(VERSION 3.20)
project(MyApp)
add_executable(MyApp main.cpp mathutils.cpp)
```

Unlike every other language course, C++ has **no single official build tool or package manager** — CMake is the closest thing to a de facto standard build system (generating platform-specific build files for whatever compiler/IDE you use), and **vcpkg** or **Conan** are the closest things to standard package managers, both far less universally adopted than npm/NuGet/pip/Maven are in their respective ecosystems.

## Detailed Example

See [mathutils.hpp](mathutils.hpp), [mathutils.cpp](mathutils.cpp), and [main.cpp](main.cpp) — a genuine multi-file example with a header/source split and a `namespace`.

## Run It

```bash
cd 01-Languages/Cpp/15-Modules-and-Packages
g++ -std=c++20 main.cpp mathutils.cpp -o app && ./app
# or, from an MSVC Developer Command Prompt:
cl /EHsc /std:c++20 /Zc:__cplusplus main.cpp mathutils.cpp /Fe:app.exe && app.exe
```

## Expected Output

Compiling both `.cpp` files together and running the resulting executable prints results from `mathutils::add`/`mathutils::multiply`, whose actual implementations live in a separate translation unit from `main.cpp`, connected only by the shared header at compile time and the linker at link time.

## Common Mistakes

- Forgetting an include guard (`#pragma once` or `#ifndef`/`#define`/`#endif`), causing duplicate-definition errors when a header is included (directly or transitively) more than once in the same translation unit.
- Putting `using namespace X;` in a header file — this pollutes every file that includes it with `X`'s names, a common source of naming collisions in larger projects.
- Forgetting to compile/link **every** `.cpp` file a program needs — a header alone provides no implementation; omitting `mathutils.cpp` from the build produces a linker error ("unresolved external symbol"), not a compiler error.

## Best Practices

- Always use an include guard in every header.
- Avoid `using namespace X;` in headers; it's more acceptable (though still often discouraged) inside a single `.cpp` file's implementation.
- Use CMake for any real project — while not universal, it's the closest thing to a portable standard and is supported by essentially every modern C++ IDE.

## Real-World Usage

Every substantial real-world C++ project uses CMake (or occasionally a similar tool) plus vcpkg/Conan for dependencies — Lessons 16-18's external dependencies (a SQLite library, an HTTP library, a testing framework) would all be declared this way in a real project rather than manually downloaded, similar in spirit to Maven/Gradle for Java.

## Summary

- C++ splits declarations (headers) from definitions (source files); other files `#include` the header and the linker resolves the actual implementation.
- Include guards (`#pragma once`) prevent duplicate-inclusion compile errors.
- CMake and vcpkg/Conan are the closest things to standard build tools/package managers, notably less universal than the equivalent tools in every other language course.

## Key Terms

- **Header file (`.hpp`/`.h`)** — contains declarations, included by any file needing to call into the declared component.
- **Include guard** — a mechanism (`#pragma once`, or `#ifndef`/`#define`/`#endif`) preventing a header's contents from being processed more than once per translation unit.
- **Linker error** — an error at the link stage (not compile stage) when a declared-but-not-implemented (or not-linked-in) symbol is referenced.

## Interview Questions

1. **Why does C++ split code into header and source files, unlike Java/C#/Python/JavaScript?**
   Because C++ compiles each `.cpp` file (translation unit) independently into an object file — a header lets other translation units see a component's *declarations* (enough to compile calls to it) without needing its full implementation at compile time; the linker later resolves those calls to whichever object file actually contains the implementation. Managed languages typically compile/interpret a whole project together (or use a module system) without this separate compile-then-link model, so they have no equivalent need for header/source separation.

2. **What does `#pragma once` do, and what happens without it?**
   It ensures a header file's contents are only processed once per translation unit, even if `#include`-d multiple times (directly or transitively through other headers). Without it, if the same header ends up included twice in one translation unit, every declaration/definition inside gets pasted in twice, causing "redefinition" compile errors.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
