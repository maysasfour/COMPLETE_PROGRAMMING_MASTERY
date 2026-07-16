# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET/POST requests with a third-party HTTP client library (cpp-httplib), since C++ has **zero** built-in networking/HTTP support.
- Know that, like every other language course's HTTP client, it doesn't throw for non-2xx responses by default.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

C++ has no built-in HTTP client of any kind — not even a low-level one. This lesson uses **cpp-httplib**, a popular single-header library (the same "one header file, no complex build step" pattern as Lesson 16's SQLite amalgamation), specifically to avoid the added complexity of libcurl (which typically needs a package manager like vcpkg) for a single lesson. This is one further step down the "built-in support" ladder from Java (which at least has `HttpClient` built in) — C++ needs a third-party dependency for the most basic networking task covered in this repository.

## Getting `httplib.h`

```bash
curl -L -o httplib.h "https://raw.githubusercontent.com/yhirose/cpp-httplib/master/httplib.h"
```

## GET and POST

```cpp
#include "httplib.h"

httplib::Client client("http://api.example.com");
auto result = client.Get("/todos/1");
if (result) {
    std::cout << result->status << std::endl;  // checked manually -- no exception for 404/500
    std::cout << result->body << std::endl;
} else {
    std::cout << "network error: " << httplib::to_string(result.error()) << std::endl;
}

std::string jsonBody = R"({"title":"test"})";
auto postResult = client.Post("/todos", jsonBody, "application/json");
```

Note the `result` (a `httplib::Result`, effectively an `std::optional`-like wrapper) is checked in **two** ways: its own truthiness distinguishes a genuine network-level failure (DNS failure, connection refused — analogous to a caught exception in other languages) from a real HTTP response, and *within* a real response, `.status` must still be checked manually for 404/500 — the same two-layer distinction as every other language course's HTTP client, just expressed through a result-wrapper instead of exceptions plus a status property.

## Detailed Example

See [example.cpp](example.cpp) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service used throughout this repository's other language courses) over plain HTTP, avoiding an OpenSSL/TLS dependency for this one lesson.

## Expected Output

Compiling and running `example.cpp` (requires internet access) prints a real GET response, confirms a 404 route returns normally (not an error/exception) with `status: 404`, and shows a POST's echoed-back response body.

## Common Mistakes

- Assuming any HTTP client automatically throws for non-2xx responses — cpp-httplib (like every client covered in this repository) returns a normal result object for HTTP-level failures, only failing "truthiness" for genuine network-level problems.
- Reaching for libcurl by default without considering a simpler single-header alternative (cpp-httplib) for smaller projects/prototypes not already using vcpkg/Conan.

## Best Practices

- Always check both layers: the result's validity (network-level success) and its `.status` (HTTP-level success).
- Set explicit connection/read timeouts (`client.set_connection_timeout(...)`) — without them, a hung connection can block indefinitely.
- For TLS/HTTPS support, cpp-httplib needs to be built with `CPPHTTPLIB_OPENSSL_SUPPORT` and linked against OpenSSL — a real project's dependency setup (vcpkg/Conan, Lesson 15) would handle this; this lesson deliberately uses plain HTTP to avoid that setup cost.

## Real-World Usage

Real C++ projects needing HTTP typically use libcurl (extremely mature, TLS built-in, but with a more involved API and build setup) or cpp-httplib (simpler API, single header, good for smaller services/prototypes) — both are entirely third-party, since the standard library provides nothing.

## Summary

- C++ has zero built-in HTTP/networking support — a third-party library (cpp-httplib or libcurl) is mandatory for any HTTP request.
- Like every other language course's HTTP client, non-2xx responses are returned normally, not thrown — check `.status` manually.
- cpp-httplib's single-header distribution mirrors Lesson 16's SQLite-amalgamation pattern: a genuine capability with minimal build complexity for a lesson-sized example.

## Key Terms

- **cpp-httplib** — a popular single-header C++ HTTP client/server library.

## Interview Questions

1. **Does the C++ standard library provide any HTTP or networking support?**
   No — none at all, at any level. Every language course in this repository has at least some networking capability built in (even Java's raw sockets, or its `HttpClient` since Java 11); C++ requires a third-party library (cpp-httplib, libcurl, Boost.Asio, or platform-specific socket APIs) for any HTTP request whatsoever.

2. **Does cpp-httplib throw an exception for a 404 response?**
   No — consistent with every HTTP client covered in this repository, a 404/500 response is a normal, successfully-received result (checked via `.status`), not an error. Only genuine network-level failures (DNS failure, connection refused, timeout) cause the result to be "falsy"/invalid, checked separately from the HTTP status itself.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
