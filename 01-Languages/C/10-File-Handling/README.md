# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `<stdio.h>`'s `FILE*`-based API: `fopen`, `fwrite`/`fread`, `fprintf`/`fgets`, `fclose`.
- Understand C has **no built-in JSON** (or any structured-data format) support — the same gap this repository's C++/Java/Kotlin courses already document.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

File I/O in C centers on the opaque `FILE*` handle from `<stdio.h>` — `fopen` returns one (or `NULL` on failure, checked via the return-code convention from Lesson 09), and every subsequent operation (`fread`/`fwrite` for binary data, `fprintf`/`fgets` for text) takes it as a parameter. There is no RAII here (Lesson 19's discipline applies): `fclose` must be called explicitly, exactly once, for every successfully-opened `FILE*`. Binary I/O with `fwrite`/`fread` writing a struct's raw memory layout directly is fast and simple but **not portable** across compilers/platforms with different struct padding or endianness — a real limitation worth knowing, distinct from a genuine serialization format. And, matching this repository's other systems-level language courses, **C has zero built-in JSON support** — no equivalent of Python's `json` module or JavaScript's native `JSON.parse`; real C JSON work requires a third-party library (commonly `cJSON` or `jansson`).

## Syntax

```c
FILE* out = fopen("data.bin", "wb");        /* "wb" = write, binary mode */
fwrite(records, sizeof(Record), count, out);
fclose(out);

FILE* in = fopen("data.bin", "rb");
Record buf[10];
size_t n = fread(buf, sizeof(Record), 10, in);
fclose(in);

FILE* textOut = fopen("notes.txt", "w");    /* "w" = write, text mode */
fprintf(textOut, "line %d\n", 1);
fclose(textOut);

FILE* textIn = fopen("notes.txt", "r");
char line[128];
while (fgets(line, sizeof(line), textIn) != NULL) {   /* fgets keeps the trailing '\n' */
    /* ... */
}
fclose(textIn);
```

## Detailed Example

See [example.c](example.c) — writes/reads back an array of `Record` structs in binary mode, writes/reads a text file line-by-line with `fgets`, and cleans up both files it creates via `remove()`.

## Expected Output

```
wrote 3 records to records.bin
read 3 records back:
  id=1 name=Alice score=91.50
  id=2 name=Bob score=84.00
  id=3 name=Carol score=97.25

reading notes.txt line by line:
  "line one"
  "line two"
  "line three"

cleaned up records.bin and notes.txt

(C has no built-in JSON support -- same gap noted in the C++/Java/Kotlin courses;
 real C JSON needs a third-party library like cJSON.)
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, and `records.bin`/`notes.txt` are deleted by the program itself at the end (also nothing is left behind for this repository's cleanliness).

## Common Mistakes

- Forgetting `fclose()` — no destructor/RAII will do this automatically; a leaked `FILE*` handle keeps a file descriptor open for the life of the process (or until the OS reclaims it at process exit).
- Reading back binary structs written by `fwrite` on a **different** compiler/platform/architecture — struct padding, alignment, and endianness are not guaranteed identical, so raw binary struct dumps are not a portable interchange format; use them only for same-machine, same-build round trips (e.g., a local cache file), never as a cross-platform format.
- Forgetting `fgets` keeps the trailing `'\n'` in the buffer — printing it directly leaves a visible blank line or double-newline; strip it (`line[strcspn(line, "\n")] = '\0';`) before further processing, as `example.c` does.

## Best Practices

- Always check `fopen`'s return value against `NULL` before using the handle.
- Always pair every successful `fopen` with exactly one `fclose`, ideally as close to the open as structurally possible.
- For anything meant to be read by another program, another language, or a future version of your own program, prefer a real interchange format (plain text/CSV, or JSON via a library like cJSON) over raw binary struct dumps.

## Real-World Usage

Embedded/systems C code often does use raw binary struct dumps for same-machine persistence (fast, simple, no library needed) — but any C project needing genuine interoperability (config files, API payloads) reaches for a third-party JSON library, exactly like this repository's C++ course does for the same reason.

## Summary

- `FILE*` plus `fopen`/`fread`/`fwrite`/`fprintf`/`fgets`/`fclose` is C's entire standard file I/O API — no RAII, `fclose` is always manual.
- Raw binary struct dumps via `fwrite`/`fread` are fast but not a portable interchange format across compilers/platforms.
- C has zero built-in JSON (or any structured-data format) support — a third-party library is required for real JSON work.

## Key Terms

- **`FILE*`** — an opaque handle to an open file stream, returned by `fopen`, required by every other `<stdio.h>` file operation.
- **Binary mode vs. text mode** — `"b"` in the mode string (`"wb"`/`"rb"`) disables newline translation, needed for exact-byte binary data; omitting it is appropriate for genuinely textual data.

## Interview Questions

1. **Why isn't writing a struct directly to a file with `fwrite` considered a portable serialization format?**
   `fwrite` writes the struct's raw in-memory byte layout exactly as the compiler laid it out — including any compiler/platform-specific padding between fields for alignment, and the platform's endianness. A different compiler, platform, or even a different struct-packing pragma on the same compiler can produce an incompatible byte layout, so a binary struct dump is only reliable for round-tripping on the exact same build, not as a genuine cross-platform interchange format.

2. **Does C have built-in JSON support? What's the real-world workaround?**
   No — the C standard library has no JSON (or any structured-data) parsing/serialization support at all, matching the same gap this repository's C++/Java/Kotlin courses already note in their own standard libraries. Real C code needing JSON links a third-party library (commonly `cJSON` or `jansson`), or, for simple internal-only needs, hand-writes a minimal ad hoc text format instead.

## Recommended Next Lesson

[11 — Structs and Unions](../11-Structs-and-Unions/README.md)
