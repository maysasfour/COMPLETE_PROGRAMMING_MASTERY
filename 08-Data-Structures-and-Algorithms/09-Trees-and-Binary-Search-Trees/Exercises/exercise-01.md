# Exercise 01 — Validate a Binary Search Tree

[Back to lesson](../README.md)

## Task

Write a function `is_valid_bst(node)` that returns `True` if a binary tree (built from the `TreeNode` class in `implementation.py`) genuinely satisfies the BST property at *every* node, not just locally between each node and its immediate children.

```python
# A tree that LOOKS locally correct at each parent/child pair, but ISN'T a
# valid BST overall:
#         5
#        / \
#       3   8
#          / \
#         4   9      <- 4 is less than 5, but it's in 5's RIGHT subtree!
```

A naive check comparing only `node.value` against `node.left.value` and `node.right.value` would incorrectly call this tree valid — `4 < 8` is true, `4`'s immediate parent is `8`, so a purely local check passes. But the *actual* BST rule is global: every node in the right subtree of `5` must be greater than `5`, and `4` is not.

## Hint

Pass down a valid `(low, high)` range as you recurse. The root has no bound (`(-infinity, +infinity)`). When you recurse into a left child, that child's new upper bound becomes the parent's value; recursing into a right child, the new lower bound becomes the parent's value.

## Deliverable

A working `is_valid_bst` function, tested against both a genuinely valid BST and the deliberately invalid example above.
