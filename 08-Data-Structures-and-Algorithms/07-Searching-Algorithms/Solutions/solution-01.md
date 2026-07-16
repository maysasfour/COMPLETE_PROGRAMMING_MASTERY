# Solution 01 — Find the First and Last Position of a Target

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
find_range([5, 7, 7, 7, 8, 8, 10], 7) -> (1, 3)
find_range([5, 7, 7, 7, 8, 8, 10], 8) -> (4, 5)
find_range([5, 7, 7, 7, 8, 8, 10], 6) -> (-1, -1)
```

## Explanation

`find_range` runs `_search_bound` twice with a `find_first` flag that changes what happens *after* a match is found. Ordinary binary search returns the instant `items[mid] == target`; `_search_bound` instead records that index as the current best `result` and **keeps narrowing** — toward the left half (`high = mid - 1`) when hunting for the first occurrence, or toward the right half (`low = mid + 1`) when hunting for the last — so it keeps finding *earlier* (or *later*) matches until the range is exhausted, at which point the last recorded `result` is the true boundary.

## Reflection Answers

1. **Why plain binary search can't find the first occurrence directly.** `binary_search_iterative` returns as soon as it finds any index where `items[mid] == target` — with duplicates, `mid` could land on any one of several equal positions, and there's no guarantee it's the first. To find the first occurrence specifically, the narrowing logic needs to change: instead of stopping on a match, treat a match as "move `high` to `mid - 1` and keep looking to the left," because there might be an *earlier* occurrence still in that left range. The search only truly stops when `low > high`, and the last recorded match is the answer.

2. **Overall complexity.** Each of the two searches (`find_first=True` and `find_first=False`) is independently O(log n), since each still halves its search range every step, exactly like ordinary binary search — the only change is *what happens on a match*, not the fundamental halving. Running two O(log n) searches back to back is `O(log n) + O(log n) = O(2 log n)`, and Big O notation drops constant factors, so this simplifies to O(log n) overall — the same complexity class as a single binary search, not double it.

3. **Why sorted input is still required, and what breaks without it.** The narrowing decision (`items[mid] < target -> search right`, `items[mid] > target -> search left`) is only valid if everything left of `mid` is guaranteed smaller and everything right is guaranteed larger — exactly the same precondition as ordinary binary search, applied twice here. If `[5, 7, 7, 7, 8, 8, 10]`'s 7s and 8s were scattered out of order (say, `[5, 8, 7, 7, 8, 7, 10]`), the algorithm might narrow toward a half that doesn't actually contain all the remaining occurrences — for example, landing on a `7` and deciding to search only left for more 7s, while an out-of-order 7 sitting to the right gets skipped entirely, producing a wrong or incomplete range silently, with no error raised.

## Common Pitfalls

- Forgetting to keep searching after a match is found — this collapses the "find boundary" search back into ordinary binary search, which only finds *one* arbitrary occurrence, not the first/last.
- Returning `mid` immediately instead of updating `result` and continuing — loses the "keep looking for a better match" behavior entirely.
- Not short-circuiting to `(-1, -1)` when the first search fails — running the second (last-occurrence) search on a target that isn't present at all is wasted work, though not incorrect, since it would also correctly return -1.
