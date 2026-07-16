# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Use `var` and `:=` (short variable declaration) correctly.
- Understand Go's **zero values** — every declared-but-uninitialized variable gets a well-defined default, never `undefined`/garbage.
- Use basic types (`int`, `float64`, `string`, `bool`) and `const`.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Go is statically typed. `var` declares a variable with an explicit type (or an inferred one from an initializer); `:=` is shorthand combining declaration and type inference, usable only inside functions (not at package level). Crucially, Go has **no concept of an uninitialized variable** — every type has a well-defined **zero value** (`0` for numbers, `""` for strings, `false` for bools, `nil` for pointers/slices/maps/etc.), assigned automatically if no initializer is given. This eliminates an entire class of "used before initialized" bugs common in C/C++.

## `var` and `:=`

```go
var age int = 30      // explicit type
var name = "Ada"        // inferred as string
count := 42               // short declaration -- inferred, function-scope only

var uninitialized int    // zero value: 0, not garbage/undefined
var emptyString string    // zero value: ""
var flag bool               // zero value: false
var ptr *int                 // zero value: nil
```

## Basic Types

```go
var i int = 42
var f float64 = 3.14
var s string = "hello"
var b bool = true

const Pi = 3.14159 // compile-time constant, cannot be reassigned
```

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints `var`/`:=` usage and each basic type's zero value when declared without an initializer.

## Common Mistakes

- Using `:=` at package level (outside any function) — only `var` works there; `:=` is function-scope only.
- Using `:=` inside a nested block (like an `if`) when you meant to reassign an outer variable — this creates a **new**, shadowed variable instead, a subtle and common Go bug.
- Assuming an uninitialized variable has garbage/undefined content, the way it might in C — Go always zero-initializes.

## Best Practices

- Use `:=` for local variables with an obvious initializer (the idiomatic Go default); use `var` when you need an explicit type or no initializer.
- Rely on zero values deliberately where they're meaningful (e.g., a zero-valued `bool` defaulting to `false` is often exactly the desired starting state), rather than always writing an explicit initializer.

## Real-World Usage

Zero values are used pervasively and deliberately in idiomatic Go — for example, a zero-valued `sync.Mutex` (Lesson 14) is already a valid, usable, unlocked mutex with no explicit initialization needed, a design pattern Go's standard library relies on throughout.

## Summary

- `var` (explicit or inferred type) works everywhere; `:=` (inferred, combined declare+assign) works only inside functions.
- Every type has a well-defined zero value — Go has no uninitialized/garbage variable state.
- `const` declares compile-time constants.

## Key Terms

- **Zero value** — the well-defined default value every Go type has when declared without an initializer (`0`, `""`, `false`, `nil`, as appropriate).
- **Short variable declaration (`:=`)** — combined declaration and type-inferred assignment, usable only inside functions.

## Interview Questions

1. **What is a "zero value" in Go, and why does it matter?**
   Every Go type has a well-defined default value assigned automatically when a variable is declared without an explicit initializer — `0` for numeric types, `""` for strings, `false` for booleans, `nil` for pointers/slices/maps/channels/interfaces. This eliminates the "uninitialized variable contains garbage" class of bugs common in C/C++, and is deliberately leveraged in idiomatic Go (e.g., a zero-valued `sync.Mutex` is already usable).

2. **What's the difference between `var x = 5` and `x := 5`?**
   Functionally equivalent for a local variable (both infer `x`'s type as `int` from the initializer) — `:=` is simply more concise shorthand. The key restriction: `:=` can only be used inside a function body; package-level (global) variable declarations must use `var`.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
