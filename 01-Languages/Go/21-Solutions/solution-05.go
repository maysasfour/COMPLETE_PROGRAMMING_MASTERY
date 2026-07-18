// solution-05.go - Exercise 05: generic Result[T] plus a cmp.Ordered-constrained sum.
package main

import (
	"cmp"
	"errors"
	"fmt"
	"strconv"
)

type Result[T any] struct {
	Value T
	Err   error
}

func Ok[T any](v T) Result[T]      { return Result[T]{Value: v} }
func Err[T any](e error) Result[T] { return Result[T]{Err: e} }

// MatchResult has to be a free function, not a method on Result[T] -- Go does not let a method
// introduce type parameters beyond the ones already bound to its receiver, so U can't appear
// on a Result[T] method signature the way it can here.
func MatchResult[T, U any](r Result[T], onSuccess func(T) U, onFailure func(error) U) U {
	if r.Err != nil {
		return onFailure(r.Err)
	}
	return onSuccess(r.Value)
}

func ParseAge(input string) Result[int] {
	age, err := strconv.Atoi(input)
	if err != nil {
		return Err[int](fmt.Errorf("%q is not a valid integer: %w", input, err))
	}
	if age < 0 {
		return Err[int](errors.New("age cannot be negative"))
	}
	return Ok(age)
}

// SumOrdered is instantiated once per concrete type at compile time (monomorphization) --
// the same source works for []int and []float64 with no boxing and no runtime type checks.
func SumOrdered[T cmp.Ordered](values []T) T {
	var total T
	for _, v := range values {
		total += v
	}
	return total
}

func main() {
	validResult := ParseAge("34")
	msg := MatchResult(validResult,
		func(age int) string { return fmt.Sprintf("parsed age: %d", age) },
		func(err error) string { return "error: " + err.Error() },
	)
	fmt.Println(msg)

	invalidResult := ParseAge("not-a-number")
	msg = MatchResult(invalidResult,
		func(age int) string { return fmt.Sprintf("parsed age: %d", age) },
		func(err error) string { return "error: " + err.Error() },
	)
	fmt.Println(msg)

	ints := []int{1, 2, 3, 4, 5}
	floats := []float64{1.5, 2.5, 3.0}
	fmt.Printf("SumOrdered(ints)   = %d\n", SumOrdered(ints))
	fmt.Printf("SumOrdered(floats) = %.1f\n", SumOrdered(floats))
}
