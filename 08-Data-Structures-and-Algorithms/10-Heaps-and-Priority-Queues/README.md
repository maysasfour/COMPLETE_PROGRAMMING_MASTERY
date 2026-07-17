# 10 — Heaps and Priority Queues

[Back to module overview](../README.md) | [Previous: Trees and Binary Search Trees](../09-Trees-and-Binary-Search-Trees/README.md)

## Beginner: The Heap Property and Array-Based Implicit Trees

A **heap** is a specialized binary tree (see [09](../09-Trees-and-Binary-Search-Trees/README.md)) with one invariant, weaker than a BST's: in a **min-heap**, every parent is less than or equal to both its children (a **max-heap** flips this — every parent is greater than or equal to both children). Unlike a BST, there's no left-vs-right ordering rule at all — only parent-vs-children.

This weaker invariant is what allows a heap to be stored as a **plain array**, with the tree structure entirely *implicit* from index arithmetic — no node objects, no `left`/`right` pointers:

- The node at index `i`'s parent is at `(i - 1) // 2`.
- Its children are at `2*i + 1` and `2*i + 2`.

This only works because a heap is always a **complete binary tree** — every level full except possibly the last, and the last level filled strictly left-to-right, with no gaps. That completeness is exactly what those index formulas assume, and it's maintained automatically by how `push`/`pop` always add/remove at the array's end (see below).

## Intermediate: Sift-Up and Sift-Down

- **`push` (insert)**: append the new value at the end of the array (the next open "leaf" slot in the complete tree), then **sift up** — repeatedly swap it with its parent as long as it's smaller than that parent, stopping the moment the heap property holds again. Since the tree has `O(log n)` levels, sift-up does at most `O(log n)` swaps.
- **`pop` (extract-min)**: the minimum is always the root (index 0). Move the *last* element in the array into the root position (this keeps the tree complete — no gap left behind), then **sift down** — repeatedly swap it with its smaller child as long as it's larger than that child, stopping once the heap property holds. Also `O(log n)`.

`implementation.py`'s `MinHeap.data` after pushing `[5, 3, 8, 1, 9, 2]` is `[1, 3, 2, 5, 9, 8]` — notice this is **not sorted**; only the heap property holds (each parent `<=` its children). This distinction matters: a heap is cheap to build and cheap to extract-the-minimum from repeatedly, but it does *not* give you sorted order for free the way a BST's in-order traversal does.

## Advanced: Heapsort and Priority Queues

**Heapsort** falls directly out of what a heap already does: push every value in (O(n log n) total), then pop repeatedly — since `pop` always returns the current minimum, popping until empty produces a fully sorted list. `implementation.py`'s `heapsort` is verified two ways: against Python's built-in `sorted()`, and against Python's own `heapq` module (`heapify` + repeated `heappop`) — both produce byte-for-byte identical output to this lesson's hand-rolled heap.

A **priority queue** is the more common real-world use of a heap: instead of raw numbers, store objects that know how to compare themselves by *priority* (`Task.__lt__` compares by `self.priority`), and the heap always pops the most urgent one next — regardless of insertion order. The scheduler demo pushes tasks in the order report(3) → outage(1) → docs(5) → review(2), and correctly serves them back out in priority order: outage(1) → review(2) → report(3) → docs(5).

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/10-Heaps-and-Priority-Queues
python implementation.py
```

## Verified Output

```
=== MinHeap: push/pop always returns the current minimum ===
heap internal array (NOT sorted -- only the heap PROPERTY holds): [1, 3, 2, 5, 9, 8]
peek (should be 1, the minimum): 1
popping until empty, in order: [1, 2, 3, 5, 8, 9] (ascending -- pop always removes the current min)

=== heapsort, cross-checked against Python's built-in sorted() ===
our heapsort   : [39, 50, 60, 75, 89, 97, 155, 220, 332, 375, 405, 429, 445, 520, 549, 597, 667, 841, 932, 971]
matches sorted(): True

=== cross-checked against Python's own heapq module ===
matches ours   : True

=== priority queue: a task scheduler that always serves the most urgent task next ===
tasks added in this order: report(3), outage(1), docs(5), review(2)
serving order (by priority, most urgent first):
 -> Task(priority=1, name='handle production outage')
 -> Task(priority=2, name='review pull request')
 -> Task(priority=3, name='send weekly report')
 -> Task(priority=5, name='update documentation')
