# Exercise 01 — An Overloaded `wrapInArray` Function

[Back to lesson](../README.md)

## Task

Write an overloaded function `wrapInArray` that:

- Given a single value of type `T` (not already an array), returns `T[]` containing just that value.
- Given an array `T[]`, returns it unchanged (still `T[]`).

Then write a plain (non-overloaded) function `describeCollection(label: string, items: unknown[]): string` returning `"{label}: {n} item(s)"`, and use both together to describe a wrapped single value and a wrapped array.

## Constraints

- Use two overload signatures plus one implementation signature, following this lesson's pattern.
- No `as` assertions in the solution.

## Starter Code

```ts
function wrapInArray<T>(value: T): T[];
function wrapInArray<T>(value: T[]): T[];
function wrapInArray<T>(value: T | T[]): T[] {
  // your implementation here
}

function describeCollection(label: string, items: unknown[]): string {
  return `${label}: ${items.length} item(s)`;
}

console.log(describeCollection("single", wrapInArray(42)));
console.log(describeCollection("already-array", wrapInArray([1, 2, 3])));
```

## Expected Output

```
single: 1 item(s)
already-array: 3 item(s)
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.ts](../Solutions/solution-01.ts).
