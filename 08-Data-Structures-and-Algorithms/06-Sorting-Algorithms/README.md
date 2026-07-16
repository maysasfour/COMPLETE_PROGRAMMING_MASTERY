# 06 — Sorting Algorithms

[Back to module overview](../README.md) | [Previous: Hash Tables](../05-Hash-Tables/README.md)

## Beginner: What Sorting Algorithms Are and Why There Are So Many

Sorting means rearranging a collection into order (ascending, by convention, unless stated otherwise). Python's built-in `sorted()` and `list.sort()` already do this — so why learn five different ways to do it by hand? Because the *differences between them* (comparisons made, memory used, behavior on already-sorted or reverse-sorted input) are exactly what interviewers probe, and exactly what determines which one to reach for outside an interview. `implementation.py` implements all five and counts their comparisons and swaps/shifts, so this README's dry-run below quotes numbers from an actual run, not a generic textbook estimate.

All five functions sort this same input for direct comparison: `[5, 2, 9, 1, 5, 6]`.

## Complexity Table

| Algorithm | Best Case | Average Case | Worst Case | Space | Stable? |
|---|---|---|---|---|---|
| Bubble Sort | O(n) (already sorted, early exit) | O(n^2) | O(n^2) | O(1) | Yes |
| Selection Sort | O(n^2) | O(n^2) | O(n^2) | O(1) | No |
| Insertion Sort | O(n) (already sorted) | O(n^2) | O(n^2) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n^2) (bad pivot choices) | O(log n) (recursion stack) | No |

**Stable** means equal elements keep their original relative order after sorting — this matters when sorting by one field but needing ties broken by original order (e.g., sorting people by last name, wanting same-last-name people to stay in their original first-name order).

## Intermediate: Verified Dry-Run on `[5, 2, 9, 1, 5, 6]`

### Bubble Sort — 14 comparisons, 6 swaps

Bubble sort repeatedly walks the array, swapping any adjacent out-of-order pair, so the largest unsorted value "bubbles" to the end each pass:

```
Start:  [5, 2, 9, 1, 5, 6]
Pass 0: (5,2)swap (5,9)no (9,1)swap (9,5)swap (9,6)swap -> [2, 5, 1, 5, 6, 9]   (5 cmp, 4 swaps)
Pass 1: (2,5)no (5,1)swap (5,5)no (5,6)no             -> [2, 1, 5, 5, 6, 9]   (4 cmp, 1 swap)
Pass 2: (2,1)swap (2,5)no (5,5)no                     -> [1, 2, 5, 5, 6, 9]   (3 cmp, 1 swap)
Pass 3: (1,2)no (2,5)no                                -> [1, 2, 5, 5, 6, 9]   (2 cmp, 0 swaps) -> no swaps this pass, exit early
Total: 5+4+3+2 = 14 comparisons, 4+1+1+0 = 6 swaps
```

Note the pass length shrinks by one each time (`n - 1 - pass_number`) — `9` reaching the end after pass 0 means it's in its final position and never needs re-checking. Pass 3 makes zero swaps, which is the early-exit condition firing — on this particular input the list actually finished sorting after pass 2's work, but the algorithm only *discovers* that by running one more all-comparisons-no-swaps pass.

### Selection Sort — 15 comparisons, 4 swaps

Selection sort finds the minimum of the remaining unsorted region and swaps it to the front of that region — at most one swap per outer iteration, no matter how unsorted the remainder is:

```
Start: [5, 2, 9, 1, 5, 6]
i=0: scan j=1..5 against arr[min_index] (starts at arr[0]=5): 2<5 -> min_index=1; 9<2? no; 1<2 -> min_index=3; 5<1? no; 6<1? no.  (5 cmp)
     min_index=3 (value 1) != i=0 -> swap arr[0],arr[3] -> [1, 2, 9, 5, 5, 6]                                            (1 swap)
i=1: scan j=2..5 against arr[1]=2: 9<2? no; 5<2? no; 5<2? no; 6<2? no.  (4 cmp)
     min_index stays 1 == i -> no swap
i=2: scan j=3..5 against arr[2]=9: 5<9 -> min_index=3; 5<5? no; 6<5? no.  (3 cmp)
     min_index=3 (value 5) != i=2 -> swap arr[2],arr[3] -> [1, 2, 5, 9, 5, 6]                                            (1 swap)
i=3: scan j=4..5 against arr[3]=9: 5<9 -> min_index=4; 6<5? no.  (2 cmp)
     min_index=4 (value 5) != i=3 -> swap arr[3],arr[4] -> [1, 2, 5, 5, 9, 6]                                            (1 swap)
i=4: scan j=5 against arr[4]=9: 6<9 -> min_index=5.  (1 cmp)
     min_index=5 (value 6) != i=4 -> swap arr[4],arr[5] -> [1, 2, 5, 5, 6, 9]                                            (1 swap)
Total: 5+4+3+2+1 = 15 comparisons, 4 swaps
```

