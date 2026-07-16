"""
Lesson 07 - Searching Algorithms
Implements linear search and binary search (both iterative and
recursive), each instrumented to count comparisons so the README can
quote real, executed numbers for the complexity comparison.

Run with:
    python implementation.py
"""


def linear_search(items, target):
    """Checks every element in order until a match is found or the list
    is exhausted. Works on ANY list, sorted or not - this is the whole
    reason it's still useful despite being slower than binary search.

    Returns (index_or_None, comparisons).
    """
    comparisons = 0
    for index, value in enumerate(items):
        comparisons += 1
        if value == target:
            return index, comparisons
    return None, comparisons


def binary_search_iterative(items, target):
    """Repeatedly halves the search range by comparing the target to
    the middle element - requires `items` to already be SORTED, since
    the entire technique relies on "everything left of mid is smaller,
    everything right of mid is larger" to safely discard half the
    remaining range on every comparison.

    Returns (index_or_None, comparisons).
    """
    comparisons = 0
    low = 0
    high = len(items) - 1

    while low <= high:
        mid = (low + high) // 2
        comparisons += 1
        if items[mid] == target:
            return mid, comparisons
        elif items[mid] < target:
            low = mid + 1  # target must be in the right half, if present
        else:
            high = mid - 1  # target must be in the left half, if present

    return None, comparisons


def binary_search_recursive(items, target, low=None, high=None, comparisons=0):
    """Same halving logic as the iterative version, expressed as a
    recursive case (compare mid, recurse into one half) with the base
    case being "range is empty, target isn't here."

    Returns (index_or_None, comparisons). Default args for low/high let
    the first call omit them (defaults to the whole list) while
    recursive calls pass explicit narrowed bounds.
    """
    if low is None:
        low = 0
    if high is None:
        high = len(items) - 1

    if low > high:
        # Base case: the range is empty - there is nowhere left to
        # look, so the target is not in the list.
        return None, comparisons

    mid = (low + high) // 2
    comparisons += 1
    if items[mid] == target:
        return mid, comparisons
    elif items[mid] < target:
        return binary_search_recursive(items, target, mid + 1, high, comparisons)
    else:
        return binary_search_recursive(items, target, low, mid - 1, comparisons)


def main():
    sorted_data = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
    print(f"Sorted data: {sorted_data}")

    print("\n=== linear_search ===")
    for target in [13, 2]:
        index, comparisons = linear_search(sorted_data, target)
        print(f"linear_search(data, {target}) -> index={index}, comparisons={comparisons}")

    print("\n=== binary_search_iterative ===")
    for target in [13, 2]:
        index, comparisons = binary_search_iterative(sorted_data, target)
        print(f"binary_search_iterative(data, {target}) -> index={index}, comparisons={comparisons}")

    print("\n=== binary_search_recursive ===")
    for target in [13, 2]:
        index, comparisons = binary_search_recursive(sorted_data, target)
        print(f"binary_search_recursive(data, {target}) -> index={index}, comparisons={comparisons}")

    print("\n=== Worst case scaling: searching for an absent value in larger lists ===")
    for size in [10, 100, 1000, 10000]:
        big_sorted = list(range(size))
        _, linear_comparisons = linear_search(big_sorted, -1)
        _, binary_comparisons = binary_search_iterative(big_sorted, -1)
        print(f"n={size:>6}: linear_search comparisons={linear_comparisons:>6}, binary_search_iterative comparisons={binary_comparisons}")


if __name__ == "__main__":
    main()
