# Solution 01 — Detect the First Duplicate

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
first_duplicate([3, 1, 4, 1, 5, 9, 2, 6]) -> 1
first_duplicate([3, 1, 4, 5, 9, 2, 6]) -> None
first_duplicate([7, 7, 7]) -> 7
```

## Explanation

`first_duplicate` keeps a `set` of every value seen so far while scanning the list once, left to right. For each new item, it checks whether that item is already in `seen` — if so, that item is the first repeated value, and the function returns immediately. Otherwise, the item is added to `seen` and the scan continues. Because set membership testing and insertion are both average-case O(1), the whole scan is O(n) overall.

## Reflection Answers

1. **Nested-loop complexity vs. the set-based approach.** Comparing every pair of elements (for each item, scan all later items looking for a match) is O(n^2) — for each of the n items, up to n comparisons. The set-based approach is O(n) *on average* because each `in` check and each `add` is average-case O(1), not because hash tables are magically faster in every case — it's that O(1)-average work done n times (O(n) total) beats O(n)-work done n times (O(n^2) total), even though both individual operations only have average-case guarantees, not worst-case ones.

2. **Why `set` beats `list` for membership testing.** `value in some_list` has to scan the list from the start until it finds a match or reaches the end — O(n) per check. `value in some_set` computes `hash(value)`, jumps to the corresponding bucket, and only needs to check the (usually very short) chain of items that happen to share that bucket — average-case O(1) per check, exactly the mechanism built from scratch in this lesson's `HashTable`.

3. **First-repeated vs. most-frequent can differ.** Example: `[1, 1, 2, 2, 2, 2, 2]`. The first value seen a second time is `1` (it repeats at index 1), even though `2` appears far more often overall (five times vs. two). `first_duplicate` answers "what repeated first," not "what repeated most" — a different question entirely, and one that would require counting occurrences of every value rather than stopping at the first repeat.

## Common Pitfalls

- Using a `list` instead of a `set` for `seen` — it still works correctly, but silently downgrades the whole function from O(n) to O(n^2), since each `in` check against a list is itself O(n).
- Forgetting to check `if item in seen` *before* calling `seen.add(item)` — adding first would make every item immediately "already seen," breaking the logic entirely.
- Confusing "first duplicate encountered during the scan" with "value with the highest total count" — see reflection question 3.
