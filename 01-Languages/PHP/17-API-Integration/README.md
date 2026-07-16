# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST HTTP requests with the `curl` extension (the standard, feature-complete choice) and `file_get_contents()` with a stream context (a simpler alternative for basic GETs).
- Confirm PHP's HTTP clients do **not** throw on 404/500 — a normal response is returned, exactly like every other language course's HTTP client in this repository.
- Decode JSON responses with the built-in `json_decode()` (Lesson 10).

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

PHP has two common ways to make HTTP requests: the `curl` extension (a binding over libcurl, offering full control — headers, POST bodies, timeouts) and the simpler `file_get_contents()` combined with a stream context (works for basic requests, treating a URL like any other readable stream). Both were verified live against the same public `jsonplaceholder.typicode.com` test API used throughout this repository.

## GET via `curl`

```php
$ch = curl_init("https://jsonplaceholder.typicode.com/todos/1");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
$todo = json_decode($response, true);
```

## A Genuine, Verified Environment Setup Requirement

Making an HTTPS request from a fresh Windows PHP install failed immediately with `curl error: SSL certificate ... unable to get local issuer certificate` — PHP's bundled OpenSSL had no CA certificate bundle configured. The fix: download a CA bundle (e.g. `cacert.pem` from `https://curl.se/ca/cacert.pem`) and point `curl.cainfo`/`openssl.cafile` at it in `php.ini`. This is a genuine, real-world PHP-on-Windows setup step (documented in Lesson 01), not something every environment needs — many Linux distributions ship a system CA bundle PHP finds automatically.

## Confirming: No Exception on 404 (Same Convention as Every Other Language Course)

```php
$ch = curl_init("https://jsonplaceholder.typicode.com/todos/99999999");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE); // 404 -- a normal value, no exception thrown
```

Verified live: requesting a nonexistent resource returns a normal response with `curl_getinfo($ch, CURLINFO_HTTP_CODE)` reporting `404` — `curl_exec()` only returns `false` (a request-level failure) for genuine network errors (DNS failure, connection refused, TLS failure), never for an HTTP-level 4xx/5xx status. This matches the exact convention documented in this repository's JavaScript (`fetch`), TypeScript, C# (`HttpClient`), Java (`HttpClient`), Go (`net/http`), and C++ (cpp-httplib) API-integration lessons — status codes must always be checked manually.

## POST with a JSON Body

```php
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
```

## Simpler Alternative: `file_get_contents()` with a Stream Context

```php
$context = stream_context_create(["http" => ["method" => "GET", "header" => "Accept: application/json"]]);
$body = file_get_contents("https://jsonplaceholder.typicode.com/todos/2", false, $context);
```

`file_get_contents()` treats a URL as a readable stream (given the `allow_url_fopen` ini setting, enabled by default) — convenient for simple GETs, but far less flexible than `curl` for anything involving custom methods, headers-with-conditional-logic, or timeouts.

## Detailed Example

See [example.php](example.php) — GET (with JSON decoding), a GET against a 404 route (confirming the no-exception convention), POST with a JSON body, and the `file_get_contents()` alternative, all run and verified against the live test API.

## Run It

```bash
cd 01-Languages/PHP/17-API-Integration
php example.php
```

(Requires internet access, and a working CA bundle configuration as described above.)

## Expected Output

Running `php example.php` prints `status: 200` with a decoded `Todo`, `status: 404` with an empty JSON object body (confirming the no-exception convention), `status: 201` with an echoed-back POST body including a fake `id`, and a second todo's title fetched via `file_get_contents()`.

## Common Mistakes

- Assuming `curl_exec()` returns `false` or throws for an HTTP-level error status (404/500) — it doesn't; only genuine network-level failures (unreachable host, TLS failure) cause `curl_exec()` to return `false`. `curl_getinfo($ch, CURLINFO_HTTP_CODE)` must always be checked explicitly.
- Forgetting `CURLOPT_RETURNTRANSFER => true` — without it, `curl_exec()` prints the response directly and returns `true`/`false` instead of giving back the response body as a string.
- On a fresh Windows PHP install, assuming HTTPS requests will just work — missing CA bundle configuration is a genuine, common setup gap, reproduced and fixed live in this lesson.

## Best Practices

- Always check the actual HTTP status code (`curl_getinfo($ch, CURLINFO_HTTP_CODE)`) after any `curl_exec()` call, regardless of whether `curl_exec()` itself returned `false` or a string.
- Use `curl` for anything beyond a simple GET (custom headers, POST/PUT/DELETE, timeouts); reserve `file_get_contents()` with a stream context for the simplest read-only cases.
- Set `curl.cainfo`/`openssl.cafile` in `php.ini` proactively on any fresh Windows PHP install expected to make HTTPS requests.

## Real-World Usage

`curl` is the standard choice for real PHP applications making outbound HTTP requests (often wrapped by a higher-level client library like Guzzle for a more ergonomic API), while `file_get_contents()` with `allow_url_fopen` remains common for quick scripts and simple integrations where curl's additional configuration isn't needed.

## Summary

- `curl` (feature-complete) and `file_get_contents()`-with-stream-context (simpler) are PHP's two common HTTP client approaches.
- Neither throws an exception for an HTTP-level 4xx/5xx response — confirmed live, matching every other language course's HTTP client convention in this repository.
- A fresh Windows PHP install needs an explicitly configured CA bundle (`curl.cainfo`/`openssl.cafile`) for HTTPS requests to succeed at all — a genuine, documented setup requirement.

## Key Terms

- **`curl_getinfo($ch, CURLINFO_HTTP_CODE)`** — retrieves the actual HTTP status code of a completed curl request.
- **CA bundle** — a file of trusted certificate authority certificates, needed by curl/OpenSSL to verify a server's TLS certificate.

## Interview Questions

1. **Does `curl_exec()` return `false` or throw when a request receives a 404 response?**
   No — verified directly: requesting a nonexistent resource still returns a normal response string (or `true`, without `CURLOPT_RETURNTRANSFER`), with `curl_getinfo($ch, CURLINFO_HTTP_CODE)` reporting `404`. `curl_exec()` only returns `false` for request-level failures — a DNS lookup failure, a refused connection, a TLS handshake failure — never for an HTTP-level error status. This matches the exact same convention documented for every other HTTP client in this repository's other language courses (JavaScript's `fetch`, C#'s `HttpClient`, Go's `net/http`, etc.), making manual status-code checking a universal requirement across virtually every language's HTTP client.

2. **Why might a PHP script fail to make any HTTPS request at all on a freshly installed Windows environment?**
   Because curl/OpenSSL needs a CA (certificate authority) bundle to verify the remote server's TLS certificate, and a fresh Windows PHP distribution doesn't necessarily have one configured or discoverable by default — this was reproduced directly in this lesson, producing the error "SSL certificate ... unable to get local issuer certificate." The fix is downloading a CA bundle (e.g. Mozilla's, distributed at curl.se) and pointing `php.ini`'s `curl.cainfo` and `openssl.cafile` settings at its file path — a genuine, one-time environment setup step, not a bug in the PHP code itself.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
