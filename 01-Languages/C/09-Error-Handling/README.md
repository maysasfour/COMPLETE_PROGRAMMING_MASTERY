# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Understand C has **no exceptions at all** — no `try`/`catch`/`throw` exists as a language concept.
- Use the return-code convention and `errno`/`strerror` for standard-library failures.
- Know `setjmp`/`longjmp` as a rarely-used non-local jump escape hatch, and why it's not a real exception mechanism.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Every other language in this repository has some form of exception handling (`try`/`catch`, `Result`/`Option` types, or both). **C has neither** — not a restricted version, genuinely none. Error handling in C is a convention, not a language feature: a function signals failure through its **return value** (a sentinel like `-1`, `NULL`, or a separate `int` status code alongside an out-parameter), and it is entirely the caller's responsibility to check it — nothing in the language forces this, and forgetting to check a return code is silently legal, unlike an uncaught exception which at least crashes loudly. The standard library additionally uses a global `errno` variable, set by many functions on failure and readable via `strerror()` for a human-readable message. `setjmp`/`longjmp` (from `<setjmp.h>`) provide a genuine non-local jump — saving a point in the call stack and later jumping back to it, skipping any number of intervening function calls — but it performs **no automatic cleanup** of anything along the way (no destructors exist to run, unlike a C++ exception unwinding through RAII objects), so it is a niche tool, not a substitute for real exception handling.

## Syntax

```c
int divide(int a, int b, int* result) {
    if (b == 0) return -1;        /* failure: signaled via return value */
    *result = a / b;
    return 0;                      /* success */
}

/* errno + strerror for standard-library failures: */
errno = 0;                          /* must be cleared manually before the call */
FILE* f = fopen("missing.txt", "r");
if (f == NULL) {
    printf("errno=%d (%s)\n", errno, strerror(errno));
}

/* setjmp/longjmp: a non-local jump, not a real exception mechanism */
jmp_buf recoveryPoint;
if (setjmp(recoveryPoint) == 0) {
    longjmp(recoveryPoint, 42);    /* jumps back to the setjmp() call, which now returns 42 */
} else {
    /* resumes here, with the value passed to longjmp */
}
```

## Detailed Example

See [example.c](example.c) — a return-code-convention `divide` function, an `errno`/`strerror` demonstration on a genuinely failing `fopen`, and a real `setjmp`/`longjmp` round-trip.

## Expected Output

```
10 / 2 = 5
divide(10, 0) failed as expected (return-code convention)
fopen failed as expected: errno=2 (No such file or directory)

setjmp: first pass, jumpValue = 0
about to longjmp back to setjmp...
setjmp: resumed after longjmp, jumpValue = 42
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings (after adding `#define _CRT_SECURE_NO_WARNINGS`, since MSVC deprecates `strerror` by default in favor of `strerror_s`; used here deliberately for portability, since `strerror_s` is not part of standard C). **A real gotcha found and fixed while writing this lesson:** the first draft's `example.c` compiled with two MSVC warnings — `C4996` (the `strerror` deprecation) and `C4702` ("unreachable code") for an illustrative `printf` placed after `longjmp()` that could genuinely never execute; both were fixed (the deprecation suppressed deliberately, the dead code removed) rather than left as noise, and the final version compiles with zero warnings.

## Common Mistakes

- **Not checking a function's return code at all** — nothing forces this in C; a caller can silently ignore a `-1`/`NULL` failure signal and keep using invalid data, unlike an uncaught exception, which at minimum terminates the program loudly.
- Reading `errno` without clearing it to `0` first — `errno` is **not** automatically reset to `0` on success, so a stale nonzero value from an earlier, unrelated failed call can be misread as belonging to the current one.
- Treating `setjmp`/`longjmp` as a general substitute for exceptions — it performs zero automatic cleanup of resources acquired between the `setjmp` and the `longjmp` (no destructors exist in C to run during the jump), so any `malloc`/`fopen` in between will leak/leave open unless cleaned up manually before jumping.

## Best Practices

- Always check every return code that can signal failure — treat an unchecked return value from a function that can fail as a real code-review flag.
- Clear `errno = 0` immediately before any call whose failure you intend to detect via `errno`, and check it immediately after — don't let other calls run in between.
- Reserve `setjmp`/`longjmp` for narrow, well-understood use cases (e.g., some testing frameworks, deeply nested parser bail-outs) — real production C code overwhelmingly prefers propagating return codes explicitly through the call chain instead.

## Real-World Usage

The Linux kernel, SQLite, and the vast majority of production C codebases use the return-code convention (often via a small number of standardized codes, e.g. SQLite's `SQLITE_OK`/`SQLITE_ERROR` family used again in Lesson 16) as their primary error-handling strategy — `errno` is reserved mainly for POSIX/C-standard-library-level failures, and `setjmp`/`longjmp` is genuinely rare in modern C code.

## Summary

- C has no exceptions at all — error handling is a return-code convention, entirely dependent on the caller actually checking it.
- `errno` + `strerror()` surface standard-library failures, but `errno` must be manually cleared before a call to be read reliably afterward.
- `setjmp`/`longjmp` is a real, rarely-used non-local jump — not a real exception mechanism, since it performs no automatic resource cleanup along the way.

## Key Terms

- **Return-code convention** — signaling failure via a function's return value (or an out-parameter's validity), entirely dependent on caller discipline to check it.
- **`errno`** — a global integer set by many standard-library functions on failure, readable via `strerror()`, that must be manually cleared before a call to be checked reliably.

## Interview Questions

1. **Does C have exceptions? If not, how do real C programs signal and handle errors?**
   No — C has no exception mechanism of any kind, at the language level. Error handling is purely conventional: functions signal failure through their return value (a sentinel, or a status code alongside an out-parameter), and callers are expected — but never forced by the compiler — to check it. The standard library additionally uses the global `errno` variable (readable via `strerror()`) for many of its own functions' failures.

2. **What does `setjmp`/`longjmp` do, and why isn't it a real substitute for exception handling?**
   `setjmp` saves the current point in the call stack into a `jmp_buf`; `longjmp` later jumps back to that saved point from anywhere else in the program, unwinding any number of intervening function calls, with the `setjmp` call effectively "returning" a second time with the value passed to `longjmp`. It is not a real substitute for exceptions because it performs **zero automatic cleanup** — there are no destructors in C, so any resource (memory, open file handles) acquired between the `setjmp` and the `longjmp` will leak or remain open unless the code manually cleans it up before jumping, unlike a C++ exception unwinding cleanly through RAII destructors.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
