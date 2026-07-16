# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators.
- Understand Go has **no operator overloading** and no ternary operator — deliberate simplicity choices.
- Use `&`/`*` for pointers.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Go's operators are C-family familiar for arithmetic/comparison/logical, with two notable, deliberate omissions compared to most other languages in this repository: **no operator overloading** (a `+` on custom types is always a compile error — this is a deliberate simplicity choice, not an oversight) and **no ternary operator** (`condition ? a : b` doesn't exist; an `if`/`else` is always required instead).

## Arithmetic, Comparison, Logical

```go
a := 5
b := 10
fmt.Println(a + b, a == b, a < b, a && true, !false)

// No ternary operator -- must use if/else, even for a simple two-way choice
var result string
if a < b {
	result = "a is smaller"
} else {
	result = "b is smaller or equal"
}
```

## Pointers

```go
x := 5
ptr := &x   // & takes the address of x
*ptr = 10    // * dereferences ptr to modify x
fmt.Println(x) // 10
```

Go has pointers (unlike Java/JavaScript/Python, similar to C++/C#) but **no pointer arithmetic** (unlike C++) — you can take an address and dereference it, but cannot do `ptr + 1` to "advance" a pointer, a deliberate safety restriction compared to C/C++.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints arithmetic/comparison/logical results, an `if`/`else`-based replacement for a ternary expression, and pointer usage.

## Common Mistakes

- Looking for a ternary operator (`?:`) — Go simply doesn't have one; use `if`/`else`, even for a trivial two-way choice.
- Attempting pointer arithmetic (`ptr + 1`) — a compile error in Go, unlike C/C++.
- Trying to overload `+`/`==` for a custom struct type — not supported; write a named method (like `.Add(...)`) instead.

## Best Practices

- Accept `if`/`else` for simple conditional assignment — it's slightly more verbose than a ternary but is Go's only, deliberately simple option.
- Use pointers primarily to allow a function to modify a caller's value, or to avoid copying a large struct — not for pointer arithmetic, which isn't available.

## Real-World Usage

Go's lack of operator overloading is a deliberate design choice favoring readability — a `+` in Go code always means exactly what it looks like for a built-in numeric/string type, never a surprising custom behavior hidden behind an overloaded operator, unlike languages that do support it (C++, Python).

## Summary

- Go has no operator overloading and no ternary operator — both deliberate simplicity choices; use named methods and `if`/`else` instead.
- Pointers (`&`/`*`) exist for modifying a caller's value or avoiding large-struct copies, but there is no pointer arithmetic.

## Key Terms

- **Operator overloading** — redefining an operator's behavior for a custom type; not supported in Go.

## Interview Questions

1. **Does Go support operator overloading?**
   No — this is a deliberate design decision. A `+` (or any operator) always means exactly its built-in meaning for the types that support it; there's no way to redefine `+`/`==`/etc. for a custom struct type. Go favors an explicit, named method (e.g., `.Add(other)`) over operator overloading's potential for surprising, hidden behavior.

2. **Does Go have a ternary operator?**
   No — `condition ? a : b` doesn't exist in Go; an `if`/`else` is always required, even for the simplest two-way conditional value selection. This is again a deliberate simplicity choice, part of Go's broader philosophy of having exactly one obvious way to do most things.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
