# 04 — API Documentation (OpenAPI/Swagger)

[Back to module overview](../README.md) | [Previous: Authentication](../03-Authentication/README.md)

## Beginner: Documentation as an Enforceable Contract, Not Just Prose

An OpenAPI (Swagger) spec documents an API's contract — required fields, types, response shapes — in a machine-readable format. This lesson focuses on a practical benefit beyond human-readable docs: that contract can be used to **validate requests before they ever reach business logic**, turning a documentation artifact into an actual safeguard. Demonstrated here with a hand-rolled, minimal version of that same idea, kept small enough to be fully self-contained.

## The Violation: A Real Crash From Skipping Contract Validation

```java
static String createUserViolation(Map<String, String> request) {
    String name = request.get("name");
    String email = request.get("email");
    return "Welcome email queued for " + name + " <" + email.toLowerCase() + ">"; // NPE if email is missing!
}
```

The documented contract says `email` is required — but nothing in the code actually checks that before using it. Verified live, a request missing `email` entirely reaches business logic and crashes deep inside it:

```
Crashed with: NullPointerException  <- BUG: a confusing internal crash, not a clean, documented API error!
```

A real client sending a malformed request would receive a confusing 500-style internal error with no indication of what was actually wrong with their request — the *documented* contract (email is required) was never actually enforced.

## The Fix: Validate Against the Contract First

```java
static String createUserFixed(Map<String, String> request) {
    Set<String> missing = findMissingFields(request, CreateUserSpec.REQUIRED_FIELDS);
    if (!missing.isEmpty()) {
        throw new IllegalArgumentException("... missing required field(s): " + missing);
    }
    // business logic only runs once the contract is satisfied
}
```

Verified live — the identical malformed request is now rejected with a clear, specific error identifying exactly what's missing, and a valid request succeeds correctly:

```
Rejected: Request does not match documented contract -- missing required field(s): [email]  <- correct: a clear, specific, documented error
Welcome email queued for Grace Hopper <grace.hopper@example.com>
```

## Detailed Example

See [Example.java](Example.java) — the real crash caused by unvalidated business logic, and the contract-validation fix.

## Run It

```bash
cd 14-APIs-and-Integrations/04-API-Documentation
javac Example.java
java Example
```

## Expected Output

A malformed request causing a real `NullPointerException` deep in business logic in the violation; the same request cleanly rejected with a specific "missing required field" error in the fix; a valid request succeeding correctly.

## Common Mistakes

- Writing API documentation that describes required fields, but never actually enforcing that requirement in code — verified live to let a malformed request crash deep inside business logic instead of being rejected cleanly at the boundary.
- Letting documentation and actual validated behavior drift apart over time — a spec that isn't used to generate or check real validation logic can silently become inaccurate.
- Returning generic 500-style errors for malformed requests instead of specific, actionable 400-style errors that tell the client exactly what was wrong.

## Best Practices

- Treat an API's documented contract as something that should be actually enforced by validation logic, not just descriptive prose that could drift out of sync with real behavior.
- Validate a request against its full contract at the API boundary, before any business logic runs, so failures are clear and specific rather than confusing internal crashes.
- Use real OpenAPI tooling (schema validation libraries, code generators) in production systems to keep the documented contract and the enforced validation logic from drifting apart — this lesson's hand-rolled version demonstrates the underlying idea at a small, understandable scale.

## Real-World Usage

Real OpenAPI/Swagger specs are commonly used to auto-generate both request validation middleware and client SDKs from the same source of truth, specifically to prevent the documentation and the actual enforced behavior from diverging. The crash demonstrated in this lesson — a required field silently assumed present, causing a deep `NullPointerException` instead of a clean 400 response — is a common, real category of production API bug in systems that document a contract without actually validating requests against it.

## Summary

- A documented "required field" that was never actually validated let a malformed request crash deep inside business logic with a confusing `NullPointerException`.
- Validating the request against the documented contract at the boundary, before business logic runs, fixed this — verified live with a clear, specific rejection message and a valid request still succeeding correctly.
- A documented API contract has real, enforceable value beyond human-readable prose, when it's actually used to validate requests.

## Key Terms

- **OpenAPI (Swagger)** — a specification format for documenting an API's contract (endpoints, required fields, types, responses) in a machine-readable way.
- **Contract validation** — checking that an incoming request actually satisfies an API's documented requirements before processing it.
- **400 Bad Request** — the HTTP status code for a client error where the request itself was malformed or invalid, as opposed to a 500 server error.

## Interview Questions

1. **Why is documenting a required field not the same as actually enforcing it, and how was the gap between them demonstrated concretely?**
   Documentation is just descriptive text (or a machine-readable spec) unless something in the actual code checks incoming requests against it — nothing about writing "email is required" in a spec stops code from assuming it's present. This was demonstrated concretely: `createUserViolation()` used `request.get("email")` directly, and calling it with a request that omitted `email` entirely produced a real `NullPointerException` — the documented requirement existed only as an assumption, never as an actual check.

2. **What's the practical benefit of validating a request against its documented contract at the API boundary, rather than letting business logic fail naturally?**
   Validating at the boundary produces a clear, specific, client-actionable error (e.g., "missing required field: email") before any business logic runs, rather than an opaque internal crash partway through processing. This was verified concretely: the same malformed request that caused a `NullPointerException` in the violation instead produced the message `"Request does not match documented contract -- missing required field(s): [email]"` in the fix — a client receiving this error knows exactly what to fix, whereas a client receiving a raw `NullPointerException` (or its HTTP equivalent, a generic 500 error) would have no idea what was actually wrong with their request.

## Recommended Next Lesson

[05 — Consuming Third-Party APIs](../05-Consuming-Third-Party-APIs/README.md)