This matches the executed 15 comparisons and 4 swaps exactly. The key structural fact: selection sort makes **at most n-1 swaps total** (one per outer iteration, only when a smaller element was found), which is why its swap count (4) is so much lower than bubble sort's (6) despite doing *more* comparisons (15 vs 14) — selection sort pays its cost in comparisons (it always fully scans the remainder, regardless of how sorted it already is), not swaps.

### Insertion Sort — 9 comparisons, 6 shifts

Insertion sort builds a sorted prefix, inserting each new element by shifting larger already-sorted elements one slot right:

```
Start: [5, 2, 9, 1, 5, 6]
i=1: key=2. Compare with arr[0]=5: 5>2, shift -> [5,5,9,1,5,6], j=-1, stop (loop boundary). Place key at arr[0] -> [2,5,9,1,5,6]  (1 cmp, 1 shift)
i=2: key=9. Compare with arr[1]=5: 5>9? No, stop immediately. Place key at arr[2] (no-op, already there) -> [2,5,9,1,5,6]  (1 cmp, 0 shifts)
i=3: key=1. Compare arr[2]=9>1 shift, arr[1]=5>1 shift, arr[0]=2>1 shift, j=-1 stop. Place key at arr[0] -> [1,2,5,9,5,6]  (3 cmp, 3 shifts)
i=4: key=5. Compare arr[3]=9>5 shift, arr[2]=5>5? No, stop. Place key at arr[3] -> [1,2,5,5,9,6]  (2 cmp, 1 shift)
i=5: key=6. Compare arr[4]=9>6 shift, arr[3]=5>6? No, stop. Place key at arr[4] -> [1,2,5,5,6,9]  (2 cmp, 1 shift)
Total: 1+1+3+2+2 = 9 comparisons, 1+0+3+1+1 = 6 shifts
```

This traces exactly to the executed counters: 9 comparisons, 6 shifts. Insertion sort's comparisons stop as soon as an in-order pair is found (the `else: break`), which is why `i=2`'s key (`9`, already the largest so far) costs only 1 comparison — no shifting was needed at all.

### Merge Sort — 10 comparisons, 5 merge operations

Merge sort recursively splits in half until pieces are trivially sorted (length ≤ 1), then merges sorted halves back together:

```
[5, 2, 9, 1, 5, 6]
  split -> [5, 2, 9]  and  [1, 5, 6]
    [5, 2, 9] split -> [5] and [2, 9]
      [2, 9] split -> [2] and [9] -> merge(2,9): 1 comparison -> [2, 9]                  (merge op 1)
    merge([5], [2,9]): compare 5,2 -> 2; compare 5,9 -> 5; append 9 -> [2, 5, 9]: 2 comparisons  (merge op 2)
    [1, 5, 6] split -> [1] and [5, 6]
      [5, 6] split -> [5] and [6] -> merge(5,6): 1 comparison -> [5, 6]                  (merge op 3)
    merge([1], [5,6]): compare 1,5 -> 1; append 5,6 -> [1, 5, 6]: 1 comparison            (merge op 4)
  merge([2,5,9], [1,5,6]): compare 2 vs 1 -> take 1; compare 2 vs 5 -> take 2; compare 5 vs 5 -> take left's 5 (tie, left wins via <=); compare 9 vs 6 -> take 6; left exhausted... wait, left still has 9 -> compare 9 vs (right exhausted) -> append remaining 9 with no more comparisons
    -> 5 comparisons total for this merge                                                  (merge op 5)
Total: 1+2+1+1+5 = 10 comparisons, 5 merge operations
```

This matches the executed 10 comparisons and 5 merge operations exactly (one merge operation per non-trivial split, and this 6-element input produces exactly 5 merges through the recursion tree). Note merge sort is the only one of the five that is **not in-place** — `_merge` builds a brand-new `result` list at every merge step, which is exactly why its space complexity is O(n) rather than O(1): at the top-level merge, two size-3 sorted halves are combined into a new size-6 list, and that temporary allocation happens at every level of recursion.

### Quick Sort — 11 comparisons, 12 swaps

Quick sort partitions around a pivot (this implementation always picks the **last** element of the current sub-range), moving everything ≤ pivot to its left and everything > pivot to its right, then recurses on each side:

