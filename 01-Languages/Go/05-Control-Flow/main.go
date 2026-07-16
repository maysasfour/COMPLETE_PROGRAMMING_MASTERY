// main.go - if/switch (no fall-through), all three for forms, range.
package main

import "fmt"

func main() {
	fmt.Println("--- if/else ---")
	temperature := 20
	if temperature > 30 {
		fmt.Println("hot")
	} else if temperature > 15 {
		fmt.Println("warm")
	} else {
		fmt.Println("cool")
	}

	fmt.Println("\n--- switch (no fall-through by default) ---")
	switch temperature {
	case 30:
		fmt.Println("exactly 30")
	default:
		fmt.Println("not exactly 30")
	}

	fmt.Println("\n--- for: classic three-part form ---")
	for i := 0; i < 3; i++ {
		fmt.Print(i, " ")
	}
	fmt.Println()

	fmt.Println("--- for: while form ---")
	count := 0
	for count < 3 {
		fmt.Print(count, " ")
		count++
	}
	fmt.Println()

	fmt.Println("--- for: infinite loop form with break ---")
	i := 0
	for {
		if i >= 3 {
			break
		}
		fmt.Print(i, " ")
		i++
	}
	fmt.Println()

	fmt.Println("\n--- range ---")
	numbers := []int{10, 20, 30}
	for index, value := range numbers {
		fmt.Println("index:", index, "value:", value)
	}
	for _, value := range numbers {
		fmt.Println("value only:", value)
	}
}
