"""
Solution 02 - Detect a Cycle

Run with:
    python solution-02.py
"""

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import LinkedList, Node  # noqa: E402


def has_cycle(linked_list):
    """Returns True if the linked list contains a cycle, using Floyd's
    cycle detection ("tortoise and hare") in O(n) time and O(1) space.

    Two pointers walk the list at different speeds. If there's no cycle,
    `fast` simply reaches the end (None) and we correctly return False.
    If there IS a cycle, both pointers are forever confined to looping
    within it - and because fast gains on slow by exactly one extra node
    of progress every iteration, it is guaranteed to eventually land on
    the exact same node as slow (they can't skip past each other onto
    non-matching nodes forever within a finite loop).
    """
    slow = linked_list.head
    fast = linked_list.head

    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next
        if slow is fast:
            # Identity comparison ("is"), NOT value comparison ("==") -
            # matters because duplicate VALUES are completely normal in a
            # valid, cycle-free list and would cause false positives if we
            # compared by value instead of by which actual node object we're on.
            return True
    return False


def build_cyclic_list(values, cycle_back_to_index):
    """Manually builds a linked list where the last node's .next points
    back to an earlier node - LinkedList.append/prepend never produce
    this, so a cycle must be constructed by hand for testing.
    """
    ll = LinkedList()
    nodes = []
    for v in values:
        node = Node(v)
        nodes.append(node)
        if ll.head is None:
            ll.head = node
        else:
            nodes[-2].next = node
    nodes[-1].next = nodes[cycle_back_to_index]  # create the cycle
    return ll


def main():
    normal = LinkedList()
    for v in [1, 2, 3, 4]:
        normal.append(v)
    print(f"Normal list {normal.to_list()} -> has_cycle: {has_cycle(normal)}")

    cyclic = build_cyclic_list([1, 2, 3, 4], cycle_back_to_index=1)
    print(f"Cyclic list (1->2->3->4->back to 2) -> has_cycle: {has_cycle(cyclic)}")

    single_self_loop = build_cyclic_list([1], cycle_back_to_index=0)
    print(f"Single self-looping node -> has_cycle: {has_cycle(single_self_loop)}")

    empty = LinkedList()
    print(f"Empty list -> has_cycle: {has_cycle(empty)}")


if __name__ == "__main__":
    main()
