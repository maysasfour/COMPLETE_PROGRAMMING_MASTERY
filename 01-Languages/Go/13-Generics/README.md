# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write generic functions and types using Go's type parameters (added in Go 1.18, 2022).
- Use type constraints, including the built-in `comparable` and custom interface constraints.
- Understand Go generics are a relatively recent addition — much existing Go code and idiom predates them.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Go had **no generics at all** until version 1.18 (March 2022) — for over a decade, Go code used `interface{}` (now spelled `any`) plus type assertions/switches to write loosely "generic" code, with no compile-time type safety. Go 1.18 added type parameters, giving Go genuine compile-time generics — closer in spirit to C#'s reified generics than to Java's fully-erased ones, though Go's implementation details differ from both.

## Generic Functions

```go
func First[T any](items []T) T { // [T any] declares a type parameter constrained to "any type"
	return items[0]
}

First([]int{1, 2, 3})       // T inferred as int
First([]string{"a", "b"})    // T inferred as string
```

## Type Constraints

```go
type Number interface {
	int | int64 | float64 // a constraint: T must be one of these specific types
}

func Sum[T Number](items []T) T {
	var total T
	for _, item := range items {
		total += item
	}
	return total
}

func Max[T comparable](a, b T) T { // comparable: a built-in constraint for == and != support
	if a == b {
		return a
	}
	// ... (comparable doesn't include < or >, only == and !=; see below for ordering)
	return a
}
```

`comparable` is a built-in constraint meaning "supports `==`/`!=`" — for ordering comparisons (`<`, `>`), Go 1.21+ added `cmp.Ordered` in the standard library, since ordering and equality are genuinely different capabilities a type might or might not support.

## Generic Types

```go
type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() T {
	n := len(s.items)
	item := s.items[n-1]
	s.items = s.items[:n-1]
	return item
}
```

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints a generic `First[T]` function correctly inferring `int` and `string`, a constrained `Sum[T Number]` function, and a generic `Stack[T]` used with two concrete types.

## Common Mistakes

- Assuming Go always had generics — pre-2022 Go code and many existing idioms/libraries use `interface{}`/`any` plus type assertions instead, since generics simply didn't exist as a language feature until Go 1.18.
- Confusing `comparable` (supports `==`/`!=`) with an ordering constraint (`<`/`>`) — they're different capabilities; use `cmp.Ordered` (Go 1.21+) for ordering.
- Over-using generics where a simple `interface{}`/`any` parameter (with a type switch, if truly needed) would be clearer for a one-off case.

## Best Practices

- Use the narrowest constraint a generic function/type actually needs (`comparable`, `cmp.Ordered`, a custom interface union) rather than defaulting to unconstrained `any` everywhere.
- Reach for generics primarily for container types (`Stack[T]`, a generic linked list) and utility functions (`Map`/`Filter`/`Reduce`-style helpers) working uniformly across many element types.

## Real-World Usage

Since Go 1.21, the standard library itself includes generic utility packages (`slices`, `maps`, `cmp`) providing `Map`/`Filter`/`Sort`-style operations generically — directly comparable to the Stream API (Java)/LINQ (C#)/`<algorithm>` (C++) covered in this repository's other language courses, just added to Go much more recently.

## Summary

- Go had no generics until version 1.18 (2022) — a genuinely recent addition, unlike every other statically-typed language course in this repository.
- Type parameters (`[T any]`) and constraints (`comparable`, custom interface unions, `cmp.Ordered`) provide compile-time-checked generic functions and types.
- Pre-2022 Go code (and much existing idiom) uses `interface{}`/`any` plus type assertions instead, since generics weren't available.

## Key Terms

- **Type parameter** — `[T Constraint]` in a function/type signature, Go's generics syntax (since 1.18).
- **`comparable`** — a built-in constraint meaning a type supports `==`/`!=`.
- **`cmp.Ordered`** (Go 1.21+) — a standard-library constraint for types supporting ordering comparisons (`<`, `>`).

## Interview Questions

1. **When were generics added to Go, and what did Go code do before that?**
   Go 1.18, released in March 2022 — over a decade after Go's initial release. Before generics, Go code needing to work generically across types used `interface{}` (Go's "any type" interface, now more commonly spelled `any`) combined with runtime type assertions or type switches, sacrificing compile-time type safety for flexibility — a real and often-cited limitation of pre-generics Go.

2. **What's the difference between the `comparable` and `cmp.Ordered` constraints?**
   `comparable` (a built-in Go constraint) means a type supports equality comparison (`==`/`!=`) — nearly every type satisfies it. `cmp.Ordered` (from the standard library's `cmp` package, Go 1.21+) means a type supports ordering comparisons (`<`, `>`, `<=`, `>=`) — a stricter, narrower requirement, since not every comparable type is meaningfully ordered (e.g., structs typically aren't, even if they support `==`).

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
