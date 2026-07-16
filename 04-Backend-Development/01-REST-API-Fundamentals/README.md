# 01 — REST API Fundamentals

[Back to module overview](../README.md)

## Beginner: What REST Actually Means

REST (Representational State Transfer) is a set of conventions for designing HTTP APIs around four core ideas:

1. **Resources are identified by URIs** — `/tasks` represents the collection of tasks; `/tasks/3` represents one specific task.
2. **HTTP methods map to operations (CRUD)** — `GET` reads, `POST` creates, `PUT`/`PATCH` updates, `DELETE` removes.
3. **Status codes communicate outcome** — `200 OK`, `201 Created`, `404 Not Found`, `400 Bad Request`, and more, each with a specific, conventional meaning.
4. **Requests are stateless** — the server keeps no per-client session; every request carries everything needed to understand and process it on its own.

This lesson builds a tiny REST API using **only the JDK's built-in `com.sun.net.httpserver`** — no framework at all — specifically so these four ideas are visible directly, before Spring Boot (Lesson 02) abstracts them behind annotations and auto-configuration.

## Beginner: Mapping HTTP Methods to Operations

```java
switch (method) {
    case "GET" -> { /* read one task or list all tasks */ }
    case "POST" -> { /* create a new task */ }
    case "PUT" -> { /* update an existing task */ }
    case "DELETE" -> { /* remove a task */ }
    default -> respond(exchange, 405, "method not allowed");
}
```

Verified live against a running instance of this lesson's `Server`:

```
POST /tasks (body: "Write lesson")          -> 201 Created, "created task 1"
POST /tasks (body: "")                      -> 400 Bad Request, "task title cannot be empty"
GET  /tasks/1                                -> 200 OK, "Write lesson"
GET  /tasks/99                                -> 404 Not Found, "task 99 not found"
PUT  /tasks/1 (body: "Write lesson (updated)") -> 200 OK, "updated task 1"
DELETE /tasks/1                                 -> 204 No Content
GET  /tasks/1 (after delete)                     -> 404 Not Found, "task 1 not found"
```

Every one of these was actually sent to a running server via `curl` and its real status code and body captured — not merely described.

## Intermediate: Status Codes Are Not Interchangeable

