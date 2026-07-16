# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Use Go's signature feature: **multiple return values**.
- Use named return values and variadic parameters.
- Understand Go has no default parameter values and no overloading — a single function name, one signature.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Go functions can return **multiple values** directly — no tuple, no wrapper object needed, just comma-separated return types and values. This is the language feature that makes Go's `(value, error)` idiom (Lesson 09) possible without any special error-handling syntax at all: a function that can fail simply returns its normal result *and* an error value side by side.

## Multiple Return Values

```go
func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errors.New("cannot divide by zero")
	}
	return a / b, nil
}

result, err := divide(10, 2)
if err != nil {
	fmt.Println("Error:", err)
} else {
	fmt.Println("Result:", result)
}
```

## Named Return Values

```go
func minMax(numbers []int) (min, max int) { // named returns -- declared in the signature
	min, max = numbers[0], numbers[0]
	for _, n := range numbers {
		if n < min {
			min = n
		}
		if n > max {
			max = n
		}
	}
	return // "naked" return -- returns the current values of min and max
}
```

Named return values are pre-declared local variables that a bare `return` (with no explicit values) automatically returns — useful for documenting what each return value means, though naked returns are often discouraged in longer functions for readability.

## Variadic Parameters

```go
func sum(numbers ...int) int { // variadic -- called with any number of int arguments
	total := 0
	for _, n := range numbers {
		total += n
	}
	return total
}

sum(1, 2, 3, 4) // called with any number of arguments
```

## No Default Parameters, No Overloading

Go deliberately has neither — every function has exactly one signature, and there's no way to omit an argument or provide multiple same-named functions with different parameter lists. The idiomatic workaround for "optional-ish" parameters is a variadic options pattern or a dedicated options struct, not language-level defaults.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints a multiple-return-value function used with the standard `if err != nil` check, a named-return-value function, and a variadic sum.

## Common Mistakes

- Ignoring one of a function's multiple return values (especially the `error`) — Go allows this syntactically for non-error extra values via `_`, but ignoring an `error` return without checking it is exactly the Lesson 09 mistake to avoid.
- Expecting default parameter values or overloading — neither exists; a variadic parameter or a dedicated options struct/function are the idiomatic substitutes.

## Best Practices

- Always check every returned `error` immediately.
- Use named return values sparingly, mainly to clarify what multiple returned values individually mean — avoid relying on "naked" returns in long functions, where they hurt readability.
- Use variadic parameters for genuinely variable-arity operations (sums, string joins); use an options struct for a function with many optional configuration parameters.

## Real-World Usage

The `(value, error)` multiple-return pattern is used by nearly every fallible function in Go's standard library and the wider ecosystem — it's the single most distinctive, most pervasive idiom in the entire language, expanded fully in Lesson 09.

## Summary

- Go functions can return multiple values directly, with no tuple/wrapper type needed — this is what makes the `(value, error)` pattern possible.
- Named return values pre-declare return variables, usable with a bare `return`.
- Go has no default parameters and no overloading; variadic parameters and options structs are the idiomatic substitutes.

## Key Terms

- **Multiple return values** — Go functions can return more than one value directly, comma-separated in both the signature and the `return` statement.
- **Variadic parameter (`...T`)** — a parameter accepting a variable number of arguments, exposed as a slice inside the function.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **How do multiple return values in Go enable its error-handling idiom?**
   Because a Go function can return more than one value directly (no wrapper/tuple type required), a fallible function can return its normal result alongside an `error` value in the same statement — `result, err := doSomething()`. This is what makes Go's `if err != nil` pattern possible without any special exception-handling syntax; it's just an ordinary second return value, checked like any other.

2. **Does Go support function overloading or default parameter values?**
   No to both — a deliberate simplicity choice. Every function name maps to exactly one signature; there's no way to declare multiple same-named functions with different parameter lists, and no way to give a parameter a default value skippable by the caller. Variadic parameters (`...T`) and options-struct patterns are the idiomatic workarounds for variable-arity or many-optional-parameter needs.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
