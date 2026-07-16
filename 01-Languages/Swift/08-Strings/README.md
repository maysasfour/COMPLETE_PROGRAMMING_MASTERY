# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift's genuinely distinctive, Unicode-correct-by-default `String`: a collection of `Character`s (extended grapheme clusters), where `.count` is **O(n)**, not O(1) — a real, deliberate trade-off unique among this repository's languages.
- Use multi-line (triple-quoted) strings and string interpolation (from Lesson 02).
- Understand `String` cannot be indexed by a plain integer — it requires `String.Index`.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Every other language covered in this repository measures string length in either bytes (PHP's `strlen`, Rust's byte length, Go's `len()`) or UTF-16 code units (Java's `.length()`, C#'s `.Length`, JavaScript's `.length`) — all of which can miscount multi-byte or multi-code-unit characters, as demonstrated live in several of those courses. Swift takes a genuinely different, stricter approach: `String.count` counts **extended grapheme clusters** (what a human perceives as a single "character"), correctly handling even complex emoji built from multiple combined Unicode scalars — at the deliberate cost of `.count` being an O(n) operation (it must walk the string to determine grapheme cluster boundaries), not O(1).

## Unicode-Correct `.count`, Even for Complex Emoji

```swift
let flag = "🇺🇸" // actually TWO Unicode scalars (regional indicator symbols) combined
print(flag.count) // 1 -- Swift correctly counts it as a single Character

let familyEmoji = "👨‍👩‍👧‍👦" // built from SEVEN Unicode scalars joined with zero-width joiners
print(familyEmoji.count)                    // 1 -- still a single Character/grapheme cluster
print(familyEmoji.unicodeScalars.count)       // 7 -- the underlying scalar count, for contrast
```

This is a much stronger correctness guarantee than any other language covered in this repository provides by default — Go/Rust require explicitly iterating by rune/char (not byte) to get a *character* count, and even then, a complex multi-scalar emoji like the family emoji above would likely count as multiple "characters" in those languages' rune/char-based counting, not the single perceptually-correct unit Swift's `.count` gives automatically.

## `String` Cannot Be Indexed by a Plain Integer

```swift
// print(s[0]) // COMPILE ERROR: cannot subscript String with an Int
let firstChar = s[s.startIndex] // must use a String.Index, not a plain integer offset
```

Because grapheme clusters can be variable-width, Swift deliberately does not allow `O(1)` integer-offset indexing into a `String` at all — this prevents code from silently assuming character access is a cheap, constant-time operation when it fundamentally cannot be, given Swift's correctness guarantee. `String.Index` values are obtained via methods like `startIndex`, `index(after:)`, or `range(of:)`, and used explicitly for any positional access.

## Multi-Line Strings

```swift
let raw = """
    Line one
    Line two
    """
```

Triple-quoted strings support multi-line content directly, similar to Kotlin's triple-quoted strings (covered in this repository's Kotlin course), with indentation matching the closing `"""` automatically stripped.

## Detailed Example

See [Example.swift](Example.swift) — core string functions, a multi-line string, the Unicode-correctness demonstration with both a simple flag emoji and a complex multi-scalar family emoji, and `String.Index`-based access.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print the uppercase/lowercase/count/replace results, the multi-line string (with the escaped `\\n` printing literally, not as a newline), `flag.count: 1`, `familyEmoji.count: 1` followed by `familyEmoji.unicodeScalars.count: 7`, the first character via `String.Index`, and the substring found via `range(of:)`.

## Common Mistakes

- Assuming `String.count` is an O(1) operation, out of habit from languages where string/array length is always constant-time — Swift's grapheme-cluster-aware counting is O(n), a genuine, deliberate performance trade-off for correctness.
- Attempting `s[0]` to access a character by integer position — this doesn't compile at all in Swift; `String.Index`-based access is required, precisely because grapheme clusters have variable byte/scalar width.
- Assuming a "character" always corresponds to exactly one Unicode scalar — complex emoji (like the family emoji in this lesson) are built from many combined scalars, yet Swift correctly counts them as a single `Character`.

## Best Practices

- Avoid calling `.count` repeatedly in a loop condition on a large string — since it's O(n), doing so can make an otherwise-linear algorithm quadratic; compute it once if needed multiple times.
- Use `String.Index`-based APIs (`range(of:)`, `firstIndex(of:)`, etc.) for positional string operations rather than trying to force integer-offset-style access.
- Rely on Swift's `.count` when genuine Unicode correctness matters (e.g., displaying an accurate "character count" to a user for arbitrary international or emoji-containing text) — it's one of the few languages covered in this repository that gets this right by default.

## Real-World Usage

Swift's Unicode-correct string handling matters directly for any app handling genuinely international text or emoji-rich user content (a very common case for iOS apps specifically) — getting character counts wrong for complex emoji or combined characters is a real, user-visible bug class in less careful string implementations, one Swift's design specifically avoids at the cost of `.count`'s O(n) complexity.

## Summary

- Swift's `String.count` counts extended grapheme clusters (perceptually correct "characters"), even for complex, multi-scalar emoji — a stronger correctness guarantee than any other language covered in this repository, at the deliberate cost of O(n) complexity.
- `String` cannot be indexed by a plain integer; `String.Index`-based access is required instead.
- Multi-line (triple-quoted) strings work similarly to Kotlin's, covered in this repository's Kotlin course.

## Key Terms

- **Extended grapheme cluster** — a sequence of one or more Unicode scalars that together form a single, perceptually-one "character" (what Swift's `Character` type represents).
- **`String.Index`** — an opaque position type used for string indexing/ranges, since grapheme clusters are variable-width.

## Interview Questions

1. **Why is `String.count` an O(n) operation in Swift, when array `.count` is O(1)?**
   Swift's `String` counts extended grapheme clusters — sequences of one or more Unicode scalars that together represent what a human perceives as a single character (this lesson demonstrated a flag emoji built from 2 scalars, and a family emoji built from 7 scalars, both correctly counted as a single `Character` each). Because grapheme cluster boundaries are variable-width and can only be determined by examining the actual scalar sequence, Swift must walk the string to count them accurately, making `.count` a linear-time operation. A plain `Array`'s `.count`, by contrast, is simply the number of stored elements, trackable in constant time regardless of what those elements are.

2. **Why can't a Swift `String` be indexed with a plain integer like `s[0]`, and what must be used instead?**
   Because Swift's grapheme-cluster-based correctness means individual "characters" can occupy a variable number of underlying Unicode scalars (and further, a variable number of bytes in the string's UTF-8 encoding) — there's no way to jump directly to "the 5th character" with simple pointer arithmetic the way a fixed-width-element array allows. Instead, Swift requires `String.Index` values, obtained through methods like `startIndex`, `index(after:)`, or `range(of:)`, which correctly account for grapheme cluster boundaries when used for indexing or slicing — this is a deliberate design choice preventing code from silently assuming O(1) integer-offset access is available when the string's Unicode-correctness guarantee fundamentally requires O(n) traversal instead.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
