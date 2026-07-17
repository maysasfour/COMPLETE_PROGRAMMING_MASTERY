import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import TreeNode


def is_valid_bst(node, low=float("-inf"), high=float("inf")):
    if node is None:
        return True
    if not (low < node.value < high):
        return False
    return is_valid_bst(node.left, low, node.value) and is_valid_bst(node.right, node.value, high)


def naive_local_check(node):
    """The WRONG approach, kept here deliberately to prove it's wrong: only
    compares each node against its immediate children, missing violations
    further down the tree."""
    if node is None:
        return True
    if node.left is not None and node.left.value >= node.value:
        return False
    if node.right is not None and node.right.value <= node.value:
        return False
    return naive_local_check(node.left) and naive_local_check(node.right)


if __name__ == "__main__":
    # A genuinely valid BST.
    valid_root = TreeNode(5)
    valid_root.left = TreeNode(3)
    valid_root.right = TreeNode(8)
    valid_root.right.left = TreeNode(6)
    valid_root.right.right = TreeNode(9)

    # The deliberately invalid tree from the exercise: 4 is in 5's right
    # subtree but is less than 5.
    invalid_root = TreeNode(5)
    invalid_root.left = TreeNode(3)
    invalid_root.right = TreeNode(8)
    invalid_root.right.left = TreeNode(4)
    invalid_root.right.right = TreeNode(9)

    print("=== is_valid_bst (the correct, range-based check) ===")
    print("valid tree  ->", is_valid_bst(valid_root))
    print("invalid tree->", is_valid_bst(invalid_root))

    print("\n=== naive_local_check (the WRONG approach) -- proving it's wrong ===")
    print("valid tree  ->", naive_local_check(valid_root))
    print("invalid tree->", naive_local_check(invalid_root), "<- WRONG, should be False")
