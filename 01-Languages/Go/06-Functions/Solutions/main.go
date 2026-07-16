// main.go - splitName using multiple/named return values.
package main

import (
	"fmt"
	"strings"
)

func splitName(fullName string) (first, last string, ok bool) {
	parts := strings.Fields(fullName)
	if len(parts) != 2 {
		return "", "", false
	}
	return parts[0], parts[1], true
}

func main() {
	f, l, ok := splitName("Ada Lovelace")
	if ok {
		fmt.Println(f, "/", l)
	}

	_, _, ok2 := splitName("Madonna")
	if !ok2 {
		fmt.Println("Split failed as expected")
	}
}
