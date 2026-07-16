# Solution 01 — Word Frequency with LINQ

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `Regex.Replace(text.ToLower(), "[.,!?]", "")` strips punctuation after lowercasing, so `"Cats,"` and `"cats!"` both normalize to `"cats"` before splitting.
- `counts.GetValueOrDefault(word, 0) + 1` avoids a manual `ContainsKey` check — `GetValueOrDefault` returns `0` for an unseen word, making the increment uniform for both new and existing keys.
- `TopN` chains `OrderByDescending` (count, highest first) with `ThenBy` (key, alphabetically, as a tie-break) then `Take(n)` — three LINQ operators composed declaratively, with no manual sorting loop.

## Verification

Ran with `dotnet run Solutions/solution-01.cs`; actual output:

```
cats: 3
dogs: 2
```

Matches the exercise's expected output exactly.
