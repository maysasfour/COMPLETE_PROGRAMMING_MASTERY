# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand packages as Go's unit of code organization (previewed here, expanded in Lesson 15).
- Write statements and comments.
- Understand Go requires no semicolons in source (the compiler inserts them automatically, unlike JavaScript's error-prone ASI).

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Every Go file belongs to a `package`, declared at the top. Go's semicolon rule is the **opposite** of JavaScript's optional-with-footguns ASI: the Go compiler automatically inserts semicolons at the end of each line based on simple, unambiguous lexical rules, and — critically — **you never write them yourself** in idiomatic Go code; the language's official style simply doesn't use explicit semicolons at all (they exist internally but are never written in source).

## Syntax

```go
package main // every file starts with a package declaration

import "fmt" // import statement

// single-line comment
/* multi-line
   comment */

func main() {
	x := 5       // statement (short variable declaration)
	y := x + 1     // `x + 1` is an expression
	fmt.Println(y) // statement containing a function-call expression
}
```

Unlike C-family languages, `{` **must** be on the same line as the preceding statement (e.g., `func main() {`, not `func main()\n{`) — this isn't just a style preference; Go's automatic semicolon insertion rule would insert a semicolon after `func main()` if `{` were on the next line, breaking the function definition. This is directly why Go's brace style is effectively mandatory, not just conventional.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints a computed value.

## Common Mistakes

- Putting an opening `{` on its own line — breaks compilation due to automatic semicolon insertion, unlike in Java/C#/JavaScript where this is just a style choice.
- Importing a package but not using it — Go treats an unused import as a **compile error**, not a warning, a deliberately strict choice enforcing tidy code.

## Best Practices

- Always run `gofmt`/`go fmt` — it enforces the one true brace style and general formatting automatically, removing any need to think about it manually.
- Remove unused imports immediately — the compiler won't let you ignore them anyway.

## Real-World Usage

Go's mandatory brace placement and unused-import/variable compile errors are deliberate design choices to keep codebases uniformly formatted and free of dead code, without needing a separate linter to enforce either.

## Summary

- Every Go file declares a `package`; semicolons are automatically inserted and never written explicitly in idiomatic code.
- `{` must be on the same line as the preceding statement, a direct consequence of automatic semicolon insertion rules.
- Unused imports (and unused local variables) are compile errors in Go, not warnings.

## Key Terms

- **Automatic semicolon insertion (Go)** — the compiler inserts semicolons based on simple lexical rules; explicit semicolons are never written in idiomatic Go.
- **Package** — Go's unit of code organization; every file declares which package it belongs to.

## Interview Questions

1. **Why must `{` be on the same line as the preceding statement in Go, unlike in C/Java/C#?**
   Go's compiler automatically inserts a semicolon at the end of a line under certain lexical conditions (e.g., after an identifier, a closing `)`). If `{` were placed on its own line after `func main()`, the compiler would insert a semicolon after `func main()`, terminating the statement there and breaking the function definition. This is a hard compilation requirement, not just a style guideline enforced by `gofmt`.

2. **What happens if you import a package in Go but never use it?**
   It's a compile error, not a warning — Go deliberately refuses to compile code with unused imports (and unused local variables), forcing genuinely tidy code without relying on a separate linter to catch dead imports.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
