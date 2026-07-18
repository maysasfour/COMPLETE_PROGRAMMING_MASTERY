# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use Scala's three built-in string interpolators: `s`, `f`, and `raw`.
- Understand that `String` is immutable and backed directly by `java.lang.String` (identical to Java's/Kotlin's `String`).

## Concept

Scala `String`s are `java.lang.String` under the hood — every method Java's `String` has is available, plus Scala adds interpolation syntax on top. There are three built-in interpolators: `s"..."` (basic interpolation, `$var`/`${expr}`), `f"..."` (adds `printf`-style formatting specifiers, e.g. `%.2f`, `%03d`), and `raw"..."` (like `s`, but disables escape-sequence processing, e.g. `\n` stays as two literal characters instead of a newline).

## The Three Interpolators

```scala
s"Hello, $name! Age: ${age + 1}"      // basic interpolation
f"Pi is ${math.Pi}%.2f"                  // formatted, printf-style specifiers
raw"tab\tstays literal"                  // no escape processing at all
```

## Immutability

```scala
val original = "hello"
val upper = original.toUpperCase   // returns a NEW string; original is untouched
```

Every `String`-returning operation (`.toUpperCase`, `.replace`, `.trim`, etc.) returns a new `String` instance — verified live in the example, where `original` remains `"hello"` after calling `.toUpperCase` on it.

## Detailed Example

See [Strings.scala](Strings.scala) — all three interpolators, live-verified immutability, multi-line strings with `.stripMargin`, and common `String` methods (`length`, `replace`, `split`, `trim`, `contains`).

## Run It

```bash
cd 01-Languages/Scala/08-Strings
scalac Strings.scala
scala run . --main-class stringsDemo
```

## Expected Output

```
s-interpolator: Hello, Ada! Next year you'll be 32.
f-interpolator (formatted): Ada is 031 years old, pi=3.14
raw-interpolator: no escape processing -- tab\tnewline\n stays literal
immutability: original=hello upper=HELLO (original unchanged: true)
multi-line:
line one
line two
length=5, replace=heLLo, split=List(a, b, c)
trim='padded', contains=true
```

## Common Mistakes

- Using `s"..."` when a formatting specifier is actually needed (e.g., fixed decimal places) — that requires `f"..."`, not `s"..."`.
- Forgetting `raw"..."` still performs interpolation (`$var` still works) — it only disables escape-sequence processing, not interpolation itself.
- Assuming a mutating-sounding method name (`.trim`, `.replace`) mutates the original `String` in place — every one of them returns a new `String`, verified live in this lesson.

## Best Practices

- Default to `s"..."` for everyday interpolation; reach for `f"..."` specifically when numeric formatting precision matters.
- Use `.stripMargin` (with a leading `|` per line) for readable multi-line string literals in real code, rather than raw embedded newlines with inconsistent indentation.

## Real-World Usage

String interpolation is used pervasively for logging, error messages, and building SQL/HTTP request bodies (always via parameterized queries for SQL, covered in Lesson 16 — string interpolation for building raw SQL is explicitly a SQL-injection anti-pattern, not shown here for that reason).

## Summary

- Scala's `String` is `java.lang.String` — fully interoperable with Java, and immutable.
- Three interpolators: `s` (basic), `f` (printf-style formatting), `raw` (no escape processing).
- Every string-transforming method returns a new `String`; none mutate in place.

## Key Terms

- **String interpolation** — embedding expressions directly inside a string literal via `$`/`${}`.
- **Immutability** — a `String`'s content can never change after construction; transformations produce new instances.

## Interview Questions

1. **What's the difference between Scala's `s`, `f`, and `raw` interpolators?** — `s` performs basic variable/expression interpolation; `f` adds `printf`-style format specifiers (e.g., `%.2f` for two decimal places) after each interpolated expression; `raw` behaves like `s` but disables escape-sequence processing, so `\n` inside a `raw` string stays as the two literal characters backslash-n rather than becoming a newline.
2. **Why is Scala's `String` immutable, and what does that mean in practice?** — Because it's backed directly by `java.lang.String`, which the JVM implements as immutable; every apparently "mutating" method (`.trim`, `.replace`, `.toUpperCase`) actually returns a brand-new `String` instance, leaving the original unchanged — verified live in this lesson by confirming the original string is unaffected after calling `.toUpperCase` on it.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
