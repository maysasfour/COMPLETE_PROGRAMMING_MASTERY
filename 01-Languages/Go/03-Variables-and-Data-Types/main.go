// main.go - var/:= declarations, zero values, basic types, const.
package main

import "fmt"

const Pi = 3.14159

func main() {
	fmt.Println("--- var and := ---")
	var age int = 30
	var name = "Ada"
	count := 42
	fmt.Println("age:", age, "name:", name, "count:", count)

	fmt.Println("\n--- zero values ---")
	var uninitializedInt int
	var emptyString string
	var flag bool
	var ptr *int
	fmt.Printf("int zero value: %d\n", uninitializedInt)
	fmt.Printf("string zero value: %q\n", emptyString)
	fmt.Printf("bool zero value: %t\n", flag)
	fmt.Printf("pointer zero value: %v\n", ptr)

	fmt.Println("\n--- const ---")
	fmt.Println("Pi:", Pi)
}
