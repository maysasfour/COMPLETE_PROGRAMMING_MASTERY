# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST HTTP requests with `dart:io`'s built-in `HttpClient` — no external package needed for basic requests, unlike Rust/C++ (both covered earlier in this repository).
- Confirm Dart's `HttpClient` does **not** throw on 404/500 — matching the convention of every HTTP client covered in this repository except Rust's `ureq`.
- Decode JSON responses with `dart:convert` (Lesson 10) — Dart's genuinely built-in JSON support.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`dart:io`'s `HttpClient` is part of the Dart SDK itself (available to standalone/server/mobile/desktop Dart, though not web/browser Dart, which uses `dart:html`/`package:http` instead) — no external package needed for basic HTTP requests, unlike Rust or C++ (both covered earlier in this repository, both needing an external crate/library for any HTTP capability). Real Dart/Flutter code more commonly uses the `http` pub.dev package for its more convenient API, but the built-in `HttpClient` used here demonstrates the capability is genuinely part of the standard SDK.

## GET

```dart
final client = HttpClient();
var request = await client.getUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
var response = await request.close();
print(response.statusCode);
var body = await response.transform(utf8.decoder).join();
var todo = jsonDecode(body) as Map<String, dynamic>;
```

## Confirming: No Exception on 404

```dart
var notFoundResponse = await notFoundRequest.close();
print(notFoundResponse.statusCode); // 404 -- a normal value, no exception thrown
```

Verified live against the same `jsonplaceholder.typicode.com` test API used throughout this repository: requesting a nonexistent resource returned a normal response with `statusCode` reporting `404` and a body of `{}` — `HttpClient` only throws for genuine network-level failures (DNS failure, connection refused), never for an HTTP-level 4xx/5xx status. This matches the exact convention documented in this repository's JavaScript (`fetch`), C#/Kotlin/Java (`HttpClient`), Go (`net/http`), PHP (`curl`), and C++ (cpp-httplib) API-integration lessons — the sole documented exception in this repository is Rust's `ureq`, which throws on non-2xx by default.

## POST with a JSON Body

```dart
var postRequest = await client.postUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
postRequest.headers.contentType = ContentType.json;
postRequest.write(jsonEncode({'title': '...', 'completed': false, 'userId': 1}));
var postResponse = await postRequest.close();
```

## Detailed Example

See [example.dart](example.dart) — GET (with `jsonDecode`-based JSON decoding), a GET against a 404 route (confirming the no-exception convention), and POST with a JSON body, all run and verified against the live test API.

## Run It

```bash
cd 01-Languages/Dart/17-API-Integration
dart run example.dart
```

(Requires internet access.)

## Expected Output

Running `dart run example.dart` prints `status: 200` with a decoded todo, `status: 404` with an empty JSON object body (confirming the no-exception convention), and `status: 201` with an echoed-back POST body including a fake `id` — all confirmed by actual execution against the live test API.

## Common Mistakes

- Assuming `HttpClient` throws or returns null/false for an HTTP-level error status (404/500) — verified live that it doesn't; only genuine network-level failures cause an exception. `response.statusCode` must always be checked explicitly.
- Forgetting `response.close()`'s result must itself be read (via `.transform(utf8.decoder).join()` or similar) to get the actual response body — the `HttpClientResponse` is itself a `Stream<List<int>>` of bytes, not a ready-made string.
- Forgetting to `client.close()` the `HttpClient` when finished — leaving connections open unnecessarily.

## Best Practices

- Always check `response.statusCode` explicitly after any `HttpClient` request, regardless of whether the request itself completed without throwing.
- Consider the `http` pub.dev package for real applications — it provides a more convenient, `Future<Response>`-based API over the lower-level `HttpClient` used in this lesson for a dependency-free demonstration.
- Use `jsonEncode`/`jsonDecode` (`dart:convert`, Lesson 10) for JSON payloads, and `fromJson`/`toJson` factory constructors (Lesson 11) for strongly-typed request/response models in larger applications.

## Real-World Usage

Real Dart/Flutter applications overwhelmingly use the `http` pub.dev package (or higher-level clients like `dio`) rather than raw `dart:io HttpClient`, for its more ergonomic `Future`-based API — but the built-in `HttpClient` demonstrated in this lesson remains available and genuinely part of the Dart SDK with zero external dependencies, useful for CLI tools or contexts wanting to avoid any package dependency at all.

## Summary

- `dart:io`'s `HttpClient` is built into the Dart SDK — no external package needed for basic HTTP requests, unlike Rust or C++.
- Dart's `HttpClient` does not throw on 404/500 — confirmed live against the live test API, matching every other HTTP client in this repository except Rust's `ureq`.
- `dart:convert`'s `jsonEncode`/`jsonDecode` (Lesson 10) handle JSON with zero external dependencies.

## Key Terms

- **`HttpClient`** — `dart:io`'s built-in HTTP client class.
- **`HttpClientResponse`** — the response object from an `HttpClient` request; itself a byte stream requiring `.transform(utf8.decoder).join()` to read as a string.

## Interview Questions

1. **Does Dart need an external package for basic HTTP requests, and does its client throw on a 404?**
   No external package is strictly needed — `dart:io`'s `HttpClient` is part of the Dart SDK itself and was used directly in this lesson with zero dependencies. And no, verified live against the same test API used throughout this repository: requesting a nonexistent resource returned a normal response with `statusCode` reporting `404`, not a thrown exception. This matches the convention of virtually every other HTTP client covered in this repository (JavaScript's `fetch`, C#/Kotlin/Java's `HttpClient`, Go's `net/http`, PHP's `curl`), with Rust's `ureq` being the sole documented exception that throws by default on non-2xx responses.

2. **Why is `HttpClientResponse` itself treated as a stream that needs `.transform(utf8.decoder).join()`, rather than providing a ready-made string body directly?**
   `HttpClientResponse` extends `Stream<List<int>>` — the response body arrives as a stream of raw bytes, potentially in multiple chunks, rather than being buffered entirely into memory automatically before being handed back. This design lets very large response bodies be processed incrementally (streaming) if needed, rather than always requiring the entire body to be loaded into memory first. For the common case of simply wanting the full body as a `String`, `.transform(utf8.decoder)` decodes the byte stream as UTF-8 text, and `.join()` concatenates all the resulting string chunks into one complete string — a small amount of extra ceremony compared to some other languages' HTTP clients that return a ready-made string/body property directly, but one that reflects Dart's stream-based I/O model consistently.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
