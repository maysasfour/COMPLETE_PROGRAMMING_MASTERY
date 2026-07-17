# 09 — Trees and Binary Search Trees

[Back to module overview](../README.md) | [Previous: Recursion](../08-Recursion/README.md)

## Beginner: Tree Terminology and the BST Property

A **tree** is a hierarchical, non-linear structure: one **root** node, with zero or more **child** nodes, each of which is itself the root of its own subtree. A node with no children is a **leaf**. A node's **depth** is how many steps it is from the root; a tree's **height** is the depth of its deepest leaf (this lesson defines an empty tree's height as `-1` and a single-node tree's height as `0`, matching `implementation.py`).

A **binary tree** restricts every node to at most two children (conventionally "left" and "right"). A **binary search tree (BST)** adds one crucial ordering invariant, true at *every* node: everything in its left subtree is smaller than it, everything in its right subtree is larger. This single rule is what makes search, insert, and delete all cost O(height) instead of O(n) — at each node, comparing the target value tells you which single subtree could possibly contain it, discarding the other subtree entirely without looking at it.

```
        50
       /  \
     30    70
    /  \   /  \
  20   40 60   80
```

## Intermediate: Insert, Search, and the Three Traversal Orders

`insert` and `search` both walk the same path: compare the target against the current node, go left if smaller, right if larger, repeat. `insert` stops when it finds an empty spot to attach a new node; `search` stops when it finds a match (or runs out of tree).

The three traversal orders differ only in *when* a node visits itself relative to its children:

- **In-order** (left, self, right) — visits nodes in ascending sorted order for any valid BST. This is the traversal's signature use: `bst.in_order()` on the tree above yields `[20, 30, 40, 50, 60, 70, 80]`, already sorted, purely as a side effect of the BST property plus this visit order.
- **Pre-order** (self, left, right) — visits the root first; useful for cloning a tree's exact shape or serializing it in a way that can be rebuilt root-first.
- **Post-order** (left, right, self) — visits a node only after both its children; the natural order for safely deleting a tree bottom-up, since children are freed before their parent.
- **Level-order** (breadth-first, via a queue) — visits nodes level by level rather than following one branch all the way down first; this is the only one of the four that isn't a natural fit for plain recursion, since it needs an explicit queue.

## Advanced: Deletion's Three Cases, and Why an Unbalanced BST Degrades to O(n)

Deleting a node is the trickiest BST operation because removing a node with two children can't just "leave a hole" — something has to take its place while preserving the BST property everywhere. `_delete` in `implementation.py` handles three distinct cases:

1. **Leaf** (no children): remove it outright.
2. **One child**: splice that child directly into the deleted node's place.
3. **Two children**: replace the deleted node's *value* with its **in-order successor** (the smallest value in its right subtree — found by walking left as far as possible from that right child), then recursively delete that successor from the right subtree (which is now guaranteed to be a simple leaf-or-one-child case, since the smallest value in a subtree can never itself have a left child).

**Why an unbalanced BST degrades to O(n)** is best shown by measurement, not just asserted — and writing this measurement surfaced a genuinely real, instructive problem: inserting 1000 already-sorted values into this recursive BST hit Python's default recursion limit (1000) with a real `RecursionError`. This wasn't a bug to route around quietly — it's the lesson itself, encountered directly: a BST built from strictly increasing input degenerates into a straight chain (every new value is greater than everything already inserted, so it always becomes the new rightmost node), meaning the tree's height — and therefore `_insert`'s recursion depth — grows to `n-1`. The fix (`sys.setrecursionlimit(1100)`, scoped to just this one demo) is only necessary *because* the tree is this pathologically skewed:

```
1000 sorted-order insertions  -> height 999   (a straight chain: height == n-1)
1000 random-order insertions  -> height 20    (ideal minimum is ~9; random order isn't
                                                perfectly balanced, but the qualitative
                                                gap -- 999 vs 20, a 50x difference --
                                                for the EXACT SAME 1000 values, with no
                                                algorithm change at all, is the point)
```

True guaranteed O(log n) height regardless of insertion order requires an explicit self-balancing structure (AVL trees rebalance via rotations after every insert/delete to bound height; red-black trees use a looser coloring invariant to bound height more cheaply) — introduced here conceptually rather than implemented, since that's a lesson of its own.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/09-Trees-and-Binary-Search-Trees
python implementation.py
```

## Verified Output

```
=== BST insert, search, and traversals ===
in_order   : [20, 30, 40, 50, 60, 70, 80]
pre_order  : [50, 30, 20, 40, 70, 60, 80]
post_order : [20, 40, 30, 60, 80, 70, 50]
level_order: [50, 30, 70, 20, 40, 60, 80]
search(40) : True
search(99) : False
height     : 2

