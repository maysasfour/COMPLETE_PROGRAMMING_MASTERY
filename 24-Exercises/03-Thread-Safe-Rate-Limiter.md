# Exercise 03 — Thread-Safe Rate Limiter

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/03-Thread-Safe-Rate-Limiter/README.md)

**Combines:** [20-Computer-Science-Fundamentals](../20-Computer-Science-Fundamentals/README.md) (race conditions, OS scheduling) + [11-Design-Principles](../11-Design-Principles/README.md) (Single Responsibility)

## Problem

You're given a naive `RateLimiter` class meant to allow at most N requests per window, tracking the count with a plain `int`:

```java
class RateLimiter {
    private int count = 0;
    private final int max;
    boolean allow() {
        if (count < max) { count++; return true; }
        return false;
    }
}
```

1. Demonstrate, with a real multi-threaded test, that this naive implementation lets **more than `max`** requests through when called concurrently by multiple threads.
2. Fix it to be genuinely thread-safe using `AtomicInteger` (or `synchronized`).
3. Verify live, across multiple runs, that the fixed version never allows more than exactly `max` requests through, no matter how many threads call it concurrently.

## Constraints

- Use at least 8 real threads, each attempting many calls to `allow()`.
- Set `max` low enough (e.g., 100) that a real race condition is very likely to be observed in the naive version within a reasonable number of attempts.

## Success Criteria

- The naive version is shown, with a real measured count, to allow more than `max` requests through under concurrent load.
- The fixed version is shown, across multiple separate runs, to reliably allow exactly `max` requests and no more.
