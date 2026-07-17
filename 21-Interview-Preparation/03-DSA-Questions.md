# Data Structures and Algorithms Interview Questions

[Back to module overview](README.md)

## 1. What is Big O notation, and why do we ignore constants and lower-order terms?

Big O describes how an algorithm's running time or memory usage grows as the input size grows, focusing on the dominant trend rather than exact operation counts. Constants and lower-order terms are ignored because, as input size grows large, the dominant term overwhelmingly determines behavior — an O(n) algorithm eventually outperforms an O(n²) algorithm regardless of constant factors, once n is large enough. See [08-Data-Structures-and-Algorithms/01-Complexity-Analysis](../08-Data-Structures-and-Algorithms/01-Complexity-Analysis/README.md).

## 2. What's the difference between an array and a linked list?

An array stores elements contiguously in memory, giving O(1) random access by index but O(n) insertion/deletion in the middle (elements must shift). A linked list stores elements as nodes with pointers to the next (and often previous) node, giving O(1) insertion/deletion once you have a reference to the position, but O(n) access by index (must traverse from the head). See [08-Data-Structures-and-Algorithms/02-Arrays-and-Strings](../08-Data-Structures-and-Algorithms/02-Arrays-and-Strings/README.md) and [03-Linked-Lists](../08-Data-Structures-and-Algorithms/03-Linked-Lists/README.md).

## 3. What's the difference between a stack and a queue?

A stack is LIFO (last-in, first-out) — the most recently added element is removed first (used for function call stacks, undo history). A queue is FIFO (first-in, first-out) — the earliest added element is removed first (used for task scheduling, breadth-first traversal). See [08-Data-Structures-and-Algorithms/04-Stacks-and-Queues](../08-Data-Structures-and-Algorithms/04-Stacks-and-Queues/README.md).

## 4. How does a hash table achieve average O(1) lookup, and what causes worst-case O(n)?

A hash function maps a key to an array index (a "bucket"); a well-distributed hash function spreads keys evenly, making lookup, insertion, and deletion average O(1). Worst-case O(n) occurs when many keys collide into the same bucket (a poor hash function, or adversarial input specifically crafted to collide), degrading that bucket to a linear search. See [08-Data-Structures-and-Algorithms/05-Hash-Tables](../08-Data-Structures-and-Algorithms/05-Hash-Tables/README.md).

## 5. What's the difference between merge sort and quicksort?

Merge sort has a guaranteed O(n log n) time complexity in all cases, at the cost of O(n) additional space, and is stable (preserves the relative order of equal elements). Quicksort is typically faster in practice (better constant factors, in-place with O(log n) space) but has a worst-case O(n²) time complexity on adversarial or already-sorted input, unless a good pivot-selection strategy (like randomization) is used. See [08-Data-Structures-and-Algorithms/06-Sorting-Algorithms](../08-Data-Structures-and-Algorithms/06-Sorting-Algorithms/README.md).

## 6. What's the difference between linear search and binary search, and what does binary search require?

Linear search checks each element in order, O(n). Binary search repeatedly halves the search space by comparing the target to the middle element, O(log n) — but it requires the data to already be sorted. See [08-Data-Structures-and-Algorithms/07-Searching-Algorithms](../08-Data-Structures-and-Algorithms/07-Searching-Algorithms/README.md).

## 7. What is a base case in recursion, and what happens without one?

A base case is the condition under which a recursive function stops calling itself and returns directly, rather than recursing further. Without a correct (or reachable) base case, the recursion continues indefinitely, adding a new stack frame each time, until the call stack is exhausted and the program crashes with a stack overflow. See [08-Data-Structures-and-Algorithms/08-Recursion](../08-Data-Structures-and-Algorithms/08-Recursion/README.md).

## 8. What's the difference between a binary tree and a binary search tree?

A binary tree is any tree where each node has at most two children, with no ordering constraint. A binary search tree (BST) additionally requires that every node's left subtree contains only smaller values and its right subtree only larger values, enabling O(log n) average-case search, insertion, and deletion (degrading to O(n) if the tree becomes unbalanced, e.g., from inserting already-sorted data).

## 9. What is a heap, and what is it commonly used for?

A heap is a tree-based structure satisfying the heap property (in a min-heap, every parent is smaller than or equal to its children; the reverse for a max-heap), typically implemented as an array for efficiency. It's commonly used to implement a priority queue, giving O(log n) insertion and O(1) access to (with O(log n) removal of) the minimum/maximum element — used in algorithms like Dijkstra's shortest path and heap sort.

## 10. What's the difference between BFS and DFS on a graph?

Breadth-first search (BFS) explores all neighbors at the current depth before moving to the next depth level, typically using a queue — it finds the shortest path in an unweighted graph. Depth-first search (DFS) explores as far as possible down one path before backtracking, typically using a stack (or recursion) — useful for tasks like detecting cycles or topological sorting.

## 11. What is dynamic programming, and what two properties must a problem have for it to apply?

Dynamic programming solves a problem by breaking it into overlapping subproblems, solving each subproblem once, and reusing (memoizing) the result rather than recomputing it. It applies when a problem has **optimal substructure** (an optimal solution can be built from optimal solutions to subproblems) and **overlapping subproblems** (the same subproblems recur multiple times) — the classic example is computing Fibonacci numbers, where naive recursion recomputes the same values exponentially many times.

## 12. What's the difference between a greedy algorithm and dynamic programming?

A greedy algorithm makes the locally optimal choice at each step, hoping (and, for certain problem classes, provably) that this leads to a globally optimal solution, without reconsidering earlier choices. Dynamic programming considers the full space of subproblem solutions, guaranteeing a globally optimal solution for problems where the greedy choice isn't always correct. Greedy algorithms are typically simpler and faster when applicable, but not every problem that dynamic programming solves correctly can be solved greedily.

## 13. Why does inserting into a hash table with a bad hash function degrade to O(n)?

If the hash function maps many distinct keys to the same bucket, that bucket must store a growing list of colliding entries, and finding a specific key within it requires scanning that list linearly — in the worst case, if all keys collide into one bucket, the hash table behaves exactly like a single linked list, O(n) for every operation. This is why hash function quality and load-factor management (resizing/rehashing) matter for real hash table performance.

## Recommended Next File

[04 — SQL and Database Questions](04-SQL-Database-Questions.md)
