# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make real GET/POST HTTP requests using `java.net.http.HttpClient` (Java 11+) — Scala has no HTTP client of its own.
- Read a response's status code and body.
- Handle a 404/not-found response.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

Scala has no HTTP client in its standard library — exactly the same gap as file writing (Lesson 10) and database access (Lesson 16) — so idiomatic Scala reaches into Java's `java.net.http.HttpClient` (available since Java 11, no extra dependency needed at all). This lesson makes real, live HTTP calls against the public [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com) fake REST API, exactly as this repository's other language courses do for their API-integration lessons.

## Building a Client and Making a GET Request

```scala
import java.net.URI
import java.net.http.{HttpClient, HttpRequest, HttpResponse}

val client = HttpClient.newBuilder().build()

val request = HttpRequest.newBuilder()
  .uri(URI.create("https://jsonplaceholder.typicode.com/todos/1"))
  .GET()
  .build()

val response = client.send(request, HttpResponse.BodyHandlers.ofString())
response.statusCode()  // 200
response.body()        // the raw JSON response body
```

## POST With a JSON Body

```scala
val request = HttpRequest.newBuilder()
  .uri(URI.create("https://jsonplaceholder.typicode.com/todos"))
  .header("Content-Type", "application/json")
  .POST(HttpRequest.BodyPublishers.ofString("""{"title": "learn Scala HTTP", "completed": false}"""))
  .build()
```

## Detailed Example

See [ApiIntegration.scala](ApiIntegration.scala) — a real GET of a single resource, a GET of a list, a POST creating a new (server-simulated) resource, and a GET against a nonexistent ID to observe a real 404 response.

## Run It

```bash
cd 01-Languages/Scala/17-API-Integration
scalac ApiIntegration.scala
scala run . --main-class apiIntegrationDemo
```

(Requires network access to reach `jsonplaceholder.typicode.com`.)

## Expected Output

Real output from an actual run (the API's specific fake `id` field on POST may vary slightly):

```
--- GET a single resource ---
status: 200
body:   {
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}

--- GET a list, sliced client-side ---
status: 200
body starts with: [
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  },
  {
    "userId": 1,
...

--- POST a new resource ---
status: 201
body:   {
  "title": "learn Scala HTTP",
  "completed": false,
  "userId": 1,
  "id": 201
}

--- handling a 404 ---
status: 404
body:   {}
```

## Common Mistakes

- Forgetting a request timeout (`.timeout(Duration.ofSeconds(...))`) — a hung server or network issue would otherwise block indefinitely.
- Assuming `jsonplaceholder`'s POST actually persists data — it's a fake API that simulates creation (returning `201` with a plausible-looking `id`) without ever really storing anything server-side, which is exactly why it's safe to use for a teaching example like this one.
- Not checking `statusCode()` before assuming the body contains the expected shape — a 404's body (`{}` here) looks nothing like a successful response's.

## Best Practices

- Always set connect and request timeouts explicitly — don't rely on defaults that may be unbounded.
- Check the status code before parsing/using the response body, branching behavior for 2xx vs. 4xx/5xx.
- Reuse a single `HttpClient` instance across many requests (as done here) rather than constructing a new one per call — it's designed to be shared and internally pools connections.

## Real-World Usage

`java.net.http.HttpClient` (or a Scala-specific wrapper like sttp) is the backbone of virtually every Scala service that talks to another HTTP API — payment gateways, third-party data providers, internal microservices — with the same GET/POST/status-code/body pattern shown here scaling directly into production code.

## Summary

- Scala has no HTTP client of its own; `java.net.http.HttpClient` (Java 11+) is used directly, with zero extra dependencies.
- Real GET and POST requests were made against a live public API, with actual captured status codes and bodies, including a genuine 404 case.

## Key Terms

- **`HttpClient`** — Java's built-in HTTP client (since Java 11), reusable across many requests.
- **`HttpRequest`/`HttpResponse`** — the request-builder and response types `HttpClient.send` operates on.
- **Status code** — the HTTP response's numeric outcome indicator (200 success, 201 created, 404 not found, etc.), which should always be checked before trusting a response body's shape.

## Interview Questions

1. **Why does this lesson use `java.net.http.HttpClient` instead of a "Scala-native" HTTP library, and what does that reveal about Scala's standard library?** — Because Scala's standard library has no HTTP client of its own (the same honest gap as file writing in Lesson 10 and database access in Lesson 16); since Scala runs on the JVM, it has full, dependency-free access to Java's built-in `java.net.http.HttpClient` (available since Java 11), which was used here to make real GET and POST calls without adding any external library.
2. **What did the 404 case in this lesson demonstrate, and why does it matter?** — Requesting a nonexistent resource (`/todos/999999`) returned a real `404` status code with an empty JSON body (`{}`), distinct in shape from the successful responses' bodies. This matters because code that blindly parses a response body assuming a successful shape (without first checking `statusCode()`) would either crash or silently misbehave on an error response — checking the status code first is what lets a caller branch correctly between success and failure handling.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
