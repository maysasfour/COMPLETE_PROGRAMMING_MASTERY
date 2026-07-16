# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use string interpolation and common `string` methods.
- Explain why `string` is immutable and use `StringBuilder` for repeated mutation.
- Use verbatim (`@""`) and raw (`""" """`) string literals.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

`string` in C# is an immutable reference type — every method (`.ToUpper()`, `.Substring()`, `.Replace()`) returns a **new** string, exactly like JavaScript/Python/TypeScript strings. Repeatedly concatenating strings in a loop (`result += piece;`) creates a new string object on every iteration, which is O(n²) overall — `StringBuilder` exists specifically to make repeated mutation efficient.

## Interpolation and Common Methods

```csharp
string name = "Ada";
int age = 30;
Console.WriteLine($"{name} is {age} years old"); // interpolation, like template literals

"  hello  ".Trim();
"hello".ToUpper();
"hello world".Contains("wor");
"hello world".Split(' ');
string.Join("-", new[] { "a", "b", "c" });
"hello".Replace("l", "L"); // replaces ALL occurrences, unlike JS's .replace() default
```

## Immutability and `StringBuilder`

```csharp
string result = "";
for (int i = 0; i < 5; i++) {
    result += i; // creates a NEW string object each iteration -- O(n) per append, O(n^2) overall
}

var sb = new System.Text.StringBuilder();
for (int i = 0; i < 5; i++) {
    sb.Append(i); // mutates an internal buffer in place -- O(1) amortized per append
}
string built = sb.ToString();
```

## Verbatim and Raw String Literals

```csharp
string path = @"C:\Users\Ada\file.txt"; // verbatim: no escape sequences needed for \

string json = """
{
  "name": "Ada"
}
"""; // raw string literal (C# 11+) -- no escaping needed for " either
```

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints interpolation, common string methods (including `.Replace()` replacing every occurrence, unlike JavaScript's default single-replace behavior), a demonstration that string concatenation in a loop produces a new object each time, and `StringBuilder` used for efficient repeated appends.

## Common Mistakes

- Concatenating strings in a tight loop with `+=` instead of `StringBuilder`, causing O(n²) performance for what should be an O(n) operation.
- Assuming `.Replace("l", "L")` only replaces the first match (as JavaScript's `.replace()` does by default) — in C#, `.Replace()` always replaces every occurrence.
- Forgetting `@""`/verbatim strings exist and manually escaping every backslash in a Windows file path.

## Best Practices

- Use `StringBuilder` for any loop performing many string concatenations.
- Use string interpolation (`$""`) over manual concatenation for readability.
- Use verbatim (`@""`) strings for file paths/regex patterns with many backslashes, and raw string literals (`""" """`) for embedded JSON/multi-line text needing minimal escaping.

## Real-World Usage

`StringBuilder` is standard in any code building up a large string incrementally (generating a report, building a large SQL query string — though parameterized queries remain mandatory for actual values, Lesson 16); raw string literals are increasingly used for embedding JSON/SQL/regex samples directly in C# source without escaping noise.

## Summary

- `string` is immutable; every method returns a new string, exactly like JS/Python/TS.
- Repeated concatenation with `+=` in a loop is O(n²); `StringBuilder` makes repeated appends efficient.
- `.Replace()` replaces all occurrences by default, unlike JavaScript's `.replace()`.
- Verbatim (`@""`) and raw (`""" """`) string literals reduce escaping noise for paths/JSON/multi-line text.

## Key Terms

- **`StringBuilder`** — a mutable string-building buffer, used to avoid O(n²) performance from repeated string concatenation.
- **Verbatim string (`@""`)** — a string literal where backslashes are not escape characters.
- **Raw string literal (`""" """`)** — a C# 11+ multi-line string literal requiring minimal escaping.

## Interview Questions

1. **Why is repeated string concatenation in a loop a performance problem, and what's the fix?**
   Because `string` is immutable, every `+=` concatenation allocates an entirely new string object and copies all the previous content into it — for `n` concatenations, this results in O(n²) total work. `StringBuilder` maintains an internal mutable buffer that grows amortized-O(1) per append, making the equivalent loop O(n) overall.

2. **Does `.Replace()` in C# behave like JavaScript's `.replace()` by default?**
   No — C#'s `string.Replace()` always replaces every occurrence of the target substring, equivalent to JavaScript's `.replaceAll()`, not its single-match-by-default `.replace()`.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
