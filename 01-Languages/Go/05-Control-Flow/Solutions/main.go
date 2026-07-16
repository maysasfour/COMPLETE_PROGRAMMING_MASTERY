// main.go - FizzBuzz with if/else if and Go's single for loop keyword.
package main

import (
	"fmt"
	"strconv"
)

func fizzBuzz(n int) string {
	if n%15 == 0 {
		return "FizzBuzz"
	}
	if n%3 == 0 {
		return "Fizz"
	}
	if n%5 == 0 {
		return "Buzz"
	}
	return strconv.Itoa(n)
}

func main() {
	for i := 1; i <= 15; i++ {
		fmt.Println(fizzBuzz(i))
	}
}