```

## Summary

- A heap's invariant is parent-vs-children only (weaker than a BST's full ordering) — a min-heap parent is always `<=` both children.
- This weaker invariant lets a heap be stored as a plain array with the tree structure entirely implicit from index math (`parent = (i-1)//2`, `children = 2i+1, 2i+2`), relying on the heap always being a complete binary tree.
- `push` appends then sifts up; `pop` moves the last element to the root then sifts down — both O(log n).
- Heapsort is "push everything, then pop everything" — verified here to byte-for-byte match both Python's `sorted()` and its own `heapq` module.
- A priority queue is a heap of comparable objects (compared by priority, not raw value) — always serves the most urgent item next, regardless of insertion order.

## Key Terms

- **Heap property** — every parent is `<=` (min-heap) or `>=` (max-heap) both its children; weaker than a BST's full left/right ordering.
- **Complete binary tree** — every level full except possibly the last, which is filled strictly left-to-right with no gaps; what makes array-based implicit indexing valid.
- **Sift-up / sift-down** — the O(log n) operations that restore the heap property after an insert (sift-up, from the new leaf toward the root) or an extract-min (sift-down, from the root toward the leaves).
- **Heapsort** — sorting by pushing every value into a heap, then popping repeatedly; O(n log n).
- **Priority queue** — an abstract data type (commonly implemented with a heap) that always serves the highest-priority item next, regardless of insertion order.

## Common Mistakes

- Assuming a heap's underlying array is sorted — it isn't; only the parent/child relationship is guaranteed, as shown directly above (`[1, 3, 2, 5, 9, 8]` is a valid min-heap despite not being sorted).
- Forgetting to move the *last* element to the root before sifting down during `pop` — simply removing the root and leaving a hole breaks the complete-tree assumption the index formulas depend on.
- Using a max-heap when a min-heap (or vice versa) was actually needed for the problem — e.g., a "k largest elements" problem (see this lesson's exercise) actually wants a size-bounded *min*-heap, which trips people up since the goal is the largest values.
- Comparing custom objects in a heap without defining `__lt__` (or a `key` function) — Python's `heapq` and this lesson's hand-rolled heap both rely on `<` comparisons between the pushed values directly.

## Interview Questions

1. **What invariant defines a heap, and how does it differ from a BST's invariant?**
   A heap requires only that every parent be `<=` (min-heap) or `>=` (max-heap) both its children — a purely local, parent-vs-children rule. A BST requires a full ordering: everything in a node's left subtree smaller, everything in its right subtree larger, at *every* node. A heap's weaker rule is exactly what allows a much simpler, pointer-free array representation.

2. **Why can a heap be represented as a plain array with no explicit pointers?**
   Because a heap is always a complete binary tree (every level full except possibly the last, filled left-to-right) — that structural guarantee means a node's parent/children positions are always computable from its array index alone (`(i-1)//2` for parent, `2i+1`/`2i+2` for children), with no need to store explicit references.

3. **Walk through what happens during `pop` (extract-min), step by step.**
   The root (always the current minimum) is saved to return. The *last* element in the array is moved into the now-empty root position, keeping the tree complete. That relocated element is then sifted down: repeatedly swapped with its smaller child as long as it's larger than that child, until the heap property is restored or it reaches a leaf.

4. **Why is heapsort O(n log n), and how does it relate to a plain heap's push/pop operations?**
   It's literally n pushes (each O(log n)) followed by n pops (each also O(log n)) — total O(n log n) for both phases combined. Since `pop` always returns the current minimum, popping n times in sequence necessarily produces the values in fully sorted order.

5. **What's the difference between a heap and a priority queue?**
   A heap is a specific data structure (an array satisfying the parent/children ordering invariant). A priority queue is an abstract data type/interface (always serve the highest-priority item next) that a heap is the most common way to implement efficiently — much like a stack is an abstract interface that could be implemented with an array or a linked list. In practice the terms are often used interchangeably because a heap is by far the most common priority-queue implementation, but they're conceptually distinct.

## Suggested Next Lesson

[11 — Graphs](../11-Graphs/README.md)
