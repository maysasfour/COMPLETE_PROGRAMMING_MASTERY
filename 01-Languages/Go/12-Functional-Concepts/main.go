// main.go - functions as first-class values, closures, Go 1.22+ loop variable capture.
package main

import "fmt"

func applyTwice(fn func(int) int, x int) int {
	return fn(fn(x))
}

func makeCounter() func() int {
	count := 0
	return func() int {
		count++
		return count
	}
}

func main() {
	fmt.Println("--- functions as first-class values ---")
	add := func(a, b int) int { return a + b }
	fmt.Println("add(2, 3):", add(2, 3))

	double := func(n int) int { return n * 2 }
	fmt.Println("applyTwice(double, 5):", applyTwice(double, 5))

	fmt.Println("\n--- closures with independent state ---")
	counterA := makeCounter()
	counterB := makeCounter()
	fmt.Println("counterA:", counterA(), counterA(), counterA())
	fmt.Println("counterB:", counterB(), "(independent from counterA)")

	fmt.Println("\n--- loop variable capture (Go 1.22+ semantics) ---")
	var funcs []func()
	for i := 0; i < 3; i++ {
		funcs = append(funcs, func() { fmt.Println(i) })
	}
	for _, f := range funcs {
		f()
	}
}
