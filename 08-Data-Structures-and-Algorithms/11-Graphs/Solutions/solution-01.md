# Solution 01 — Count Connected Components

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
components: 3 (expected 3: {A,B,C}, {D,E}, {F})
fully-connected triangle components: 1 (expected 1)
empty graph components: 0 (expected 0)
```

## A Real Import Bug Hit Along the Way

Running `solution-01.py` directly at first failed with:
```
ImportError: cannot import name 'MinHeap' from partially initialized module 'implementation' (most likely due to a circular import)
```
This wasn't actually a circular import — it was a **module-naming collision**. `implementation.py` exists in *both* this lesson's folder (`11-Graphs`) and the previous one (`10-Heaps-and-Priority-Queues`), and the graphs lesson's `implementation.py` uses `sys.path.insert` + `from implementation import MinHeap` to reuse the heap. Once `solution-01.py` (a *different* file, also effectively named/imported as `implementation` via its own `sys.path` manipulation) had already been loaded, Python's `sys.modules` cache had `"implementation"` pointing at the *wrong* one of the two same-named files — a real, reproducible consequence of two unrelated files sharing a module name. Fixed in `implementation.py` itself by loading the heap module via `importlib.util.spec_from_file_location(...)` with an explicit, unique internal name (`"heaps_lesson_implementation"`), which sidesteps the shared-name collision entirely regardless of what else has already been imported elsewhere in the process — see the comment at the fix site in `implementation.py`.

## Explanation

`count_components` iterates over every vertex in the graph. Each time it finds a vertex that hasn't been visited by any *previous* traversal, that's proof a new, previously-unreached component has been found — so the counter increments, and a full BFS from that vertex marks every vertex reachable from it (i.e., every vertex in that same component) as visited, so none of them will incorrectly trigger another new-component count later.

## Reflection Answers

1. **Why iterate over all vertices, not just run one traversal.** A single BFS/DFS call only reaches the vertices in *one* connected component — by definition, a connected component is exactly "everything reachable from some starting vertex." If the graph has more than one component, a traversal starting in one component can never reach vertices in a different, disconnected component; the only way to find those is to notice they're still unvisited afterward and start a fresh traversal from one of them.

2. **What if `add_vertex("F")` were skipped for an isolated vertex.** Looking at `add_edge`/`add_vertex` in `implementation.py`: `self.adjacency` is a dictionary that only gets a key for a vertex when `add_vertex` (or `add_edge`, which calls it) is explicitly called for that vertex. A vertex with genuinely zero edges that's never explicitly added via `add_vertex` simply wouldn't exist in `self.adjacency` at all — it wouldn't be silently miscounted, it would be entirely invisible to `count_components` (and every other method), since the `for vertex in graph.adjacency` loop only ever sees vertices that exist as keys.

3. **Does BFS vs. DFS matter for this problem?** No — both visit exactly the same *set* of vertices from a given starting point (everything reachable from it), just in a different *order*. Since this problem only cares about which vertices belong to the same component (a set membership question), not the order they're visited in, either traversal produces the identical correct count.

## Common Pitfalls

- Forgetting to mark every vertex reached by a component's traversal as visited before moving to the next unvisited vertex in the outer loop — without this, the same component could be (incorrectly) counted multiple times.
- Assuming every vertex appears in `graph.adjacency` automatically — as shown in the reflection answers, a vertex only exists in the graph at all once `add_vertex` or `add_edge` has been called for it.
- For a **directed** graph specifically (not this exercise's undirected case, but worth knowing): "connected components" isn't even well-defined the same way, because reachability isn't necessarily symmetric — the relevant concept there is *strongly* connected components (mutually reachable both ways), a genuinely different and more involved algorithm (e.g., Tarjan's or Kosaraju's).
