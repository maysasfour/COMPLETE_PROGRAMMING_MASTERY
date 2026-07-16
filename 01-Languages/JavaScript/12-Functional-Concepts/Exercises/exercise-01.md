# Exercise 01 — A `memoize` Higher-Order Function

[Back to lesson](../README.md)

## Task

Write a higher-order function `memoize(fn)` that returns a new function caching `fn`'s results by argument, so repeated calls with the same arguments skip recomputation. Also make the returned function expose how many times the underlying `fn` was actually invoked (not counting cache hits), via a property `.callCount` on the memoized function.

## Constraints

- Assume `fn` takes any number of arguments that are all JSON-serializable (numbers, strings, booleans, plain objects/arrays) — use `JSON.stringify(args)` as the cache key.
- `.callCount` must only increment on an actual (non-cached) call to the underlying function.
- Use a `Map` for the cache, per Lesson 07's guidance on keyed collections.

## Starter Code

```js
function memoize(fn) {
  const cache = new Map();
  function memoized(...args) {
    // check cache, else call fn and store, tracking callCount
  }
  memoized.callCount = 0;
  return memoized;
}

function slowSquare(n) {
  for (let i = 0; i < 1e6; i++) {} // pretend this is expensive
  return n * n;
}

const fastSquare = memoize(slowSquare);
console.log(fastSquare(5)); // computed
console.log(fastSquare(5)); // cached
console.log(fastSquare.callCount); // 1
```

## Expected Output

```
25
25
1
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
