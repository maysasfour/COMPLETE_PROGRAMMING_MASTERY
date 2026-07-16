# Exercise 01 — Word Frequency with Streams

[Back to lesson](../README.md)

## Task

Write `Map<String, Long> wordFrequency(String text)` that lowercases and strips basic punctuation, splits into words, and returns a frequency map using `Collectors.groupingBy`/`Collectors.counting()`. Then write `List<Map.Entry<String, Long>> topN(Map<String, Long> freq, int n)` returning the `n` most frequent entries (ties broken alphabetically) using a Stream pipeline with `.sorted()`/`.limit()`.

## Constraints

- Use Streams for both methods — no manual loops for the counting or ranking logic.
- `"Cats, cats, and dogs. Dogs love cats!"` should count `"cats"` as 3.

## Starter Code

```java
Map<String, Long> wordFrequency(String text) {
    String cleaned = text.toLowerCase().replaceAll("[.,!?]", "");
    return Arrays.stream(cleaned.split("\\s+"))
        .collect(Collectors.groupingBy(w -> w, Collectors.counting()));
}

List<Map.Entry<String, Long>> topN(Map<String, Long> freq, int n) {
    return freq.entrySet().stream()
        .sorted(Map.Entry.<String, Long>comparingByValue().reversed()
            .thenComparing(Map.Entry.comparingByKey()))
        .limit(n)
        .collect(Collectors.toList());
}
```

## Expected Output

```
cats=3
dogs=2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/Solution01.java](../Solutions/Solution01.java).
