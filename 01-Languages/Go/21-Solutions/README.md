# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Solutions to all 7 problems in [20-Exercises](../20-Exercises/README.md), one self-contained `.go` file per exercise (`solution-01.go` through `solution-07.go`), all `package main` in this same directory. Each is independently runnable — `go run solution-NN.go` compiles only the named file, ignoring its siblings (they all happen to declare their own `func main`, which would conflict under `go build ./...`, but `go run <single-file>.go` never touches the rest of the directory). A shared `go.mod` covers the whole folder; none of the seven needs anything beyond the standard library, so there's no `go.sum`.

Every file below was actually run with `go run` (Go 1.23.4) and the output pasted verbatim — nothing here was written from imagination.

## How to Run Any Solution

```bash
cd 01-Languages/Go/21-Solutions
go run solution-01.go
```

## Solution 01 — Zero-Value-Safe Struct + Validating Constructor

[solution-01.go](solution-01.go)

```
$ go run solution-01.go
zero-value Rectangle: {Width:0 Height:0}, Area() = 0.0 (no crash, no nil check needed)
NewRectangle(4, 5) succeeded: {Width:4 Height:5}, Area() = 20.0
NewRectangle(-3, 5) rejected as expected: width and height must both be positive
```

## Solution 02 — Custom Error Type + `errors.As`/`errors.Is`

[solution-02.go](solution-02.go)

```
$ go run solution-02.go
direct: extracted struct fields -- balance=100.00 requested=250.00 (shortfall=150.00)
wrapped error message: transaction rejected: insufficient funds: balance 100.00, requested 250.00
through wrapper: still extracted -- balance=100.00 requested=250.00
```

## Solution 03 — Slice/Map Sales Report with Closures

[solution-03.go](solution-03.go)

```
$ go run solution-03.go
--- revenue per product (descending) ---
  Gadget   850.85
  Gizmo    400.60
  Widget   340.75

highest-value sale: Gadget in North for 400.10

--- regions selling 2+ distinct products ---
  East (3 distinct products)
  West (3 distinct products)
  North (3 distinct products)

average sale amount: 159.22
east-region sale count (via filterSales closure): 4
```

Note: Go's `map` iteration order is randomized by design (a deliberate anti-footgun so code never accidentally depends on it), so the "regions selling 2+ distinct products" lines can print in a different order between runs — the *set* of regions printed will always be the same three.

## Solution 04 — Structs, Implicit Interfaces, and Embedding

[solution-04.go](solution-04.go)

```
$ go run solution-04.go
This is a circle | Area=28.27 Perimeter=18.85
This is a rectangle | Area=24.00 Perimeter=20.00
This is a rectangle | Area=25.00 Perimeter=20.00
  ...and it's a square
```

## Solution 05 — Generic `Result[T]` with a Constrained Sum

[solution-05.go](solution-05.go)

```
$ go run solution-05.go
parsed age: 34
error: "not-a-number" is not a valid integer: strconv.Atoi: parsing "not-a-number": invalid syntax
SumOrdered(ints)   = 15
SumOrdered(floats) = 7.0
```

## Solution 06 — Concurrent "Fetches" with Goroutines and Channels

[solution-06.go](solution-06.go)

```
$ go run solution-06.go
https://api.example.com/broken -> FAILED: simulated error
https://api.example.com/users -> 200 OK
https://api.example.com/products -> 200 OK
https://api.example.com/orders -> 200 OK

total elapsed: 506ms (close to the slowest single delay of 500ms, not the ~1400ms sum of all four)
```

The order results print in is nondeterministic (whichever `time.Sleep` finishes first sends first — here the 200ms `/broken` job won the race), which is itself proof the fetches ran concurrently rather than in the order they were launched. The elapsed time (506ms) tracks the slowest single delay (500ms) plus a few milliseconds of goroutine/channel overhead, not the ~1400ms sum of all four delays — re-run and the exact number will vary slightly but should stay in that same ballpark.

## Solution 07 — JSON Roundtrip with Filtering

[solution-07.go](solution-07.go)

```
$ go run solution-07.go
wrote temp file: C:\Users\HP\AppData\Local\Temp\books-1719179406.json
read back 6 books from disk

books published after 2015 with rating >= 4.0, sorted by rating descending:
  100 Go Mistakes                Teiva Harsanyi                 2022  4.8
  Learning Go                    Jon Bodner                     2021  4.6
  Concurrency in Go              Katherine Cox-Buday            2017  4.3

temp file cleanup confirmed: os.Stat now returns os.ErrNotExist
```

The temp file path and its random suffix (`books-1719179406.json`) will differ on every run (`os.CreateTemp` guarantees uniqueness) — the important part is that the program creates it, reads it back, and deletes it, confirmed via the `os.Stat`/`os.ErrNotExist` check at the end. No `.json` file was left behind in the repository or the OS temp directory after running this.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
