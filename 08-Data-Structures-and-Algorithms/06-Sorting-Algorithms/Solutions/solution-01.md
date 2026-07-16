# Solution 01 — Count Inversions While Sorting

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
count_inversions([1, 2, 3, 4, 5]) -> 0 (brute force check: 0)
count_inversions([5, 4, 3, 2, 1]) -> 10 (brute force check: 10)
count_inversions([2, 4, 1, 3, 5]) -> 3 (brute force check: 3)
```

## Explanation

`_sort_and_count` mirrors `merge_sort`'s recursive split exactly, but each level also returns an inversion count: the total inversions in a list equal the inversions entirely within the left half, plus entirely within the right half, plus inversions that span across the two halves — and that last category is exactly what gets counted during the merge step. Because both halves are already sorted by the time they're merged, the moment an element is pulled from the right half ahead of the current left element, every left element from the current position onward is guaranteed larger than it too (the left half is sorted, so if `left[i] > right[j]`, then `left[i+1], left[i+2], ...` are all `>= left[i] > right[j]`) — so all of those pairs can be counted in one O(1) addition (`len(left) - i`) instead of individually.

## Reflection Answers

1. **Why taking from the right half implies a batch of inversions.** Both `left` and `right` arrive at the merge step already sorted (guaranteed by recursion having fully processed them first). If the algorithm is currently comparing `left[i]` against `right[j]` and chooses `right[j]` because it's smaller, that means `left[i] > right[j]`. Since `left` is sorted ascending, every element from `left[i]` to the end of `left` is `>= left[i]`, and therefore also `> right[j]`. Each of those elements paired with `right[j]` is an inversion (an earlier, larger element before a later, smaller one) — and there are exactly `len(left) - i` of them remaining.

2. **Complexity comparison.** The merge-based approach is O(n log n) time (same recursive structure as merge sort: O(log n) levels, O(n) work merging at each level) and O(n) space (same temporary merge buffers as merge sort). Checking every `(i, j)` pair directly with nested loops is O(n^2) time and O(1) extra space. For large inputs the O(n log n) approach is dramatically faster (e.g., n=1,000,000 makes the nested-loop approach roughly 50,000x more comparisons than the merge-based one), at the cost of the same O(n) auxiliary space merge sort already requires.

3. **Manual inversion list for `[5, 4, 3, 2, 1]`.** Every pair is inverted here since the list is in strictly decreasing order: (5,4), (5,3), (5,2), (5,1), (4,3), (4,2), (4,1), (3,2), (3,1), (2,1) — 10 pairs total, matching `n*(n-1)/2 = 5*4/2 = 10` (the maximum possible for 5 elements). The merge-based count arrives at 10 without ever listing a pair explicitly: at each merge, every time a right-half element is taken before the left half is exhausted, the *entire remaining left half* is credited as inverted with it in one addition — batching what the brute-force method does one comparison at a time into a handful of O(1) additions across the recursion.

## Common Pitfalls

- Counting inversions only when elements are strictly compared in the wrong merge step (e.g., using `<` instead of `<=` when deciding which side to take from) — this changes correctness on lists with duplicate values, since a tie (`left[i] == right[j]`) should not count as an inversion (the definition requires `arr[i] > arr[j]`, strictly).
- Trying to count inversions during the split phase instead of the merge phase — the split itself creates no information about cross-half ordering; the count only becomes derivable once both halves are sorted and being merged together.
- Recomputing brute-force inversions inside the fast function "just to check" during real use — that reintroduces the O(n^2) cost the whole exercise exists to avoid; brute force belongs only in a test/cross-check function, as done here.
