"""
Lesson 03 - Linked Lists
Implements a singly linked list from scratch: Node + LinkedList classes
with append, prepend, delete, search, and reverse.

Run with:
    python implementation.py
"""


class Node:
    """A single link in the chain: a value plus a pointer to the next Node.

    Unlike an array element, a Node does not live at a predictable memory
    offset from its neighbors - it only knows where the NEXT node is, via
    an explicit reference. That's the entire mechanism that makes linked
    lists behave so differently from arrays.
    """

    def __init__(self, value):
        self.value = value
        self.next = None  # None means "this is the last node"


class LinkedList:
    """A singly linked list: a chain of Nodes, tracked via a head pointer.

    We keep a `head` reference (the first node) and derive everything else
    by walking `.next` pointers. There is no random access - reaching the
    5th element means following 5 links one at a time, which is the core
    trade-off versus an array (Lesson 02).
    """

    def __init__(self):
        self.head = None

    def is_empty(self):
        return self.head is None

    def append(self, value):
        """Add a new value at the END of the list. O(n): must walk to the
        last node first, since we don't keep a separate tail pointer here
        (a production implementation often would, to make this O(1) - see
        the Common Mistakes section in the README for that trade-off).
        """
        new_node = Node(value)
        if self.is_empty():
            self.head = new_node
            return
        current = self.head
        while current.next is not None:
            current = current.next
        current.next = new_node

    def prepend(self, value):
        """Add a new value at the FRONT of the list. O(1): no walking
        needed - we just point the new node at the old head and make the
        new node the head. This is the operation linked lists are strictly
        better at than arrays (compare to Lesson 02's insert(0, x): O(n)).
        """
        new_node = Node(value)
        new_node.next = self.head
        self.head = new_node

    def delete(self, value):
        """Remove the FIRST node holding `value`. O(n): must walk the list
        looking for it, and must track the PREVIOUS node so we can re-link
        around the node being removed (a singly linked list has no way to
        go backward, so we can't discover the previous node any other way
        than remembering it as we walk forward).

        Returns True if a node was removed, False if `value` wasn't found.
        """
        if self.is_empty():
            return False

        if self.head.value == value:
            # Special case: removing the head means just moving the head
            # pointer forward - there is no "previous" node to re-link.
            self.head = self.head.next
            return True

        previous = self.head
        current = self.head.next
        while current is not None:
            if current.value == value:
                previous.next = current.next  # skip over `current`, removing it from the chain
                return True
            previous = current
            current = current.next
        return False

    def search(self, value):
        """Returns True if `value` exists anywhere in the list. O(n): no
        shortcut exists - must check nodes one at a time from the head.
        """
        current = self.head
        while current is not None:
            if current.value == value:
                return True
            current = current.next
        return False

    def reverse(self):
        """Reverses the list IN PLACE by re-pointing every `.next` link to
        point backward instead of forward. O(n) time, O(1) extra space -
        we only ever hold three pointers at once, regardless of list length.
        """
        previous = None
        current = self.head
        while current is not None:
            next_node = current.next  # save it before we overwrite current.next
            current.next = previous   # flip the link to point backward
            previous = current        # advance previous
            current = next_node       # advance current using the saved reference
        self.head = previous  # after the loop, `previous` is the new first node

    def to_list(self):
        """Converts to a Python list for easy printing/testing/comparison."""
        result = []
        current = self.head
        while current is not None:
            result.append(current.value)
            current = current.next
        return result

    def __len__(self):
        count = 0
        current = self.head
        while current is not None:
            count += 1
            current = current.next
        return count


def main():
    ll = LinkedList()
    print(f"New list. Empty? {ll.is_empty()}, contents: {ll.to_list()}")

    print("\n--- append(10), append(20), append(30) ---")
    ll.append(10)
    ll.append(20)
    ll.append(30)
    print(f"Contents: {ll.to_list()}, length: {len(ll)}")

    print("\n--- prepend(5) ---")
    ll.prepend(5)
    print(f"Contents: {ll.to_list()}")

    print("\n--- search(20), search(99) ---")
    print(f"search(20) -> {ll.search(20)}")
    print(f"search(99) -> {ll.search(99)}")

    print("\n--- delete(20) ---")
    deleted = ll.delete(20)
    print(f"delete(20) returned {deleted}, contents now: {ll.to_list()}")

    print("\n--- delete(999) [not present] ---")
    deleted = ll.delete(999)
    print(f"delete(999) returned {deleted}, contents unchanged: {ll.to_list()}")

    print("\n--- delete(5) [the head] ---")
    deleted = ll.delete(5)
    print(f"delete(5) returned {deleted}, contents now: {ll.to_list()}")

    print("\n--- reverse() ---")
    ll.append(40)
    ll.append(50)
    print(f"Before reverse: {ll.to_list()}")
    ll.reverse()
    print(f"After reverse:  {ll.to_list()}")


if __name__ == "__main__":
    main()
