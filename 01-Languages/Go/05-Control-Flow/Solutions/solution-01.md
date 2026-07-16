# Solution 01 — FizzBuzz with Go's Single Loop Keyword

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `n%15 == 0` is checked first, before `%3`/`%5`, since each `if` returns immediately — checking `%3`/`%5` first would incorrectly return `"Fizz"`/`"Buzz"` for multiples of 15 before the combined case is ever reached.
- `strconv.Itoa(n)` converts the fallback `int` to a `string` explicitly — Go has no implicit numeric-to-string conversion, unlike some other languages' string concatenation operators.
- `main` uses the classic three-part `for` form (`for i := 1; i <= 15; i++`), Go's only loop keyword covering what other languages might split across `for`/`while`.

## Verification

Ran with `go run main.go`; actual output matches the exercise's expected output exactly, line for line, for all values 1 through 15.
