// main.go - arithmetic/comparison/logical, no-ternary if/else, pointers.
package main

import "fmt"

func main() {
	fmt.Println("--- arithmetic, comparison, logical ---")
	a := 5
	b := 10
	fmt.Println(a+b, a == b, a < b, a > 0 && b > 0, !false)

	fmt.Println("\n--- no ternary: if/else required ---")
	var result string
	if a < b {
		result = "a is smaller"
	} else {
		result = "b is smaller or equal"
	}
	fmt.Println(result)

	fmt.Println("\n--- pointers ---")
	x := 5
	ptr := &x
	*ptr = 10
	fmt.Println("x after modifying through ptr:", x)
}
