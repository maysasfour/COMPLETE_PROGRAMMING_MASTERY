# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Explain the event loop and why JavaScript is single-threaded yet handles concurrency well for I/O.
- Use Promises (`.then`/`.catch`) and `async`/`await` correctly.
- Run independent async operations concurrently with `Promise.all`, and understand `Promise.race`/`Promise.allSettled`.
- Explain the microtask/macrotask distinction and why it produces a specific, predictable ordering.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept: The Event Loop

JavaScript runs on a **single thread** — there's no free-threading the way Java or C# have. Concurrency for I/O (network requests, file reads, timers) comes from the **event loop**: an operation that would block (like waiting for a network response) is handed off to the runtime (the browser or Node's libuv), and JavaScript keeps executing other code; when the operation finishes, its callback is queued to run once the current synchronous code finishes. This is fundamentally different from Python's `asyncio` in one respect: JavaScript's event loop isn't opt-in — every Node/browser program already runs on one, whereas Python code is synchronous unless you specifically write `async def` and run it under `asyncio`.

## Promises

```js
function delay(ms, value) {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), ms);
  });
}

delay(100, "done")
  .then((result) => console.log("Resolved with:", result))
  .catch((err) => console.log("Rejected with:", err));
```

A **Promise** represents a value that will be available *later* — it's either `pending`, `fulfilled` (with a value), or `rejected` (with a reason), and once settled (fulfilled or rejected), it never changes state again.

## `async`/`await`

```js
async function loadGreeting() {
  const message = await delay(100, "Hello!"); // pauses THIS function only, not the whole program
  return message.toUpperCase();
}

loadGreeting().then((result) => console.log(result)); // "HELLO!"
```

`async`/`await` is syntax sugar over Promises — an `async function` always returns a Promise, and `await` pauses that function's execution (not the entire program — other code keeps running) until the awaited Promise settles. This is why `try`/`catch` (Lesson 09) works transparently around `await` calls: an awaited rejection is thrown as a regular exception inside the `async` function.

## Running Things Concurrently: `Promise.all`

```js
async function loadDashboard() {
  const [user, orders, notifications] = await Promise.all([
    delay(100, { name: "Ada" }),
    delay(150, [{ id: 1 }, { id: 2 }]),
    delay(50, []),
  ]);
  return { user, orders, notifications };
}
```

Awaiting three Promises **sequentially** (`await a(); await b(); await c();`) takes the *sum* of their durations. `Promise.all([...])` starts all three immediately and waits for all of them together, taking roughly the *longest* single duration instead — a critical difference for real-world performance whenever operations don't depend on each other.

`Promise.race([...])` resolves/rejects as soon as the *first* Promise settles (useful for timeouts). `Promise.allSettled([...])` waits for every Promise to finish regardless of success/failure, returning a status for each — useful when you want partial results even if some operations fail.

## Microtasks vs. Macrotasks

```js
console.log("1: sync");
setTimeout(() => console.log("4: macrotask (setTimeout)"), 0);
Promise.resolve().then(() => console.log("3: microtask (Promise)"));
console.log("2: sync");
```

Output order is always `1, 2, 3, 4` — **all** synchronous code runs first, then the entire microtask queue (Promise callbacks) drains completely, and only then does the next macrotask (`setTimeout`, I/O callbacks) run, even though the `setTimeout` was scheduled with a `0`ms delay. This ordering is a common interview question precisely because it surprises people expecting `setTimeout(fn, 0)` to run "immediately."

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints a resolved Promise value, an `async`/`await` transformed greeting, a demonstration that `Promise.all` finishes in roughly the time of its longest task rather than the sum of all three, and the microtask-before-macrotask ordering proof from above, with real elapsed-time measurements confirming the concurrency claim (not just an assumption).

## Common Mistakes

