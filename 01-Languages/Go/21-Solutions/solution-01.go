// solution-01.go - Exercise 01: zero-value-safe struct + validating constructor.
package main

import (
	"errors"
	"fmt"
)

type Rectangle struct {
	Width, Height float64
}

// Area works correctly even on a Rectangle{} that was never touched by a constructor --
// Go zero-initializes struct fields (0.0 for float64), so there's no "uninitialized object"
// state to guard against, unlike a nil reference that would panic on method call elsewhere.
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// NewRectangle is the validating path. It returns the zero Rectangle{} alongside a non-nil
// error on failure -- the caller is expected to check err, not to catch an exception.
func NewRectangle(width, height float64) (Rectangle, error) {
	if width <= 0 || height <= 0 {
		return Rectangle{}, errors.New("width and height must both be positive")
	}
	return Rectangle{Width: width, Height: height}, nil
}

func main() {
	// No constructor call at all -- just a declaration. This is legal and safe in Go
	// precisely because there's no such thing as an uninitialized struct.
	var zero Rectangle
	fmt.Printf("zero-value Rectangle: %+v, Area() = %.1f (no crash, no nil check needed)\n", zero, zero.Area())

	good, err := NewRectangle(4, 5)
	if err != nil {
		fmt.Println("unexpected error:", err)
	} else {
		fmt.Printf("NewRectangle(4, 5) succeeded: %+v, Area() = %.1f\n", good, good.Area())
	}

	_, err = NewRectangle(-3, 5)
	if err != nil {
		fmt.Println("NewRectangle(-3, 5) rejected as expected:", err)
	}
}
