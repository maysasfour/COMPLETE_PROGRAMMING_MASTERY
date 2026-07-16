// solution-01.js - memoize higher-order function with a Map cache and callCount tracking.

function memoize(fn) {
  const cache = new Map();

  function memoized(...args) {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      return cache.get(key);
    }
    const result = fn(...args);
    cache.set(key, result);
    memoized.callCount += 1;
    return result;
  }

  memoized.callCount = 0;
  return memoized;
}

function slowSquare(n) {
  for (let i = 0; i < 1e6; i++) {} // pretend this is expensive
  return n * n;
}

const fastSquare = memoize(slowSquare);
console.log(fastSquare(5));          // computed -- callCount becomes 1
console.log(fastSquare(5));          // cached -- callCount stays 1
console.log(fastSquare.callCount);

console.log("\n--- confirming a different argument triggers a real call ---");
console.log(fastSquare(6));          // computed -- callCount becomes 2
console.log(fastSquare.callCount);
