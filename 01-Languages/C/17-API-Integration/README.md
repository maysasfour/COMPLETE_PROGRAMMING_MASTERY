# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make a real HTTPS request from C using WinHTTP (a Windows-specific OS library — genuinely not part of C at all).
- Understand C has **zero** built-in HTTP support — an even starker gap than C++'s (which at least has portable single-header libraries like cpp-httplib to reach for).

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

C's standard library has no networking or HTTP support whatsoever — no sockets abstraction, no TLS, nothing. This is a strictly worse starting point than C++'s equivalent gap: C++ at least has portable (if third-party) single-header libraries like cpp-httplib that work identically across platforms as ordinary C++ source. In C, making an HTTPS request means reaching for a **platform-specific OS API** directly — on Windows, that's **WinHTTP** (`<winhttp.h>`, linked against `winhttp.lib`), which is genuinely not part of the C language or its standard library at all, just a Windows OS component happening to have a C-callable interface. A real cross-platform C project would need an entirely *different* implementation on Linux/macOS (raw BSD sockets plus a hand-rolled HTTP request and manual TLS, or a library like libcurl) — there is nothing in ISO C to fall back on portably, unlike C++'s at least-somewhat-portable third-party options.

## Syntax

```c
#include <windows.h>
#include <winhttp.h>
#pragma comment(lib, "winhttp.lib")

HINTERNET session = WinHttpOpen(L"MyApp/1.0", WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                                  WINHTTP_NO_PROXY_NAME, WINHTTP_NO_PROXY_BYPASS, 0);
HINTERNET connect = WinHttpConnect(session, L"example.com", INTERNET_DEFAULT_HTTPS_PORT, 0);
HINTERNET request = WinHttpOpenRequest(connect, L"GET", L"/path", NULL,
                                         WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES,
                                         WINHTTP_FLAG_SECURE);
WinHttpSendRequest(request, WINHTTP_NO_ADDITIONAL_HEADERS, 0, WINHTTP_NO_REQUEST_DATA, 0, 0, 0);
WinHttpReceiveResponse(request, NULL);
/* WinHttpReadData(...) in a loop to read the response body */
WinHttpCloseHandle(request);   /* every handle must be explicitly closed -- no RAII */
WinHttpCloseHandle(connect);
WinHttpCloseHandle(session);
```

## Detailed Example

See [example.c](example.c) — a real HTTPS GET against the same live `jsonplaceholder.typicode.com` API used throughout this repository's other language courses, reading and printing the raw response body (no JSON parsing — C has none built in, same gap as Lesson 10).

## Expected Output

```
GET https://jsonplaceholder.typicode.com/todos/1 -> HTTP 200
Response body:
{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings, a real live network call to `jsonplaceholder.typicode.com` during course construction, real captured `HTTP 200` and JSON body (byte-for-byte what the API returned at the time, not fabricated).

## Common Mistakes

- Forgetting `WinHttpCloseHandle()` on every handle (`session`, `connect`, `request`) — no RAII exists here; each leaked handle is a genuine resource leak, exactly Lesson 19's broader `malloc`/`free`-style discipline applied to OS handles instead.
- Forgetting WinHTTP's string parameters are **wide strings** (`L"..."`, `wchar_t*`), not plain `char*` — passing an ordinary C string literal where a wide string is required is a type mismatch the compiler will reject, a genuinely Windows-specific gotcha with no equivalent on POSIX socket APIs.
- Assuming this code is portable to Linux/macOS — it is not; WinHTTP is a Windows-only API, and a cross-platform C HTTP client needs an entirely separate implementation path per platform (or a cross-platform library like libcurl) to work everywhere.

## Best Practices

- Always check every `WinHttpOpen`/`WinHttpConnect`/`WinHttpOpenRequest` call's return value for `NULL` before using the handle it's supposed to produce.
- Always close every handle, in reverse order of acquisition, even on an error path (a real resource-cleanup discipline point, not just a style preference).
- For anything beyond a small educational example, prefer a genuine cross-platform library (libcurl is the most widely used in real C projects) over hand-rolling per-platform networking code directly.

## Real-World Usage

Real cross-platform C projects overwhelmingly use **libcurl** for HTTP, precisely to avoid maintaining separate WinHTTP/BSD-sockets/whatever-else implementations per platform — WinHTTP directly (as shown here) is genuinely more common in Windows-only C/C++ system utilities and services than in portable application code.

## Summary

- C has zero built-in HTTP/networking support — a starker gap than C++'s, since C also lacks even a portable third-party single-header convention to fall back on across platforms.
- WinHTTP (Windows-only, not part of C at all) was used here to make a real HTTPS GET, confirmed live against the same API this repository's other language courses use.
- Real cross-platform C projects use libcurl specifically to avoid maintaining separate per-platform networking code.

## Key Terms

- **WinHTTP** — a Windows OS component providing HTTP(S) client functionality via a C-callable API; not part of the C language or standard library.
- **libcurl** — the most widely used cross-platform C HTTP client library in real-world C projects, used precisely because ISO C provides no portable alternative.

## Interview Questions

1. **Does C have any built-in HTTP client capability? How does this compare to C++'s equivalent gap?**
   No — C has zero built-in networking or HTTP support of any kind, and unlike C++ (which at least has portable, single-header third-party libraries like cpp-httplib usable as ordinary C++ source across platforms), C's most direct options are genuinely platform-specific OS APIs (WinHTTP on Windows, raw BSD sockets on Linux/macOS) with no shared implementation between them, making C's HTTP gap a strictly more manual starting point than C++'s own already-significant one.

2. **Why is WinHTTP not considered "C" in the way `<stdio.h>` is, and what does that imply for portability?**
   WinHTTP is a Windows operating system component with a C-callable interface — it is not part of the ISO C standard or its standard library, and using it means the code is now Windows-specific, requiring an entirely separate implementation (raw sockets, or a cross-platform library like libcurl) to run on Linux/macOS. This is a meaningfully different situation from calling `printf` or `malloc`, which are guaranteed by the C standard to exist and behave consistently on any conforming C implementation, anywhere.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
