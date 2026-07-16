# Exercise 01 — Word Frequency with LINQ

[Back to lesson](../README.md)

## Task

Write a method `Dictionary<string, int> WordFrequency(string text)` that lowercases and strips basic punctuation (`.`, `,`, `!`, `?`) from `text`, splits it into words, and returns a dictionary mapping each word to its count. Then write `List<KeyValuePair<string,int>> TopN(Dictionary<string,int> freq, int n)` returning the `n` most frequent words (ties broken alphabetically), using LINQ's `OrderByDescending`/`ThenBy`/`Take`.

## Constraints

- Use LINQ for `TopN` — no manual sorting loops.
- `"Cats, cats, and dogs. Dogs love cats!"` should count `"cats"` as 3.

## Starter Code

```csharp
Dictionary<string, int> WordFrequency(string text) {
    // clean, split, count
}

List<KeyValuePair<string, int>> TopN(Dictionary<string, int> freq, int n) {
    return freq
        .OrderByDescending(kv => kv.Value)
        .ThenBy(kv => kv.Key)
        .Take(n)
        .ToList();
}
```

## Expected Output

```
cats: 3
dogs: 2
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cs](../Solutions/solution-01.cs).
