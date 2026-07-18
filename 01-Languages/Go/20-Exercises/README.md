# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 (which cover FizzBuzz-with-`for`, multiple-return-value functions, and slice-aliasing respectively) — solve those first if you haven't, then come back here for problems that pull in custom error types, struct embedding with implicit interfaces, generics with constraints, and goroutines/channels: the things that make Go's design distinctive against every other language course in this repository.

Attempt each problem yourself in a scratch `.go` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`Exercise 01` &harr; `solution-01.go`).

## Exercise 01 — Zero-Value-Safe Struct + Validating Constructor (Beginner)

**Lessons used:** Variables and Data Types (03), Error Handling (09)

Define a struct `Rectangle` with `Width, Height float64` fields and a method `Area() float64`. Write a validating constructor `NewRectangle(width, height float64) (Rectangle, error)` that returns a `Rectangle` and a `nil` error on success, or a zero `Rectangle{}` and a non-nil error if either dimension is `<= 0`.

- Show that a **zero-value** `Rectangle{}` (declared with `var r Rectangle`, no constructor at all) is immediately safe to call `.Area()` on and returns `0` — no crash, no nil-pointer check needed, unlike a language where an uninitialized object reference is `null`/`nil` by default.
- Show `NewRectangle` rejecting a negative width via the `(value, error)` pattern, checked with `if err != nil` at the call site (not a `try`/`catch`).

## Exercise 02 — Custom Error Type + `errors.As`/`errors.Is` (Beginner/Intermediate)

**Lessons used:** Error Handling (09)

Define a struct type `InsufficientFundsError` with fields `Balance, Requested float64` that implements the `error` interface (an `Error() string` method formatting a message from both fields). Write `Withdraw(balance, amount float64) (float64, error)` that returns the new balance on success, or `Rectangle{}`-style zero value plus an `*InsufficientFundsError` (returned via `&InsufficientFundsError{...}`) if `amount > balance`.

- Call `Withdraw` with an amount that fails, then use `errors.As` to extract the concrete `*InsufficientFundsError` back out of the returned `error` interface value and print its structured fields individually (not just the formatted string).
- Separately, wrap that same error with `fmt.Errorf("transaction rejected: %w", err)` and show `errors.As` **still** successfully unwraps through the wrapper to find the original `*InsufficientFundsError` — demonstrating why `%w` (not `%v`) matters for preserving the error chain.

## Exercise 03 — Slice/Map Sales Report with Closures (Intermediate)

**Lessons used:** Collections (07), Functional Concepts (12)

Define `type Sale struct { Product, Region string; Amount float64 }` and a hardcoded `[]Sale` of at least 10 entries spanning 3+ products and 2+ regions. Without any external library — only `sort` and plain loops/maps — compute and print:

