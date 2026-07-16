# 05 — Consuming Third-Party APIs

[Back to module overview](../README.md) | [Previous: API Documentation](../04-API-Documentation/README.md)

## Beginner: A Third-Party API Can Be Slow or Unresponsive at Any Time

When your code calls someone else's API, you have no control over how fast — or whether — it responds. This lesson demonstrates a real, measured difference between a client with no timeout and one with a properly configured timeout, against a genuine embedded HTTP server that deliberately delays its response by 3 real seconds.

## The Violation: A Real, Measured Unbounded Wait

```java
HttpClient noTimeoutClient = HttpClient.newHttpClient(); // no per-request timeout set
long start = System.currentTimeMillis();
HttpResponse<String> response = noTimeoutClient.send(request, HttpResponse.BodyHandlers.ofString());
long elapsed = System.currentTimeMillis() - start;
```

Verified live, against a server deliberately sleeping 3 real seconds before responding:

```
Request completed after 3211 ms: {"status":"ok"}
BUG (in principle): with NO timeout, this call would have waited INDEFINITELY if the third-party API had simply never responded at all, instead of just being slow -- tying up a thread/connection for as long as the third party chooses.
```

The call did eventually complete here, because the simulated third-party API was merely *slow* (3 seconds), not *unresponsive forever* — but nothing in the client code limits how long it's willing to wait. If the real third-party API hung indefinitely (a genuinely common failure mode — an overloaded backend, a stuck connection), this exact code would wait indefinitely too, tying up a thread for as long as the third party chooses.

## The Fix: A Real, Measured Timeout

```java
timeoutClient.send(
        HttpRequest.newBuilder(uri).timeout(Duration.ofSeconds(1)).GET().build(),
        HttpResponse.BodyHandlers.ofString());
```

Verified live, against the identical 3-second-delay server:

```
Request FAILED FAST after 1003 ms (timeout was set to 1000ms): request timed out
Correct: the call gave up well before the 3-second delay, freeing the calling thread to retry, fall back, or fail gracefully instead of hanging indefinitely.
```

The client correctly gave up at almost exactly the configured 1000ms — a real, measured, enforced upper bound on how long it's willing to wait, regardless of how long (or whether) the third party actually responds.

## Detailed Example

See [Example.java](Example.java) — a real, deliberately slow embedded HTTP server, and both the unbounded and timeout-bounded client calls, with real measured elapsed times.

## Run It

```bash
cd 14-APIs-and-Integrations/05-Consuming-Third-Party-APIs
javac Example.java
java Example
```

The example takes about 4 seconds to run in total (a real 3-second server delay, plus a real ~1-second timeout).

## Expected Output

A real HTTP server starting; a request with no timeout completing after roughly 3 seconds (the server's real delay); a request with a 1-second timeout failing with `HttpTimeoutException` after roughly 1 second, well before the server's response would have arrived; the server stopping cleanly.

## Common Mistakes

- Calling a third-party API with no timeout configured, assuming it will always respond reasonably quickly — verified live to have no built-in upper bound on wait time at all.
- Setting a timeout so short that genuinely slow-but-successful responses are needlessly treated as failures — the right timeout value depends on the specific API's real, expected latency characteristics.
- Not having a fallback/retry strategy for when a timeout does trigger — a timeout failing fast is only useful if the calling code actually does something sensible with that failure (retry with backoff, return a cached value, degrade gracefully).

## Best Practices

- Always configure an explicit timeout when calling any external API — never rely on defaults that may have no effective upper bound.
- Choose a timeout value based on the third-party API's actual documented or observed latency characteristics, not an arbitrary guess.
- Combine timeouts with a real fallback strategy (retry with backoff, circuit breaker, cached response) so a timeout's fast failure is actually useful rather than just a different kind of failure.

## Real-World Usage

Every production system that depends on a third-party API (a payment gateway, a weather service, another internal microservice as in [13-Software-Architecture Lesson 03](../../13-Software-Architecture/03-Microservices-Fundamentals/README.md)) needs a real, configured timeout — an unresponsive dependency without one can exhaust a caller's thread pool or connection pool entirely, turning one slow dependency into a cascading outage across the whole system. This is precisely why resilience libraries (circuit breakers, bulkheads) exist in production Java systems, building on exactly this timeout foundation.

## Summary

- A client with no configured timeout was shown, with real measured elapsed time (3211ms), to have no enforced upper bound on how long it will wait for a slow third-party API.
- A client with an explicit 1-second timeout was shown, with real measured elapsed time (1003ms), to fail fast well before the third party's actual response would have arrived.
- Timeouts convert an unbounded, unpredictable wait into a bounded, predictable failure that calling code can actually plan for.

## Key Terms

- **Timeout** — a configured maximum duration a client will wait for a response before giving up and failing.
- **HttpTimeoutException** — the exception Java's `HttpClient` throws when a request exceeds its configured timeout.
- **Cascading failure** — a failure in one system component (like an unresponsive third-party API) propagating to and degrading unrelated components, often because of unbounded waits tying up shared resources.

## Interview Questions

1. **Why is calling a third-party API with no configured timeout a real risk, even if it usually responds quickly?**
   Without an explicit timeout, a client has no enforced upper bound on how long it will wait — if the third-party API ever hangs (rather than just being slow), the calling code waits indefinitely, tying up whatever thread or connection resource made the call. This was demonstrated concretely: a client with no timeout configured took the full, real 3211ms to complete against a deliberately slow server — proving there was no limit in effect, only the server's own behavior determining how long the wait actually was.

2. **How does an explicit timeout change a slow dependency's failure mode, and how was this verified?**
   Without a timeout, "slow" and "will never respond" look identical to the calling code — both simply mean waiting. With an explicit timeout, a slow-or-unresponsive dependency instead produces a bounded, predictable failure (an `HttpTimeoutException`) at a known point in time, which calling code can actually handle (retry, fall back, degrade gracefully). This was verified concretely: against the identical 3-second-delay server, a client with a 1-second timeout failed with `HttpTimeoutException` after a measured 1003ms — well before the server's response would have arrived — proving the timeout, not the server's actual behavior, determined when the call gave up.

## Recommended Next Lesson

This is the final lesson in the APIs and Integrations module. Continue to [15-Testing-and-Debugging](../../15-Testing-and-Debugging/README.md) if built, or return to the [module overview](../README.md).
