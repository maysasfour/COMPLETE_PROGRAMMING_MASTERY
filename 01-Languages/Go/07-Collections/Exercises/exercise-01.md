# Exercise 01 — Word Frequency with a Map

[Back to lesson](../README.md)

## Task

Write `wordFrequency(text string) map[string]int` that lowercases and strips basic punctuation (`.`, `,`, `!`, `?`), splits on whitespace (`strings.Fields`), and returns a frequency map. Then write a function that finds the top N most frequent words (ties broken alphabetically) by copying the map into a slice of structs and sorting with `sort.Slice`.

## Constraints

- Use `sort.Slice` with a custom comparator — no manual sorting loop.
- `"Cats, cats, and dogs. Dogs love cats!"` should count `"cats"` as 3.

## Starter Code

```go
package main

import (
	"fmt"
	"sort"
	"strings"
)

type wordCount struct {
	word  string
	count int
}

func wordFrequency(text string) map[string]int {
	cleaned := strings.ToLower(text)
	cleaned = strings.NewReplacer(".", "", ",", "", "!", "", "?", "").Replace(cleaned)
	freq := make(map[string]int)
	for _, word := range strings.Fields(cleaned) {
		freq[word]++
	}
	return freq
}

func topN(freq map[string]int, n int) []wordCount {
	entries := make([]wordCount, 0, len(freq))
	for word, count := range freq {
		entries = append(entries, wordCount{word, count})
	}
	sort.Slice(entries, func(i, j int) bool {
		if entries[i].count != entries[j].count {
			return entries[i].count > entries[j].count
		}
		return entries[i].word < entries[j].word
	})
	if len(entries) > n {
		entries = entries[:n]
	}
	return entries
}
```

## Expected Output

```
cats: 3
dogs: 2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.go](../Solutions/main.go).
