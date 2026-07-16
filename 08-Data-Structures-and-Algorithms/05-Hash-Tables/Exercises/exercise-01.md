# Exercise 01 — Detect the First Duplicate

[Back to lesson](../README.md)

## Task

Write a function `first_duplicate(items)` that takes a list and returns the **first value that appears more than once**, scanning left to right, using a hash-table-based approach (a Python `set` or `dict`) so the whole function runs in O(n) time. Return `None` if there are no duplicates.

```python
first_duplicate([3, 1, 4, 1, 5, 9, 2, 6])  # -> 1  (1 is the first value seen a second time)
first_duplicate([3, 1, 4, 5, 9, 2, 6])     # -> None (no duplicates at all)
first_duplicate([7, 7, 7])                 # -> 7
```

Hint: walk the list once, keeping a `set` of values seen so far. For each item, checking "have I seen this before?" against a set is O(1) average case — this is the entire reason the task is solvable in one O(n) pass instead of the O(n^2) approach of comparing every pair of elements.

## Reflection Questions

1. What would the time complexity be if you solved this with nested loops (comparing every pair of elements) instead of a set? Why is the set-based approach faster, given that hash table operations are also "just" average-case O(1) rather than guaranteed O(1)?
2. Why does a `set` (rather than a `list`) make the "have I seen this value before" check fast? What is happening internally when you write `value in seen_set`?
3. This function returns the first *repeated* value in scan order, not necessarily the value that appears the most times overall. Give an example list where those two things differ.

## Deliverable

A working `first_duplicate` function plus answers to the three reflection questions.
