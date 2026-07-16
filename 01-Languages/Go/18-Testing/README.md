# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with Go's built-in `testing` package — like `net/http` and `encoding/json`, no external dependency needed.
- Use table-driven tests, Go's idiomatic parameterized-test pattern.
- Use `t.Errorf`/`t.Fatalf` correctly.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Go's `testing` package is fully built into the standard library — like Python's `pytest` needing an install, or Java's JUnit/C#'s xUnit both being third-party, Go instead ships testing support directly, closer in spirit to JavaScript's `node:test`. Test files are named `*_test.go` and are automatically excluded from a normal `go build`/`go run`, discovered only by the `go test` command.

## Basic Tests

```go
// mathutils_test.go
package main

import "testing"

func TestAddSumsTwoPositiveNumbers(t *testing.T) {
	got := add(2, 3)
	want := 5
	if got != want {
		t.Errorf("add(2, 3) = %d; want %d", got, want)
	}
}
```

A test function must be named `TestXxx` (capitalized, taking `*testing.T`) to be discovered — Go has no `[Fact]`/`@Test` annotation; the naming convention itself **is** the discovery mechanism. `t.Errorf` records a failure but lets the test function continue running; `t.Fatalf` records a failure and immediately stops that test function (useful when a later assertion would panic if an earlier one already failed, e.g., dereferencing a nil result).

## Table-Driven Tests: Go's Idiomatic Parameterization

```go
func TestAddTableDriven(t *testing.T) {
	cases := []struct {
		a, b, want int
	}{
		{1, 1, 2},
		{0, 0, 0},
		{-1, 1, 0},
	}
	for _, c := range cases {
		got := add(c.a, c.b)
		if got != c.want {
			t.Errorf("add(%d, %d) = %d; want %d", c.a, c.b, got, c.want)
		}
	}
}
```

Rather than a special `[InlineData]`/`@CsvSource`/`@parametrize` annotation, Go's convention is a plain slice of anonymous structs iterated with an ordinary `for` loop — no special language feature needed, since it's just data plus a loop, following Go's general "no special syntax where a normal language feature already works" philosophy.

## Detailed Example

See [mathutils.go](mathutils.go) (module under test) and [mathutils_test.go](mathutils_test.go) (tests).

## Run It

```bash
cd 01-Languages/Go/18-Testing
go test -v
```

## Expected Output

`go test -v` reports all 5 tests passing (`--- PASS:` for each), ending with `PASS` and `ok`.

## Common Mistakes

- Forgetting the `Test` prefix (capitalized) on a test function name — Go simply won't discover/run it, with no error or warning.
- Using `t.Errorf` when `t.Fatalf` was needed (or vice versa) — `Errorf` lets execution continue, which can cause a confusing secondary panic if a later line depends on something the first failure means isn't actually valid.
- Naming a test file without the `_test.go` suffix — it won't be recognized as a test file at all.

## Best Practices

- Use table-driven tests for the same logic across multiple input/output pairs, Go's idiomatic parameterization approach.
- Use `t.Fatalf` when a failed assertion means continuing the test function would be meaningless or crash; use `t.Errorf` when independent checks should all still run and report.
- Keep the module under test and its test file separate but co-located (as this lesson does), matching the convention from every other language course's testing lesson.

## Real-World Usage

`go test ./...` (running every package's tests recursively) is the standard command in Go CI pipelines, exactly analogous to `pytest`/`node --test`/`dotnet test`/`mvn test` in this repository's other language courses — with the notable difference that no test framework needed to be installed first.

## Summary

- Go's `testing` package is fully built into the standard library — no dependency needed, unlike Java/C#/C++.
- `TestXxx(t *testing.T)` naming is the discovery mechanism — no special annotation exists.
- Table-driven tests (a slice of struct cases plus a loop) are Go's idiomatic parameterized-test pattern, needing no special language feature.

## Key Terms

- **`testing` package** — Go's built-in testing framework.
- **Table-driven test** — Go's idiomatic pattern for parameterized tests: a slice of case structs iterated in a loop.

## Interview Questions

1. **How does Go discover which functions are tests, given it has no `[Fact]`/`@Test` annotation?**
   Purely by naming convention: a function named `TestXxx` (capitalized `Test` prefix) taking a single `*testing.T` parameter, defined in a file ending in `_test.go`, is automatically discovered and run by `go test`. There's no special annotation or registration step — the naming convention itself is the entire discovery mechanism.

2. **What is a table-driven test, and why does Go favor this pattern over a dedicated parameterized-test feature?**
   A table-driven test defines a slice of anonymous structs, each representing one test case (inputs plus expected output), then iterates that slice with an ordinary `for` loop, running the same assertion logic against each case. Go favors this over a dedicated language/framework feature (like `[InlineData]` or `@CsvSource`) because it requires no special syntax at all — it's just data and a loop, consistent with Go's broader philosophy of solving problems with existing, simple language features rather than adding new ones.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
