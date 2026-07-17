"""Graphs -- adjacency-list representation, BFS, DFS (recursive and
iterative), cycle detection (directed and undirected), and Dijkstra's
shortest-path algorithm (reusing the MinHeap from Lesson 10)."""

import importlib.util
import os
from collections import deque

# Loaded via importlib with an explicit, UNIQUE module name (rather than
# `sys.path.insert` + `from implementation import MinHeap`) specifically to
# avoid a real bug hit while writing this lesson's exercise: Lesson 10's file
# is ALSO named `implementation.py`, so a plain sys.path-based import collides
# with this very file's own module name in sys.modules the moment anything
# else in the same process (e.g. Solutions/solution-01.py) has already
# imported a DIFFERENT `implementation` module -- Python then finds the wrong,
# partially-initialized one already cached under that shared name, producing
# a genuine ImportError. Giving the heap module an explicit, distinct name
# avoids the collision entirely, regardless of import order elsewhere.
_heap_module_path = os.path.join(os.path.dirname(__file__), "..", "10-Heaps-and-Priority-Queues", "implementation.py")
_spec = importlib.util.spec_from_file_location("heaps_lesson_implementation", _heap_module_path)
_heaps_module = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_heaps_module)
MinHeap = _heaps_module.MinHeap


class Graph:
    """An adjacency LIST: each vertex maps to a list of (neighbor, weight)
    pairs. Chosen over an adjacency MATRIX because real-world graphs are
    usually SPARSE (far fewer edges than the n^2 a matrix would allocate
    regardless of actual edge count) -- a matrix only wins when a graph is
    dense or when "are u and v connected?" needs to be O(1)."""

    def __init__(self, directed=False):
        self.directed = directed
        self.adjacency = {}

    def add_vertex(self, vertex):
        self.adjacency.setdefault(vertex, [])

    def add_edge(self, u, v, weight=1):
        self.add_vertex(u)
        self.add_vertex(v)
        self.adjacency[u].append((v, weight))
        if not self.directed:
            self.adjacency[v].append((u, weight))

    def neighbors(self, vertex):
        return self.adjacency[vertex]

    def bfs(self, start):
        """Breadth-first search: visits vertices in order of DISTANCE from
        start (all distance-1 vertices before any distance-2 vertex), using
        an explicit QUEUE (FIFO) -- this is what makes it the natural choice
        for shortest-path-in-hops on an UNWEIGHTED graph: the first time a
        vertex is reached is guaranteed to be via a shortest possible path."""
        visited = {start}
        order = []
        queue = deque([start])
        while queue:
            current = queue.popleft()
            order.append(current)
            for neighbor, _weight in self.neighbors(current):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        return order

    def dfs_recursive(self, start):
        """Depth-first search: follows one branch all the way down before
        backtracking, using the CALL STACK itself as the implicit stack."""
        visited = set()
        order = []

        def visit(vertex):
            visited.add(vertex)
            order.append(vertex)
            for neighbor, _weight in self.neighbors(vertex):
                if neighbor not in visited:
                    visit(neighbor)

        visit(start)
        return order

    def dfs_iterative(self, start):
        """The same traversal as dfs_recursive, but with an EXPLICIT stack
        instead of the call stack -- avoids Python's recursion depth limit on
        very deep/large graphs, at the cost of slightly more code.

        A genuine bug was caught while verifying this against dfs_recursive:
        an earlier version marked a vertex "visited" at PUSH time (the moment
        it was discovered as a neighbor), the same convention bfs() uses.
        That produced a DIFFERENT traversal order than dfs_recursive on this
        exact graph (['A','B','D','C','E'] vs ['A','B','D','E','C']) whenever
        a vertex is reachable from two different branches before either has
        been fully processed -- marking it visited at discovery time let
        whichever branch discovered it FIRST silently claim it, even if that
        branch wasn't actually processed first. The fix: mark a vertex
        visited only at POP time (when it's actually being processed), and
        allow the same vertex to be pushed onto the stack more than once,
        skipping it on pop if it turns out to already be visited by then.
        This mirrors dfs_recursive's actual semantics (visited.add happens at
        the top of visit(), i.e. at "processing" time) instead of BFS's.
        """
        visited = set()
        order = []
        stack = [start]
        while stack:
            current = stack.pop()
            if current in visited:
                continue  # a stale duplicate pushed via a different branch; skip it
            visited.add(current)
            order.append(current)
            # Push neighbors in reverse so the traversal visits them in the
            # same left-to-right order as the recursive version would.
            for neighbor, _weight in reversed(self.neighbors(current)):
                if neighbor not in visited:
                    stack.append(neighbor)
        return order

    def has_cycle_undirected(self):
        """For an UNDIRECTED graph: a cycle exists if DFS ever reaches an
        already-visited vertex that is NOT the immediate parent we just came
        from (going back to the parent is normal for an undirected edge --
        every edge is bidirectional -- and is not itself a cycle)."""
        visited = set()

        def visit(vertex, parent):
            visited.add(vertex)
            for neighbor, _weight in self.neighbors(vertex):
                if neighbor not in visited:
                    if visit(neighbor, vertex):
                        return True
                elif neighbor != parent:
                    return True
            return False

        for vertex in self.adjacency:
            if vertex not in visited:
                if visit(vertex, None):
                    return True
        return False

    def has_cycle_directed(self):
        """For a DIRECTED graph, reaching an already-visited vertex is NOT
        automatically a cycle (it might just be reachable via two different
        paths, both fine in a DAG). What actually indicates a cycle is
        reaching a vertex that's on the CURRENT recursion path (its "in
        progress" state) -- tracked here with a three-color scheme:
        WHITE (unvisited), GRAY (in progress / on the current path), BLACK
        (fully finished, safe)."""
        WHITE, GRAY, BLACK = 0, 1, 2
        color = {vertex: WHITE for vertex in self.adjacency}

        def visit(vertex):
            color[vertex] = GRAY
            for neighbor, _weight in self.neighbors(vertex):
                if color[neighbor] == GRAY:
                    return True  # a back-edge to a vertex on the CURRENT path -- a real cycle
                if color[neighbor] == WHITE and visit(neighbor):
                    return True
            color[vertex] = BLACK
            return False

        for vertex in self.adjacency:
            if color[vertex] == WHITE:
                if visit(vertex):
                    return True
        return False

    def dijkstra(self, start):
        """Shortest paths from `start` to every other vertex, for a graph
        with NON-NEGATIVE edge weights. Reuses Lesson 10's MinHeap as the
        priority queue: always expand the currently-closest-known unvisited
        vertex next, which guarantees that by the time a vertex is popped,
        its recorded distance is already final (cannot be improved later) --
        this greedy-expansion property is exactly what breaks down if
        negative edge weights are allowed."""
        distances = {vertex: float("inf") for vertex in self.adjacency}
        distances[start] = 0
        visited = set()

        heap = MinHeap()
        heap.push((0, start))

        while len(heap) > 0:
            current_distance, current = heap.pop()
            if current in visited:
                continue  # a stale, already-superseded entry; skip it
            visited.add(current)

            for neighbor, weight in self.neighbors(current):
                new_distance = current_distance + weight
                if new_distance < distances[neighbor]:
                    distances[neighbor] = new_distance
                    heap.push((new_distance, neighbor))

        return distances


