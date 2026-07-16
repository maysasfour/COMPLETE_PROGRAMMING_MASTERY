# Solution 01 — `fetchWithTimeout` Using `Promise.race`

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `Promise.race([asyncTask(), timeout])` starts both Promises immediately and settles with whichever one settles first — if `asyncTask()` resolves before the timeout fires, `race` resolves with its value; if the timeout's `setTimeout` fires first, `race` rejects with the timeout `Error`.
- The timeout Promise's executor deliberately never calls `resolve` — only `reject`, after the delay — because a timeout by definition represents a failure path, not a value to succeed with.
- Note that `Promise.race` does not cancel the loser — if `asyncTask()` eventually resolves after the timeout already rejected, that resolution is simply ignored by whoever awaited `fetchWithTimeout`, but the underlying `asyncTask()` still ran to completion in the background. True cancellation would need an `AbortController`, out of scope for this exercise.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
data
Operation timed out after 50ms
```

Matches the exercise's expected output exactly: the 50ms task beat its generous 200ms timeout and resolved normally, while the 200ms task lost its race against a strict 50ms timeout and rejected with the exact expected message.
