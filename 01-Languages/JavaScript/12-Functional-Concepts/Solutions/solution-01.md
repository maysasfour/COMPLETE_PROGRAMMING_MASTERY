# Solution 01 — A `memoize` Higher-Order Function

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `JSON.stringify(args)` turns the full argument list into a single deterministic string key — `memoize` doesn't need to know how many arguments `fn` takes or what types they are, as long as they're JSON-serializable, matching the exercise's stated constraint.
- `memoized.callCount` is a property attached directly to the returned function object (functions are objects in JavaScript, so they can carry extra properties) — it's incremented only inside the "not found in cache" branch, so cache hits never touch it.
- The cache itself (`cache`) lives in the closure created by `memoize(fn)`, exactly like Lesson 06's counter example — each call to `memoize(...)` produces an entirely independent cache and `callCount`.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
25
25
1

--- confirming a different argument triggers a real call ---
36
2
```

The first three lines match the exercise's expected output exactly. The additional check (calling with `6` instead of `5`) confirms `callCount` correctly increments to `2` on a genuinely new argument, ruling out a bug where the cache key ignores the actual argument value.
