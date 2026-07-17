# Exercise 01 — Count Connected Components

[Back to lesson](../README.md)

## Task

Write a function `count_components(graph)` that returns how many separate **connected components** an undirected `Graph` (from `implementation.py`) has — i.e., how many groups of vertices exist such that every vertex in a group can reach every other vertex in that same group, but not any vertex in a different group.

```python
g = Graph(directed=False)
g.add_edge("A", "B")
g.add_edge("B", "C")
g.add_edge("D", "E")
g.add_vertex("F")  # F has no edges at all -- its own isolated component

count_components(g)  # -> 3   ({A,B,C}, {D,E}, {F})
```

## Hint

Run a traversal (BFS or DFS — either works) starting from any not-yet-visited vertex; everything it reaches belongs to the same component as that starting vertex. Count how many times you have to *start a fresh traversal* from a vertex that hasn't been visited by any previous traversal.

## Reflection Questions

1. Why does this problem require iterating over *all* vertices in the graph (not just running one traversal from an arbitrary starting vertex), even though a single BFS/DFS call already visits an entire connected component?
2. What would go wrong if you forgot to call `add_vertex("F")` for an isolated vertex with no edges at all — would it still be counted as its own component? (Look at how `add_edge` and `add_vertex` interact with `self.adjacency` in `implementation.py`.)
3. Does it matter whether you use BFS or DFS to find each component? Why or why not?

## Deliverable

A working `count_components` function plus answers to the three reflection questions.
