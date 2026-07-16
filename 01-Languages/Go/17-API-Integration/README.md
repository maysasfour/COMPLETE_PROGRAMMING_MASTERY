# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST requests with the built-in `net/http` package — Go, like Node/C#/Java 11+, needs no external dependency for basic HTTP.
- Decode a JSON response directly into a struct using `encoding/json` (Lesson 10).
- Know that, like every other language course's HTTP client, it doesn't error for non-2xx responses.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`net/http` is fully built into Go's standard library — a genuine advantage over C++ (needs a third-party library entirely) and closer to Java 11+/Node/C#'s built-in HTTP clients. Combined with `encoding/json` (also built-in, Lesson 10), Go can make an HTTP request and decode its JSON response into a struct with zero external dependencies at all.

## GET and JSON Decoding

```go
import (
	"encoding/json"
	"io"
	"net/http"
)

type Todo struct {
	UserID    int    `json:"userId"`
	Title     string `json:"title"`
	Completed bool   `json:"completed"`
}

resp, err := http.Get("https://api.example.com/todos/1")
if err != nil { /* genuine network-level error */ }
defer resp.Body.Close()          // ALWAYS close the response body -- it's a resource

fmt.Println(resp.StatusCode)      // checked manually -- no error for 404/500

body, _ := io.ReadAll(resp.Body)
var todo Todo
json.Unmarshal(body, &todo)
```

`defer resp.Body.Close()` is essential and easy to forget — the HTTP response body is a resource (an open network connection under the hood) that must be closed, and `defer` (Go's closest analog to RAII/`finally`-style guaranteed cleanup) is the idiomatic way to ensure it happens regardless of how the function exits.

## POST with a JSON Body

```go
jsonBody, _ := json.Marshal(map[string]interface{}{"title": "test"})
resp, err := http.Post("https://api.example.com/todos", "application/json", bytes.NewBuffer(jsonBody))
```

## Detailed Example

See [main.go](main.go) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service used throughout this repository's other language courses).

## Expected Output

Running `go run main.go` (requires internet access) prints a real, JSON-decoded `Todo` struct, confirms a 404 route returns normally (`err == nil`, `StatusCode: 404`) rather than an error, and shows a POST's echoed-back response body.

## Common Mistakes

- Forgetting `defer resp.Body.Close()` — leaks the underlying network connection's resources.
- Assuming `http.Get`/`http.Post` return a non-nil `err` for a 404/500 — they don't; `err` is only non-nil for genuine network-level failures (DNS failure, connection refused, timeout), matching the pattern from every other language course's HTTP client lesson.
- Forgetting struct tags (`` `json:"userId"` ``) when the JSON's key casing doesn't match Go's exported `PascalCase` field names.

## Best Practices

- Always `defer resp.Body.Close()` immediately after checking `err` from an HTTP call.
- Check `resp.StatusCode` explicitly for HTTP-level success/failure, separately from checking `err` for network-level failure.
- For anything beyond the simplest cases, construct an `http.Client` with an explicit `Timeout` rather than relying on `http.Get`'s package-level default client, which has no timeout at all by default.

## Real-World Usage

`net/http` combined with `encoding/json` is the standard way Go services call other HTTP APIs, and also the foundation of Go's HTTP *server* capabilities (the same package provides both client and server functionality) — a notable contrast with languages needing separate libraries for each direction.

## Summary

- `net/http` is fully built into Go's standard library — no dependency needed for HTTP requests, unlike C++.
- Like every other language course's HTTP client, it doesn't error for non-2xx responses — check `resp.StatusCode` manually.
- `defer resp.Body.Close()` is essential, idiomatic cleanup for every HTTP response.

## Key Terms

- **`net/http`** — Go's built-in HTTP client and server package.
- **`defer`** — Go's mechanism for guaranteed cleanup code, run when the enclosing function returns, regardless of how.

## Interview Questions

1. **Does `http.Get`/`http.Post` return an error for a 404 or 500 response?**
   No — like every HTTP client covered in this repository, `err` is only non-nil for genuine network-level failures (DNS failure, connection refused, timeout). A 404/500 response is returned as a completely normal, non-error `*http.Response`; `resp.StatusCode` must be checked manually to detect an HTTP-level failure.

2. **Why is `defer resp.Body.Close()` important, and what does `defer` do generally?**
   An HTTP response body represents an open network connection/resource that must be explicitly closed, or it leaks. `defer` schedules a function call to run when the enclosing function returns — regardless of whether it returns normally or via a panic — making it Go's idiomatic mechanism for guaranteed cleanup, conceptually similar to RAII (C++) or `finally` (Java/C#), though implemented as an explicit statement rather than tied to an object's lifetime or a dedicated block.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
