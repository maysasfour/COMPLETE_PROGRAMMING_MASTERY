# Solution 01 — Word Frequency with a Map

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `strings.NewReplacer(...)` strips all four punctuation characters in one pass, more efficient than four separate `strings.ReplaceAll` calls.
- `freq[word]++` relies on Go's map semantics: reading a not-yet-present key returns the zero value (`0` for `int`), so incrementing it directly works correctly for both new and existing words with no explicit "does this key exist" check needed.
- `topN` copies the map's entries into a `[]wordCount` slice (maps have no defined iteration order in Go, so they can't be sorted directly) and uses `sort.Slice` with a custom `less` function: higher count first, alphabetical tie-break — the same comparator-composition pattern as the C#/Java/C++ courses' equivalent exercises.

## Verification

Ran with `go run main.go`; actual output:

```
cats: 3
dogs: 2
```

Matches the exercise's expected output exactly.
