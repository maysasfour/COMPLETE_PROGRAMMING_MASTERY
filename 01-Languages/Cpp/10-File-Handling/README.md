# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files with `<fstream>`.
- Understand RAII closes file streams automatically (extending Lesson 09's point).
- Understand the C++ standard library has no built-in JSON library, matching the Java course's honest gap.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`<fstream>` provides `std::ifstream` (input), `std::ofstream` (output), and `std::fstream` (both) for file I/O — all RAII types whose destructors automatically close the underlying file handle when they go out of scope, with no explicit `.close()` call required (though calling it explicitly is fine and sometimes useful to flush early). Like Java, the C++ standard library has **no built-in JSON library** — real projects reach for a third-party library (nlohmann/json is the most popular).

## Reading and Writing Text Files

```cpp
#include <fstream>
#include <string>

std::ofstream outFile("notes.txt");
outFile << "Hello, file system!" << std::endl;
outFile.close(); // optional here -- RAII would close it anyway when outFile goes out of scope

std::ifstream inFile("notes.txt");
std::string line;
std::getline(inFile, line);
std::cout << line << std::endl;
```

## Handling a Missing File

```cpp
std::ifstream file("does-not-exist.txt");
if (!file.is_open()) {
    std::cout << "File doesn't exist -- using defaults" << std::endl;
}
```

Unlike Python/Node/Java/C#, `<fstream>` does **not** throw an exception for a missing file by default — `std::ifstream`'s constructor simply leaves the stream in a "failed" state, checkable via `.is_open()` or the stream's boolean conversion (`if (!file)`). This is a genuinely different error-handling convention from every other language course's file-handling lesson.

## Detailed Example

See [example.cpp](example.cpp) — writes and reads a text file, and handles a genuinely missing file via the stream-state check (not an exception).

## Expected Output

Compiling and running `example.cpp` prints round-tripped text content and confirms a missing file is detected via `.is_open()`/boolean stream conversion, not an exception.

## Common Mistakes

- Expecting `std::ifstream`'s constructor to throw for a missing file, the way Python/Node/Java/C#'s file APIs do — it doesn't, by default; check `.is_open()` or the stream's boolean state instead.
- Assuming the JDK's-equivalent gap (no built-in JSON) doesn't apply to C++ too — it does; nlohmann/json (a third-party library, via a package manager like vcpkg/Conan, Lesson 15) is the near-universal real-world solution.

## Best Practices

- Always check `.is_open()` (or `if (!file)`) after opening a file, since the default behavior is silent failure, not an exception.
- Rely on RAII for closing files — an explicit `.close()` is rarely necessary except to flush/release a resource earlier than the enclosing scope's end.

## Real-World Usage

Real C++ projects handling JSON add nlohmann/json (or a similar library) as a dependency via vcpkg/Conan (Lesson 15) — the same "the standard library doesn't include this, everyone adds the same third-party library" situation as Java's Jackson dependency.

## Summary

- `<fstream>`'s stream types are RAII — files close automatically when the stream object goes out of scope.
- Unlike most other language courses, a missing file does **not** throw by default — check `.is_open()`/boolean stream state instead.
- The C++ standard library has no built-in JSON library, matching the Java course's honest gap.

## Key Terms

- **`<fstream>`** — the standard library header providing file stream types (`ifstream`, `ofstream`, `fstream`).
- **Stream state** — a stream's internal success/failure flags, checked via `.is_open()` or boolean conversion, C++'s default (non-exception) file-error-reporting mechanism.

## Interview Questions

1. **Does opening a missing file with `std::ifstream` throw an exception by default?**
   No — unlike most other languages covered in this repository, `std::ifstream`'s constructor for a missing file does not throw by default; it leaves the stream object in a "failed" state, checkable via `.is_open()` or the stream's boolean conversion operator (`if (!file)`). Exception-throwing behavior can be explicitly enabled via `file.exceptions(...)`, but it's opt-in, not the default.

2. **Does the C++ standard library include JSON support?**
   No — like Java's JDK, the C++ standard library has no built-in JSON parsing/serialization. Real projects universally add a third-party library (most commonly nlohmann/json) via a package manager (vcpkg or Conan, Lesson 15) to handle JSON.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
