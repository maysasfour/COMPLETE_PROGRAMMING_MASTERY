# Solution 01 — Kth Largest Element with a Size-Bounded Heap

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
kth_largest([3, 1, 5, 12, 2, 11], 2) -> 11 (expected 11)
kth_largest([3, 1, 5, 12, 2, 11], 1) -> 12 (expected 12)
kth_largest([3, 1, 5, 12, 2, 11], 4) -> 3 (expected 3)
kth_largest([1,2,3], 5) correctly raised: k=5 is out of range for a list of length 3
```

## Explanation

Every value is pushed onto a min-heap; whenever the heap grows past size `k`, the current minimum is popped off. After processing every value, the heap contains exactly the `k` largest values seen — and because it's a *min*-heap, the smallest among those `k` largest sits at the root, which is exactly the k-th largest value overall.

## Reflection Answers

1. **Time complexity and comparison to `sorted(values)[-k]`.** This approach is O(n log k): each of the `n` values does one push (O(log k), since the heap never grows past size k) and, once the heap is full, a paired pop (also O(log k)). `sorted(values)[-k]` is O(n log n) — it sorts the *entire* list regardless of how small `k` is. When `k` is small relative to `n` (e.g., "top 10 out of a million"), O(n log k) is meaningfully faster than O(n log n), since `log k` stays tiny while `log n` grows with the whole input.

2. **Why bounding the heap at size k guarantees the root is the k-th largest.** At every point where the heap has exactly `k` elements, those `k` elements are, by construction, the `k` largest values encountered *so far* (any value discarded via a pop was, at the moment it was discarded, smaller than all `k` values currently kept — a min-heap always discards its current minimum, never a larger value). Once every input value has been processed this way, the final `k` elements in the heap are the `k` largest values in the *entire* list, and the smallest among them (the heap's root) is, by definition, the k-th largest overall.

3. **Handling `k` larger than the list length.** This implementation raises a `ValueError` immediately rather than silently returning a wrong or partial answer — verified above with `kth_largest([1,2,3], 5)`. Silently returning `None` or the overall minimum would both be worse: they'd look like valid answers to a caller who passed an out-of-range `k` by mistake, rather than surfacing the mistake immediately.

## Common Pitfalls

- Using a **max**-heap instead of a min-heap for this problem — a max-heap would make it easy to find the single largest value repeatedly, but awkward to efficiently maintain "only the k largest so far" and read off the *smallest* of that group in O(1); a min-heap of bounded size k is the standard, more efficient shape for this specific problem.
- Forgetting to pop *before* checking the final answer — if the heap is allowed to grow unboundedly (never popped down to size k), the root becomes the overall minimum instead of the k-th largest.
- Not validating `k` against the input length — silently indexing or peeking into a heap smaller than expected would produce a confusing error deep inside heap internals rather than a clear, immediate message about the actual mistake (a bad `k` value).
