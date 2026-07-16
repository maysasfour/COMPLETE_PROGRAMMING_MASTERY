# Solution 01 — A `splitName` Function with Multiple Return Values

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `strings.Fields` splits on any run of whitespace and automatically discards empty entries, correctly handling both a single-space "Ada Lovelace" and any accidental extra whitespace.
- Checking `len(parts) != 2` catches both zero-space names (`"Madonna"`) and multi-word names as failures, returning `ok = false` with empty strings rather than panicking — matching Go's `(value, ok)` idiom used pervasively throughout the standard library (e.g., map lookups, type assertions).
- No struct wrapper was needed — Go's native multiple return values express "first, last, and a success flag" directly and clearly.

## Verification

Ran with `go run main.go`; actual output:

```
Ada / Lovelace
Split failed as expected
```

Matches the exercise's expected output exactly.
