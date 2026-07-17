# Solution 01 — Validate a Binary Search Tree

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
=== is_valid_bst (the correct, range-based check) ===
valid tree  -> True
invalid tree-> False

=== naive_local_check (the WRONG approach) -- proving it's wrong ===
valid tree  -> True
invalid tree-> True <- WRONG, should be False
```

## Explanation

`is_valid_bst` threads a valid `(low, high)` range down through the recursion. The root starts with no bound at all (`(-inf, +inf)`). Recursing left tightens the *upper* bound to the parent's value (everything in a left subtree must be less than every ancestor it's a left descendant of, not just its immediate parent); recursing right tightens the *lower* bound the same way. A node fails validation the instant its own value falls outside the range accumulated from *all* its ancestors — not just its direct parent.

This is exactly why `naive_local_check` gets the invalid tree wrong: it only ever compares a node against its immediate parent/children. In the invalid tree, `4` is `8`'s left child (`4 < 8` — passes the local check), but `4` is *also* somewhere in `5`'s right subtree, and the real BST rule says everything there must be greater than `5`. The naive check never carries that constraint down past `8`, so it never catches the violation.

## Common Pitfalls

- Comparing only a node to its immediate parent (the bug this exercise exists to demonstrate) — this misses violations that skip a generation, like the `4` in the example.
- Using `<=`/`>=` instead of strict `<`/`>` when checking against the bounds, which would incorrectly accept duplicate values as valid (this BST implementation's own `insert` already rejects duplicates, but a validity checker should independently enforce strict ordering, not assume the tree was built correctly).
- Forgetting the base case (`node is None` returns `True`) — an empty subtree is trivially a valid BST; without this, the recursion has nowhere to stop.
