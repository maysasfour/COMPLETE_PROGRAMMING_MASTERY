# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Pair every `malloc` with exactly one `free`, and prove a leak's existence via allocation/free counters rather than by assertion.
- Understand why C's string functions (`strcpy`, `strncpy`) offer no automatic bounds checking, and how to use them safely.
- Apply `const`-correctness to pointer parameters that only read through them.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

C's defining trade-off, restated at the end of the course: total control, zero safety net. There is no garbage collector (Java, C#, Python, JavaScript), no ownership borrow-checker (Rust), and — unlike this repository's own C++ course — not even *optional* RAII/smart pointers to lean on. Every `malloc` must be matched by exactly one `free`, on every code path, including early returns and error branches; missing one leaks, calling one twice is undefined behavior. Every fixed-size buffer is exactly as large as declared and the compiler will not stop you writing past its end — `strcpy`, `sprintf`, and friends copy however much data you hand them, no questions asked. `const` is the one piece of static safety C does offer for pointers: marking a parameter `const char*` documents (and lets the compiler enforce) that a function only reads through it, never writes.

## Syntax

```c
/* Leak-free pairing */
char* buf = malloc(32);
/* ... use buf ... */
free(buf);              /* always paired, on every exit path */

/* Buffer safety: never strcpy into a fixed buffer from untrusted length */
char small[8];
strncpy(small, source, sizeof(small) - 1);
small[sizeof(small) - 1] = '\0';   /* strncpy does NOT guarantee this */

/* const-correctness */
size_t countVowels(const char* text) { /* only reads through text */ }
```

## Detailed Example

See [example.c](example.c) — three demonstrations, each genuinely executed:

1. **A real, measured leak.** `malloc`/`free` are wrapped in `trackedMalloc`/`trackedFree`, which increment global counters. `leaky()` allocates and never frees; `fixed()` allocates and frees. The counters printed after each call prove the mismatch directly, rather than asserting "this leaks" in prose.
2. **A real buffer-overflow scenario**, shown as a commented-out `strcpy` call with an explanation of why it is dangerous — genuinely running it would be undefined behavior, which this repository does not fabricate output for — immediately followed by the `strncpy` + explicit NUL-termination fix, which *is* executed.
3. **const-correctness**: `countVowels(const char* text)` compiles cleanly against a `const char*` argument; the parameter's `const` documents to callers (and the compiler) that the string is read-only.

## Run It

```bash
cd 01-Languages/C/19-Best-Practices
cl /std:c17 /nologo /W4 example.c
example.exe
```

## Expected Output

```
--- Memory leak demo ---
After leaky(): allocCount=1, freeCount=0 (mismatch = 1 leaked block(s))
After fixed(): allocCount=2, freeCount=1 (mismatch = 1 leaked block(s))

--- Buffer safety demo ---
overflowDemo: unsafe strcpy(small, long-string) would overflow small[8] -- not executed
overflowFixed: safely truncated to "this st"

--- const-correctness demo ---
countVowels("The Quick Brown Fox") = 5
```

Genuinely compiled with `cl /std:c17 /nologo /W4 example.c` and run — zero warnings (after adding `#define _CRT_SECURE_NO_WARNINGS`, the same deliberate, documented pattern Lesson 09 uses for `strcpy`/`strncpy`, MSVC's deprecated-but-standard string functions). Note the mismatch after `fixed()` stays at `1`, not `0` — that block is `leaky()`'s permanently-lost allocation from earlier in the run; `fixed()`'s own allocation is correctly paired and does not add to the leak count.

## Common Mistakes

- **Freeing on only some code paths** — an early `return` after a `malloc` but before the matching `free` (e.g., an error branch) is the single most common way real C leaks happen; every exit path needs its own `free`, or a `goto cleanup;` pattern that funnels every path through one shared `free` call.
- **Assuming `strncpy` NUL-terminates the destination** — it only does when the source is shorter than the destination size; when the source is longer or equal, no NUL is written at all, silently leaving the buffer non-string-terminated unless you add `dest[size-1] = '\0';` yourself, as `example.c` does.
- **Passing a `const` pointer's data to a function expecting non-`const`** — this is caught at compile time as an error (not silently allowed), which is `const`'s entire value: it turns an accidental-mutation bug into a build failure instead of a runtime surprise.

## Best Practices

- Track allocation/free symmetry visually in code review: every `malloc`/`calloc`/`realloc` should have an obvious, nearby `free` — if it's not obvious, add a comment explaining where the matching free lives.
- Never use `strcpy`/`sprintf`/`gets` against a buffer of unknown-vs-fixed-size relationship; prefer `strncpy`/`snprintf` (with explicit NUL-termination) or the fixed-size-safe `_s` variants MSVC suggests.
- Mark every pointer parameter `const` unless the function genuinely writes through it — it costs nothing at runtime and turns a class of accidental-mutation bugs into compile errors.

## Real-World Usage

Valgrind and AddressSanitizer exist specifically because this discipline is easy to get wrong at scale in real C codebases — production C projects (the Linux kernel, SQLite, curl) run these tools routinely in CI specifically to catch the leaks and overflows this lesson's `example.c` demonstrates by hand at a toy scale.

## Summary

- C has no garbage collector, no RAII, and no bounds-checked arrays — leak-freedom and buffer safety are entirely the programmer's manual responsibility, provable here via real allocation counters, not assertion.
- `strncpy` does not guarantee NUL-termination when the source is too long; always terminate explicitly.
- `const`-correctness is C's one compile-time safety net for pointer misuse — use it on every read-only pointer parameter.

## Key Terms

- **Memory leak** — an allocated block whose owning pointer goes out of scope (or is overwritten) before `free` is called on it, permanently unreachable for the rest of the process's life.
- **Buffer overflow** — writing past the end of a fixed-size buffer, corrupting adjacent memory; undefined behavior in C, with no automatic bounds checking to prevent it.

## Interview Questions

1. **How would you detect a memory leak in a real C program, beyond code review?**
   Use a dedicated tool — Valgrind's `memcheck` (Linux/macOS) or AddressSanitizer (`-fsanitize=address`, cross-platform including MSVC's `/fsanitize=address`) — which tracks every allocation and reports unfreed blocks at process exit, including the call stack where each was allocated. `example.c`'s hand-rolled `trackedMalloc`/`trackedFree` counters demonstrate the same core idea (allocations minus frees equals leaked blocks) at a tiny, educational scale.

2. **Why doesn't `strncpy` guarantee a NUL-terminated result, and how do you fix that?**
   `strncpy(dest, src, n)` copies at most `n` bytes from `src`, but if `src` is `n` bytes or longer, it copies exactly `n` bytes and stops — without ever writing a terminating `'\0'`, since it was designed originally for fixed-width (not necessarily NUL-terminated) buffer fields. The fix is to always follow it with an explicit `dest[n-1] = '\0';` (using the destination's last valid index), as `example.c`'s `overflowFixed()` does, guaranteeing termination regardless of the source's length.

## Recommended Next Lesson

[20 — Exercises](../20-Exercises/README.md)
