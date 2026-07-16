# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason. The "no exception on 404" claim below is stated per Swift/Foundation's documented `URLSession` behavior, consistent with how every other HTTP client covered in this repository (except Rust's `ureq`) behaves — but unlike those other courses, it has **not** been confirmed against the live test API in this environment.

## Learning Objectives

- Make GET/POST HTTP requests with `URLSession`, using Swift's native `async`/`await` (Lesson 14) — no separate networking library needed.
- Understand that `URLSession` does not throw on 404/500 per its documented design — matching the convention of every HTTP client covered in this repository except Rust's `ureq`.
- Decode JSON responses with `Codable` (Lesson 10) — Swift's genuinely built-in JSON support.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`URLSession` is Foundation's built-in HTTP client, usable directly with Swift's native `async`/`await` (Lesson 14) via its `data(from:)`/`data(for:)` async methods — no separate library needed, similar to Kotlin/Java's built-in `HttpClient` (covered in this repository's Kotlin course) and unlike Rust or C++ (both of which needed an external crate/library for any HTTP capability at all).

## GET with `async`/`await`

```swift
let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
let (data, response) = try await URLSession.shared.data(from: url)
if let httpResponse = response as? HTTPURLResponse {
    print(httpResponse.statusCode)
}
let todo = try JSONDecoder().decode(Todo.self, from: data)
```

## Per Documented Behavior: No Exception on 404

```swift
let (data, response) = try await URLSession.shared.data(from: notFoundURL)
if let httpResponse = response as? HTTPURLResponse {
    print(httpResponse.statusCode) // 404 -- a normal value, per URLSession's documented design
}
```

Per Foundation's documented `URLSession` behavior, a 404/500 response is delivered as a normal, successful `HTTPURLResponse` with the corresponding `statusCode` — `URLSession.shared.data(from:)` only throws for genuine network-level failures (no connection, DNS failure, TLS errors), not for HTTP-level error statuses. This matches the exact convention documented in this repository's JavaScript (`fetch`), C# (`HttpClient`), Java/Kotlin (`HttpClient`), Go (`net/http`), PHP (`curl`), and C++ (cpp-httplib) API-integration lessons — with Rust's `ureq` being the sole documented exception that does throw on non-2xx by default. **Unlike those other lessons, this specific claim has not been confirmed by actually running this code against the live test API in this environment** — see the honesty note at the top of this lesson.

## POST with a JSON Body

```swift
var request = URLRequest(url: postURL)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = try JSONEncoder().encode(newTodo)
let (data, response) = try await URLSession.shared.data(for: request)
```

## Detailed Example

See [Example.swift](Example.swift) — GET (with `Codable`-based JSON decoding), a GET against a 404 route, and POST with a JSON body, all written against the same live `jsonplaceholder.typicode.com` test API used throughout this repository (but not actually executed here).

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above. If you have a working Swift toolchain, running this against the live test API would provide the same kind of confirmation this repository's other language courses obtained directly.

## Expected Output

Running the compiled binary should print `status: 200` with a decoded `Todo`, `status: 404` with an empty JSON object body, and `status: 201` with an echoed-back POST body including a fake `id` — mirroring the exact pattern confirmed live in this repository's other API-integration lessons, but not independently confirmed for Swift specifically in this environment.

## Common Mistakes

- Assuming `URLSession` throws for an HTTP-level error status (404/500) — per its documented design, it doesn't; only genuine network-level failures cause `data(from:)`/`data(for:)` to throw. `response.statusCode` (after casting to `HTTPURLResponse`) must always be checked explicitly.
- Forgetting to cast `URLResponse` to `HTTPURLResponse` to access `.statusCode` — the base `URLResponse` type doesn't expose it directly.
- Forgetting `Content-Type: application/json` on a POST request with a JSON body.

## Best Practices

- Always check `(response as? HTTPURLResponse)?.statusCode` explicitly after any `URLSession` call, regardless of whether the call itself threw.
- Use `Codable` structs for request/response bodies rather than manually constructing/parsing JSON dictionaries.
- Prefer `URLSession`'s native `async`/`await` methods over older completion-handler-based APIs in new Swift code.

## Real-World Usage

`URLSession` combined with `async`/`await` and `Codable` is the standard, idiomatic way real Swift/iOS applications make network requests and decode JSON responses — no third-party networking library (like the once-popular Alamofire) is strictly required for most use cases, since Foundation's built-in tools now cover the common cases directly and idiomatically.

## Summary

- `URLSession` is Foundation's built-in HTTP client, directly usable with Swift's native `async`/`await` — no separate library needed.
- Per its documented behavior, `URLSession` does not throw for HTTP-level error statuses — matching every HTTP client covered in this repository except Rust's `ureq`, though this specific claim was not independently confirmed by execution in this environment (see the honesty note).
- `Codable`/`JSONDecoder`/`JSONEncoder` (Lesson 10) provide built-in JSON support with no external library.

## Key Terms

- **`URLSession`** — Foundation's built-in HTTP client class.
- **`HTTPURLResponse`** — the concrete `URLResponse` subtype exposing `.statusCode` for HTTP requests.

## Interview Questions

1. **Does `URLSession` throw an error for a 404 response, and how does this compare to other HTTP clients covered in this repository?**
   Per Foundation's documented design, no — a 404 (or any other HTTP-level status) is delivered as a normal, successful `HTTPURLResponse` with the corresponding `statusCode`; `URLSession`'s `data(from:)`/`data(for:)` methods only throw for genuine network-level failures. This matches the documented convention of every other HTTP client covered in this repository except Rust's `ureq` (JavaScript's `fetch`, C#/Kotlin/Java's `HttpClient`, Go's `net/http`, PHP's `curl`, C++'s cpp-httplib all behave the same way) — though unlike those other lessons, this specific claim was not confirmed by actually running the code against a live API in the environment that built this course (see this lesson's honesty note).

2. **Why doesn't a Swift project need a third-party JSON or networking library for basic API integration, unlike several other languages covered in this repository?**
   Swift's standard library/Foundation provides both pieces natively: `URLSession` for HTTP requests (usable directly with `async`/`await` since Swift 5.5, matching Kotlin/Java's built-in `HttpClient`) and `Codable`/`JSONEncoder`/`JSONDecoder` for JSON serialization (Lesson 10), which required no external dependency at all. This combination covers the common API-integration case entirely with built-in tools — a genuinely convenient starting point compared to, for instance, this repository's Rust or C++ courses, both of which needed an external crate/library for HTTP, and several of which also needed one for JSON.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
