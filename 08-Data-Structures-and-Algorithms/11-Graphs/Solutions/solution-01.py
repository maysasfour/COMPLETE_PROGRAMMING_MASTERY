import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import Graph


def count_components(graph):
    visited = set()
    components = 0

    for vertex in graph.adjacency:
        if vertex not in visited:
            components += 1
            for reached in graph.bfs(vertex):
                visited.add(reached)

    return components


if __name__ == "__main__":
    g = Graph(directed=False)
    g.add_edge("A", "B")
    g.add_edge("B", "C")
    g.add_edge("D", "E")
    g.add_vertex("F")  # isolated -- no edges at all

    print("components:", count_components(g), "(expected 3: {A,B,C}, {D,E}, {F})")

    fully_connected = Graph(directed=False)
    fully_connected.add_edge("A", "B")
    fully_connected.add_edge("B", "C")
    fully_connected.add_edge("C", "A")
    print("fully-connected triangle components:", count_components(fully_connected), "(expected 1)")

    empty = Graph(directed=False)
    print("empty graph components:", count_components(empty), "(expected 0)")
