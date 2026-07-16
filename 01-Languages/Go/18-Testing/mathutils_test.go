// mathutils_test.go - Go's built-in testing package. Files ending in _test.go are
// automatically discovered by `go test` and excluded from a normal `go build`/`go run`.
package main

import "testing"

func TestAddSumsTwoPositiveNumbers(t *testing.T) {
	got := add(2, 3)
	want := 5
	if got != want {
		t.Errorf("add(2, 3) = %d; want %d", got, want)
	}
}

func TestAddHandlesNegativeNumbers(t *testing.T) {
	got := add(-2, -3)
	want := -5
	if got != want {
		t.Errorf("add(-2, -3) = %d; want %d", got, want)
	}
}

func TestDivideDividesCorrectly(t *testing.T) {
	got, err := divide(10, 2)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got != 5 {
		t.Errorf("divide(10, 2) = %f; want 5", got)
	}
}

func TestDivideThrowsOnDivisionByZero(t *testing.T) {
	_, err := divide(10, 0)
	if err == nil {
		t.Fatal("expected an error for division by zero, got nil")
	}
}

// Table-driven test -- Go's idiomatic way to parameterize a test across multiple cases,
// analogous to xUnit's [InlineData], JUnit's @CsvSource, and pytest's @parametrize.
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
