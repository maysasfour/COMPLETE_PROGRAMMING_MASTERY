// solution-02.go - Exercise 02: custom error type + errors.As/errors.Is through a %w wrapper.
package main

import (
	"errors"
	"fmt"
)

// InsufficientFundsError carries structured data, not just a message -- the whole point of a
// custom error type over errors.New is that callers can recover the fields, not just the text.
type InsufficientFundsError struct {
	Balance   float64
	Requested float64
}

func (e *InsufficientFundsError) Error() string {
	return fmt.Sprintf("insufficient funds: balance %.2f, requested %.2f", e.Balance, e.Requested)
}

func Withdraw(balance, amount float64) (float64, error) {
	if amount > balance {
		return 0, &InsufficientFundsError{Balance: balance, Requested: amount}
	}
	return balance - amount, nil
}

func main() {
	_, err := Withdraw(100, 250)

	// errors.As walks the error chain looking for a match on the target's concrete type,
	// unwrapping through anything implementing Unwrap() along the way -- unlike a plain type
	// assertion, which only ever looks at the top-level error value.
	var insufficientErr *InsufficientFundsError
	if errors.As(err, &insufficientErr) {
		fmt.Printf("direct: extracted struct fields -- balance=%.2f requested=%.2f (shortfall=%.2f)\n",
			insufficientErr.Balance, insufficientErr.Requested, insufficientErr.Requested-insufficientErr.Balance)
	}

	// Wrap with %w (not %v) specifically so the original error stays reachable in the chain.
	wrapped := fmt.Errorf("transaction rejected: %w", err)
	fmt.Println("wrapped error message:", wrapped)

	var insufficientErr2 *InsufficientFundsError
	if errors.As(wrapped, &insufficientErr2) {
		fmt.Printf("through wrapper: still extracted -- balance=%.2f requested=%.2f\n",
			insufficientErr2.Balance, insufficientErr2.Requested)
	} else {
		fmt.Println("errors.As failed to unwrap -- this would happen if %v had been used instead of %w")
	}
}
