# APIs and Integrations Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../14-APIs-and-Integrations/README.md)

## Idempotency
`PUT` (client-supplied ID, replaces resource state) is idempotent — retrying is safe. Plain `POST` (server-generated ID, creates new) is not. Verified live in [14-APIs-and-Integrations/01](../../14-APIs-and-Integrations/01-HTTP-Fundamentals/README.md): retrying a `POST` created 2 orders; retrying an idempotent `PUT` left exactly 1.

## Versioning
Never change an existing response shape in place. Serve `/v1/` (unchanged) and `/v2/` (new shape) side by side. Verified live in [14-APIs-and-Integrations/02](../../14-APIs-and-Integrations/02-REST-Design-and-Versioning/README.md): an unversioned field rename broke a real client's parsing (`null` instead of the expected value).

## Authentication vs. Authorization
```java
Claims claims = verifyToken(token);          // authentication: is this genuine?
if (!claims.scope().contains("write")) {      // authorization: is this ALLOWED?
    throw new SecurityException("denied");
}
```
Verified live in [14-APIs-and-Integrations/03](../../14-APIs-and-Integrations/03-Authentication/README.md): a genuinely valid, read-only token was wrongly accepted for a write operation when only validity was checked, not scope.

## Contract Validation (OpenAPI)
Validate incoming requests against the documented contract *before* business logic runs. Verified live in [14-APIs-and-Integrations/04](../../14-APIs-and-Integrations/04-API-Documentation/README.md): an unvalidated missing field caused a real `NullPointerException` deep in business logic instead of a clean 400.

## Consuming Third-Party APIs
```java
HttpRequest request = HttpRequest.newBuilder(uri)
        .timeout(Duration.ofSeconds(3))   // ALWAYS set a timeout
        .GET().build();
```
Verified live in [14-APIs-and-Integrations/05](../../14-APIs-and-Integrations/05-Consuming-Third-Party-APIs/README.md): a client with no timeout waited the full delay a slow server imposed (3211ms); one with an explicit timeout failed fast (1003ms).

## HTTP Is Just Text Over TCP
```
GET /hello HTTP/1.1
Host: localhost
Connection: close

```
Proven live with a raw `Socket` (no HTTP library) in [20-Computer-Science-Fundamentals/02-Networking](../../20-Computer-Science-Fundamentals/02-Networking/README.md).

See the [full APIs and Integrations module](../../14-APIs-and-Integrations/README.md) for verified, runnable code for everything above.
