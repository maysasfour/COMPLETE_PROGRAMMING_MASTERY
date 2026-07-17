import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from implementation import MinHeap


def kth_largest(values, k):
    if k > len(values) or k < 1:
        raise ValueError(f"k={k} is out of range for a list of length {len(values)}")

    heap = MinHeap()
    for value in values:
        heap.push(value)
        if len(heap) > k:
            heap.pop()  # discard the current smallest, keeping only the k largest so far

    return heap.peek()


if __name__ == "__main__":
    print("kth_largest([3, 1, 5, 12, 2, 11], 2) ->", kth_largest([3, 1, 5, 12, 2, 11], 2), "(expected 11)")
    print("kth_largest([3, 1, 5, 12, 2, 11], 1) ->", kth_largest([3, 1, 5, 12, 2, 11], 1), "(expected 12)")
    print("kth_largest([3, 1, 5, 12, 2, 11], 4) ->", kth_largest([3, 1, 5, 12, 2, 11], 4), "(expected 3)")

    try:
        kth_largest([1, 2, 3], 5)
    except ValueError as e:
        print("kth_largest([1,2,3], 5) correctly raised:", e)
