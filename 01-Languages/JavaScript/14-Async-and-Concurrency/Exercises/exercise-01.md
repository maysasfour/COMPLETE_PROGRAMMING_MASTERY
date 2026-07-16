# Exercise 01 — `fetchWithTimeout` Using `Promise.race`

[Back to lesson](../README.md)

## Task

Write an async function `fetchWithTimeout(asyncTask, timeoutMs)` that races a given async operation (a function returning a Promise, called with no arguments) against a timeout:

- If `asyncTask()` resolves before `timeoutMs` elapses, `fetchWithTimeout` resolves with that same value.
- If `timeoutMs` elapses first, `fetchWithTimeout` rejects with an `Error` whose message is `"Operation timed out after {timeoutMs}ms"`.

Use `Promise.race` — do not use any external library.

## Constraints

- Implement the timeout itself as a Promise that rejects via `setTimeout`, then race it against `asyncTask()` with `Promise.race`.
- `fetchWithTimeout` must be an `async function` (or return a Promise directly) so it composes with `await`/`try`-`catch` at the call site.

## Starter Code

```js
function delay(ms, value) {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms));
}

async function fetchWithTimeout(asyncTask, timeoutMs) {
  // race asyncTask() against a timeout Promise
}

// A task that resolves in 50ms, given a generous 200ms timeout -> should succeed
fetchWithTimeout(() => delay(50, "data"), 200).then(console.log);

// A task that resolves in 200ms, given only a 50ms timeout -> should reject
fetchWithTimeout(() => delay(200, "data"), 50).catch((err) => console.log(err.message));
```

## Expected Output

```
data
Operation timed out after 50ms
```

(Order may vary slightly since both calls run concurrently, but each line's content must match.)

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
