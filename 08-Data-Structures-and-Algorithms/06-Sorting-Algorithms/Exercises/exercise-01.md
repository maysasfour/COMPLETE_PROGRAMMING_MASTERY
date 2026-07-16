# Exercise 01 — Count Inversions While Sorting

[Back to lesson](../README.md)

## Task

An **inversion** in a list is a pair of indices `(i, j)` where `i < j` but `arr[i] > arr[j]` — a pair that's "out of order" relative to each other. The number of inversions is a common measure of "how unsorted" a list is (a sorted list has 0 inversions; a reverse-sorted list has the maximum possible).

Write a function `count_inversions(items)` that returns the total number of inversions in the list, **using a modified merge sort** so the whole thing runs in O(n log n) rather than the O(n^2) of checking every pair directly.

```python
count_inversions([1, 2, 3, 4, 5])  # -> 0  (already sorted)
count_inversions([5, 4, 3, 2, 1])  # -> 10 (every pair is inverted: 5*4/2 = 10)
count_inversions([2, 4, 1, 3, 5])  # -> 3  (pairs: (2,1), (4,1), (4,3))
```

Hint: reuse the structure of `merge_sort` from `implementation.py`. The key insight is in the merge step: whenever you take an element from the **right** half instead of the left half (because it's smaller), every *remaining* element in the left half is now known to form an inversion with it — count all of them at once (`len(left) - i`) rather than checking pairs individually. This is exactly why this technique reaches O(n log n) instead of O(n^2): it counts a whole batch of inversions in O(1) at each step of an already-necessary merge, rather than making a separate pass to check every pair.

## Reflection Questions

1. Why does taking an element from the right half during merge mean *all* remaining left-half elements form an inversion with it? Walk through why this is guaranteed given that both halves are already individually sorted before this merge step runs.
2. What is the time and space complexity of this approach, and how does it compare to checking every `(i, j)` pair directly with nested loops?
3. `count_inversions([5, 4, 3, 2, 1])` should return 10. Manually list all 10 inverted pairs to confirm this by brute force, then explain how your merge-based counting arrives at the same total without ever listing individual pairs.

## Deliverable

A working `count_inversions` function plus answers to the three reflection questions.
