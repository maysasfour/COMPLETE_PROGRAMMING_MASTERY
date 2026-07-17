# Data Structures and Algorithms Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../08-Data-Structures-and-Algorithms/README.md)

## Big O Cheat Table
| Complexity | Name | Example |
|---|---|---|
| O(1) | Constant | Hash table lookup (average case) |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Linear search, single pass |
| O(n log n) | Linearithmic | Merge sort, quicksort (average) |
| O(n²) | Quadratic | Nested loops, bubble sort |
| O(2ⁿ) | Exponential | Naive recursive Fibonacci |

See [08-Data-Structures-and-Algorithms/01-Complexity-Analysis](../../08-Data-Structures-and-Algorithms/01-Complexity-Analysis/README.md).

## Core Structures at a Glance
| Structure | Access | Insert/Delete | Notes |
|---|---|---|---|
| Array | O(1) by index | O(n) middle | Contiguous memory |
| Linked List | O(n) | O(1) at known position | No shifting needed |
| Stack | O(1) top | O(1) top | LIFO |
| Queue | O(1) front | O(1) rear | FIFO |
| Hash Table | O(1) average | O(1) average | O(n) worst case on collisions |
| Binary Search Tree | O(log n) average | O(log n) average | O(n) worst case if unbalanced |
| Heap | O(1) peek | O(log n) | Priority queue backing structure |

See [08-Data-Structures-and-Algorithms](../../08-Data-Structures-and-Algorithms/README.md) Lessons 02-05, 09-10.

## Sorting/Searching
- **Merge sort**: guaranteed O(n log n), stable, O(n) extra space.
- **Quicksort**: average O(n log n), worst-case O(n²), in-place.
- **Binary search**: O(log n), requires sorted input.

See [06-Sorting-Algorithms](../../08-Data-Structures-and-Algorithms/06-Sorting-Algorithms/README.md) and [07-Searching-Algorithms](../../08-Data-Structures-and-Algorithms/07-Searching-Algorithms/README.md).

## Recursion
Every recursive function needs a reachable base case; without one, the call stack grows until it overflows. See [08-Recursion](../../08-Data-Structures-and-Algorithms/08-Recursion/README.md).

## Dynamic Programming vs. Greedy
- **DP**: applies when a problem has optimal substructure + overlapping subproblems; memoize to avoid recomputation.
- **Greedy**: makes the locally optimal choice at each step; simpler and faster, but not always globally optimal.

See the [full DSA module](../../08-Data-Structures-and-Algorithms/README.md) for verified, runnable Python implementations of everything above.
