# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Understand a C "string" is just a `char` array with a trailing `'\0'` — no distinct string type, no stored length.
- Use core `<string.h>` functions (`strlen`, `strcat`, `strcmp`).
- See a **real, safely-reproduced buffer overflow** from `strcpy`, and the partial fix `strncpy` provides.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Unlike every other language course in this repository (including C++'s `std::string`), C has no string type at all. A "string" is purely a convention: a `char` array (or `char*`) whose end is marked by a `'\0'` (null) byte — every `<string.h>` function works by scanning forward until it finds that byte. There is no length stored anywhere alongside the data; `strlen` recomputes it by scanning every single call. This convention is also the root cause of C's most infamous class of bug: **`strcpy` (and `sprintf`, `gets`, `strcat` without a length limit) will copy as many bytes as the source string has, with zero regard for the destination buffer's actual size** — if the source is longer than the destination, it overwrites whatever memory comes right after the buffer, silently and without error. This is not a rare edge case; it is the single most consequential category of real-world C security vulnerability (buffer overflow exploits), reproduced safely below in memory we own and can inspect, rather than left as an abstract warning.

## Syntax

```c
char greeting[20] = "Hello";
strcat(greeting, ", C!");                 /* "Hello, C!" -- greeting must have room for the result */
strlen(greeting);                          /* scans for '\0', returns length NOT counting it */
strcmp("abc", "abd");                      /* 0 = equal; nonzero otherwise -- never use == on C strings */
strncpy(dest, src, sizeof(dest) - 1);      /* caps the copy -- but does NOT guarantee null-termination */
dest[sizeof(dest) - 1] = '\0';             /* must be done manually after strncpy */
```

## Detailed Example

See [example.c](example.c) — `strlen`/`strcat`/`strcmp`, then a controlled overflow: a heap-allocated `struct Sandbox { char buffer[8]; char canary[8]; }` where `strcpy`ing a 19-character string into an 8-byte `buffer` genuinely, visibly overwrites the adjacent `canary` field, followed by the same operation done safely with `strncpy` plus manual null-termination.

## Expected Output

```
greeting = "Hello", strlen = 5, sizeof(array) = 20
after strcat: "Hello, C!"
strcmp("abc", "abc") = 0
strcmp("abc", "abd") = -1 (nonzero -- never compare C strings with ==)

Before overflow: buffer=(empty), canary="INTACT!"
After strcpy overflow: buffer="A very long string", canary="ong string" (CORRUPTED -- overwritten by the overflow)

After strncpy (capped + manually terminated): buffer="A very ", canary="INTACT!" (intact)
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` (with `#define _CRT_SECURE_NO_WARNINGS` at the top, since MSVC deprecates `strcpy` by default — the whole point of this lesson is to show the real, un-"improved" function's actual behavior). **Two things confirmed live, worth calling out honestly:**

- The overflow was deliberately contained to a **heap-allocated** struct, not a stack local — MSVC's `/GS` stack-protector would detect a similar overflow on the call stack and abort the process outright (`__fastfail`), which would prevent observing the corruption at all rather than demonstrate it. Heap memory has no equivalent runtime guard by default, so the corruption is genuinely visible instead of crashing.
- The overflow's actual reach turned out to be the *entire* 19-character string, not just the 8 bytes needed to reach `canary` — `strcpy` doesn't stop at the struct's boundary at all; it kept writing past `canary` too, into whatever heap memory followed (in this run, apparently still-valid, readable memory, since the program didn't crash and `free()` succeeded normally afterward). This is exactly the "no guaranteed behavior, just undefined behavior that happened not to crash this time" nature of a real buffer overflow — a genuinely different, and more unsettling, outcome than "it neatly stopped at the next field," worth reporting honestly rather than smoothing over.

## Common Mistakes

- Comparing C strings with `==` — this compares **pointer addresses**, not contents; two different `char*` values holding identical text compare unequal with `==`. Always use `strcmp` (`0` means equal).
- Using `strcpy`/`strcat`/`sprintf` with no length limit on untrusted or variable-length input — exactly the bug reproduced above; there is no bounds checking of any kind in these functions.
- Assuming `strncpy` null-terminates its destination automatically — it does **not**, if the source is at least as long as the given length; the manual `dest[len-1] = '\0'` step (shown in `example.c`) is required every time.

## Best Practices

- Prefer `strncpy`/`snprintf`/`strncat` (or, in newer code, `strcpy_s`/`strcat_s` where available) over their unbounded counterparts for anything touching variable-length or untrusted input, always pairing `strncpy` with an explicit manual null-termination step.
- Always allocate string buffers with enough room for the worst case you actually expect, and validate/truncate input length before copying into a fixed buffer.
- Use `strcmp`/`strncmp`, never `==`, to compare C string contents.

## Real-World Usage

Buffer overflow vulnerabilities from unbounded `strcpy`/`sprintf`/`gets` calls are one of the most historically significant categories of real-world security exploits in C software (including famous worms/CVEs) — this is precisely why modern C code (and compilers, which now warn/deprecate the worst offenders) pushes hard toward the bounded alternatives shown here.

## Summary

- A C string is just a `char` array/pointer with a trailing `'\0'` — no length is stored; every `<string.h>` function scans for it.
- `strcpy` has zero bounds checking — genuinely, safely reproduced here overwriting adjacent heap memory when the source is longer than the destination.
- `strncpy` caps the copy length but does **not** guarantee null-termination — that must be done manually.

## Key Terms

- **Null-terminated string** — a `char` array whose logical end is marked by a `'\0'` byte, not a stored length.
- **Buffer overflow** — writing past the end of a fixed-size buffer, corrupting adjacent memory; the root cause of a huge class of real-world C security vulnerabilities.

## Interview Questions

1. **What is a C string, structurally, and why does that make `strlen` an O(n) operation every single call?**
   A C string is just a `char` array (or `char*`) whose logical end is marked by a `'\0'` byte — there is no length stored anywhere alongside the data. `strlen` has no choice but to scan byte-by-byte from the start until it finds that `'\0'`, making it O(n) on every call, unlike a length-prefixed string type (e.g., most other languages in this repository) where length is an O(1) stored field.

2. **Why is `strcpy` considered dangerous, and what did the reproduced demonstration in this lesson actually show?**
   `strcpy` copies bytes from the source until it hits the source's `'\0'`, with absolutely no awareness of the destination buffer's actual size — if the source is longer, it silently overwrites whatever memory follows the destination. This lesson reproduced it safely (in a heap-allocated struct, not the real call stack) by `strcpy`-ing a 19-character string into an 8-byte buffer and showing the immediately adjacent `canary` field's contents visibly corrupted afterward — and further observed that the overwrite wasn't even neatly contained to the next field, but continued writing the full source string into whatever heap memory followed, exactly the "no guaranteed behavior" nature that makes real buffer overflows dangerous.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
