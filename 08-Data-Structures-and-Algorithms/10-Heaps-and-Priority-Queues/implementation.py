"""Heaps and Priority Queues -- a binary heap implemented as a plain array
with implicit tree indexing, sift-up/sift-down, heapsort built from it, and a
priority-queue task scheduler, cross-checked against Python's built-in heapq."""

import heapq
import random


class MinHeap:
    """A min-heap stored in a plain Python list. The tree structure is
    IMPLICIT from array indices alone -- no node objects or pointers needed:
    for the node at index i, its parent is at (i-1)//2, its children are at
    2*i+1 and 2*i+2. This is why a heap is always a COMPLETE binary tree
    (every level full except possibly the last, filled left-to-right) --
    that's exactly the shape these index formulas assume."""

    def __init__(self):
        self.data = []

    def _parent(self, i):
        return (i - 1) // 2

    def _left(self, i):
        return 2 * i + 1

    def _right(self, i):
        return 2 * i + 2

    def peek(self):
        return self.data[0] if self.data else None

    def push(self, value):
        self.data.append(value)
        self._sift_up(len(self.data) - 1)

    def _sift_up(self, i):
        """A newly appended value starts at the end of the array (the next
        open leaf spot) and 'bubbles up' toward the root as long as it's
        smaller than its parent -- restoring the heap property (a parent is
        always <= both its children) in O(log n), since it moves at most one
        level per swap and there are only log2(n) levels."""
        while i > 0 and self.data[i] < self.data[self._parent(i)]:
            parent = self._parent(i)
            self.data[i], self.data[parent] = self.data[parent], self.data[i]
            i = parent

    def pop(self):
        """Removes and returns the minimum (always the root, index 0). The
        LAST element is moved to the root position (keeping the tree
        complete -- no gaps), then sifted DOWN to restore the heap property."""
        if not self.data:
            raise IndexError("pop from an empty heap")
        minimum = self.data[0]
        last = self.data.pop()
        if self.data:
            self.data[0] = last
            self._sift_down(0)
        return minimum

    def _sift_down(self, i):
        size = len(self.data)
        while True:
            left, right = self._left(i), self._right(i)
            smallest = i
            if left < size and self.data[left] < self.data[smallest]:
                smallest = left
            if right < size and self.data[right] < self.data[smallest]:
                smallest = right
            if smallest == i:
                break
            self.data[i], self.data[smallest] = self.data[smallest], self.data[i]
            i = smallest

    def __len__(self):
        return len(self.data)


def heapsort(values):
    """Push everything into a heap, then pop repeatedly -- pops come out in
    ascending order by definition (pop always returns the current minimum),
    so this produces a fully sorted list in O(n log n): O(n) pushes at
    O(log n) each, plus O(n) pops at O(log n) each."""
    heap = MinHeap()
    for value in values:
        heap.push(value)
    return [heap.pop() for _ in range(len(heap))]


class Task:
    """A priority-queue entry. Compared purely by priority (lower number =
    more urgent, the conventional min-heap priority-queue direction) so a
    MinHeap of Tasks naturally pops the most urgent task first."""

    def __init__(self, priority, name):
        self.priority = priority
        self.name = name

    def __lt__(self, other):
        return self.priority < other.priority

    def __repr__(self):
        return f"Task(priority={self.priority}, name={self.name!r})"


if __name__ == "__main__":
    print("=== MinHeap: push/pop always returns the current minimum ===")
    heap = MinHeap()
    for value in [5, 3, 8, 1, 9, 2]:
        heap.push(value)
    print("heap internal array (NOT sorted -- only the heap PROPERTY holds):", heap.data)
    print("peek (should be 1, the minimum):", heap.peek())

    popped_order = []
    while len(heap) > 0:
        popped_order.append(heap.pop())
    print("popping until empty, in order:", popped_order, "(ascending -- pop always removes the current min)")

    print("\n=== heapsort, cross-checked against Python's built-in sorted() ===")
    random.seed(7)
    values = random.sample(range(1, 1000), 20)
    our_result = heapsort(values)
    expected = sorted(values)
    print("input          :", values)
    print("our heapsort   :", our_result)
    print("matches sorted():", our_result == expected)

    print("\n=== cross-checked against Python's own heapq module ===")
    heapq_copy = values[:]
    heapq.heapify(heapq_copy)
    heapq_result = [heapq.heappop(heapq_copy) for _ in range(len(heapq_copy))]
    print("heapq result   :", heapq_result)
    print("matches ours   :", heapq_result == our_result)

    print("\n=== priority queue: a task scheduler that always serves the most urgent task next ===")
    scheduler = MinHeap()
    scheduler.push(Task(3, "send weekly report"))
    scheduler.push(Task(1, "handle production outage"))
    scheduler.push(Task(5, "update documentation"))
    scheduler.push(Task(2, "review pull request"))

    print("tasks added in this order: report(3), outage(1), docs(5), review(2)")
    print("serving order (by priority, most urgent first):")
    while len(scheduler) > 0:
        print(" ->", scheduler.pop())