- total revenue per product, as a `map[string]float64` built with a loop, then printed **sorted descending by revenue** (`sort.Slice` over a slice of product names, comparing against the map)
- the single highest-value sale (track it in one pass, don't sort the whole slice just to find a max)
- the set of distinct regions that sold 2 or more distinct products (a `map[string]map[string]bool` or equivalent, then filtered)
- the average sale amount, formatted to 2 decimal places with `fmt.Printf("%.2f", ...)`

Write at least one small reusable closure (e.g. a `filterSales(sales []Sale, keep func(Sale) bool) []Sale` helper) and use it for at least one of the above instead of a bespoke loop, to practice functions as values.

## Exercise 04 — Structs, Implicit Interfaces, and Embedding (Intermediate)

**Lessons used:** OOP (11)

Define an interface `Shape` with `Area() float64` and `Perimeter() float64`. Define a struct `NamedShape struct { Name string }` with a method `Describe() string` returning `"This is a " + s.Name`. Define `Circle` and `Rectangle` structs that each **embed** `NamedShape` (not just hold it as a named field) and implement `Shape` — satisfying the interface implicitly, with no `implements` keyword anywhere.

- Build a `[]Shape` containing at least one `Circle` and two `Rectangle`s (one of them with `Width == Height`), and iterate it printing `shape.Describe()` (promoted from the embedded `NamedShape`, called directly on the outer struct) alongside `Area()`/`Perimeter()`.
- For the square-shaped `Rectangle`, use a type assertion (`shape.(Rectangle)`) to detect `Width == Height` and print a distinct `"...and it's a square"` message — demonstrating that embedding gives you field/method promotion, not inheritance, and a type assertion is how you recover the concrete type from an interface value when you need to.

## Exercise 05 — Generic `Result[T]` with a Constrained Sum (Advanced)

**Lessons used:** Generics (13)

Model a minimal "railway-oriented" result type using Go 1.18+ generics — Go has no built-in `Result`/`Option` type (unlike Rust), so this is a from-scratch pattern:

```go
type Result[T any] struct {
    Value T
    Err   error
}

func Ok[T any](v T) Result[T]       { return Result[T]{Value: v} }
func Err[T any](e error) Result[T]  { return Result[T]{Err: e} }
```

Write a package-level generic function `MatchResult[T, U any](r Result[T], onSuccess func(T) U, onFailure func(error) U) U` (Go doesn't allow a method to introduce new type parameters beyond its receiver's, so this has to be a free function, not `r.Match(...)`). Use it to implement `ParseAge(input string) Result[int]` (wraps `strconv.Atoi`, fails on a negative parsed value too) and call `MatchResult` on both a valid and an invalid input, printing a different message via each branch's callback.

Separately, write `func SumOrdered[T cmp.Ordered](values []T) T` (Go 1.21+'s standard `cmp.Ordered` constraint) and call it with both a `[]int` and a `[]float64` — the same generic function, two different concrete instantiations, no boxing and no runtime type assertions involved.

## Exercise 06 — Concurrent "Fetches" with Goroutines and Channels (Advanced)

**Lessons used:** Async and Concurrency (14)

Write `fetch(id int, url string, delay time.Duration, shouldFail bool, results chan<- string, wg *sync.WaitGroup)` that (inside a goroutine) sleeps for `delay` via `time.Sleep`, then sends either `"<url> -> 200 OK"` or `"<url> -> FAILED: simulated error"` on `results`, and calls `wg.Done()` before returning.

- Launch at least 4 of these concurrently (`go fetch(...)`, mixed delays, at least one `shouldFail: true`) sharing one buffered `results` channel sized to the number of fetches, and a `sync.WaitGroup` to know when all goroutines have finished.
- Close the channel only after `wg.Wait()` returns (in a separate goroutine or after the wait, your choice — but get the ordering right, since sending on a closed channel panics and ranging over a channel that's never closed blocks forever).
- Measure wall-clock time with `time.Now()`/`time.Since()` around the whole batch and print it, confirming it's close to the **slowest single** delay, not the sum of all delays — proving the fetches ran concurrently, not sequentially.
- Range over the channel and print every result, including the failed one — nothing silently dropped.

## Exercise 07 — JSON Roundtrip with Filtering (Advanced)

**Lessons used:** File Handling (10), Collections (07)

Define `type Book struct { Title string \`json:"title"\`; Author string \`json:"author"\`; Year int \`json:"year"\`; Rating float64 \`json:"rating"\` }`. Write a program that:

- builds a `[]Book` of at least 6 books
- serializes it with `json.MarshalIndent` and writes it to a temp file created with `os.CreateTemp("", "books-*.json")`
- reads the file back with `os.ReadFile` and unmarshals it into a **new** `[]Book` (proving the roundtrip, not reusing the original slice)
- uses `sort.Slice` plus a plain loop to print books published after 2015 with `Rating >= 4.0`, sorted by rating descending
- removes the temp file with `os.Remove` at the end, and confirms cleanup succeeded by checking that a subsequent `os.Stat` on the same path returns an error satisfying `os.IsNotExist`

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
