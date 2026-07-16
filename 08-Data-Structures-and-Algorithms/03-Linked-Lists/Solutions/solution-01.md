# Solution 01 — Find the Middle Node

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
Odd-length list [10, 20, 30, 40, 50]  -> middle: 30
Even-length list [10, 20, 30, 40] -> middle: 30
```

## Explanation

`find_middle` uses the **slow/fast pointer technique**: both pointers start at `head`, but `slow` advances one node per iteration while `fast` advances two. Because `fast` covers exactly twice the distance of `slow` in the same number of steps, the moment `fast` reaches (or passes) the end of the list, `slow` has covered exactly half that distance — landing on the middle node.

## Reflection Answers

1. **Why the 2x speed guarantees landing on the middle.** If the list has `n` nodes, `fast` needs roughly `n/2` iterations to traverse it (moving 2 nodes each time). In that same number of iterations, `slow` — moving 1 node each time — has advanced roughly `n/2` nodes from the head, i.e. exactly to the middle. The ratio of speeds (2:1) directly produces the ratio of distances covered (full length : half length).

2. **Complexity.** `find_middle` is O(n) time (fast pointer makes roughly n/2 iterations, still O(n)) and O(1) extra space (only two pointer variables, regardless of list length). The "obvious" approach — call `len(linked_list)` (itself an O(n) walk, per `__len__` in `implementation.py`), then walk again to index `length // 2` (another O(n) walk) — is also O(n) overall (two O(n) passes = O(n), constants dropped), but it makes **two separate full/partial traversals** where the two-pointer technique makes **one combined traversal**. In practice this matters more for readability/elegance and for cases where you can't call `len()` up front (e.g., streaming data) than for the Big O class itself, which is the same either way.

3. **Even vs. odd tracing.**
   - **Odd (5 nodes: 10,20,30,40,50):** `fast` starts at 10. Step 1: slow->20, fast->30. Step 2: slow->30, fast->50. Now `fast.next` is `None`, loop condition `fast is not None and fast.next is not None` fails, loop stops. `slow` is at 30 — the true middle.
   - **Even (4 nodes: 10,20,30,40):** `fast` starts at 10. Step 1: slow->20, fast->30. Step 2: slow->30, `fast.next` would be `None` before the assignment even runs (`fast.next.next` — since `fast` is `30`, `fast.next` is `40`, `fast.next.next` is `None`), so fast->None. Now `fast is not None` is `False`, loop stops. `slow` is at 30 — the **second** of the two true middle nodes (30 and 40 are both "middle" in a 4-node list; this technique consistently picks the later one), matching the convention stated in the exercise.

## Common Pitfalls

- Forgetting the `fast.next is not None` half of the loop condition — checking only `fast is not None` before doing `fast.next.next` crashes with an `AttributeError` on `None.next` when the list has an even number of nodes.
- Assuming both approaches (two-pointer vs. len()-then-walk) differ in Big O class — they don't; the two-pointer technique's advantage is a smaller constant factor (one traversal instead of two) and applicability to data you can only walk once, not a different complexity class.