if __name__ == "__main__":
    print("=== BFS vs DFS on the same undirected graph ===")
    g = Graph(directed=False)
    edges = [("A", "B"), ("A", "C"), ("B", "D"), ("C", "D"), ("D", "E")]
    for u, v in edges:
        g.add_edge(u, v)

    print("edges:", edges)
    recursive_order = g.dfs_recursive("A")
    iterative_order = g.dfs_iterative("A")
    print("bfs from A          :", g.bfs("A"), "(visits by distance -- B,C before D, D before E)")
    print("dfs_recursive from A:", recursive_order, "(follows one branch deep before backtracking)")
    print("dfs_iterative from A:", iterative_order, "(explicit stack, fixed to mark visited at pop time)")
    print("recursive == iterative order:", recursive_order == iterative_order)

    print("\n=== cycle detection: undirected ===")
    acyclic = Graph(directed=False)
    for u, v in [("A", "B"), ("B", "C"), ("C", "D")]:
        acyclic.add_edge(u, v)
    print("A-B-C-D (a simple path, no cycle) -> has_cycle:", acyclic.has_cycle_undirected())

    cyclic = Graph(directed=False)
    for u, v in [("A", "B"), ("B", "C"), ("C", "A")]:
        cyclic.add_edge(u, v)
    print("A-B-C-A (a triangle, a real cycle) -> has_cycle:", cyclic.has_cycle_undirected())

    print("\n=== cycle detection: directed ===")
    dag = Graph(directed=True)
    for u, v in [("A", "B"), ("A", "C"), ("B", "D"), ("C", "D")]:
        dag.add_edge(u, v)
    print("A->B->D and A->C->D (two paths to D, but no CYCLE since edges are one-way) -> has_cycle:",
          dag.has_cycle_directed())

    directed_cycle = Graph(directed=True)
    for u, v in [("A", "B"), ("B", "C"), ("C", "A")]:
        directed_cycle.add_edge(u, v)
    print("A->B->C->A (a real directed cycle) -> has_cycle:", directed_cycle.has_cycle_directed())

    print("\n=== Dijkstra's shortest path ===")
    weighted = Graph(directed=True)
    weighted.add_edge("A", "B", 4)
    weighted.add_edge("A", "C", 1)
    weighted.add_edge("C", "B", 1)  # A->C->B costs 1+1=2, cheaper than the direct A->B edge of 4
    weighted.add_edge("B", "D", 1)
    weighted.add_edge("C", "D", 5)

    distances = weighted.dijkstra("A")
    print("edges: A-B(4), A-C(1), C-B(1), B-D(1), C-D(5)")
    print("shortest distances from A:", distances)
    print("shortest A->B is via A->C->B (cost 2), NOT the direct A->B edge (cost 4):",
          distances["B"] == 2)
    print("shortest A->D is via A->C->B->D (cost 3), cheaper than A->C->D (cost 6):",
          distances["D"] == 3)