```
_quick_sort(arr, 0, 5), pivot = arr[5] = 6
  partition: i=-1
    j=0: arr[0]=5 <= 6? yes -> i=0, swap(0,0) -> [5,2,9,1,5,6]
    j=1: arr[1]=2 <= 6? yes -> i=1, swap(1,1) -> [5,2,9,1,5,6]
    j=2: arr[2]=9 <= 6? no
    j=3: arr[3]=1 <= 6? yes -> i=2, swap(2,3) -> [5,2,1,9,5,6]
    j=4: arr[4]=5 <= 6? yes -> i=3, swap(3,4) -> [5,2,1,5,9,6]
  final swap: swap(i+1=4, high=5) -> [5,2,1,5,6,9]   pivot 6 now at index 4
  (5 comparisons, 5 swaps so far)
  recurse left  (0,3) on [5,2,1,5], pivot = arr[3] = 5
    j=0: 5<=5 yes -> i=0 swap(0,0)
    j=1: 2<=5 yes -> i=1 swap(1,1)
    j=2: 1<=5 yes -> i=2 swap(2,2)
    final swap: swap(3,3) -> pivot 5 stays at index 3
    (3 comparisons, 4 swaps - all no-op self-swaps but still counted)
    recurse left (0,2) on [5,2,1], pivot = arr[2] = 1
      j=0: 5<=1 no
      j=1: 2<=1 no
      final swap: swap(0,2) -> [1,2,5]
      (2 comparisons, 1 swap)
      recurse left (0,-1): base case, no-op
      recurse right (1,2) on [2,5], pivot = arr[2] = 5
        j=1: 2<=5 yes -> i=1 swap(1,1)
        final swap: swap(2,2)
        (1 comparison, 2 swaps)
    recurse right (4,3): base case (low > high), no-op
  recurse right (5,5): base case (low == high), no-op
Total: 5+3+2+1 = 11 comparisons, 5+4+1+2 = 12 swaps
```

This matches the executed 11 comparisons and 12 swaps. Quick sort's swap count looks high (12, more than any other algorithm here) largely because this implementation's partition scheme performs a **self-swap** (`arr[i], arr[j] = arr[j], arr[i]` when `i == j`) every time an element is already on the correct side of the pivot — those are counted even though they don't change the array, which is a real, worth-noticing quirk of this partitioning style (Lomuto partition scheme).

## Advanced: Why Quick Sort's Worst Case Is O(n^2)

This implementation always picks the **last element** as the pivot. If the input is already sorted (or reverse-sorted), that pivot is always the maximum (or minimum) of the current range, so every partition splits the range into "everything" on one side and "nothing" on the other — the recursion degenerates from splitting the problem roughly in half each time (giving O(log n) recursion depth) to peeling off just one element per call (giving O(n) recursion depth), and O(n) work per level times O(n) levels is O(n^2).

The executed proof: sorting the already-sorted `[1, 2, 3, 4, 5]` with `quick_sort` in this module produces **10 comparisons and 14 swaps** for just 5 elements — noticeably worse than `merge_sort` would do on the same input (merge sort is unaffected by input order; it always splits exactly in half). Production-quality quicksort implementations avoid this by picking a pivot randomly, or using the median of the first/middle/last elements, so that adversarial or already-sorted input can't reliably trigger the worst case.

Bubble sort and insertion sort, by contrast, have a **best case of O(n)** on already-sorted input — bubble sort's early-exit flag and insertion sort's `else: break` both mean a fully sorted list is detected and confirmed in a single linear pass, with zero swaps/shifts. The executed proof: `bubble_sort([1, 2, 3, 4, 5])` makes 4 comparisons and 0 swaps.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/06-Sorting-Algorithms
python implementation.py
```

## Verified Output

```
Original data: [5, 2, 9, 1, 5, 6]

--- bubble_sort([5, 2, 9, 1, 5, 6]) ---
Sorted: [1, 2, 5, 5, 6, 9], comparisons: 14, swaps: 6

--- selection_sort([5, 2, 9, 1, 5, 6]) ---
Sorted: [1, 2, 5, 5, 6, 9], comparisons: 15, swaps: 4

--- insertion_sort([5, 2, 9, 1, 5, 6]) ---
Sorted: [1, 2, 5, 5, 6, 9], comparisons: 9, shifts: 6

--- merge_sort([5, 2, 9, 1, 5, 6]) ---
Sorted: [1, 2, 5, 5, 6, 9], comparisons: 10, merge_operations: 5

--- quick_sort([5, 2, 9, 1, 5, 6]) ---
Sorted: [1, 2, 5, 5, 6, 9], comparisons: 11, swaps: 12

--- Already-sorted input, bubble_sort best case ---
bubble_sort([1, 2, 3, 4, 5]) -> comparisons: 4, swaps: 0 (early exit, no swaps needed)

