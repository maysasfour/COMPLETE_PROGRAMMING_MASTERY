// main.go - arrays vs slices, slice aliasing, maps with the comma-ok idiom.
package main

import "fmt"

func main() {
	fmt.Println("--- arrays vs slices ---")
	var arr [3]int = [3]int{1, 2, 3}
	slice := []int{1, 2, 3}
	slice = append(slice, 4)
	fmt.Println("arr:", arr, "(fixed size, part of the type)")
	fmt.Println("slice after append:", slice)

	fmt.Println("\n--- slice aliasing: a sub-slice shares the underlying array ---")
	original := []int{1, 2, 3, 4, 5}
	view := original[1:3]
	view[0] = 999
	fmt.Println("original after mutating view:", original)

	fmt.Println("\n--- maps and the comma-ok idiom ---")
	ages := map[string]int{"Ada": 30}
	value, ok := ages["Ada"]
	fmt.Println("ages[\"Ada\"]:", value, "ok:", ok)

	value2, ok2 := ages["Unknown"]
	fmt.Println("ages[\"Unknown\"]:", value2, "ok:", ok2, "(zero value, not an error)")
}
