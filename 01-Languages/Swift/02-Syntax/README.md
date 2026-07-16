# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md#top) and the [course README](../README.md) for the disclosed reason (Swift's Windows toolchain requires a system-wide installer, declined this session).

## Learning Objectives

- Write top-level Swift code with no enclosing `main` function or class required (in a `main.swift` file or single-file script).
- Use `let` (constant, the idiomatic default) vs. `var` (variable) and string interpolation.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Swift's top-level syntax is deliberately concise, similar in spirit to Kotlin's top-level functions (just covered in this repository) and Python's script-level code: a file named `main.swift` (or a single-file script run via `swift file.swift`) can contain executable statements directly at the top level, with no `func main()` wrapper required, unlike C/C++/Java/C# (all covered earlier in this repository), all of which require an explicit entry-point function.

## `let` vs. `var`

```swift
let name = "World"  // constant -- cannot be reassigned, the idiomatic default
var count = 0          // variable -- reassignable
count = 1               // fine
// name = "other"      // COMPILE ERROR: cannot assign to value: 'name' is a 'let' constant
```

`let` is Swift's equivalent of Kotlin's `val` or Rust's default immutability — declared as the idiomatic default, with `var` reserved for values that genuinely need to change after initialization.

## String Interpolation

```swift
print("Hello, \(name)!")            // \(expr) embeds any expression's value directly
print("count + 1 = \(count + 1)")
```

Swift's `\(expression)` interpolation syntax is functionally equivalent to Kotlin's `$variable`/`${expression}` (just covered) or C#'s `$"..."` — embedding values directly into a string literal without explicit concatenation.

## Comments

```swift
// single-line
/* multi-line */
/* Swift supports /* NESTED */ block comments -- unlike most C-family languages */
```

## Detailed Example

See [Example.swift](Example.swift) — top-level code, `let`/`var`, string interpolation, and a note on the compile error that would result from reassigning a `let`.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `Hello, World!`, `count + 1 = 1`, and `count is now 1`.

## Common Mistakes

- Attempting to reassign a `let` constant — this is a compile-time error, not a runtime one, enforced statically just like Kotlin's `val`.
- Forgetting Swift supports nested block comments (`/* /* ... */ */`) — a genuine, if minor, divergence from most C-family languages, where nesting `/* */` comments is a syntax error.

## Best Practices

- Default to `let`; use `var` only when a value genuinely needs to change after initialization — the same discipline recommended for Kotlin's `val`/`var` in this repository's Kotlin course.
- Use string interpolation (`\(expr)`) instead of manual string concatenation for building strings with embedded values.

## Real-World Usage

Swift's `let`-by-default convention is considered a core part of its design philosophy around safety and predictability — real Swift codebases (and linters like SwiftLint) strongly encourage `let` wherever a value doesn't change, mirroring the same idiom recommended in this repository's Kotlin and Rust courses.

## Summary

- Swift allows top-level executable code with no `main` function wrapper required.
- `let` (constant, default) and `var` (variable) are enforced at compile time.
- String interpolation uses `\(expression)` syntax.

## Key Terms

- **`let`** — a compile-time-enforced, single-assignment constant, Swift's idiomatic default.
- **String interpolation** — Swift's `\(expression)` syntax for embedding values directly into a string literal.

## Interview Questions

1. **Why does Swift favor `let` over `var` as the idiomatic default, and what enforces this?**
   `let` declares a constant whose value is set once and can never be reassigned — enforced by the compiler as a hard error on any attempted reassignment. Favoring immutability by default reduces a whole class of bugs around unexpected mutation and makes code easier to reason about, mirroring the same design philosophy this repository's Kotlin course (`val`) and Rust course (default immutability) both apply, though each language expresses it with different keywords.

2. **What does Swift's `\(expression)` syntax do, and how does it compare to Kotlin's string templates?**
   `\(expression)` embeds the value of any Swift expression directly into a string literal at that point — functionally equivalent to Kotlin's `$variable`/`${expression}` string templates (covered in this repository's Kotlin course) or C#'s `$"..."` interpolated strings, all serving the same purpose of avoiding manual string concatenation, just with different syntactic delimiters per language.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
