# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST HTTP requests with `java.net.http.HttpClient` — built into the JDK since Java 11, used directly from Kotlin with no additional library needed for the HTTP layer itself.
- Confirm Kotlin/Java's `HttpClient` does **not** throw on 404/500 — matching the convention of every HTTP client covered in this repository except Rust's `ureq`.
- Decode JSON responses with Gson (Lesson 10), since Kotlin still has no built-in JSON support.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

Since Kotlin runs on the JVM, it uses Java's built-in `java.net.http.HttpClient` (available since Java 11, the same client covered in this repository's Java course) directly — no separate networking library needed for HTTP itself, unlike Rust or C++ (both covered earlier, both requiring an external crate/library for any HTTP capability at all).

## GET

```kotlin
val client = HttpClient.newHttpClient()
val request = HttpRequest.newBuilder()
    .uri(URI.create("https://jsonplaceholder.typicode.com/todos/1"))
    .GET()
    .build()
val response = client.send(request, HttpResponse.BodyHandlers.ofString())
val todo = gson.fromJson(response.body(), Todo::class.java)
```

## Confirming: No Exception on 404

```kotlin
val response = client.send(notFoundRequest, HttpResponse.BodyHandlers.ofString())
println(response.statusCode()) // 404 -- a normal value, no exception thrown
```

Verified live: requesting a nonexistent resource returned a normal `HttpResponse` with `statusCode()` reporting `404` and a body of `{}` — `client.send()` only throws for genuine network-level failures (connection refused, DNS failure, TLS errors), never for an HTTP-level 4xx/5xx status. This matches the exact convention documented in this repository's JavaScript (`fetch`), TypeScript, C# (`HttpClient`), Java (`HttpClient`, since Kotlin uses the identical class here), Go (`net/http`), C++ (cpp-httplib), and PHP (`curl`) API-integration lessons — the sole documented exception in this repository is Rust's `ureq`, which does throw on non-2xx by default.

## POST with a JSON Body

```kotlin
val payload = gson.toJson(mapOf("title" to "...", "completed" to false, "userId" to 1))
val request = HttpRequest.newBuilder()
    .uri(URI.create("https://jsonplaceholder.typicode.com/todos"))
    .header("Content-Type", "application/json")
    .POST(HttpRequest.BodyPublishers.ofString(payload))
    .build()
```

## Detailed Example

See [Example.kt](Example.kt) — GET (with Gson-based JSON decoding into a `Todo` data class), a GET against a 404 route (confirming the no-exception convention), and POST with a JSON body, all run and verified against the live `jsonplaceholder.typicode.com` test API used throughout this repository.

## Run It

```bash
cd 01-Languages/Kotlin/17-API-Integration
# Requires gson.jar on the classpath (downloaded separately, not committed):
kotlinc -cp gson.jar Example.kt -include-runtime -d Example.jar
java -cp "Example.jar;gson.jar" ExampleKt
```

## Expected Output

Running the compiled JAR prints `status: 200` with a decoded `Todo` data class, `status: 404` with an empty JSON object body (confirming the no-exception convention), and `status: 201` with an echoed-back POST body including a fake `id`.

## Common Mistakes

- Assuming `client.send()` throws or returns `null`/`false` for an HTTP-level error status (404/500) — it doesn't; only genuine network-level failures cause an exception. `response.statusCode()` must always be checked explicitly.
- Forgetting to set the `Content-Type: application/json` header on a POST request with a JSON body — some servers reject or misinterpret the body without it.
- Assuming Kotlin needs a separate networking library the way Rust or C++ do — it doesn't; `java.net.http.HttpClient` is available directly, since Kotlin compiles to and runs on the JVM alongside Java.

## Best Practices

- Always check `response.statusCode()` explicitly after any `HttpClient.send()` call, regardless of whether the call itself completed without throwing.
- Use `HttpClient.newBuilder()` (rather than `HttpClient.newHttpClient()`) when custom configuration (timeouts, redirect policy) is needed for a real application.
- Continue using a JSON library (Gson, Jackson, or `kotlinx.serialization`) for decoding — `HttpClient` itself has no JSON awareness at all, it only transports raw bytes/strings.

## Real-World Usage

`java.net.http.HttpClient` is a common, dependency-free choice for JVM-based Kotlin backend services (or apps already avoiding heavier third-party HTTP libraries like OkHttp/Retrofit, common in Android development); its non-throwing-on-4xx/5xx convention is the same one developers moving between this repository's Java and Kotlin courses (or any of the other languages sharing this convention) can rely on without re-learning HTTP error handling.

## Summary

- Kotlin uses Java's built-in `java.net.http.HttpClient` directly — no separate HTTP library needed, unlike Rust or C++.
- Kotlin/Java's `HttpClient` does not throw on 404/500 — confirmed live, matching every other HTTP client in this repository except Rust's `ureq`.
- Gson (or another JSON library) is still required for JSON decoding, since neither Kotlin nor the JVM provides built-in JSON support.

## Key Terms

- **`HttpClient`** — the JDK's built-in (Java 11+) HTTP client class, used directly from Kotlin.
- **`HttpResponse.BodyHandlers.ofString()`** — configures a request to receive its response body as a plain `String`.

## Interview Questions

1. **Does Kotlin need its own HTTP client library, or can it use Java's directly — and does that client throw on a 404 response?**
   Kotlin needs no separate HTTP client library at all for basic use — since it compiles to and runs on the JVM, `java.net.http.HttpClient` (built into the JDK since Java 11) is available and usable directly from Kotlin code, exactly as demonstrated in this lesson. And no, it does not throw for an HTTP-level error status: verified live, requesting a nonexistent resource returned a normal `HttpResponse` object with `statusCode()` reporting `404`, not a thrown exception — matching the convention of virtually every other HTTP client covered in this repository (JavaScript's `fetch`, C#'s `HttpClient`, Go's `net/http`, PHP's `curl`), with Rust's `ureq` being the sole documented exception that does throw by default on non-2xx responses.

2. **Why is Gson (or a similar library) still needed for JSON when using `HttpClient`?**
   `HttpClient` is purely a networking/transport layer — it sends bytes/strings over HTTP and returns bytes/strings in the response; it has no awareness of JSON as a format at all. Decoding a JSON response body into a structured Kotlin object (like the `Todo` data class in this lesson) or encoding a Kotlin object into a JSON string for a POST body requires a separate JSON library, since neither the JVM's standard library nor Kotlin's adds this capability (the same gap documented in this repository's Java course, inherited directly by Kotlin).

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
