# 11 — Graphs

[Back to module overview](../README.md) | [Previous: Heaps and Priority Queues](../10-Heaps-and-Priority-Queues/README.md)

## Beginner: Representations, and Why Adjacency Lists Win for Sparse Graphs

A **graph** generalizes a tree ([09](../09-Trees-and-Binary-Search-Trees/README.md)) by dropping its restrictions: no single root, cycles are allowed, and a vertex can have any number of connections ("edges") to other vertices. A graph is **directed** if an edge only goes one way (A→B doesn't imply B→A) or **undirected** if edges are bidirectional; it's **weighted** if edges carry a cost/distance, **unweighted** otherwise.

Two common ways to represent one in code:

- **Adjacency matrix**: an `n x n` grid where `matrix[i][j]` records whether an edge exists (and its weight). O(1) to check "are u and v connected?", but O(n²) space regardless of how many edges actually exist.
- **Adjacency list**: each vertex maps to a list of its neighbors (`implementation.py`'s `Graph.adjacency`). O(V + E) space — proportional to the *actual* number of edges, not the square of the vertex count.

Most real-world graphs (social networks, road networks, dependency graphs) are **sparse** — the number of edges is nowhere near `n²` — which is exactly why this lesson uses an adjacency list throughout; a matrix only wins when a graph is genuinely dense or when O(1) edge-existence checks matter more than space.

## Intermediate: BFS vs. DFS

- **Breadth-first search (BFS)** uses an explicit **queue** (FIFO — first in, first out; see [04-Stacks-and-Queues](../04-Stacks-and-Queues/README.md)) and visits vertices in order of distance from the start: every vertex at distance 1 before any vertex at distance 2. This is exactly why BFS is the right tool for shortest-path-in-hops on an *unweighted* graph — the first time a vertex is reached is guaranteed to be via a shortest possible path.
- **Depth-first search (DFS)** follows one branch all the way down before backtracking, naturally expressed with recursion (`dfs_recursive`, using the call stack itself as the implicit stack) or with an explicit stack (`dfs_iterative`) to avoid Python's recursion depth limit on very large/deep graphs.

## Advanced: Cycle Detection, and Dijkstra's Shortest Path

**Cycle detection differs fundamentally between undirected and directed graphs:**

- **Undirected**: a cycle exists if DFS reaches an already-visited vertex that is *not* the immediate parent just came from — going back to your own parent is normal (every undirected edge is bidirectional) and isn't itself a cycle.
- **Directed**: reaching an already-visited vertex is *not* automatically a cycle (it might just be reachable via two separate valid paths in a DAG — this lesson's demo confirms A→B→D and A→C→D is correctly reported as **no** cycle). What actually indicates a real cycle is reaching a vertex that's on the *current* recursion path — tracked with a three-color scheme (white = unvisited, gray = in-progress/on the current path, black = fully finished) so a "gray" neighbor specifically means a back-edge to something still open on the current path.

**Dijkstra's algorithm** finds shortest paths from one start vertex to every other vertex, for graphs with non-negative edge weights — and this lesson's implementation directly **reuses Lesson 10's `MinHeap`** as its priority queue: always expand the closest-known unvisited vertex next. This greedy-expansion strategy guarantees a vertex's recorded distance is final the moment it's popped (it can never be improved later) — which is exactly the property that breaks if negative edge weights were allowed (a later, very negative edge could still improve an "already final" distance).

## A Real Bug Found While Verifying `dfs_iterative` Against `dfs_recursive`

The first version of `dfs_iterative` marked a vertex visited the moment it was *discovered* (pushed onto the stack) — the same convention `bfs` uses. Comparing its output against `dfs_recursive` on the exact same graph exposed a genuine discrepancy: `['A','B','D','C','E']` (recursive) vs. `['A','B','D','E','C']` (iterative) — different orders, from the same graph and the same starting vertex, using what was supposed to be "the same algorithm with an explicit stack." Root cause: marking a vertex visited at *discovery* time (rather than *processing* time) lets whichever branch discovers a shared vertex first silently claim it, even when a different branch would have processed it first under a true depth-first order. Fixed by marking visited only at *pop* time and allowing the same vertex to be pushed more than once (skipping it on pop if already visited by then) — verified afterward to produce byte-for-byte identical output to `dfs_recursive`.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/11-Graphs
python implementation.py
```

## Verified Output

```
=== BFS vs DFS on the same undirected graph ===
bfs from A          : ['A', 'B', 'C', 'D', 'E']
dfs_recursive from A: ['A', 'B', 'D', 'C', 'E']
dfs_iterative from A: ['A', 'B', 'D', 'C', 'E']
recursive == iterative order: True

=== cycle detection: undirected ===
A-B-C-D (a simple path, no cycle) -> has_cycle: False
A-B-C-A (a triangle, a real cycle) -> has_cycle: True

=== cycle detection: directed ===
A->B->D and A->C->D (two paths to D, but no CYCLE since edges are one-way) -> has_cycle: False
A->B->C->A (a real directed cycle) -> has_cycle: True

=== Dijkstra's shortest path ===
shortest distances from A: {'A': 0, 'B': 2, 'C': 1, 'D': 3}
shortest A->B is via A->C->B (cost 2), NOT the direct A->B edge (cost 4): True
shortest A->D is via A->C->B->D (cost 3), cheaper than A->C->D (cost 6): True
```

## Summary

- Adjacency lists (O(V+E) space) beat adjacency matrices (O(V²) space) for the sparse graphs most real problems involve.
- BFS (queue-based) visits by distance from the start — the right tool for shortest-path-in-hops on unweighted graphs. DFS (stack-based, recursive or explicit) follows one branch deep before backtracking.
- Cycle detection genuinely differs between undirected graphs (any revisit that isn't the immediate parent) and directed graphs (a revisit specifically on the *current* recursion path, tracked via three-coloring).
- Dijkstra's algorithm reuses a min-heap as its priority queue, always expanding the closest-known vertex next — this greedy property only holds for non-negative edge weights.
- A real bug was found and fixed comparing `dfs_iterative` against `dfs_recursive`: marking a vertex visited at discovery time (vs. processing time) silently changes traversal order whenever a vertex has more than one discovery path.

## Key Terms

- **Adjacency list / adjacency matrix** — the two standard graph representations; list favors sparse graphs, matrix favors O(1) edge lookups or genuinely dense graphs.
- **Directed / undirected, weighted / unweighted** — the four independent axes describing a graph's edges.
- **BFS (breadth-first search)** — queue-based traversal, visits by distance from the start; the basis for unweighted shortest-path.
- **DFS (depth-first search)** — stack-based (explicit or via recursion) traversal, follows one branch fully before backtracking.
- **Cycle** — a path that returns to a vertex already on it; detected differently for undirected (non-parent revisit) vs. directed (revisit on the current recursion path) graphs.
- **Dijkstra's algorithm** — greedy shortest-path algorithm for non-negative-weight graphs, using a priority queue to always expand the closest-known vertex next.

## Common Mistakes

- Using an adjacency matrix by default without considering graph density — wasting O(V²) space on a graph with only O(V) actual edges.
- Applying undirected cycle detection's "any revisit is a cycle" rule to a directed graph — as shown directly in this lesson, a directed graph can have a vertex reachable via two separate valid paths with no cycle at all; only a revisit on the *current* path counts.
- Running Dijkstra's algorithm on a graph with negative edge weights — its core greedy assumption (a popped vertex's distance is already final) breaks down, and it can produce an incorrect, non-final "shortest" distance ([Bellman-Ford](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) exists specifically to handle negative weights correctly, at higher time complexity).
- Marking vertices visited at the wrong time in an iterative traversal (discovery/push time vs. processing/pop time) — a real, subtle bug this lesson encountered directly, silently producing a different traversal order than the "equivalent" recursive version.

## Interview Questions

1. **When would you choose an adjacency matrix over an adjacency list, and vice versa?**
   An adjacency matrix wins when the graph is dense (edges close to the maximum possible `n²`) or when O(1) "are u and v directly connected?" queries matter more than memory. An adjacency list wins for sparse graphs (most real-world graphs), since its space is proportional to actual edges (`O(V+E)`) rather than the square of vertex count (`O(V²)`) regardless of how few edges actually exist.

2. **Why is BFS, not DFS, the right choice for shortest-path-in-hops on an unweighted graph?**
   BFS visits vertices strictly in order of distance from the start — every distance-1 vertex before any distance-2 vertex, guaranteed by the FIFO queue. This means the *first* time BFS reaches any given vertex, it's necessarily via a shortest possible path. DFS gives no such guarantee — it can reach a distant vertex via a long, winding path long before finding a shorter one.

3. **Explain why the same "revisited vertex means a cycle" logic doesn't work for directed graphs the way it does for undirected ones.**
   In an undirected graph, every edge is inherently bidirectional, so simply going back to the vertex you just came from would trivially "revisit" it — that specific parent-revisit is excluded, and any OTHER revisit means a real cycle. In a directed graph, a vertex can legitimately be reached via two entirely separate directed paths with no cycle at all (this lesson's A→B→D / A→C→D example) — a revisit there is only a genuine cycle if it's a revisit of a vertex still "in progress" on the *current* recursive path, which requires explicitly tracking that (the three-color scheme), not just a plain visited/unvisited flag.

4. **Why does Dijkstra's algorithm fail on graphs with negative edge weights?**
   Its core assumption is that once a vertex is popped from the priority queue (i.e., it's the closest-known unvisited vertex), its recorded distance is final and can never be improved later — every other unvisited vertex is at least as far away, so no future expansion could find a shorter path to it. A negative edge weight breaks this: a much-later, very negative edge could still reduce the total cost to a vertex whose distance was already treated as final, producing an incorrect answer.

5. **Describe the bug found comparing this lesson's `dfs_iterative` against `dfs_recursive`, and the general lesson it illustrates.**
   The initial iterative version marked a vertex "visited" the moment it was pushed onto the stack (discovery time), not when it was actually popped and processed. When a vertex was reachable via two different branches before either had finished processing, whichever branch discovered it first silently "claimed" it — producing a different traversal order than the true depth-first order the recursive version naturally produces (which marks visited at the top of each call, i.e., at processing time). The general lesson: an iterative reimplementation of a recursive algorithm needs to reproduce not just *which* nodes get visited, but *when*, relative to the algorithm's actual semantics — "explicit stack instead of the call stack" is not automatically equivalent without care.

## Suggested Next Lesson

[12 — Dynamic Programming](../12-Dynamic-Programming/README.md)
