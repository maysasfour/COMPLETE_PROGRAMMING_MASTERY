# 02 — REST Design and Versioning

[Back to module overview](../README.md) | [Previous: HTTP Fundamentals](../01-HTTP-Fundamentals/README.md)

## Beginner: Why Breaking Changes Are Dangerous in Public APIs

Once an API's response shape is in use by real clients, changing it — even something as small as renaming a field — can silently break every client that was never updated to expect the change. This lesson reproduces that exact failure against a real embedded HTTP server and a real client-side parser, then fixes it with versioning.

## The Violation: A Real, Silent Breaking Change

```java
server.createContext("/products/widget", exchange ->
        respond(exchange, "{\"name\":\"Widget\",\"unitPrice\":9.99}")); // "price" renamed to "unitPrice", in place
```

An "old client" — modeled here as a real, working field-extraction function that looks for `"price":` in the JSON response — was written against the *original* field name. Verified live, against the actual server response:

```
Server response: {"name":"Widget","unitPrice":9.99}
Old client (still looking for "price"): null  <- BUG: null! The field was renamed to "unitPrice" with no warning.
```

The server change is entirely valid JSON and might look like a harmless rename to whoever deployed it — but every existing client still looking for `"price"` silently receives `null` instead of a real price, with no error, no warning, and no indication anything went wrong until something downstream breaks.

## The Fix: Versioned Endpoints

```java
server.createContext("/v1/products/widget", exchange ->
        respond(exchange, "{\"name\":\"Widget\",\"price\":9.99}")); // unchanged, forever, for existing clients
server.createContext("/v2/products/widget", exchange ->
        respond(exchange, "{\"name\":\"Widget\",\"unitPrice\":9.99}")); // new shape, opt-in only
```

Verified live — the same old client's parser now correctly finds `"price"` at `/v1/`, while a new client correctly finds `"unitPrice"` at `/v2/`:

```
/v1/ response: {"name":"Widget","price":9.99}
Old client (still looking for "price"): 9.99  <- correct: /v1/ was never changed, so old clients keep working
/v2/ response: {"name":"Widget","unitPrice":9.99}
New client (looking for "unitPrice"): 9.99  <- correct: new clients opt into the new shape via /v2/
```

`/v1/` is never touched again once clients depend on it; the new response shape only exists at the new `/v2/` path, which clients opt into deliberately rather than being forced into by a silent in-place change.

## Detailed Example

See [Example.java](Example.java) — the real breaking-change bug and the versioned fix, against a genuine embedded HTTP server.

## Run It

```bash
cd 14-APIs-and-Integrations/02-REST-Design-and-Versioning
javac Example.java
java Example
```

## Expected Output

A real HTTP server starting; an unversioned breaking change causing a real "old client" parser to receive `null` for a renamed field; versioned `/v1/` and `/v2/` endpoints each correctly serving their respective client's expected field name; the server stopping cleanly.

## Common Mistakes

- Changing a public API response shape in place, assuming clients will simply adapt — verified live to silently break an old client's parsing with no error or warning at all.
- Treating versioning as unnecessary "until it's actually needed" — by the time a breaking change is needed, it's often too late to add versioning retroactively without an initial breaking change.
- Version-bumping the entire API for every field-level change rather than reserving new versions for genuinely breaking changes — over-versioning has its own maintenance cost.

## Best Practices

- Never change an existing, in-use API response shape in a way that breaks existing field names/types/structure — add new fields alongside old ones when possible, and reserve full version bumps for genuinely breaking changes.
- Introduce a new versioned path (or header-based version) for breaking changes, and keep the old version's behavior completely unchanged for as long as clients depend on it.
- Communicate a deprecation timeline for old versions clearly, rather than removing them without warning once a new version exists.

## Real-World Usage

Public APIs used by real, third-party clients (Stripe, GitHub, Twilio) are extremely conservative about breaking changes for exactly this reason — a single accidental field rename can silently break every integration relying on that field, often without the API provider even knowing until support tickets arrive. Explicit versioning (`/v1/`, `/v2/`, or a version header) is the standard mechanism for introducing breaking changes safely.

## Summary

- Renaming a field in an unversioned, already-in-use API response was shown, live, to make a real client's field lookup silently return `null`.
- Serving the old and new response shapes from separate, versioned endpoints (`/v1/`, `/v2/`) was shown, live, to let both an old and a new client keep working correctly, each against the version it expects.

## Key Terms

- **Breaking change** — a change to an API's contract (response shape, required fields, behavior) that causes existing, correctly-written clients to fail.
- **API versioning** — providing multiple, coexisting versions of an API (via URL path, header, or similar) so breaking changes can be introduced without affecting clients still on an older version.
- **Backward compatibility** — the property of a new API version (or change) not breaking clients written against a previous version.

## Interview Questions

1. **Why is renaming a field in an existing API response considered a breaking change, and how was this demonstrated concretely?**
   Existing clients are written to expect specific field names in an API's response; if a field is renamed, any client still looking for the old name will find it missing, typically resulting in `null` or a missing-value error, with no indication from the API itself that anything changed. This was demonstrated concretely: an "old client" parser looking for `"price":` in a JSON response correctly returned `9.99` before the change, but returned `null` after the field was silently renamed to `"unitPrice"` in the same, unversioned endpoint — verified via the actual printed output of the real HTTP response and the real parser's result.

2. **How does versioning solve the breaking-change problem, and how was the fix verified in this lesson?**
   Versioning provides multiple, simultaneously available versions of an endpoint, so a breaking change can be introduced as a *new* version while the old version's behavior remains completely unchanged for clients still depending on it. This was verified live: `/v1/products/widget` continued returning `{"price":9.99}` exactly as before, and the same old-client parser correctly retrieved `9.99` from it, while `/v2/products/widget` served the new `{"unitPrice":9.99}` shape only to clients that deliberately requested that version — both coexisting correctly against the same running server.

## Recommended Next Lesson

[03 — Authentication](../03-Authentication/README.md)
