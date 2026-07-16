// main.go - common string operations, byte vs rune, strconv conversions.
package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	fmt.Println("--- common operations ---")
	s := "  hello  "
	fmt.Printf("TrimSpace: [%s]\n", strings.TrimSpace(s))
	fmt.Println("ToUpper:", strings.ToUpper(s))
	fmt.Println("Contains 'ell':", strings.Contains(s, "ell"))
	fmt.Println("Split:", strings.Split("a,b,c", ","))
	fmt.Println("Join:", strings.Join([]string{"a", "b"}, "-"))
	fmt.Println("ReplaceAll:", strings.ReplaceAll("hello", "l", "L"))

	fmt.Println("\n--- byte length vs rune count ---")
	accented := "héllo"
	fmt.Println("len(accented) [byte count]:", len(accented))
	runeCount := 0
	for range accented {
		runeCount++
	}
	fmt.Println("rune count (via for range):", runeCount)

	fmt.Println("\n--- rune iteration ---")
	for i, r := range accented {
		fmt.Printf("byte offset %d: %c\n", i, r)
	}

	fmt.Println("\n--- strconv ---")
	n, err := strconv.Atoi("42")
	fmt.Println("Atoi(\"42\"):", n, "err:", err)

	_, err2 := strconv.Atoi("not-a-number")
	fmt.Println("Atoi(\"not-a-number\") err:", err2)

	str := strconv.Itoa(42)
	fmt.Println("Itoa(42):", str)
}
