# Exercise 01 — Find the First and Last Position of a Target

[Back to lesson](../README.md)

## Task

Given a **sorted** list that may contain duplicate values, write a function `find_range(items, target)` that returns a tuple `(first_index, last_index)` giving the first and last position of `target` in the list, using binary search (not linear scanning) so the whole thing stays O(log n) rather than O(n). Return `(-1, -1)` if `target` isn't present.

```python
find_range([5, 7, 7, 7, 8, 8, 10], 7)   # -> (1, 3)
find_range([5, 7, 7, 7, 8, 8, 10], 8)   # -> (4, 5)
find_range([5, 7, 7, 7, 8, 8, 10], 6)   # -> (-1, -1)
```

Hint: a single binary search that stops the moment it finds *a* match only tells you *one* position where the target exists, not the boundary. Instead, run two separate, slightly modified binary searches: one biased to keep searching left even after finding a match (to find the first occurrence), and one biased to keep searching right even after finding a match (to find the last occurrence). Each is still O(log n), so two of them together are still O(log n) overall (constants drop out of Big O).

## Reflection Questions

1. Why doesn't a plain binary search (like `binary_search_iterative` in `implementation.py`) reliably find the *first* occurrence of a duplicated target on its own? What would need to change about its narrowing logic?
2. What is the overall time complexity of `find_range`, given that it runs two binary searches instead of one? Explain why this doesn't push it into a different Big O class than a single binary search.
3. Why does this technique require the input to be sorted, same as ordinary binary search? What would go wrong on unsorted input, concretely, for the `[5, 7, 7, 7, 8, 8, 10]` example if the 7s and 8s were scattered out of order?

## Deliverable

A working `find_range` function plus answers to the three reflection questions.
