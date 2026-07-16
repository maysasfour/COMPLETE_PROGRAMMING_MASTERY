// main.go - multiple return values, named returns, variadic parameters.
package main

import (
	"errors"
	"fmt"
)

func divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errors.New("cannot divide by zero")
	}
	return a / b, nil
}

func minMax(numbers []int) (min, max int) {
	min, max = numbers[0], numbers[0]
	for _, n := range numbers {
		if n < min {
			min = n
		}
		if n > max {
			max = n
		}
	}
	return
}

func sum(numbers ...int) int {
	total := 0
	for _, n := range numbers {
		total += n
	}
	return total
}

func main() {
	fmt.Println("--- multiple return values ---")
	result, err := divide(10, 2)
	if err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println("Result:", result)
	}

	_, err = divide(10, 0)
	if err != nil {
		fmt.Println("Error:", err)
	}

	fmt.Println("\n--- named return values ---")
	min, max := minMax([]int{5, 3, 9, 1, 7})
	fmt.Println("min:", min, "max:", max)

	fmt.Println("\n--- variadic parameters ---")
	fmt.Println("sum(1,2,3,4):", sum(1, 2, 3, 4))
	fmt.Println("sum():", sum())
}
