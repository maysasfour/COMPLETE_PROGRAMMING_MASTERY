# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use the `(value, error)` return pattern as Go's primary error-handling mechanism.
- Create custom errors with `errors.New`/`fmt.Errorf` and check specific error types with `errors.Is`/`errors.As`.
- Use `panic`/`recover` for genuinely exceptional, unrecoverable situations — not routine error handling.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Go deliberately has **no exceptions** for routine error handling — every language course before this one in this repository uses `try`/`catch`. Instead, Go's convention (enabled by multiple return values, Lesson 06) is: a function that can fail returns its normal result **and** an `error` value, and the caller checks `if err != nil` immediately. `panic`/`recover` exist but are reserved for truly exceptional situations (a programming bug, an unrecoverable state) — using them for expected, routine failures (like "file not found" or "invalid user input") is considered un-idiomatic Go.

## The `(value, error)` Pattern (Recap and Extension)

```go
import "errors"

func validateAge(age int) (int, error) {
	if age < 0 {
		return 0, errors.New("age cannot be negative")
	}
	return age, nil
}

age, err := validateAge(-5)
if err != nil {
	fmt.Println("Validation failed:", err)
}
```

## Custom Error Types and `errors.Is`/`errors.As`

```go
type ValidationError struct {
	Field   string
	Message string
}

func (e *ValidationError) Error() string { // implementing the `error` interface
	return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func validate(age int) error {
	if age < 0 {
		return &ValidationError{Field: "age", Message: "cannot be negative"}
	}
	return nil
}

err := validate(-5)
var valErr *ValidationError
if errors.As(err, &valErr) { // checks if err IS (or wraps) a *ValidationError, and extracts it
	fmt.Println("Field:", valErr.Field)
}
```

Any type with an `Error() string` method automatically satisfies the built-in `error` interface — this is Go's structural typing (Lesson 11) applied to errors specifically, with no special "must extend Exception" requirement the way Java/C#/C++ have for custom exceptions.

## `panic`/`recover`: For Truly Exceptional Situations Only

```go
func mustDivide(a, b int) int {
	if b == 0 {
		panic("division by zero") // for a genuine programming error, not routine handling
	}
	return a / b
}

func safeDivide(a, b int) (result int, err error) {
	defer func() {
		if r := recover(); r != nil { // recover() catches a panic, converting it back to a normal error
			err = fmt.Errorf("recovered from panic: %v", r)
		}
	}()
	return mustDivide(a, b), nil
}
```

`recover()` only works inside a `defer`-ed function, and only catches a panic occurring in the same goroutine. Using `panic`/`recover` as a general substitute for `try`/`catch` (rather than for genuinely unrecoverable situations, or at a well-defined boundary like converting a library's panics into errors) is considered bad Go style.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints the `(value, error)` pattern used, a custom error type checked with `errors.As`, and a `panic` recovered and converted back into a normal `error` return.

## Common Mistakes

- Ignoring a returned `error` — Go allows this syntactically (there's no compiler-enforced "must handle" the way checked exceptions are in Java), so it's a real, easy-to-make mistake with no safety net beyond code review/linters.
- Using `panic` for routine, expected failures (invalid user input, a missing file) instead of returning an `error` — idiomatic Go reserves `panic` for genuinely unrecoverable situations.
- Forgetting `recover()` only works inside a directly-`defer`-ed function — calling it elsewhere does nothing.

## Best Practices

- Always check every returned `error` immediately after the call.
- Implement the `error` interface (`Error() string`) for custom error types, and use `errors.Is`/`errors.As` to check for specific error types/values rather than string-comparing error messages.
- Reserve `panic`/`recover` for genuinely exceptional situations or well-defined boundaries (like a top-level HTTP handler recovering from any panic in request-handling code to avoid crashing the whole server).

## Real-World Usage

Nearly every function in Go's standard library and the broader ecosystem that can fail returns an `error` as its last return value — this is the single most consistent idiom across the entire language, and linters (like `errcheck`) exist specifically to catch ignored error returns, since the compiler itself doesn't enforce it.

## Summary

- Go has no exceptions for routine error handling — the `(value, error)` return pattern is the idiomatic mechanism, enabled by multiple return values.
- Any type implementing `Error() string` satisfies the built-in `error` interface; `errors.Is`/`errors.As` check for specific error types/values.
- `panic`/`recover` exist but are reserved for genuinely exceptional situations, not routine error handling — using them as a `try`/`catch` substitute is un-idiomatic.

## Key Terms

- **`error` interface** — Go's built-in interface (`Error() string`) that any custom error type can implement.
- **`panic`/`recover`** — Go's mechanism for genuinely exceptional, unrecoverable situations; `recover()` only works inside a directly-deferred function.

## Interview Questions

1. **How does Go handle routine errors, given it has no `try`/`catch`?**
   A function that can fail returns its normal result alongside an `error` value (by convention, the last return value) — enabled by Go's support for multiple return values. The caller checks `if err != nil` immediately after the call; there's no automatic propagation the compiler enforces, so an ignored error is silently dropped rather than causing a build error or an obvious crash.

2. **When is it appropriate to use `panic`/`recover` in Go, versus returning an `error`?**
   `panic` is reserved for genuinely exceptional, typically unrecoverable situations — a programming bug (like an out-of-bounds index), a corrupted invariant, or a situation where continuing execution would be actively wrong. Routine, expected failures (invalid input, a missing file, a failed network call) should always be represented as a returned `error`, checked by the caller — using `panic` for these cases is considered poor Go style, since it bypasses the language's normal, explicit error-handling convention.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
