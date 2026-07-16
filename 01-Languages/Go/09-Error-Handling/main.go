// main.go - (value, error) pattern, custom error types with errors.As, panic/recover.
package main

import (
	"errors"
	"fmt"
)

func validateAge(age int) (int, error) {
	if age < 0 {
		return 0, errors.New("age cannot be negative")
	}
	return age, nil
}

type ValidationError struct {
	Field   string
	Message string
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func validate(age int) error {
	if age < 0 {
		return &ValidationError{Field: "age", Message: "cannot be negative"}
	}
	return nil
}

func mustDivide(a, b int) int {
	if b == 0 {
		panic("division by zero")
	}
	return a / b
}

func safeDivide(a, b int) (result int, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("recovered from panic: %v", r)
		}
	}()
	return mustDivide(a, b), nil
}

func main() {
	fmt.Println("--- (value, error) pattern ---")
	_, err := validateAge(-5)
	if err != nil {
		fmt.Println("Validation failed:", err)
	}

	fmt.Println("\n--- custom error type with errors.As ---")
	err2 := validate(-5)
	var valErr *ValidationError
	if errors.As(err2, &valErr) {
		fmt.Println("Field:", valErr.Field, "Message:", valErr.Message)
	}

	fmt.Println("\n--- panic/recover ---")
	result, err3 := safeDivide(10, 0)
	if err3 != nil {
		fmt.Println("safeDivide error:", err3)
	} else {
		fmt.Println("safeDivide result:", result)
	}

	result2, err4 := safeDivide(10, 2)
	fmt.Println("safeDivide(10, 2):", result2, "err:", err4)
}