- Awaiting independent async calls sequentially instead of using `Promise.all`, needlessly serializing work that could run concurrently.
- Forgetting `await` in front of an async call, then working with the resulting `Promise` object instead of its resolved value.
- Not handling a rejected Promise at all (missing `.catch()`/`try`-`catch`), which can crash a Node process on an unhandled rejection.
- Assuming `setTimeout(fn, 0)` runs "right away" — it always runs after the current synchronous code *and* the entire microtask queue.

## Best Practices

- Use `Promise.all` for independent operations that can run concurrently; reserve sequential `await` for operations that genuinely depend on each other's results.
- Always attach error handling (`try`/`catch` around `await`, or `.catch()` on a Promise chain) — an unhandled rejection is a real production risk, not just noisy console output.
- Prefer `async`/`await` over raw `.then()` chains for anything beyond a single step — it reads top-to-bottom like synchronous code and composes far more readably with `try`/`catch`.
- Use `Promise.allSettled` when partial success matters (e.g., fetching from three independent APIs where one failing shouldn't discard the other two results).

## Real-World Usage

Every network call, database query, and file operation in Node-based backends ([04-Backend-Development](../../../04-Backend-Development/)) is asynchronous; a request handler that queries a user, their orders, and a recommendation service typically uses `Promise.all` to run all three concurrently rather than serially, directly reducing response latency.

## Performance Considerations

Sequential `await` calls that don't depend on each other are one of the most common, easy-to-fix performance bugs in real Node codebases — converting three sequential 100ms awaits into a single `Promise.all` can turn a 300ms response into a 100ms one with no other change.

## Summary

- JavaScript is single-threaded; the event loop provides I/O concurrency by handing off blocking operations and running other code meanwhile.
- Promises represent a future value (pending/fulfilled/rejected); `async`/`await` is syntax sugar over them that reads like synchronous code.
- `Promise.all` runs independent operations concurrently, finishing in roughly the longest single duration instead of the sum.
- Microtasks (Promise callbacks) always fully drain before the next macrotask (`setTimeout`, I/O), regardless of a `0ms` delay.

## Key Terms

- **Event loop** — the mechanism that lets single-threaded JavaScript handle concurrent I/O by queuing callbacks to run once current work finishes.
- **Promise** — an object representing a value that will be available later, in one of three states: pending, fulfilled, or rejected.
- **Microtask** — a callback (Promise `.then`, `queueMicrotask`) that runs immediately after the current synchronous code, before any macrotask.
- **Macrotask** — a callback (`setTimeout`, I/O events) that runs only after the microtask queue is fully drained.

## Review Questions

1. Why does `Promise.all` typically finish faster than three sequential `await` calls?
2. Why does a `Promise.resolve().then(...)` callback always run before a `setTimeout(fn, 0)` callback?
3. What's the difference between `Promise.all` and `Promise.allSettled`?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **How does JavaScript achieve concurrency despite being single-threaded?**
   Blocking operations (network I/O, file access, timers) are handed off to the runtime (the browser's APIs, or Node's libuv thread pool) rather than executed inline; JavaScript's single thread keeps running other code in the meantime, and the operation's callback/Promise is queued to run once the current synchronous work — and the microtask queue — finishes. This is cooperative concurrency for I/O, not true parallel execution of JavaScript code itself.

2. **What's the difference between `Promise.all` and `Promise.allSettled`?**
   `Promise.all` resolves with an array of all results only if every Promise fulfills — if even one rejects, `Promise.all` immediately rejects with that reason, discarding any other results. `Promise.allSettled` always waits for every Promise to finish and resolves with a status object per Promise (`{status: "fulfilled", value}` or `{status: "rejected", reason}`), never short-circuiting on a single failure.

3. **Why does a microtask always run before a macrotask scheduled at the "same time"?**
   The event loop's specification-defined order is: run all synchronous code, then drain the entire microtask queue completely (even if new microtasks are added during draining), and only then process the next single macrotask. A `setTimeout(fn, 0)` callback is a macrotask, so it always waits behind the full microtask queue, regardless of its nominal `0ms` delay.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
