// main.go - basic program structure and runtime version check.
package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println("Hello, Go")
	fmt.Println("Running on Go version:", runtime.Version())
}
