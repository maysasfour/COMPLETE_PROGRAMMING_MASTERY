# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Use functions as first-class values (assigned to variables, passed as arguments, returned from other functions).
- Write closures and understand Go's loop-variable-capture gotcha (fixed in Go 1.22+).
- Use function types for a decorator-style higher-order function.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Go functions are first-class values — assignable, passable, returnable — with no special ceremony (no `Func<>`/`std::function` wrapper type needed the way C#/C++ have, since Go function types are already concrete, nameable types). Closures work as expected, but Go had a well-known, now-fixed gotcha around loop variable capture that's worth understanding even after the fix, since older code and older Go versions still exhibit it.

## Functions as First-Class Values

```go
add := func(a, b int) int { return a + b } // a function literal, assigned to a variable
fmt.Println(add(2, 3))

func applyTwice(fn func(int) int, x int) int { // a function TYPE as a parameter
	return fn(fn(x))
}
double := func(n int) int { return n * 2 }
fmt.Println(applyTwice(double, 5)) // 20
```

## Closures

```go
func makeCounter() func() int {
	count := 0
	return func() int { // closes over `count` from the enclosing function
		count++
		return count
	}
}

counter := makeCounter()
fmt.Println(counter(), counter(), counter()) // 1 2 3 -- each call sees the same captured `count`
```

## The (Now-Fixed) Loop Variable Capture Gotcha

```go
// Go 1.22+ (this course's target version): each iteration gets its OWN loop variable
var funcs []func()
for i := 0; i < 3; i++ {
	funcs = append(funcs, func() { fmt.Println(i) })
}
for _, f := range funcs {
	f() // prints 0, 1, 2 -- each closure correctly captured its OWN i, as of Go 1.22+
}
```

**Before Go 1.22**, the loop variable `i` was a single shared variable reused across all iterations — every closure above would have captured the *same* `i`, and all three calls would print `3` (the final value after the loop ended), a famous, frequently-asked-about Go gotcha. Go 1.22 changed loop semantics so each iteration gets its own copy, eliminating the bug at the language level — but it's still worth knowing, since plenty of existing code (and pre-1.22 Go versions) still needs the classic workaround (capturing the loop variable via a function parameter).

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints function-as-value usage, a closure-based counter demonstrating independent captured state, and the loop-variable-capture example printing `0, 1, 2` correctly (confirming Go 1.22+ semantics).

## Common Mistakes

- Assuming pre-1.22 loop variable semantics if working with an older Go version or reading older code/tutorials — the classic "closures over a loop variable all print the same final value" bug is specific to Go < 1.22.
- Forgetting Go has no generic `Func<>`/`std::function` box needed — a function type (`func(int) int`) is already a concrete, directly usable type.

## Best Practices

- On Go 1.22+, loop variable capture in closures behaves intuitively — no special workaround needed.
- On older Go versions (or when in doubt), capture a loop variable explicitly via a parameter (`func(i int) { ... }(i)`) if a closure needs its own per-iteration copy.

## Real-World Usage

Closures are commonly used in Go for HTTP middleware (a function wrapping a handler, adding behavior like logging/auth before calling the original), directly mirroring the `withLogging`-style decorator pattern from the JavaScript/TypeScript/C#/Java courses.

## Summary

- Go functions are first-class values, directly usable as parameters/return values/variables with no special wrapper type needed.
- Closures capture enclosing variables, each call to an outer function producing independent captured state.
- Go 1.22+ fixed the classic loop-variable-capture gotcha by giving each loop iteration its own variable; older code/versions still need the manual capture workaround.

## Key Terms

- **Closure** — a function value that captures variables from its enclosing scope.
- **Loop variable capture (pre-Go 1.22)** — the historical gotcha where all iterations of a loop shared one loop variable, causing closures created inside the loop to all observe its final value.

## Interview Questions

1. **What changed about loop variables in Go 1.22, and why did it matter?**
   Prior to Go 1.22, a `for` loop's index/range variables were single variables reused across every iteration — a closure created inside the loop body and called later would see whatever the variable's value was *after the loop finished*, not the value at the iteration where the closure was created, since all closures shared the same underlying variable. Go 1.22 changed the language so each loop iteration gets its own fresh copy of the loop variable, making closures behave as most developers intuitively expect, without needing the classic manual-capture workaround.

2. **Does Go need a `Func<>`/`std::function`-style wrapper type to pass functions around, like C#/C++?**
   No — Go function types (like `func(int) int`) are already concrete, directly nameable, directly usable types; a function value can be assigned to a variable, passed as an argument, or returned from another function with no wrapper/boxing type needed at all.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