--- Already-sorted input, quick_sort worst case ---
quick_sort([1, 2, 3, 4, 5]) -> comparisons: 10, swaps: 14 (last-element pivot degrades on sorted input)
```

## Summary

- Bubble, selection, and insertion sort are all O(n^2) average/worst case and O(1) space — simple to write, fine for small or nearly-sorted input, too slow for large random input.
- Bubble sort and insertion sort both have an O(n) best case on already-sorted input, thanks to early-exit logic; selection sort does not — it always scans the full remainder for a minimum regardless of input order.
- Merge sort guarantees O(n log n) in all cases, at the cost of O(n) extra space for the temporary merge buffers.
- Quick sort is O(n log n) on average but degrades to O(n^2) on adversarial input for a naive pivot choice (like always picking the last element) — the fix is randomized or median-based pivot selection.
- Selection sort pays its cost in comparisons (always O(n^2) comparisons) while making very few swaps (at most n-1); the others trade comparisons and swaps/shifts differently depending on input order.

## Key Terms

- **In-place** — an algorithm that sorts by rearranging the original array using O(1) extra memory, rather than allocating a new structure (bubble, selection, insertion, and this quicksort are in-place; merge sort is not).
- **Stable sort** — a sort that preserves the relative order of elements that compare as equal.
- **Pivot** — in quick sort, the element chosen to partition the rest of the array into "smaller" and "larger" groups.
- **Partition** — the step in quick sort that rearranges a sub-array around the pivot and returns the pivot's final sorted index.
- **Divide and conquer** — an algorithm design pattern (used by merge sort and quick sort) that splits a problem into smaller subproblems, solves them (often recursively), and combines the results.

## Common Mistakes

- Assuming all O(n^2) sorts perform identically — they don't; bubble sort has an early-exit best case, selection sort does not, and insertion sort's cost depends heavily on how "nearly sorted" the input already is (see the 9 comparisons for this input's insertion sort vs. selection sort's fixed 15 regardless of order).
- Forgetting that merge sort needs O(n) auxiliary space — in a memory-constrained environment, that can matter as much as its time complexity advantage.
- Always picking the first or last element as quick sort's pivot in production code — this is fine for teaching (as here) but creates a reliable O(n^2) worst case on sorted or reverse-sorted input, which real-world data (e.g., a mostly-sorted log file) can easily trigger.
- Confusing "average case O(n log n)" for quick sort with "guaranteed O(n log n)" — only merge sort guarantees that bound in every case; quick sort's guarantee is weaker unless pivot selection is randomized or otherwise hardened.

## Interview Questions

1. **Why does merge sort guarantee O(n log n) in every case, while quick sort can degrade to O(n^2)?**
   Merge sort always splits its input exactly in half regardless of the input's values, giving a fixed recursion depth of O(log n) with O(n) merge work per level — the split point never depends on data. Quick sort's split point is the pivot's final position, which depends entirely on the data and the pivot-selection strategy; a consistently bad pivot (e.g., always the max or min of the current range, which happens on sorted input with a last-element pivot) produces a lopsided partition every time, turning O(log n) recursion depth into O(n) depth.

2. **What does "stable" mean for a sorting algorithm, and which of these five are stable?**
   A stable sort preserves the original relative order of elements that compare equal. Bubble sort, insertion sort, and merge sort are stable (they never swap two equal elements past each other unnecessarily). Selection sort and this quick sort implementation are not stable — selection sort's swap can jump an element past equal elements it was next to, and quick sort's partitioning can reorder equal elements relative to each other.

3. **Why is selection sort's swap count so much lower than bubble sort's, even on the same input?**
   Selection sort performs at most one swap per outer loop iteration (n-1 total, only when a new minimum was found), because it fully scans the unsorted remainder first and swaps only once it knows the correct minimum. Bubble sort swaps every time it finds *any* adjacent out-of-order pair during its scan, which is typically many more swaps per pass — it fixes local disorder as it goes rather than finding the single best fix per pass.

4. **How would you fix quick sort's worst-case behavior on already-sorted input?**
   Change the pivot selection strategy: pick the pivot randomly, or use the median of the first, middle, and last elements of the current range ("median-of-three"). Either approach makes it statistically very unlikely that an adversary or an already-sorted input can force the worst-case lopsided partition every single time, restoring expected O(n log n) behavior in practice.

5. **Why does merge sort need O(n) extra space while the other four (as implemented here) don't?**
   Merging two sorted halves into one sorted whole requires comparing elements from both halves while neither has been overwritten yet — that's only possible by writing the merged result into a separate new list, not into either input half in place. Bubble, selection, insertion, and this quicksort all rearrange elements within the original array using only a few extra index/temp variables (O(1) extra space), because their core operation (compare-and-swap, or shift-and-insert) never needs to preserve a full separate copy of any sub-range.

## Suggested Next Lesson

[07 — Searching Algorithms](../07-Searching-Algorithms/README.md)
