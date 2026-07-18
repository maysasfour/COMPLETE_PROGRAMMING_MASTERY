# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Know C's primitive types and that their sizes are platform/compiler-defined minimums, not fixed values.
- Understand that `bool` does not exist in C at all until `<stdbool.h>` (C99) or natively in C23 — it is not a keyword the way it is in every other language this repository covers.
- Understand C's much weaker `const` compared to C++'s.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

C's primitive types (`char`, `short`, `int`, `long`, `long long`, `float`, `double`, their `unsigned` variants) are the same types C++ inherited unchanged — but C makes their manual-sizing nature more visible, since C lacks C++'s `<cstdint>` convenience of habitually reaching for fixed-width types, and (until C99's `<stdint.h>`, which C also has and should be preferred in new code) had no standard fixed-width integer types at all. The C standard only guarantees **minimum** sizes and relative orderings (`sizeof(short) <= sizeof(int) <= sizeof(long) <= sizeof(long long)`), not exact widths — a genuinely observed difference below.

## The `long` Size Trap, Confirmed Live

```c
printf("sizeof(long) = %zu bytes\n", sizeof(long));
```

On this Windows/MSVC toolchain, `sizeof(long)` is genuinely **4 bytes** (MSVC uses the LLP64 data model: `long` stays 32-bit even in 64-bit builds), while on Linux/macOS (LP64), `sizeof(long)` is **8 bytes**. This is not a hypothetical — it is a real, frequently-encountered cross-platform C portability trap, and the exact reason `<stdint.h>`'s `int32_t`/`int64_t`/`uint64_t` (fixed-width, guaranteed on every platform) are strongly preferred over bare `long` in any code that needs a specific width or is meant to be portable.

## No Boolean Type Without `<stdbool.h>`

Unlike every other language course in this repository, C has **no boolean keyword at all** in C89/C90/C99-without-the-header. `<stdbool.h>` (C99) `#define`s `bool` to the real underlying type `_Bool`, plus `true`/`false` macros to `1`/`0`. Pre-C99 C code (and plenty of real, still-maintained C code today) uses plain `int` for booleans: `0` means false, anything nonzero means true. C23 finally makes `bool`/`true`/`false` genuine keywords needing no include — but this course's MSVC toolchain reports `/std:clatest` as still C17-based, not C23, so `<stdbool.h>` remains necessary here.

## Syntax

```c
#include <stdbool.h>
#include <limits.h>

int i = -7;
unsigned int ui = 4000000000U;
long l = 100000L;
bool isReady = true;               /* requires <stdbool.h> */
const int maxRetries = 3;          /* weaker guarantee than C++'s const -- see below */
```

## Detailed Example

See [example.c](example.c) — prints every primitive type's value and `sizeof`, confirms the `long` size on this platform, and demonstrates `<stdbool.h>`'s `bool`.

## Expected Output

```
char c = A, sizeof(char) = 1 byte
short s = 32000, sizeof(short) = 2 bytes
int i = -7, sizeof(int) = 4 bytes, INT_MAX = 2147483647
long l = 100000, sizeof(long) = 4 bytes
long long ll = 9000000000, sizeof(long long) = 8 bytes
unsigned int ui = 4000000000
float f = 3.140000, sizeof(float) = 4 bytes
double d = 3.14159265359, sizeof(double) = 8 bytes
bool isReady = 1 (stdbool.h's bool is just _Bool; %d is the only correct printf spec for it)
maxRetries = 3
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, confirming `sizeof(long) == 4` on this MSVC/Windows toolchain, as described above.

## Common Mistakes

- Assuming `int`/`long` have the same width on every platform — genuinely false, as shown above; use `<stdint.h>`'s `int32_t`/`int64_t` when an exact width matters.
- Using `bool`/`true`/`false` without `#include <stdbool.h>` — a hard compile error pre-C23 (`bool` is simply an undeclared identifier), unlike C++ where `bool` is a real keyword needing no include.
- Printing a `bool` with anything other than `%d` — there is no `%b`; `_Bool`/`bool` promotes to `int` when passed to a variadic function like `printf`, so `%d` is correct and the only sane choice.

## Best Practices

- Prefer `<stdint.h>`'s fixed-width types (`int32_t`, `uint64_t`, etc.) whenever an exact width matters, rather than bare `int`/`long`.
- Always `#include <stdbool.h>` in new C code needing a boolean — it costs nothing and documents intent clearly, versus a bare `int` used as a boolean.
- Use `const` for any variable that shouldn't be reassigned, understanding it is a compiler-enforced *read-only view*, not a true `constexpr`-style compile-time constant the way C++'s `constexpr` is.

## Real-World Usage

Network protocol/file-format code (which cares about exact byte widths crossing platforms) almost universally uses `<stdint.h>` types instead of bare `int`/`long`, precisely because of the portability trap demonstrated above.

## Summary

- C's primitive type sizes are platform/compiler-defined minimums, not fixed values — genuinely confirmed here: `sizeof(long) == 4` on this MSVC/Windows build, vs. `8` on Linux/macOS.
- `bool` does not exist without `<stdbool.h>` (or natively in C23, not yet used by this toolchain) — pre-C99 C uses plain `int` for booleans.
- `const` in C is weaker than in C++: a read-only view of a variable, not a genuine compile-time constant.

## Key Terms

- **LP64 / LLP64** — two competing 64-bit data models; Linux/macOS use LP64 (`long` is 64-bit), Windows/MSVC uses LLP64 (`long` stays 32-bit, `long long` is the 64-bit type).
- **`_Bool`** — the real underlying C99 boolean type; `<stdbool.h>`'s `bool` is just a macro alias for it.

## Interview Questions

1. **Is `sizeof(long)` guaranteed to be the same on every platform? What did you observe on this toolchain?**
   No — the C standard only guarantees minimum sizes and relative orderings between integer types, not exact widths. On this MSVC/Windows (LLP64) toolchain, `sizeof(long)` is genuinely 4 bytes, confirmed by compiling and running `example.c`; on Linux/macOS (LP64), it would be 8. This is why portable C code needing a specific width uses `<stdint.h>`'s `int32_t`/`int64_t` instead of bare `long`.

2. **Does C have a native boolean type? How does `bool` work in `<stdbool.h>`?**
   Not until C23 as a real keyword — pre-C23 C has no boolean type at all, and `<stdbool.h>` (C99) merely `#define`s `bool` as a macro for the real type `_Bool`, plus `true`/`false` as macros for `1`/`0`. Code that predates C99, or that avoids the header, uses plain `int` for booleans instead, a genuine and still-common C idiom absent from every other language in this repository.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
