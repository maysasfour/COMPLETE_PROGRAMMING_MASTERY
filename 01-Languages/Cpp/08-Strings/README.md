# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use `std::string` and understand it is **mutable**, unlike every other language course in this repository.
- Use common `std::string` methods.
- Use `std::string_view` (C++17+) to avoid unnecessary copies when read-only access is all that's needed.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

This is a genuine, notable departure from every other language course in this repository: **`std::string` is mutable**. Python/JavaScript/TypeScript/Java/C#'s strings are all immutable — every "modifying" method returns a new string. C++'s `std::string` can be modified in place (`+=`, `.append()`, indexed assignment), consistent with C++'s general value-semantics, mutable-by-default philosophy (Lesson 03).

## `std::string` Is Mutable

```cpp
std::string s = "hello";
s += " world";        // genuinely modifies s in place -- no new object created
s[0] = 'H';             // indexed assignment mutates in place too
std::cout << s << std::endl; // "Hello world"
```

## Common Methods

```cpp
std::string text = "  hello  ";
// C++ has no built-in .trim() until C++23's ranges -- often hand-rolled or via a library pre-C++23
std::cout << text.size() << std::endl;
std::cout << text.substr(2, 5) << std::endl; // substring: start index, length
std::string upper = text;
for (char& c : upper) c = std::toupper(static_cast<unsigned char>(c));
```

Notice there's no built-in `.trim()`/`.toUpperCase()` the way every other language course's strings have — C++'s standard library string API is comparatively low-level; common operations often require a manual loop or a `<algorithm>` call (`std::transform`), or a third-party library for convenience.

## `std::string_view` (C++17+)

```cpp
#include <string_view>

void printFirstWord(std::string_view text) { // no copy made, regardless of caller's string type
    auto spacePos = text.find(' ');
    std::cout << text.substr(0, spacePos) << std::endl;
}

printFirstWord("hello world");     // works with a string literal, no std::string constructed
printFirstWord(std::string("hi there")); // works with a std::string too, still no copy
```

`std::string_view` is a lightweight, non-owning "view" into existing string data (a pointer + length) — passing it instead of `const std::string&` avoids even the possibility of constructing a temporary `std::string` from a literal, and works uniformly whether the caller has a literal, a `std::string`, or a substring of one.

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints demonstrations of in-place string mutation, common methods (substring, manual uppercase via `<algorithm>`), and `std::string_view` used with both a literal and a `std::string`.

## Common Mistakes

- Assuming `std::string` methods return new strings the way every other language course's strings do — `+=`/indexed assignment genuinely mutate in place.
- Passing `std::string_view` and holding onto it past the lifetime of the underlying data it views — since `string_view` doesn't own the data, this is a dangling-reference bug waiting to happen.
- Expecting built-in `.trim()`/`.toUpperCase()`-style convenience methods — C++'s string API predates many such conveniences; `<algorithm>`/manual loops fill the gap.

## Best Practices

- Prefer `std::string_view` for read-only string parameters where the function doesn't need to own or outlive the caller's data.
- Be deliberate about `std::string` mutation — its mutability is a genuine capability (in-place `StringBuilder`-like efficiency without a separate type), but also a source of aliasing bugs if a reference to a string is held while it's mutated elsewhere.

## Real-World Usage

`std::string_view` is now the standard parameter type for read-only string arguments in modern C++ APIs, specifically to avoid the copy/allocation overhead `const std::string&` can still incur when the caller only has a string literal or a substring.

## Summary

- Unlike every other language course in this repository, `std::string` is mutable — `+=`, indexed assignment, and `.append()` all modify in place.
- The standard string API is comparatively low-level; `.trim()`/`.toUpperCase()`-equivalents often need `<algorithm>` or manual loops.
- `std::string_view` (C++17+) is a lightweight, non-owning view avoiding unnecessary copies for read-only string parameters.

## Key Terms

- **`std::string` mutability** — unlike every other language course here, C++ strings can be modified in place.
- **`std::string_view`** — a lightweight, non-owning view into string data, avoiding copies for read-only access.

## Interview Questions

1. **Is `std::string` mutable or immutable, and how does this compare to Python/JavaScript/Java strings?**
   `std::string` is mutable — operations like `+=`, indexed assignment (`s[0] = 'x'`), and `.append()` modify the string object in place, with no new object created. This is a direct contrast with Python, JavaScript, TypeScript, Java, and C#, all of which have immutable strings where every "modifying" operation returns a new string object.

2. **What problem does `std::string_view` solve, and what's its main risk?**
   It provides a lightweight, non-owning "view" (essentially a pointer + length) into existing string data, letting a function accept string data for read-only use without copying it or requiring a specific owning type (`std::string` vs. a literal) — it works uniformly with either. The main risk is a dangling reference: since a `string_view` doesn't own or extend the lifetime of the data it views, holding onto one after the underlying string/literal is destroyed or goes out of scope is undefined behavior.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
