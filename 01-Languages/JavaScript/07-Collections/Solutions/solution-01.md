# Solution 01 — Word Frequency Counter

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `text.toLowerCase().replace(/[.,!?]/g, "")` normalizes case and strips punctuation before splitting, so `"Cats,"` and `"cats"` count as the same word.
- `.split(/\s+/).filter(Boolean)` splits on any run of whitespace and drops empty strings that can appear from double spaces or leading/trailing whitespace.
- `counts.set(word, (counts.get(word) ?? 0) + 1)` uses `??`, not `||`, deliberately — a word seen once already has a count of `1`, which is truthy either way, but `??` is the philosophically correct operator here since `0` (not yet seen) is a legitimate starting value, not something to "correct."
- `topN` converts the `Map` to an array of `[word, count]` pairs via `Array.from(map.entries())`, sorts by count descending with an alphabetical tie-break, then `.slice(0, n)` takes the top results — exactly as the exercise's constraints required.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
[ [ 'cats', 3 ], [ 'dogs', 2 ] ]
Full frequency map: Map(4) { 'cats' => 3, 'and' => 1, 'dogs' => 2, 'love' => 1 }
```

Matches the exercise's expected output exactly, and the full frequency map confirms `"cats"` was correctly counted 3 times across `"Cats,"`, `"cats,"`, and `"cats!"`.
