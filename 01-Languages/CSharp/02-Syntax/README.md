# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Distinguish statements from expressions in C#.
- Understand that semicolons are mandatory, unlike JavaScript's ASI.
- Write single-line and multi-line comments and XML doc comments.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

C# is a curly-brace, semicolon-terminated language (like C, Java, and JavaScript's non-ASI form) — every statement ends with `;`, and there is no equivalent of JavaScript's Automatic Semicolon Insertion. Blocks are delimited with `{ }`. C# is case-sensitive and uses `PascalCase` for types/methods/properties and `camelCase` for local variables/parameters, a stronger and more consistently enforced convention than most languages in this repository.

## Syntax

```csharp
int x = 5;              // statement (declaration)
int y = x + 1;           // `x + 1` is an expression, assigned via a statement
Console.WriteLine(y);    // statement containing a method-call expression

// single-line comment
/* multi-line
   comment */

/// <summary>
/// XML doc comment -- picked up by IDEs for tooltips/IntelliSense and doc generation tools.
/// </summary>
void Greet() { }
```

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints results of a few statements and expressions, confirming semicolons are required (a commented-out missing-semicolon line is shown, not executed, since it would fail to compile).

## Common Mistakes

- Forgetting a semicolon — unlike JavaScript, there is no ASI fallback; this is always a compile error.
- Using `camelCase` for public members (methods, properties) instead of C#'s conventional `PascalCase`.

## Best Practices

- Follow `PascalCase` for types, methods, properties; `camelCase` for locals and parameters — enforced by convention and by most linters/analyzers, not the compiler itself.
- Use XML doc comments (`///`) on public APIs; IDEs surface them directly as IntelliSense tooltips.

## Real-World Usage

XML doc comments are the source for generated API documentation in most .NET libraries and are what powers the parameter/return-type tooltips seen in Visual Studio/Rider/VS Code.

## Summary

- C# requires semicolons; there is no ASI.
- `PascalCase` for types/methods/properties, `camelCase` for locals, by strong convention.
- `///` XML doc comments feed IDE tooltips and documentation generators.

## Key Terms

- **XML doc comment (`///`)** — a structured comment format IDEs and doc-generation tools parse for API documentation.

## Interview Questions

1. **Does C# require semicolons?**
   Yes, always — there is no automatic semicolon insertion mechanism like JavaScript's; omitting one is a compile error.

2. **What's the difference between `//` and `///` comments?**
   `//`/`/* */` are ordinary comments ignored by the compiler and tooling. `///` XML doc comments follow a structured format (`<summary>`, `<param>`, `<returns>`) that IDEs parse to show IntelliSense tooltips and that documentation generators use to build API reference docs.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
