# Exercise 01 — Word Frequency Counter

[Back to lesson](../README.md)

## Task

Write a function `wordFrequency(text)` that takes a sentence and returns a `Map` where each key is a lowercase word and each value is how many times it appears. Then write `topN(frequencyMap, n)` that returns an array of `[word, count]` pairs for the `n` most frequent words, sorted highest-count first (ties broken alphabetically).

## Constraints

- `wordFrequency` must lowercase words and strip basic punctuation (`.`, `,`, `!`, `?`) before counting — `"Cats, cats, and dogs."` should count `"cats"` as 2.
- Use a `Map`, not a plain object, to store counts.
- `topN` must use `Array.from(map.entries())` (or equivalent) plus `.sort()` and `.slice()` — no manual loops for the ranking logic.

## Starter Code

```js
function wordFrequency(text) {
  const counts = new Map();
  // split, clean, and count here
  return counts;
}

function topN(frequencyMap, n) {
  // convert to array, sort, slice
}

const freq = wordFrequency("Cats, cats, and dogs. Dogs love cats!");
console.log(topN(freq, 2));
```

## Expected Output

```
[ [ 'cats', 3 ], [ 'dogs', 2 ] ]
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
