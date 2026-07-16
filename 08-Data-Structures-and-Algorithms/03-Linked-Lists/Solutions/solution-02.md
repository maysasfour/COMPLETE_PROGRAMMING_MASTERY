# Solution 02 — Detect a Cycle

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-02.md)

Runnable code lives in `solution-02.py`. Verified output:

```
Normal list [1, 2, 3, 4] -> has_cycle: False
Cyclic list (1->2->3->4->back to 2) -> has_cycle: True
Single self-looping node -> has_cycle: True
Empty list -> has_cycle: False
```

## Explanation

`has_cycle` reuses the slow/fast pointer pattern from Exercise 01 (Floyd's cycle detection, nicknamed "tortoise and hare"). `slow` advances one node per step, `fast` advances two. On a cycle-free list, `fast` simply falls off the end (`None`) and the function returns `False`. On a list with a cycle, both pointers get trapped inside the loop forever — and because `fast` closes the gap to `slow` by exactly one node every iteration, it is mathematically guaranteed to eventually land on the exact same node object as `slow`.

## Reflection Answers

1. **Why no cycle means they can never be equal.** With no cycle, both pointers are moving strictly toward `None` along a finite, non-repeating chain. `fast` is always at least as far along as `slow` and gets further ahead each step (never falls behind or loops back), so it reaches `None` (and the loop exits) before it could ever coincide with `slow` at the same node.

2. **Why a cycle guarantees eventual catch-up.** Once both pointers are inside the cycle, think of the gap between them (in number of nodes, going forward) as shrinking by exactly one node every iteration, because `fast` moves 2 and `slow` moves 1 — net gain of 1 per step. A gap that shrinks by exactly 1 each step and wraps around a finite loop must eventually hit exactly 0 (it can't "jump over" zero, since it decreases by exactly 1 at a time), which means `fast` and `slow` are on the same node — cycle detected.

3. **Why identity, not value, comparison.** Comparing `slow.value == fast.value` would produce false positives on any perfectly valid, cycle-free list that happens to contain a repeated value (e.g., `[5, 3, 5, 3]`) — two *different* nodes can legitimately hold equal values. `is` compares object identity (are these literally the same Node object in memory), which is the only correct question here: a cycle exists if and only if the pointers are standing on the *same node*, not merely two nodes that look alike.

## Common Pitfalls

- Comparing `slow.value == fast.value` instead of `slow is fast` — passes on simple test cases with unique values, then silently produces wrong answers (false positives) the moment duplicate values appear, which is a subtle bug that's easy to miss without deliberately testing for it.
- Using a `set()` of visited node ids to detect revisits — this correctly detects cycles too, but it's O(n) *extra space*, which fails the exercise's explicit O(1)-space requirement. It's worth knowing as an alternative, but not a substitute for the two-pointer solution when the requirement is stated.
- Forgetting to test the single-node self-loop edge case (a node whose own `.next` points to itself) — it's a valid and common cycle shape that a sloppy loop condition can mishandle.
