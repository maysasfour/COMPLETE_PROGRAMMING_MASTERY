// main.go - imports a package from a different directory within the same module.
package main

import (
	"fmt"

	"example.com/modulesdemo/mathutils"
)

func main() {
	fmt.Println("mathutils.Add(2, 3):", mathutils.Add(2, 3))
	fmt.Println("mathutils.Multiply(4, 5):", mathutils.Multiply(4, 5))
}
