# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use common string operations via the `strings` and `strconv` packages.
- Understand Go strings are immutable **byte sequences**, and the distinction between a byte and a **rune** (a Unicode code point).
- Convert between strings and numbers with `strconv`.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Go strings are immutable (like every language course except C++), but are specifically defined as immutable **sequences of bytes**, which are not necessarily one-byte-per-character — Go source and strings are UTF-8 by default, so indexing a string by byte position (`s[0]`) can split a multi-byte character in the middle for non-ASCII text. A **rune** (Go's name for `int32`, representing a Unicode code point) is what you get when ranging over a string with `for range`, which correctly decodes UTF-8 rather than naively indexing bytes.

## Common Operations

```go
import "strings"

s := "  hello  "
fmt.Println(strings.TrimSpace(s))
fmt.Println(strings.ToUpper(s))
fmt.Println(strings.Contains(s, "ell"))
fmt.Println(strings.Split("a,b,c", ","))
fmt.Println(strings.Join([]string{"a", "b"}, "-"))
fmt.Println(strings.ReplaceAll("hello", "l", "L")) // replaces ALL occurrences
```

## Bytes vs. Runes

```go
s := "héllo" // 'é' is a multi-byte UTF-8 character
fmt.Println(len(s))       // byte length -- 6, NOT 5 characters, because 'é' takes 2 bytes

for i, r := range s { // `range` on a string correctly decodes UTF-8, yielding runes
	fmt.Printf("%d: %c\n", i, r)
}
```

`len(s)` on a Go string always returns the **byte** length, not the character count — for ASCII-only strings these are the same, but for any string containing multi-byte UTF-8 characters, they diverge. `for range` over a string is the correct way to iterate actual characters (runes), decoding UTF-8 automatically, unlike a manual byte-index loop.

## `strconv` for Type Conversion

```go
import "strconv"

n, err := strconv.Atoi("42")     // string to int, with an error for invalid input
s := strconv.Itoa(42)              // int to string
f, err := strconv.ParseFloat("3.14", 64)
```

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints common string operations, a demonstration that `len()` returns byte length (not character count) for a string with a multi-byte character, correct rune-based iteration, and `strconv` conversions.

## Common Mistakes

- Indexing a string by byte position (`s[i]`) expecting to get the i-th *character* — for non-ASCII text, this can return part of a multi-byte character's raw bytes, not a full character.
- Using `len(s)` and assuming it's the character count — it's always the byte count.
- Forgetting `strconv.Atoi`/`ParseFloat` return an `error` (Lesson 09's pattern) that must be checked for invalid input.

## Best Practices

- Use `for range` (not manual byte indexing) to iterate a string's actual characters correctly.
- Always check the `error` returned by `strconv` conversions.
- Use `utf8.RuneCountInString(s)` (from the `unicode/utf8` package) when you specifically need the character count, not the byte count.

## Real-World Usage

The byte-vs-rune distinction matters for any Go code processing genuinely international text (names, addresses, user-generated content) — a naive byte-indexing approach that works fine in testing with ASCII data can corrupt non-ASCII text in production.

## Summary

- Go strings are immutable UTF-8 byte sequences; `len(s)` returns byte length, not character count.
- A rune is a Unicode code point (Go's `int32`); `for range` over a string correctly decodes UTF-8 into runes.
- `strconv` converts between strings and numbers, returning an `error` for invalid input, following Lesson 06's multiple-return-value pattern.

## Key Terms

- **Rune** — Go's term for a Unicode code point, represented as `int32`.
- **Byte length vs. character count** — `len(s)` always returns the byte count; for non-ASCII UTF-8 text, this differs from the actual character count.

## Interview Questions

1. **Does `len(s)` return the number of characters in a Go string?**
   No — it always returns the number of **bytes**. For ASCII-only strings, byte count and character count are the same, but any string containing multi-byte UTF-8 characters (like accented letters or emoji) will have `len(s)` return a larger number than the actual character count. Use `utf8.RuneCountInString(s)` for the true character count.

2. **What is a "rune" in Go?**
   Go's term for a Unicode code point, represented as the type `int32`. `for range` over a string yields runes (correctly decoding multi-byte UTF-8 sequences into single characters), as opposed to indexing a string directly (`s[i]`), which yields raw bytes that may only be part of a multi-byte character.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
