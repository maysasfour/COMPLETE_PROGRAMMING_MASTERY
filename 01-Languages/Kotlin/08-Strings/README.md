# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use string templates (from Lesson 02) and triple-quoted raw strings for multiline, escape-free text.
- Understand that Kotlin's `String` *is* `java.lang.String` (direct JVM interoperability, Lesson 01), so every Java string method is available directly.
- Reinforce Lesson 04's structural-vs-referential equality distinction specifically for strings, contrasted with the interned-literal case.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Because Kotlin compiles to JVM bytecode and interoperates directly with Java, `kotlin.String` is literally `java.lang.String` under the hood — every method available on a Java string is available on a Kotlin string, plus a large set of additional Kotlin-specific extension functions (`.uppercase()`, wrappers with more idiomatic naming than Java's `.toUpperCase()`, etc.) layered on top.

## Triple-Quoted Raw Strings

```kotlin
val raw = """
    Line one
    Line two with a literal backslash: \n (not a newline escape here!)
    Line three with "quotes" needing no escaping at all
""".trimIndent()
```

Triple-quoted strings need no escaping for quotes or backslashes and preserve line breaks literally — ideal for multi-line text, SQL, or JSON embedded directly in source. `trimIndent()` strips the common leading whitespace from every line, letting the raw string be indented naturally within the surrounding code without that indentation appearing in the actual string content.

## Core String Functions (Direct Java Interop)

```kotlin
s.uppercase(); s.lowercase(); s.length; s.replace("World", "Kotlin"); s.substring(7, 12)
s.startsWith("Hello"); s.contains("World"); s.split(", ")
```

## String Equality: Structural vs. Referential, Revisited

```kotlin
val a = "test"
val b = String(charArrayOf('t', 'e', 's', 't')) // built via a char array, NOT a literal
a == b   // true  -- structural equality (content), as expected
a === b // false -- genuinely DIFFERENT object instances this time
```

Verified live: unlike Lesson 04's `"hello"` vs. `"hel" + "lo"` case (where compile-time constant folding interned both to the *same* object, making `===` unexpectedly `true`), constructing a string via `String(charArrayOf(...))` at runtime produces a genuinely separate object — `===` correctly returns `false` here, while `==` still correctly returns `true` for the matching content. This contrast reinforces that `===`'s result depends on exactly how a string was constructed (a compile-time-foldable literal expression vs. a runtime construction), not just its content.

## Detailed Example

See [Example.kt](Example.kt) — string templates, a triple-quoted raw string with `trimIndent()`, core Java-inherited string functions, Kotlin-specific convenience functions, and the live-verified equality contrast above.

## Run It

```bash
cd 01-Languages/Kotlin/08-Strings
kotlinc Example.kt -include-runtime -d Example.jar
java -jar Example.jar
```

## Expected Output

Running the compiled JAR prints the interpolated template string, the triple-quoted raw string (with its natural indentation stripped by `trimIndent()`, and a literal `\n` printed as two characters, not a newline), the core string function results, `true`/`true`/`[Hello, World!]` for the convenience functions, and `true`/`false` for the final structural-vs-referential comparison — confirming `===` behaves differently here than it did for the interned literal in Lesson 04.

## Common Mistakes

- Forgetting `trimIndent()` on a triple-quoted string embedded inside indented code — without it, every line's leading whitespace (matching the surrounding code's indentation) becomes part of the actual string content.
- Assuming a literal backslash inside a triple-quoted string needs escaping, or is interpreted as an escape sequence — it isn't; triple-quoted strings treat backslashes as ordinary literal characters, unlike regular double-quoted strings.
- Assuming `===` always behaves consistently for strings — as shown in this lesson (contrasted with Lesson 04), the result depends on exactly how the string was constructed (compile-time-folded literal vs. runtime-constructed), which is precisely why `==` (structural), not `===`, should always be used for string content comparison.

## Best Practices

- Use triple-quoted raw strings (with `trimIndent()`) for any multi-line text, SQL, or JSON embedded directly in Kotlin source, instead of manual `\n`-joined string concatenation.
- Always use `==` (never `===`) for string content comparison — `===`'s result depends on construction details (interning, compile-time folding) that shouldn't matter for a content comparison, verified live in this lesson to behave inconsistently across two different construction methods.
- Take advantage of Kotlin's more idiomatically-named string functions (`.uppercase()`/`.lowercase()` over Java's `.toUpperCase()`/`.toLowerCase()`, still available via interop) for more natural-reading Kotlin code.

## Real-World Usage

Triple-quoted raw strings are commonly used in real Kotlin code for embedding SQL queries, JSON templates, or multi-line log/help text directly in source without escaping noise — a genuine readability improvement over manually escaped, concatenated strings for this kind of content.

## Summary

- Kotlin's `String` is `java.lang.String` directly — full Java string API availability plus Kotlin-specific extensions.
- Triple-quoted (`"""`) raw strings need no escaping and preserve literal formatting; `trimIndent()` strips common leading whitespace.
- `==` (structural) is always correct for string content comparison; `===` (referential) depends on construction details and should not be relied on for strings, verified live to behave differently across two different construction methods.

## Key Terms

- **Triple-quoted string** — a raw, multi-line string literal requiring no escape sequences.
- **`trimIndent()`** — strips the smallest common leading whitespace from every line of a multi-line string.

## Interview Questions

1. **Why might `===` give inconsistent-seeming results when comparing two strings with identical content?**
   Because `===` checks object identity (the same underlying object in memory), and whether two strings with identical content end up as the *same* object depends entirely on how each was constructed — compile-time-constant string literal expressions get folded and interned into a shared pool object by the compiler (verified in Lesson 04, where `"hello" === "hel" + "lo"` was `true`), while strings built at runtime (e.g., from a `charArrayOf`, verified in this lesson) are genuinely separate objects even with identical content, making `===` return `false`. This inconsistency is exactly why `==` (structural/content equality) — not `===` — should always be used for comparing string values, regardless of how they were constructed.

2. **What does `trimIndent()` do, and why is it commonly paired with triple-quoted strings?**
   `trimIndent()` detects the smallest amount of leading whitespace common to all non-blank lines of a multi-line string and removes exactly that much from each line, letting a triple-quoted string literal be naturally indented to match the surrounding code's indentation level without that indentation becoming part of the actual string content. Without it, a triple-quoted string written inside an indented function body would include all of that indentation as literal leading whitespace on every line except the first, which is almost never the intended behavior.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
