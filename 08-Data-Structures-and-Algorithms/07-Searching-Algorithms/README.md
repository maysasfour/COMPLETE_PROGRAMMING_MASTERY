# 07 — Searching Algorithms

[Back to module overview](../README.md) | [Previous: Sorting Algorithms](../06-Sorting-Algorithms/README.md)

## Beginner: The Two Ways to Look for a Value

Searching means finding whether (and where) a target value exists in a collection. There are two fundamentally different strategies, and which one you can use depends entirely on one fact: **is the data sorted?**

- **Linear search** checks every element in order, one at a time, until it finds a match or runs out of elements. It works on *any* list, sorted or not — no assumptions required.
- **Binary search** repeatedly checks the middle element of the current range and, based on whether the target is smaller or larger, discards *half* the remaining range each time. It only works on **sorted** data — the entire technique depends on being able to say "everything to the left of mid is smaller, everything to the right is larger," which is only true if the data is already in order.

`implementation.py` implements all three: `linear_search`, `binary_search_iterative`, and `binary_search_recursive`, each counting its own comparisons so the numbers below come from an actual run.

## Complexity Comparison

| Algorithm | Best Case | Average Case | Worst Case | Space | Requires Sorted Input? |
|---|---|---|---|---|---|
| Linear Search | O(1) (target is first element) | O(n) | O(n) (target is last, or absent) | O(1) | No |
| Binary Search (iterative) | O(1) (target is the first mid checked) | O(log n) | O(log n) | O(1) | Yes |
| Binary Search (recursive) | O(1) | O(log n) | O(log n) | O(log n) (call stack) | Yes |

The recursive version has the same time complexity as the iterative version, but pays an O(log n) **space** cost the iterative version doesn't — each recursive call adds a frame to the call stack, and the number of frames scales with how many times the range gets halved (log n times).

## Intermediate: Verified Trace on `[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]`, target = 13

### Linear Search — 7 comparisons

```
index 0: 1  == 13? no
index 1: 3  == 13? no
index 2: 5  == 13? no
index 3: 7  == 13? no
index 4: 9  == 13? no
index 5: 11 == 13? no
index 6: 13 == 13? yes -> return index 6
Total: 7 comparisons
```

Linear search costs one comparison per element checked — finding index 6 out of a 10-element list costs 7 comparisons (indices 0 through 6), regardless of the fact that the data happens to be sorted; linear search never uses that fact.

### Binary Search (iterative) — 4 comparisons

```
low=0, high=9: mid=4, items[4]=9.  9 == 13? no. 9 < 13 -> discard left half, low=5
low=5, high=9: mid=7, items[7]=15. 15 == 13? no. 15 > 13 -> discard right half, high=6
low=5, high=6: mid=5, items[5]=11. 11 == 13? no. 11 < 13 -> discard left half, low=6
low=6, high=6: mid=6, items[6]=13. 13 == 13? yes -> return index 6
Total: 4 comparisons
```

Each comparison eliminates roughly half of whatever range remained — starting from 10 elements, the range shrinks 10 -> 5 -> 2 -> 1, needing only 4 comparisons instead of linear search's 7. `binary_search_recursive` performs the identical sequence of comparisons (4) for the same target, since it implements the exact same halving logic, just expressed as recursive calls with narrowed `low`/`high` bounds instead of a loop that mutates them.

## Advanced: Why the Gap Widens as Input Grows

The real payoff of O(log n) over O(n) isn't visible on a 10-element list — it becomes dramatic as `n` grows, because `log n` grows so much slower than `n`. Searching for an absent value (the worst case for both algorithms) in progressively larger already-sorted ranges, executed and verified:

```
n=    10: linear_search comparisons=    10, binary_search_iterative comparisons=3
n=   100: linear_search comparisons=   100, binary_search_iterative comparisons=6
n=  1000: linear_search comparisons=  1000, binary_search_iterative comparisons=9
n= 10000: linear_search comparisons= 10000, binary_search_iterative comparisons=13
```

Linear search's comparison count grows in exact lockstep with `n` (10x the input means 10x the comparisons). Binary search's comparison count grows by only a few more comparisons each time `n` grows by 10x, because each additional comparison doubles the amount of data it can rule out — this is the concrete, measured meaning of "O(log n)."

The cost of this speed: binary search requires sorted input. If the data isn't already sorted, you must sort it first (Lesson 06 — O(n log n) at best), which only pays off if you're going to search the *same* sorted data multiple times; sorting once just to do a single search is strictly worse than a single O(n) linear search.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/07-Searching-Algorithms
python implementation.py
```

## Verified Output

```
Sorted data: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

=== linear_search ===
linear_search(data, 13) -> index=6, comparisons=7
linear_search(data, 2) -> index=None, comparisons=10

