"""
Solution 01 - Count Inversions While Sorting

Run with:
    python solution-01.py
"""


def count_inversions(items):
    """Counts inversions (pairs i<j with arr[i] > arr[j]) in O(n log n)
    using a merge-sort-shaped divide and conquer, instead of the O(n^2)
    of checking every pair directly.

    The counting trick lives entirely in the merge step: both halves
    arrive already individually sorted (by recursion), so the moment an
    element from the RIGHT half is taken because it's smaller than the
    current LEFT element, every remaining left-half element (there are
    `len(left) - i` of them) is also greater than that right element -
    all of those pairs are inversions, counted in one O(1) step instead
    of individually.
    """
    _, total_inversions = _sort_and_count(items)
    return total_inversions


def _sort_and_count(items):
    if len(items) <= 1:
        return items, 0

    mid = len(items) // 2
    left, left_inversions = _sort_and_count(items[:mid])
    right, right_inversions = _sort_and_count(items[mid:])
    merged, split_inversions = _merge_and_count(left, right)

    return merged, left_inversions + right_inversions + split_inversions


def _merge_and_count(left, right):
    result = []
    i = j = 0
    inversions = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            # right[j] is smaller than left[i], and left is sorted, so
            # right[j] is also smaller than every left element from i
            # onward - that's len(left) - i inversions counted at once.
            result.append(right[j])
            inversions += len(left) - i
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result, inversions


def brute_force_count(items):
    """O(n^2) reference implementation used only to cross-check the
    fast version - not something you'd ship, but the direct definition
    of "inversion" made literal.
    """
    count = 0
    n = len(items)
    for i in range(n):
        for j in range(i + 1, n):
            if items[i] > items[j]:
                count += 1
    return count


def main():
    cases = [
        [1, 2, 3, 4, 5],
        [5, 4, 3, 2, 1],
        [2, 4, 1, 3, 5],
    ]
    for case in cases:
        fast = count_inversions(case)
        slow = brute_force_count(case)
        print(f"count_inversions({case}) -> {fast} (brute force check: {slow})")


if __name__ == "__main__":
    main()
