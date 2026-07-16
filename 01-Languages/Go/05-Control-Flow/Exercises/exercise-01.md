# Exercise 01 — FizzBuzz with Go's Single Loop Keyword

[Back to lesson](../README.md)

## Task

Write a function `fizzBuzz(n int) string` returning `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, and the number itself (via `strconv.Itoa`) otherwise. Use a `for` loop (Go's only loop keyword) to print results for 1 through 15.

## Constraints

- Use `if`/`else if` (not `switch`) inside `fizzBuzz`.
- Use the classic three-part `for` form to iterate 1 through 15.

## Starter Code

```go
package main

import (
	"fmt"
	"strconv"
)

func fizzBuzz(n int) string {
	// your logic here
}

func main() {
	for i := 1; i <= 15; i++ {
		fmt.Println(fizzBuzz(i))
	}
}
```

## Expected Output

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.go](../Solutions/main.go).
