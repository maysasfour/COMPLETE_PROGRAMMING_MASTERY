# Exercise 01 — Kth Largest Element with a Size-Bounded Heap

[Back to lesson](../README.md)

## Task

Write a function `kth_largest(values, k)` that returns the `k`-th largest value in a list, using a **min-heap of size at most `k`** — not by sorting the whole list.

```python
kth_largest([3, 1, 5, 12, 2, 11], 2)  # -> 11  (the 2nd largest: 12, then 11)
kth_largest([3, 1, 5, 12, 2, 11], 1)  # -> 12  (the largest)
kth_largest([3, 1, 5, 12, 2, 11], 4)  # -> 3
```

## Hint

Push each value onto a min-heap. Whenever the heap's size exceeds `k`, pop the minimum off — this keeps the heap containing only the `k` *largest* values seen so far, with the smallest of *those* always sitting at the root. Once every value has been processed, the root of a size-`k` heap is exactly the k-th largest overall.

## Reflection Questions

1. What is the time complexity of this approach in terms of `n` (the list length) and `k`, and how does it compare to just calling `sorted(values)[-k]` for large `n` and small `k`?
2. Why does keeping the heap size bounded at exactly `k` (popping the minimum whenever it exceeds `k`) guarantee the root ends up being the k-th largest, rather than some other value?
3. What should happen if `k` is larger than the length of `values`? Does your implementation handle that case, and what's a reasonable behavior (an error, or a specific return value)?

## Deliverable

A working `kth_largest` function plus answers to the three reflection questions.
