# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Make GET and POST requests with the built-in global `fetch()` — no library install required.
- Correctly check `response.ok`/`response.status`, since `fetch()` does not throw on HTTP error statuses.
- Handle genuine network failures (unreachable host, DNS failure) with `try`/`catch`.
- Send and parse JSON request/response bodies.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

Node has shipped a spec-compliant, browser-compatible global `fetch()` since v18 — no `axios` or `node-fetch` install is needed for basic usage, mirroring exactly how `fetch` works in browser JavaScript ([03-Frontend-Development](../../../03-Frontend-Development/)). This is a deliberate ecosystem convergence: the same `fetch` code can often run unmodified in a browser and in Node.

The single most important, most commonly-missed fact about `fetch()`: **it does not reject/throw for HTTP error responses** (404, 500, etc.) — only for actual network-level failures (DNS failure, connection refused, no internet). Checking `response.ok` (or `response.status`) yourself is mandatory; assuming a resolved `fetch()` Promise means "the request succeeded" is a very common bug.

## Syntax: GET

```js
const response = await fetch("https://api.example.com/users/1");
console.log(response.status);  // e.g. 200, 404, 500
console.log(response.ok);      // true only for 200-299 status codes

if (!response.ok) {
  throw new Error(`Request failed with status ${response.status}`);
}
const data = await response.json(); // parses the body as JSON
```

## Syntax: POST with a JSON Body

```js
const response = await fetch("https://api.example.com/users", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ name: "Ada", role: "admin" }),
});
const created = await response.json();
```

The `Content-Type: application/json` header and `JSON.stringify(...)` on the body are both required — `fetch` does not automatically serialize a plain object passed as `body`; you must stringify it yourself, and tell the server what format to expect.

## The `response.ok` Trap, Concretely

```js
const response = await fetch("https://api.example.com/does-not-exist");
// response.ok is false, response.status is 404 -- but the Promise RESOLVED, it did not reject!

try {
  const data = await response.json(); // this line runs fine even for a 404
  console.log(data); // often an error-description body from the server, not what you wanted
} catch {
  // this catch block only fires for network failures, NOT for a 404/500 status
}
```

## Handling Genuine Network Failures

```js
try {
  await fetch("https://this-domain-does-not-exist.invalid/");
} catch (err) {
  console.log("Network-level failure:", err.message); // DNS/connection failure -- THIS throws
}
```

## Detailed Example

See [example.js](example.js) — makes real network calls to the public `jsonplaceholder.typicode.com` test API (the same service the equivalent [Python API-Integration lesson](../../Python/17-API-Integration/README.md) uses, for direct comparison): a successful GET, a GET that returns 404 (demonstrating `fetch` not throwing), a POST with a JSON body, and a genuine network-level failure against an invalid domain.

## Expected Output

Running `node example.js` (requires internet access) prints a real todo item fetched from the public API, confirms a 404 response resolves normally with `response.ok === false` rather than throwing, shows a POST request's echoed-back response body, and confirms a request to a genuinely unreachable domain does reject the `fetch()` Promise with a `TypeError`.

## Common Mistakes

- Assuming a resolved `fetch()` Promise means success — it only means "a response was received," not "the response was 200 OK." Always check `response.ok`.
- Forgetting to `JSON.stringify()` the request body, sending `[object Object]` as a literal string instead of real JSON.
- Forgetting the `Content-Type: application/json` header, causing some servers to fail to parse the body correctly even though it's valid JSON text.
- Calling `.json()` on a response body that isn't actually JSON (e.g., an HTML error page from a misconfigured endpoint), which throws a parsing error.

## Best Practices

- Always check `response.ok` (or `response.status`) before trusting `.json()`'s contents; throw a descriptive error if the request wasn't successful.
- Wrap `fetch()` calls in `try`/`catch` specifically to handle genuine network failures, separately from checking `response.ok` for HTTP-level failures.
- Set `Content-Type` explicitly and `JSON.stringify()` the body for any JSON API request.
- For production code making many external calls, consider a small wrapper function that centralizes the "check `.ok`, throw a typed error otherwise" logic (Lesson 09's custom error classes) instead of repeating it at every call site.

## Real-World Usage

Every frontend framework in [03-Frontend-Development](../../../03-Frontend-Development/) uses this exact `fetch` API to talk to backend APIs; Node backend services also use it to call third-party or internal APIs, making this the single most transferable networking pattern in the whole JavaScript ecosystem, identical in browser and server code.

## Security Considerations

Never trust or directly render unsanitized data returned from an external API into HTML without escaping it (a form of XSS, see [16-Security](../../../16-Security/)) — treat API responses as untrusted input, the same as any user-supplied data, even from an API you control.

## Summary

- `fetch()` is a built-in, browser-compatible HTTP client available in Node without any install.
- It resolves (does not reject) for HTTP error statuses (404, 500) — always check `response.ok`.
- It only rejects for genuine network-level failures (DNS, connection refused) — wrap those calls in `try`/`catch`.
- POST/PUT bodies must be manually `JSON.stringify()`-ed, with an explicit `Content-Type: application/json` header.

## Key Terms

- **`fetch()`** — the built-in, Promise-based HTTP client API, shared between browsers and Node.
- **`response.ok`** — `true` only for HTTP status codes 200-299; does not reflect network-level success/failure.
- **Network-level failure** — a failure to reach the server at all (DNS failure, connection refused), which does cause `fetch()`'s Promise to reject.

## Review Questions

1. Why does checking only `try`/`catch` around `fetch()` fail to catch a 404 response?
2. What two things does sending a JSON POST body require that `fetch()` doesn't do automatically?
3. What's the practical difference between an HTTP-level failure (404) and a network-level failure (DNS error) as far as `fetch()`'s Promise is concerned?

## Interview Questions

1. **Does `fetch()` throw an error for a 404 or 500 response?**
   No — `fetch()`'s Promise resolves successfully as long as a response was received at all, regardless of its HTTP status code. `response.ok` (true for 200-299) and `response.status` must be checked manually to detect an HTTP-level failure; `fetch()` only rejects for genuine network-level failures (DNS resolution failure, connection refused, no network).

2. **What do you need to do to send a JSON body with `fetch()`?**
   Set the `Content-Type: application/json` header explicitly, and pass `JSON.stringify(data)` (not the raw object) as the `body` option — `fetch` does not automatically serialize JavaScript objects into JSON for you.

3. **How would you write a `fetch` wrapper that throws a proper error for both network failures and HTTP error statuses?**
   Wrap the call in `try`/`catch` for network-level failures, and after a successful resolve, check `response.ok` and manually `throw new Error(...)` (or a custom error class) if it's `false`, so that both failure categories end up as a thrown error the caller can handle uniformly with one `catch` block.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
