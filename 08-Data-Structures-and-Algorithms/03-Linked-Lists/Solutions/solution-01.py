"""
Solution 01 - Find the Middle Node

Run with:
    python solution-01.py
"""

import sys
import os

# Import the LinkedList class from the lesson's implementation.py, which
# lives one directory up - this keeps the class definition in one place
# rather than duplicating it here.
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import LinkedList  # noqa: E402


def find_middle(linked_list):
    """Returns the value of the middle node using the slow/fast pointer
    technique, in a single O(n) pass with O(1) extra space.

    `fast` advances two nodes for every one node `slow` advances. Since
    fast covers ground twice as quickly, by the time fast has reached the
    end of the list, slow has covered exactly half the distance - which is
    the middle, by construction, not by coincidence.
    """
    slow = linked_list.head
    fast = linked_list.head

    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next

    return slow.value if slow is not None else None


def build_list(values):
    ll = LinkedList()
    for v in values:
        ll.append(v)
    return ll


def main():
    odd_list = build_list([10, 20, 30, 40, 50])
    even_list = build_list([10, 20, 30, 40])

    print(f"Odd-length list {odd_list.to_list()}  -> middle: {find_middle(odd_list)}")
    print(f"Even-length list {even_list.to_list()} -> middle: {find_middle(even_list)}")


if __name__ == "__main__":
    main()