=== delete: all three cases ===
delete(20) -- a leaf
in_order after: [30, 40, 50, 60, 70, 80]
delete(30) -- one child (40) after 20 was removed
in_order after: [40, 50, 60, 70, 80]
delete(50) -- the root, with two children
in_order after: [40, 60, 70, 80]
new root value: 60

=== why an unbalanced BST degrades to O(n): a measured comparison ===
1000 sorted-order insertions  -> height 999 (a BST of sorted input degenerates into a linked list: height == n-1)
1000 random-order insertions  -> height 20 (the ideal minimum for 1000 nodes is log2(1000) ~= 9; ...)
Still, the qualitative gap is enormous: the skewed tree's height (999) is 50x the random tree's height (20) ...
```

## Summary

- A BST maintains one invariant at every node: left subtree smaller, right subtree larger — this single rule makes search/insert/delete all O(height).
- In-order traversal of any valid BST visits nodes in ascending sorted order, purely as a consequence of that invariant.
- Deleting a two-children node works by replacing its value with its in-order successor, then deleting that successor (now a simple case) from the right subtree.
- A BST's height depends entirely on insertion order: sorted-order insertion degenerates to a straight chain (height n-1, i.e. O(n) operations), while random order typically stays close to O(log n) — a real, measured 999-vs-20 height difference for the identical 1000 values proves this isn't just theoretical.
- Guaranteed O(log n) height regardless of insertion order requires an explicit self-balancing tree (AVL, red-black) — not covered in implementation here, only conceptually.

## Key Terms

- **Root / leaf / height / depth** — the root has no parent; a leaf has no children; height is the longest root-to-leaf path length; depth is a specific node's distance from the root.
- **Binary search tree (BST) property** — at every node, all values in its left subtree are smaller, all values in its right subtree are larger.
- **In-order / pre-order / post-order traversal** — the three depth-first visit orders, differing in when a node visits itself relative to its children.
- **In-order successor** — the smallest value in a node's right subtree; used to replace a deleted two-children node's value while preserving the BST property.
- **Self-balancing tree (AVL, red-black)** — a BST variant that actively maintains a bounded height regardless of insertion order, guaranteeing O(log n) operations.

## Common Mistakes

- Deleting a two-children node by just picking either child to "promote" arbitrarily, rather than specifically the in-order successor (or predecessor) — this breaks the BST property for the rest of the tree.
- Assuming a BST is automatically balanced just because it's a BST — as measured above, a BST's height depends entirely on insertion order; nothing about the plain BST structure itself bounds it.
- Confusing pre-order and post-order, since both visit both children — the distinguishing detail is only *when* the current node itself is added to the result, before or after its children.
- Forgetting that level-order traversal needs an explicit queue — attempting it with plain recursion (which naturally goes deep before wide) produces a depth-first order, not the intended breadth-first one.

## Interview Questions

1. **What single invariant defines a binary search tree, and why does it make search O(height) instead of O(n)?**
   At every node, everything in its left subtree is smaller and everything in its right subtree is larger. This lets search discard an entire subtree at each step (go left or right based on one comparison), so the number of comparisons needed is bounded by the tree's height, not its total node count.

2. **Why does in-order traversal of a BST always produce sorted output?**
   In-order visits left subtree, then the node itself, then right subtree. Because the BST property guarantees everything in the left subtree is smaller than the current node and everything in the right subtree is larger, visiting in that order at every level recursively produces values in strictly ascending order.

3. **Walk through deleting a node with two children. Why use the in-order successor specifically?**
   Replace the deleted node's value with the smallest value in its right subtree (found by walking left as far as possible from that right child), then delete that successor value from the right subtree. The in-order successor is guaranteed to be larger than everything in the deleted node's left subtree (it's still in the right subtree) and smaller than everything else remaining in the right subtree (it was the smallest value there) — so promoting it preserves the BST property everywhere, and because it's the smallest value in its subtree, it can never itself have a left child, making its own removal a simple one-child-or-leaf case.

4. **Why can the exact same set of values produce BSTs of wildly different heights, and what's the practical consequence?**
   A BST's shape depends entirely on insertion *order*, not just which values it holds. Sorted-order insertion always attaches each new value as the new rightmost (or leftmost) node, producing a straight chain of height n-1. Random-order insertion tends to branch more evenly. The practical consequence, measured directly in this lesson: identical 1000 values produced heights of 999 (sorted) vs. 20 (random) — a 50x difference in the worst-case number of comparisons a search might need.

5. **What guarantees O(log n) height regardless of insertion order, and why doesn't a plain BST provide that on its own?**
   A self-balancing tree structure (AVL trees, which rebalance via rotations after every insert/delete; red-black trees, which use a looser coloring invariant to bound height more cheaply) actively restructures itself to keep height bounded. A plain BST has no such mechanism at all — its height is purely an emergent consequence of whatever order values happened to be inserted in, which is exactly why sorted input is its worst case.

## Suggested Next Lesson

[10 — Heaps and Priority Queues](../10-Heaps-and-Priority-Queues/README.md)
