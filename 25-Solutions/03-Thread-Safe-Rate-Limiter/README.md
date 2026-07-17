# Solution 03 — Thread-Safe Rate Limiter

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/03-Thread-Safe-Rate-Limiter.md)

## Approach

The violation's `if (count < max) { count++; }` is a check-then-act sequence, not atomic — a tiny, deliberate delay between the check and the increment widens the real race window so the bug reproduces reliably (the same technique used in [12-Design-Patterns/01-Singleton](../../12-Design-Patterns/01-Singleton/README.md)). The fix uses `AtomicInteger.getAndUpdate` to perform the check-and-increment as a single atomic operation.

## Verified Live

```
=== Violation: naive int-based rate limiter under concurrent load ===
Max allowed: 100, actually allowed: 120  <- BUG: allowed MORE than max under concurrent load!

=== Fixed: AtomicInteger-based rate limiter, verified across 3 runs ===
Run 1: max allowed: 100, actually allowed: 100  <- correct
Run 2: max allowed: 100, actually allowed: 100  <- correct
Run 3: max allowed: 100, actually allowed: 100  <- correct
```

Rerunning the violation multiple times reliably shows over-allowance (120, 129, 136 across different runs — the exact number varies with real thread scheduling), while the fixed version reliably allows exactly 100 across every run.

## Run It

```bash
cd 25-Solutions/03-Thread-Safe-Rate-Limiter
javac Example.java
java Example
```

See [Example.java](Example.java) for the full, runnable solution.
