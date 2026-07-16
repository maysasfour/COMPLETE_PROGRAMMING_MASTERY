# 03 — End-to-End Testing

[Back to module overview](../README.md) | [Previous: Integration Testing](../02-Integration-Testing/README.md)

## Beginner: Why This Bug Only Shows Up When the Real App Is Running

An end-to-end test drives the **complete, actually-running application** exactly as a real client would — a real server, started on a real port, exercised with real HTTP requests. This lesson demonstrates a real wiring bug that neither a unit test of a handler in isolation nor an integration test of one component would catch, because it's specifically a bug in how the pieces are *wired together* into the running app.

## The Bug: A Real, Verified Routing Mistake

```java
public static HttpServer start(int port) throws IOException {
    HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
    server.createContext("/health", exchange -> respond(exchange, 200, "OK"));
    server.createContext("/api/v1/notes", exchange -> respond(exchange, 200, "[]")); // wrong path!
    server.start();
    return server;
}
```

The notes handler's own logic is perfectly correct — if you called its lambda directly in a unit test, it would return `200` and `"[]"` without any issue. The bug is that it was wired up under the **wrong URL path** (`/api/v1/notes` instead of the documented `/notes`). Verified live, starting the real app on a real port and making a real HTTP request to the documented endpoint:

```
AppEndToEndTest.notesEndpointRespondsOk:51 GET /notes should respond 200, matching the app's documented API ==> expected: <200> but was: <404>
Tests run: 2, Failures: 1, Errors: 0, Skipped: 0
```

A real client calling `GET /notes` — exactly as documented — receives a real `404 Not Found`, because that path was simply never registered. No unit test of the handler's *logic* would ever catch this, because the handler's logic was never actually wrong — only its wiring was.

## The Fix, Verified Green

```java
server.createContext("/notes", exchange -> respond(exchange, 200, "[]"));
```

Re-running the identical end-to-end test suite after the fix:

```
Tests run: 2, Failures: 0, Errors: 0
BUILD SUCCESS
```

Both the `/health` and `/notes` endpoints now correctly respond `200` when hit exactly as a real client would.

## Detailed Example

See [App.java](src/main/java/com/example/e2e/App.java) (now the fixed version) and [AppEndToEndTest.java](src/test/java/com/example/e2e/AppEndToEndTest.java) — the actual test that caught this real wiring bug, starting a genuine server on an OS-assigned port and using a real `HttpClient`.

## Run It

```bash
cd 15-Testing-and-Debugging/03-End-to-End-Testing
mvn test
```

To see the original failure for yourself, temporarily change `App.start()`'s notes route back to `"/api/v1/notes"` and rerun `mvn test`.

## Expected Output

`Tests run: 2, Failures: 0, Errors: 0` and `BUILD SUCCESS` against the current (fixed) code.

## Common Mistakes

- Testing a route handler's logic in isolation and assuming that's sufficient — verified live that this specific bug (a handler wired to the wrong path) is entirely invisible to a test that never actually starts the real app and hits it via the real, documented URL.
- Hardcoding a fixed port for end-to-end tests, risking collisions with other running processes — this lesson uses port `0` (letting the OS assign a free port) and reads back the actual assigned port via `server.getAddress().getPort()`.
- Treating end-to-end tests as a replacement for unit and integration tests — they're slower and cover less of the code's internal logic in detail; the [testing pyramid](../01-Unit-Testing/README.md#real-world-usage) principle is to have many fast unit tests, fewer integration tests, and the fewest (but still present) end-to-end tests.

## Best Practices

- Write end-to-end tests against the actual, documented public interface of the app (the real URLs clients will use), not internal implementation details.
- Start the real app on a dynamically-assigned port in tests, to avoid port conflicts and allow tests to run in parallel safely.
- Reserve end-to-end tests for verifying the system is correctly wired together and behaves correctly as a whole — leave detailed logic verification to faster unit tests.

## Real-World Usage

Routing/wiring bugs — a handler that works correctly but was registered under the wrong path, or never registered at all — are a genuinely common category of real production bug, especially as an API grows and routes are added by different people over time. End-to-end tests, run as part of a CI pipeline against a real running instance of the application, are specifically what catches this category of bug before it reaches production, since they exercise the system exactly as an external client would.

## Summary

- A route handler's logic was completely correct, but it was wired up under the wrong URL path — a real bug that only an end-to-end test (starting the real app and hitting the real, documented endpoint) could catch.
- Verified live: `GET /notes` returned a real `404` against the buggy wiring, and a real `200` after the fix.
- This class of bug is invisible to both unit tests (which would test the handler's logic directly, bypassing routing entirely) and most integration tests (which typically test one component's interaction with one dependency, not the full request-routing wiring).

## Key Terms

- **End-to-end test** — a test that exercises the complete, actually-running system through its real, external interface (here, real HTTP requests to a real running server).
- **Testing pyramid** — the principle that a healthy test suite has many fast unit tests, fewer integration tests, and the fewest end-to-end tests, each layer catching a different category of bug.
- **Wiring bug** — a bug where individually correct components are connected to each other incorrectly (here, a correct handler registered at the wrong path).

## Interview Questions

1. **Why couldn't a unit test of the notes handler have caught this lesson's bug?**
   A unit test calling the handler's lambda directly would invoke its logic in isolation, completely bypassing the routing/registration step where the actual bug existed — the handler itself always correctly returned `200` and `"[]"` when invoked, so a unit test would have passed regardless of what path it was registered under. Only a test that started the real server and made a real HTTP request to the real, documented URL (`/notes`) could reveal that the routing itself was wrong — verified live by the actual response code being `404`, not `200`, for a request whose handler logic was entirely correct.

2. **What does it mean for an end-to-end test to exercise the system "exactly as a real client would," and why does that matter here?**
   It means the test interacts with the system only through its real, external, documented interface — starting the actual server process (or an equivalent), making real network requests to real URLs, and checking real responses — rather than calling internal methods or classes directly. This matters because the bug in this lesson existed entirely in that external interface (the URL a client must use), not in any internal method's logic; a test that bypassed the real HTTP layer (by calling the handler method directly, for example) would never exercise the routing table where the actual mistake lived, which is exactly why the end-to-end test — and only the end-to-end test — caught it.

## Recommended Next Lesson

[04 — Test-Driven Development](../04-Test-Driven-Development/README.md)
