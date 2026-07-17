# Web Development Interview Questions

[Back to module overview](README.md)

## 1. What's the difference between `200`, `201`, `204`, `400`, `401`, `403`, and `404`?

`200 OK` (generic success), `201 Created` (a new resource was created), `204 No Content` (success, no response body), `400 Bad Request` (the request itself was malformed), `401 Unauthorized` (not authenticated), `403 Forbidden` (authenticated, but not allowed), `404 Not Found` (resource doesn't exist). All verified live with real HTTP requests in [04-Backend-Development/01-REST-API-Fundamentals](../04-Backend-Development/01-REST-API-Fundamentals/README.md), including the genuinely-verified finding that Spring Security's default unauthenticated response is `403`, not the commonly-assumed `401`.

## 2. What does REST's "statelessness" constraint mean?

Each request must contain all the information needed to process it — the server does not store client session state between requests. This is why token-based authentication (JWTs) is common in REST APIs instead of server-side sessions, and why it matters for horizontal scalability (any server instance can handle any request).

## 3. What's the difference between authentication and authorization?

Authentication answers "who are you?" (verifying identity, e.g., checking a password or token signature). Authorization answers "what are you allowed to do?" (checking permissions/roles/scopes for a specific action). A request can be fully authenticated yet still correctly denied — verified live in both [04-Backend-Development/04-Authentication-and-Authorization](../04-Backend-Development/04-Authentication-and-Authorization/README.md) (role-based) and [14-APIs-and-Integrations/03-Authentication](../14-APIs-and-Integrations/03-Authentication/README.md) (a genuinely, cryptographically valid token was still correctly denied a write operation because its scope didn't grant it).

## 4. Why is `PUT` typically idempotent while plain `POST` is not?

`PUT` replaces the resource at a specific URL with the given state — repeating the identical request produces the same end result every time. `POST` (in typical usage) creates a new resource each time, so repeating it creates duplicates. This was verified live in [14-APIs-and-Integrations/01-HTTP-Fundamentals](../14-APIs-and-Integrations/01-HTTP-Fundamentals/README.md): retrying an identical `POST /orders` request created 2 separate orders, while retrying an identical `PUT` with a client-supplied ID left exactly 1.

## 5. How would you introduce a breaking change to a public API without breaking existing clients?

Introduce a new version (via URL path like `/v2/`, or a version header) with the new behavior, while leaving the existing version's behavior completely unchanged for clients still depending on it. This was verified live in [14-APIs-and-Integrations/02-REST-Design-and-Versioning](../14-APIs-and-Integrations/02-REST-Design-and-Versioning/README.md): renaming a field in an unversioned endpoint broke a real client's parsing (`null` instead of the expected value), while serving old and new field names from separate `/v1/`/`/v2/` paths let both an old and new client succeed simultaneously.

## 6. What is Cross-Site Scripting (XSS), and how do you prevent it?

XSS happens when user input is rendered into HTML output without encoding, letting an attacker's input become real, executable markup (including `<script>` tags). This was demonstrated with a real, literal `<script>` tag verified present in an actual HTTP response body in [16-Security/03-Input-Validation-and-Output-Encoding](../16-Security/03-Input-Validation-and-Output-Encoding/README.md), fixed by HTML-encoding output at the point of rendering, verified to neutralize the identical payload into inert text.

## 7. What does HTTPS actually protect against, and what doesn't it protect against?

HTTPS (TLS) encrypts and authenticates data in transit, protecting against eavesdropping and tampering on the network path between client and server. It does not protect against application-level vulnerabilities like XSS or SQL injection, and does not by itself prevent clickjacking or MIME-sniffing — those require separate security headers (`X-Frame-Options`, `X-Content-Type-Options`), demonstrated in [16-Security/04-HTTPS-and-Security-Headers](../16-Security/04-HTTPS-and-Security-Headers/README.md) alongside a real, verified TLS 1.3 handshake.

## 8. Why should you always configure a timeout when calling a third-party API?

Without a timeout, a client has no enforced upper bound on how long it will wait for a slow or hung dependency, risking indefinitely tied-up resources. This was verified live in [14-APIs-and-Integrations/05-Consuming-Third-Party-APIs](../14-APIs-and-Integrations/05-Consuming-Third-Party-APIs/README.md) with real, measured elapsed times: a client with no timeout took the full 3211ms a deliberately slow server imposed, while a client with an explicit 1-second timeout failed fast at 1003ms.

## 9. What is CORS, and why does it exist?

Cross-Origin Resource Sharing is a browser security mechanism that restricts whether a web page can make requests to a different origin (domain/port/protocol) than the one it was served from, unless the target server explicitly opts in via response headers. It exists to prevent a malicious page from silently making authenticated requests to other sites on a victim's behalf.

## 10. What's the difference between a unit test, an integration test, and an end-to-end test for a web API?

A unit test exercises one piece of logic in isolation (fast, no real dependencies). An integration test verifies real interaction with an actual dependency (a real database, a real file). An end-to-end test drives the fully running, wired-together application through its real, external interface. All three were demonstrated with genuinely distinct real bugs each layer caught (and the others would have missed) in [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md) Lessons 01-03.

## 11. What is a race condition in the context of a web server handling concurrent requests, and how do you prevent it?

If multiple requests concurrently read and modify shared, unsynchronized state, updates can be lost due to unpredictable thread interleaving. See [20-Computer-Science-Fundamentals/03-OS-Fundamentals](../20-Computer-Science-Fundamentals/03-OS-Fundamentals/README.md) for a real, measured demonstration and its fix with `AtomicInteger`/proper synchronization.

## Recommended Next File

[06 — System Design Questions](06-System-Design-Questions.md)
