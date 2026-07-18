# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Use `Net::HTTP` (Ruby's standard library HTTP client — no gem needed) for GET and POST requests.
- Confirm live that `Net::HTTP` does not raise on a 404 — the caller must check the response explicitly.
- Write a small helper enforcing "check success before parsing" as a reusable pattern.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`Net::HTTP` ships in Ruby's standard library — `require "net/http"` needs no gem install, matching the "genuinely built-in" theme of Lesson 10's JSON support. `Net::HTTP.get_response(uri)` performs a GET and returns a response object; a POST needs an explicit `Net::HTTP::Post.new` request object with headers/body set manually, plus an `http.request(request)` call.

The recurring trap verified live in this lesson, the same one this repository has already confirmed for `fetch()` in JavaScript and `curl`/`file_get_contents` in PHP: **`Net::HTTP` does not raise an exception on an HTTP error status like 404.** It simply returns a `Net::HTTPNotFound` response object with `.code == "404"`; the caller must explicitly check `response.is_a?(Net::HTTPSuccess)` (or inspect `.code`) before trusting the body contains what was expected.

## Detailed Example

See [example.rb](example.rb) — a GET against the shared `jsonplaceholder.typicode.com` test API used throughout this repository, a deliberate GET against a non-existent resource proving no exception is raised (just a `Net::HTTPNotFound` response), a POST with a JSON request body, and a `safe_get_json` helper that raises explicitly after checking `Net::HTTPSuccess`, caught live for the same non-existent resource.

## Run It

```bash
cd 01-Languages/Ruby/17-API-Integration
ruby example.rb
```

## Expected Output (real, captured)

```
GET https://jsonplaceholder.typicode.com/todos/1 -> 200
{"userId" => 1, "id" => 1, "title" => "delectus aut autem", "completed" => false}
GET https://jsonplaceholder.typicode.com/todos/999999 -> 404 (Net::HTTPNotFound)
is_a?(Net::HTTPSuccess) = false
POST https://jsonplaceholder.typicode.com/posts -> 201
{"title" => "Ruby Course", "body" => "posted via Net::HTTP", "userId" => 1, "id" => 101}
safe_get_json user: Leanne Graham <Sincere@april.biz>
caught: HTTP 404 for https://jsonplaceholder.typicode.com/users/999999
```

This was run against the real, live public `jsonplaceholder.typicode.com` test API, not a mock — the `201` status and echoed `id: 101` on the POST, and the real `Leanne Graham`/`Sincere@april.biz` user data, all came back from an actual network call.

## Common Mistakes

- Assuming a 404 (or any non-2xx status) raises an exception the way some other HTTP clients do — `Net::HTTP` does not; verified live above, `response.is_a?(Net::HTTPSuccess)` returns `false` for the 404 case with zero exception raised.
- Forgetting `http.use_ssl = true` for an `https://` URL when using the multi-step `Net::HTTP.new` + explicit request-object form (the simpler `Net::HTTP.get_response(uri)` shortcut handles this automatically for a GET).
- Not setting the `Content-Type` header on a POST with a JSON body — some APIs will silently fail to parse the body as JSON without it.

## Best Practices

- Always check `response.is_a?(Net::HTTPSuccess)` (or the numeric `.code`) before parsing a response body as the expected successful shape.
- Centralize the "check success, then parse" pattern in one helper (as this lesson's `safe_get_json` does) rather than repeating the check at every call site.
- Prefer `Net::HTTP.get_response` for simple GETs; drop to the explicit `Net::HTTP.new` + request-object form only when headers/method/body need finer control (as the POST example does).

## Real-World Usage

`Net::HTTP` (often wrapped by higher-level gems like `Faraday`/`HTTParty` in larger projects, but usable directly with zero dependencies as shown here) is what those very gems build on internally; the "doesn't throw on 404" trap and the "check success before parsing" fix are the exact same lesson this repository has already verified for JavaScript's `fetch()` and PHP's `curl`.

## Summary

- `Net::HTTP` is Ruby's standard-library HTTP client — no gem needed for GET/POST/headers/JSON bodies.
- It does not raise on 404/error statuses; the caller must check `Net::HTTPSuccess`/`.code` explicitly, verified live.
- A small wrapper helper centralizing that check is the idiomatic fix, also verified live against a real non-existent resource.

## Key Terms

- **`Net::HTTPSuccess`** — the response superclass matching any 2xx status; `response.is_a?(Net::HTTPSuccess)` is the idiomatic success check.

## Interview Questions

1. **Does `Net::HTTP` raise an exception for a 404 response?**
   No — it returns a `Net::HTTPNotFound` response object like any other response, with `.code == "404"`; no exception is raised at all. This was verified live in this lesson by requesting a genuinely non-existent `todos/999999` resource from the real `jsonplaceholder.typicode.com` API and confirming `response.is_a?(Net::HTTPSuccess)` returns `false` with zero exception involved — the caller must check this explicitly before trusting the response body.

2. **What does a `safe_get_json` helper add over a raw `Net::HTTP.get_response` call?**
   It centralizes the "check success, then parse" pattern in one place: it calls `Net::HTTP.get_response`, explicitly raises if the response isn't a `Net::HTTPSuccess`, and only then parses the body as JSON — so every call site gets a clear, immediate exception on failure instead of silently parsing (or failing to parse) an error page's body as if it were the expected JSON shape. Verified live by calling it against a real non-existent resource and catching the resulting `RuntimeError`.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