=== binary_search_iterative ===
binary_search_iterative(data, 13) -> index=6, comparisons=4
binary_search_iterative(data, 2) -> index=None, comparisons=3

=== binary_search_recursive ===
binary_search_recursive(data, 13) -> index=6, comparisons=4
binary_search_recursive(data, 2) -> index=None, comparisons=3

=== Worst case scaling: searching for an absent value in larger lists ===
n=    10: linear_search comparisons=    10, binary_search_iterative comparisons=3
n=   100: linear_search comparisons=   100, binary_search_iterative comparisons=6
n=  1000: linear_search comparisons=  1000, binary_search_iterative comparisons=9
n= 10000: linear_search comparisons= 10000, binary_search_iterative comparisons=13
```

## Summary

- Linear search checks every element in order; it works on unsorted data but costs O(n) in the average/worst case.
- Binary search repeatedly halves the search range by comparing against the middle element; it costs only O(log n), but requires the data to already be sorted.
- The recursive and iterative binary search implementations do the identical number of comparisons (same algorithm, different expression) — the only real difference is that recursion adds O(log n) call-stack space, while the loop-based version uses O(1) space.
- The advantage of O(log n) over O(n) is invisible on tiny input and enormous on large input — this is a general pattern with Big O comparisons, not specific to searching.

## Key Terms

- **Search space** — the range of the collection still being considered; binary search's core trick is shrinking this range by half on every comparison.
- **Midpoint** — the element at the center of the current search space, `(low + high) // 2`; what binary search compares the target against on every step.
- **Monotonic / sorted precondition** — the requirement that data be in sorted order before binary search can be applied correctly; violating this silently produces wrong results rather than an error.
- **Tail-recursive** — a recursive function (like `binary_search_recursive`) whose recursive call is the very last action taken; Python does not optimize this away (no tail-call elimination), so it still consumes real stack frames, unlike some other languages.

## Common Mistakes

- Running binary search on unsorted data — it won't raise an error, it will just silently return wrong results (or fail to find a value that's actually present), because the halving logic's core assumption (sorted order) is violated.
- Computing the midpoint as `(low + high) / 2` and forgetting integer division — in Python this matters less due to `//`, but in languages with fixed-width integers, `low + high` can even overflow for very large indices; the safer general formula is `low + (high - low) // 2`.
- Off-by-one errors in the `low`/`high` boundary updates — using `mid` instead of `mid + 1`/`mid - 1` when narrowing the range can cause an infinite loop (the range never shrinks) or skip checking the midpoint element itself.
- Assuming binary search is always better — for a very small list, or a list that will only ever be searched once, the O(n log n) cost of sorting first (if not already sorted) makes a single O(n) linear search cheaper overall.

## Interview Questions

1. **Why does binary search require sorted input, but linear search doesn't?**
   Binary search's core operation — discarding half the remaining range based on one comparison against the midpoint — is only valid if everything on one side of the midpoint is guaranteed smaller and everything on the other side is guaranteed larger. That guarantee only holds if the data is sorted. Linear search makes no such assumption; it simply checks every element, so order is irrelevant to its correctness (only to its early-exit possibilities).

2. **What is the time complexity of binary search, and why?**
   O(log n). Each comparison eliminates half of the remaining search space, so the number of comparisons needed is the number of times n can be halved before reaching 1 — which is, by definition, log base 2 of n.

3. **What's the practical difference between iterative and recursive binary search, given they do the same number of comparisons?**
   Space complexity. The iterative version uses a fixed number of variables (`low`, `high`, `mid`) regardless of how many halvings occur — O(1) space. The recursive version creates a new stack frame for each recursive call, and since the recursion depth is O(log n) (one call per halving), it uses O(log n) space — more than the iterative version, though still far less than linear search's data size.

4. **When would you choose linear search over binary search even though binary search is asymptotically faster?**
   When the data isn't sorted and won't be reused — sorting purely to enable one binary search costs O(n log n) up front, which is worse than a single O(n) linear search. Also when the collection is a data structure without efficient random access to an arbitrary middle element (e.g., a plain singly linked list, from Lesson 03) — binary search needs O(1) access to `items[mid]`, which arrays provide but linked lists do not.

5. **Trace binary search's comparisons searching for a value NOT in a 10-element sorted list, and explain why the worst case is O(log n) rather than O(1).**
   As shown above, searching a 10-element list for an absent value (`2`) takes exactly 3 comparisons — the range narrows 10 -> ~5 -> ~2 -> 1 before being recognized as empty (`low > high`). It's not O(1) because you can't know a value is absent without narrowing the range all the way down; but it's O(log n), not O(n), because every comparison still discards half of whatever range remained, even when the answer is ultimately "not found."

## Suggested Next Lesson

[08 — Recursion](../08-Recursion/README.md)
