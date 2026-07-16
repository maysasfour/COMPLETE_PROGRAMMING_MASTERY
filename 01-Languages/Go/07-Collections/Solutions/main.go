// main.go - word frequency counting with a map, ranked via sort.Slice.
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

func main() {
	freq := wordFrequency("Cats, cats, and dogs. Dogs love cats!")
	for _, entry := range topN(freq, 2) {
		fmt.Printf("%s: %d\n", entry.word, entry.count)
	}
}
