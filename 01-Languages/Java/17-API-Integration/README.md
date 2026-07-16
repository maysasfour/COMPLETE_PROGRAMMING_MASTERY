# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST requests with `java.net.http.HttpClient` (built into the JDK since Java 11 — no dependency needed, unlike Lesson 16's database driver).
- Know that `HttpClient` does not throw for a non-2xx response by default.
- Understand why real JSON handling still needs Jackson/Gson (Lesson 10's gap applies here too).

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

Unlike JDBC (Lesson 16, built-in API but requires an external driver), `java.net.http.HttpClient` (Java 11+) is **fully built into the JDK** with no external dependency needed for making HTTP requests — a genuine, welcome modernization over the older, more verbose `HttpURLConnection`. Like every HTTP client covered in this repository's other language courses, it does not throw for HTTP error statuses by default; only for genuine network-level failures.

## GET and POST

```java
HttpClient client = HttpClient.newHttpClient();

HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://api.example.com/todos/1"))
    .GET()
    .build();
HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

System.out.println(response.statusCode()); // checked manually -- no exception for 404/500
System.out.println(response.body());
```

```java
HttpRequest postRequest = HttpRequest.newBuilder()
    .uri(URI.create("https://api.example.com/todos"))
    .header("Content-Type", "application/json")
    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
    .build();
```

## The JSON Gap, Again

This lesson's example extracts a single field from a JSON response with a small regex, deliberately **not** a real JSON parser — reinforcing Lesson 10's point that the JDK has no built-in JSON library. A real project would deserialize the response body with Jackson (`objectMapper.readValue(body, Todo.class)`) rather than hand-rolled string extraction, which is fragile and shown here only to avoid introducing a dependency for one lesson.

## Detailed Example

See [Example.java](Example.java) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service used throughout this repository's other language courses), demonstrating a GET with minimal field extraction, the 404-doesn't-throw trap, and a POST.

## Expected Output

Running `java Example.java` (requires internet access) prints a real response's extracted title field, confirms a 404 doesn't throw (status code checked manually), and shows a POST's echoed-back response body.

## Common Mistakes

- Assuming `client.send(...)` throws for a 404/500 — it doesn't; only genuine network-level failures (`IOException`, `InterruptedException`) are thrown, which `HttpClient.send` declares as checked exceptions (Lesson 09) the caller must handle or propagate.
- Hand-rolling JSON parsing with regex/string splitting for anything beyond a single-field lesson demo — fragile and incorrect for nested structures, arrays, or escaped characters; use Jackson/Gson for real work.

## Best Practices

- Reuse a single `HttpClient` instance (it's designed to be reused and is thread-safe) rather than creating one per request.
- Check `response.statusCode()` explicitly rather than assuming a returned response means success.
- Use Jackson/Gson (a Maven/Gradle dependency, Lesson 15) for any real JSON parsing — never hand-rolled regex extraction beyond a toy example.

## Real-World Usage

`HttpClient` combined with Jackson is the standard modern way Java services call other HTTP APIs, replacing the older, far more verbose `HttpURLConnection` and third-party clients (Apache HttpClient, OkHttp) that were previously necessary before Java 11 added a built-in modern client.

## Summary

- `java.net.http.HttpClient` (Java 11+) is fully built into the JDK — no dependency needed for HTTP requests themselves.
- Like every other language course's HTTP client, it doesn't throw for non-2xx responses by default.
- Real JSON parsing still needs Jackson/Gson — the JDK's JSON gap (Lesson 10) applies here too.

## Key Terms

- **`java.net.http.HttpClient`** — the JDK's built-in (Java 11+) HTTP client.

## Interview Questions

1. **Does `HttpClient.send()` throw an exception for a 404 response?**
   No — like every HTTP client covered in this repository's other language courses, it only throws for genuine network-level failures (connection refused, DNS failure, interrupted request), declared as checked exceptions (`IOException`, `InterruptedException`) the caller must handle. A 404/500 response is returned normally; `response.statusCode()` must be checked manually.

2. **Why doesn't this lesson use a real JSON parser?**
   Because the JDK has no built-in JSON library (established in Lesson 10) — adding Jackson/Gson would require a Maven/Gradle dependency, breaking this course's single-file-lesson consistency for just one example. The regex-based field extraction shown is explicitly flagged as a toy simplification, not a real-world recommendation; production code should always use Jackson/Gson for JSON.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