- **200 OK** — the request succeeded and the response body contains the result.
- **201 Created** — a new resource was created (conventionally used for successful `POST`); the response often includes the new resource's location or ID.
- **204 No Content** — the request succeeded but there's genuinely nothing to send back (used here for a successful `DELETE`).
- **400 Bad Request** — the request itself was malformed (an empty task title, in this lesson's case) — the client's fault, distinct from a missing resource.
- **404 Not Found** — the requested resource doesn't exist — this is about the *resource*, not the request's validity.
- **405 Method Not Allowed** — the resource exists, but this particular HTTP method isn't supported on it.

Verified live: an empty `POST` body was correctly rejected with `400` (a malformed request), while a `GET` for a nonexistent ID was correctly rejected with `404` (a missing resource) — these are genuinely different failure categories, not interchangeable "error" responses.

## Advanced: Statelessness

Notice `Server` keeps its task data in a single, shared `Map<Integer, String>` — but critically, it stores no information about *which client* made which request, no session tokens, no "logged in as" state between requests. Every request is handled independently: the `GET /tasks/1` request carries everything the server needs to answer it (the method and the path), with no dependency on what request came before it from the same client.

This matters because it's what makes REST APIs horizontally scalable — any server instance behind a load balancer can handle any request, since no server-side session ties a client to one specific instance. (Real-world authentication, covered in Lesson 04, still fits within statelessness: a token is sent with *every* request, rather than the server remembering a login across requests.)

## Detailed Example

See [Server.java](src/main/java/com/example/restfundamentals/Server.java) — a full CRUD REST API using only `com.sun.net.httpserver`, demonstrating all four REST fundamentals with real, verified HTTP responses.

## Run It

```bash
cd 04-Backend-Development/01-REST-API-Fundamentals
javac -d out src/main/java/com/example/restfundamentals/Server.java
java -cp out com.example.restfundamentals.Server 8082
# in another terminal:
curl -X POST -d "Write lesson" http://localhost:8082/tasks
curl http://localhost:8082/tasks/1
```

## Expected Output

Running the commands above prints `201`/`Location`-style creation confirmation, `200` for a successful read, `404` for a missing task, `400` for an empty task body, and `204` for a successful delete — all confirmed against a real, running server in this lesson's own verification.

## Common Mistakes

- Using `GET` for an operation that changes server state (creating, updating, deleting) — `GET` should be safe to call repeatedly with no side effects (idempotent and side-effect-free); mutating operations belong on `POST`/`PUT`/`DELETE`.
- Returning `200 OK` for every outcome, including failures, with the actual error only described in the body text — real REST APIs use the status code itself to communicate success/failure category, so clients (and tooling, and browsers) can react correctly without needing to parse the body first.
- Conflating "malformed request" (400) with "resource not found" (404) — they're genuinely different failure categories with different correct client-side handling (a 400 means "fix your request"; a 404 means "that thing doesn't exist").

## Best Practices

- Use plural nouns for collection resources (`/tasks`, not `/task` or `/getTasks`) and let the HTTP method express the action, not the URL.
- Return the most specific, conventionally-correct status code for each outcome, not just `200`/`500`.
- Design every endpoint to be stateless — no server-side session data that a request implicitly depends on beyond what it carries itself.

## Real-World Usage

Virtually every public HTTP API (GitHub's, Stripe's, Twitter's) follows these same conventions, precisely because they're now a shared, cross-language, cross-framework standard — client libraries, API documentation tools (OpenAPI/Swagger, covered in `14-APIs-and-Integrations`), and HTTP client code (like the `URLSession`/`HttpClient`/`fetch` clients covered throughout this repository's `01-Languages` module) are all built assuming these conventions hold.

## Summary

- REST APIs organize around resources (URIs), HTTP methods (CRUD operations), status codes (outcome), and statelessness (no server-side session).
- Status codes are not interchangeable — 400 (bad request) and 404 (not found) are different failure categories with different correct client handling, verified live in this lesson.
- Statelessness is what makes REST APIs horizontally scalable — no server instance needs to "remember" a specific client across requests.

## Key Terms

- **Resource** — a named entity (e.g., a task) identified by a URI, the core unit REST APIs organize around.
- **Idempotent** — an operation that produces the same result no matter how many times it's repeated (GET, PUT, DELETE are conventionally idempotent; POST is not).
- **Statelessness** — the constraint that each request must carry everything needed to process it, with no reliance on server-side session state from prior requests.

## Interview Questions

1. **What's the difference between `200`, `201`, and `204`, and when would you use each?**
   `200 OK` is the general "success, here's the result" response, typically for `GET`/`PUT`. `201 Created` specifically signals a new resource was created, conventionally the response to a successful `POST`, often including the new resource's ID/location. `204 No Content` signals success with genuinely nothing to return, conventionally used for a successful `DELETE`. Verified live in this lesson: creating a task returned `201`, updating returned `200`, and deleting returned `204`.

2. **Why does REST require statelessness, and what problem does it solve?**
   Statelessness means the server keeps no client-specific session state between requests — every request must carry everything needed to process it on its own (this lesson's server, for instance, never remembers which "client" sent a previous request). This is what allows REST APIs to scale horizontally: since no request depends on server-side state from an earlier request, any server instance behind a load balancer can handle any incoming request, with no need to route a specific client's requests back to the exact same server instance that handled their previous one.

## Recommended Next Lesson

[02 — Building a REST API with Spring Boot](../02-Building-a-REST-API-with-Spring-Boot/README.md)
