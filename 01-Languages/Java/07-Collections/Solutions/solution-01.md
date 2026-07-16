# Solution 01 — Word Frequency with Streams

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `Collectors.groupingBy(w -> w, Collectors.counting())` is a two-level collector: it groups stream elements by the identity function (the word itself) and, within each group, counts occurrences — a one-line replacement for a manual "increment or initialize a counter in a map" loop.
- `Map.Entry.<String, Long>comparingByValue().reversed().thenComparing(Map.Entry.comparingByKey())` composes a `Comparator`: sort by value (count) descending first, then by key (word) ascending as a tie-break — directly mirroring the `sort((a,b) => b[1]-a[1] || a[0].localeCompare(b[0]))` pattern from the JavaScript course's equivalent exercise, just expressed via `Comparator` composition.

## Verification

Ran with `java Solutions/Solution01.java`; actual output:

```
cats=3
dogs=2
```

Matches the exercise's expected output exactly.
