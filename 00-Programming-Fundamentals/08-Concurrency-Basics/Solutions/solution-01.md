# Solution 01 — Concurrent Downloads (Simulated)

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Full runnable code is in `solution-01.py`. Verified output:

```
Downloading small.txt...
Downloading medium.txt...
Downloading large.txt...
Finished small.txt
Finished medium.txt
Finished large.txt
Total elapsed: ~1.5s (not ~3.0s, because the waits overlapped)
Results: ['small.txt: 200 OK', 'medium.txt: 200 OK', 'large.txt: 200 OK']

--- Reflection: what happens if one download raises? ---
Default gather() re-raises immediately: failed as simulated
return_exceptions=True collects everything instead:
  small.txt -> failed as simulated
  medium.txt -> medium.txt: 200 OK
  large.txt -> large.txt: 200 OK
```

## Timing Prediction

Sequential downloads would take `0.5 + 1.0 + 1.5 = 3.0s` (each wait fully completing before the next starts). The concurrent version instead takes roughly `1.5s` — the length of the *longest* single delay — because all three `asyncio.sleep()` calls overlap: while `small.txt` and `medium.txt` are "waiting," the event loop is free to run whichever coroutine is ready, so all three waits proceed at once rather than being queued up one after another.

## Reflection Answer

With `asyncio.gather`'s **default** behavior (`return_exceptions=False`), the moment any one of the gathered coroutines raises an exception, that exception propagates out of the `gather()` call immediately to the caller — it does not wait for the other coroutines to finish first. The other coroutines are not forcibly stopped, but their eventual results (or their own exceptions) are discarded from the caller's perspective, since `gather()` has already returned control via the raised exception.

Passing `return_exceptions=True` changes this: instead of raising, `gather()` waits for **every** coroutine to finish and returns a list where each position holds either that coroutine's actual return value or the `Exception` instance it raised. This lets the caller decide, per-item, how to handle successes and failures individually rather than losing all the successful results just because one item failed.

## Common Pitfalls

- Assuming concurrent `asyncio.gather` calls run in true parallel (multiple cores) — they don't; this is single-threaded cooperative concurrency, and the speedup comes entirely from overlapping I/O waits, not from CPU parallelism.
- Forgetting `await` in front of `asyncio.gather(...)` — this creates a coroutine object without running it, silently doing nothing useful (Python will typically warn "coroutine was never awaited").
- Assuming the default `gather()` cancels the other tasks when one fails — it does not automatically cancel them; it just stops waiting for them from the caller's point of view, which can leak still-running background work if not handled deliberately.
