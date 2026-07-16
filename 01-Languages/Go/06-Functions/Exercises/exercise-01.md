# Exercise 01 — A `splitName` Function with Multiple Return Values

[Back to lesson](../README.md)

## Task

Write `splitName(fullName string) (first, last string, ok bool)` that splits a "First Last" string using `strings.Fields` (splits on whitespace), returning `ok = false` (with empty strings) if the result isn't exactly two words.

## Constraints

- Must use Go's multiple/named return values — no single struct wrapper.
- No panics for a malformed name — return `ok = false` instead.

## Starter Code

```go
package main

import (
	"fmt"
	"strings"
)

func splitName(fullName string) (first, last string, ok bool) {
	// your logic here
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
```

## Expected Output

```
Ada / Lovelace
Split failed as expected
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.go](../Solutions/main.go).
