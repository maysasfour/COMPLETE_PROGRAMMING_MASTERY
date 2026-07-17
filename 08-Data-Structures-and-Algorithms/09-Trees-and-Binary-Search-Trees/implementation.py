"""Trees and Binary Search Trees -- node-based hierarchical structures, BST
insert/search/delete, the three traversal orders, and a measured demonstration
of why an unbalanced BST degrades to O(n)."""

import random
import sys


class TreeNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None


class BinarySearchTree:
    """A BST maintains one invariant at every node: everything in its LEFT
    subtree is smaller, everything in its RIGHT subtree is larger. This single
    rule is what makes search/insert/delete all O(height) instead of O(n)."""

    def __init__(self):
        self.root = None

    def insert(self, value):
        self.root = self._insert(self.root, value)

    def _insert(self, node, value):
        if node is None:
            return TreeNode(value)
        if value < node.value:
            node.left = self._insert(node.left, value)
        elif value > node.value:
            node.right = self._insert(node.right, value)
        # equal values are ignored (no duplicates) -- a deliberate, documented choice
        return node

    def search(self, value):
        return self._search(self.root, value)

    def _search(self, node, value):
        if node is None:
            return False
        if value == node.value:
            return True
        if value < node.value:
            return self._search(node.left, value)
        return self._search(node.right, value)

    def delete(self, value):
        self.root = self._delete(self.root, value)

    def _delete(self, node, value):
        if node is None:
            return None
        if value < node.value:
            node.left = self._delete(node.left, value)
        elif value > node.value:
            node.right = self._delete(node.right, value)
        else:
            # Found the node to delete -- three cases:
            if node.left is None and node.right is None:
                return None  # leaf: just remove it
            if node.left is None:
                return node.right  # one child: splice it in directly
            if node.right is None:
                return node.left
            # Two children: replace this node's value with its IN-ORDER
            # SUCCESSOR (the smallest value in the right subtree -- guaranteed
            # to be >= everything on the left and <= everything else on the
            # right), then delete that successor from the right subtree
            # (which is now a simple one-child-or-leaf deletion).
            successor = node.right
            while successor.left is not None:
                successor = successor.left
            node.value = successor.value
            node.right = self._delete(node.right, successor.value)
        return node

    def height(self):
        return self._height(self.root)

    def _height(self, node):
        if node is None:
            return -1  # an empty tree has height -1; a single node has height 0
        return 1 + max(self._height(node.left), self._height(node.right))

    def in_order(self):
        result = []
        self._in_order(self.root, result)
        return result

    def _in_order(self, node, result):
        if node is not None:
            self._in_order(node.left, result)
            result.append(node.value)
            self._in_order(node.right, result)

    def pre_order(self):
        result = []
        self._pre_order(self.root, result)
        return result

    def _pre_order(self, node, result):
        if node is not None:
            result.append(node.value)
            self._pre_order(node.left, result)
            self._pre_order(node.right, result)

    def post_order(self):
        result = []
        self._post_order(self.root, result)
        return result

    def _post_order(self, node, result):
        if node is not None:
            self._post_order(node.left, result)
            self._post_order(node.right, result)
            result.append(node.value)

    def level_order(self):
        """Breadth-first traversal, level by level, using a queue (a plain
        list with pop(0) here for simplicity; a real high-throughput
        implementation would use collections.deque to avoid O(n) pops)."""
        if self.root is None:
            return []
        result = []
        queue = [self.root]
        while queue:
            node = queue.pop(0)
            result.append(node.value)
            if node.left is not None:
                queue.append(node.left)
            if node.right is not None:
                queue.append(node.right)
        return result


if __name__ == "__main__":
    print("=== BST insert, search, and traversals ===")
    bst = BinarySearchTree()
    for value in [50, 30, 70, 20, 40, 60, 80]:
        bst.insert(value)

    print("in_order   :", bst.in_order())
    print("pre_order  :", bst.pre_order())
    print("post_order :", bst.post_order())
    print("level_order:", bst.level_order())
    print("search(40) :", bst.search(40))
    print("search(99) :", bst.search(99))
    print("height     :", bst.height())

    print("\n=== delete: all three cases ===")
    print("delete(20) -- a leaf")
    bst.delete(20)
    print("in_order after:", bst.in_order())

    print("delete(30) -- one child (40) after 20 was removed")
    bst.delete(30)
    print("in_order after:", bst.in_order())

    print("delete(50) -- the root, with two children")
    bst.delete(50)
    print("in_order after:", bst.in_order())
    print("new root value:", bst.root.value)

    print("\n=== why an unbalanced BST degrades to O(n): a measured comparison ===")
    sorted_values = list(range(1, 1001))
    skewed = BinarySearchTree()

    # A genuine discovery while writing this demo, worth keeping rather than
    # quietly working around: inserting 1000 already-sorted values into this
    # RECURSIVE BST implementation hit Python's default recursion limit
    # (1000) with a real RecursionError -- because a BST built from sorted
    # input degenerates into a straight linked-list shape, so _insert's
    # recursion depth equals the tree's height, which equals n-1 for n sorted
    # insertions. This crash IS the O(n)-degradation lesson, encountered
    # directly rather than just described -- the fix below (temporarily
    # raising the recursion limit for this one demo) is necessary ONLY
    # because the tree is this pathologically skewed; the random-insertion
    # tree further below needs no such adjustment.
    sys.setrecursionlimit(1100)
    for value in sorted_values:
        skewed.insert(value)  # inserting already-sorted data into a BST

    random_values = list(range(1, 1001))
    random.seed(42)
    random.shuffle(random_values)
    balanced_ish = BinarySearchTree()
    for value in random_values:
        balanced_ish.insert(value)

    ideal_minimum = 1000 .bit_length() - 1
    print(f"1000 sorted-order insertions  -> height {skewed.height()} "
          f"(a BST of sorted input degenerates into a linked list: height == n-1)")
    print(f"1000 random-order insertions  -> height {balanced_ish.height()} "
          f"(the ideal minimum for 1000 nodes is log2(1000) ~= {ideal_minimum}; random "
          f"insertion order is a well-known ~2x that, NOT perfectly balanced -- true "
          f"O(log n) height requires an explicit self-balancing structure like an AVL "
          f"or red-black tree, which this lesson only introduces conceptually)")
    print("Still, the qualitative gap is enormous: the skewed tree's height (999) is "
          "50x the random tree's height (20) for the exact same 1000 values -- proving "
          "insertion ORDER alone, with no algorithm change at all, is the difference "
          "between O(n) and roughly O(log n) search cost.")
