# 14 — APIs and Integrations

[Back to repository root](../README.md)

## What APIs and Integrations Covers

This module covers the practical design and consumption concerns of HTTP APIs that go beyond building a single backend service ([04-Backend-Development](../04-Backend-Development/README.md)) or a single service boundary ([13-Software-Architecture](../13-Software-Architecture/README.md)): idempotency and safe retries, versioning without breaking existing clients, authentication vs. authorization at the token-scope level, documentation as an enforceable contract, and the real risks of depending on a third-party API you don't control. Five lessons, each demonstrating a real, verified bug caused by getting one of these concerns wrong, followed by a fix.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [13-Software-Architecture](../13-Software-Architecture/README.md) for the same reasoning). Every lesson in this module is plain Java, using only the JDK's built-in `com.sun.net.httpserver.HttpServer` and `java.net.http.HttpClient` — no build tool, no external dependencies — the same zero-framework approach as [13-Software-Architecture Lesson 03](../13-Software-Architecture/03-Microservices-Fundamentals/README.md). Lessons 01, 02, and 05 spin up genuine embedded HTTP servers and make real network requests against them; Lesson 03 uses the JDK's own `javax.crypto` for a genuinely working HMAC-signed token, not a mocked stand-in.

## Why It Matters / Where It's Used

- **Every one of these concerns causes real, well-documented categories of production incidents**: duplicate charges from unsafe retries, silently broken integrations from unversioned breaking changes, broken function-level authorization from checking validity but not scope, confusing crashes from undocumented-but-unenforced contracts, and cascading failures from unbounded waits on a slow dependency.
- **Nearly every real system both exposes and consumes APIs** — these lessons apply whether you're the one building the API or the one calling someone else's.
- **Interviews**: "how would you design this endpoint to be safely retryable," "how do you introduce a breaking API change without breaking existing clients," and "how would you handle a slow third-party dependency" are common, practical system-design interview questions, directly covered by this module's five lessons.

## Advantages of This Approach

- Every concept is backed by a **real, compiled, and run bug** verified against genuine network requests: two duplicate orders from an unsafe retry, a real `null` from an unversioned field rename, a real bypassed authorization check on a genuinely signed token, a real `NullPointerException` from an unvalidated contract, and real, measured elapsed times (3211ms vs. 1003ms) proving a timeout's effect.
- Lessons 01, 02, and 05 use genuine embedded HTTP servers and real `HttpClient` calls rather than simulating HTTP behavior in-process, directly extending the real-server verification discipline from [13-Software-Architecture](../13-Software-Architecture/README.md) and [04-Backend-Development](../04-Backend-Development/README.md).
- Lesson 03's token implementation is genuinely cryptographically signed (HMAC-SHA256 via the JDK's own `javax.crypto`), so its scope-bypass bug and its tamper-detection are both real, not illustrative stand-ins.

## Disadvantages / Trade-offs

- This module's examples are deliberately minimal (a single Java file per lesson) — real production systems use dedicated libraries for JWT/OAuth2 (rather than hand-rolled tokens), real OpenAPI tooling (rather than a hand-written required-fields check), and dedicated resilience libraries (circuit breakers, retry-with-backoff) beyond the plain timeout shown here.
- Some lessons' "in principle" risks (an infinitely hanging third-party API in Lesson 05) are demonstrated via a bounded stand-in (a 3-second delay) rather than a genuinely unbounded hang, for the practical reason that a truly hung demo would never complete — the measured contrast (3211ms vs. 1003ms) still proves the timeout's real, enforced effect.

## How to Run the Examples

Each lesson is a single, self-contained Java file — no build tool or dependencies required.

```bash
cd 14-APIs-and-Integrations/01-HTTP-Fundamentals
javac Example.java
java Example
```

Lessons 01, 02, and 05 start and cleanly stop a real embedded HTTP server as part of their own execution — no separate setup is required. Requires only a JDK (this module was built and verified against JDK 25). `.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Assuming `POST` is always safe to retry** — verified live in Lesson 01 to create a genuine duplicate order.
- **Changing an existing, in-use API response shape in place** — verified live in Lesson 02 to silently break an old client's parsing.
- **Checking only that a token is validly signed, not what it's scoped to do** — verified live in Lesson 03 to let a read-only token perform a destructive write.
- **Documenting a required field without actually validating it** — verified live in Lesson 04 to let a malformed request crash deep inside business logic.
- **Calling a third-party API with no timeout configured** — verified live in Lesson 05 to have no enforced upper bound on wait time.

## Best Practices

- Design operations a client might retry (payments, order creation) to be idempotent, typically via a client-supplied ID or explicit idempotency key.
- Never change an existing API response shape in a breaking way; version explicitly (`/v1/`, `/v2/`) when a breaking change is genuinely needed.
- Always check both token validity (authentication) and scope/permissions (authorization) as distinct steps.
- Validate incoming requests against the documented contract at the API boundary, before business logic runs.
- Always configure an explicit timeout — paired with a real fallback strategy — when calling any external API.

## Interview Questions

1. Why is `PUT` typically idempotent while plain `POST` is not, and how would you design a `POST` endpoint to be safely retryable?
2. How would you introduce a breaking change to a public API without breaking existing clients?
3. Why isn't a validly-signed token sufficient to authorize every action a client might request?
4. What's the practical benefit of validating a request against an OpenAPI-documented contract, beyond having the documentation exist?
5. What happens to a system if a third-party dependency hangs and no timeout is configured?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [HTTP Fundamentals](01-HTTP-Fundamentals/README.md) | Idempotency; a real duplicate-order bug from an unsafe retry |
| 02 | [REST Design and Versioning](02-REST-Design-and-Versioning/README.md) | A real breaking-change bug; versioned endpoints coexisting |
| 03 | [Authentication](03-Authentication/README.md) | Validity vs. scope; a real HMAC-signed token and a real authorization bypass |
| 04 | [API Documentation](04-API-Documentation/README.md) | Contract validation; a real crash from an unenforced documented requirement |
| 05 | [Consuming Third-Party APIs](05-Consuming-Third-Party-APIs/README.md) | Timeouts; real, measured elapsed times proving their effect |

## Suggested Path

Work through 01 → 05 in order — each lesson addresses a distinct, practical concern that compounds with the others in a real production API. See also [04-Backend-Development](../04-Backend-Development/README.md) (for building a complete REST API, including role-based JWT authentication) and [13-Software-Architecture](../13-Software-Architecture/README.md) (for the service-boundary and reliability-isolation concepts this module's Lessons 01 and 05 build on).

**Previous module:** [13-Software-Architecture](../13-Software-Architecture/README.md)
