"""
Solution 01 - Find the First and Last Position of a Target

Run with:
    python solution-01.py
"""


def find_range(items, target):
    """Returns (first_index, last_index) of target in a SORTED list
    that may contain duplicates, using two O(log n) binary searches
    instead of an O(n) linear scan.

    Both helper searches use the same halving logic as ordinary binary
    search, but neither stops immediately on a match - each keeps
    narrowing in one direction to find the boundary, recording the best
    match seen so far.
    """
    first = _search_bound(items, target, find_first=True)
    if first == -1:
        return -1, -1
    last = _search_bound(items, target, find_first=False)
    return first, last


def _search_bound(items, target, find_first):
    low = 0
    high = len(items) - 1
    result = -1

    while low <= high:
        mid = (low + high) // 2
        if items[mid] == target:
            result = mid
            # Found a match, but there may be more matches further in
            # the biased direction - keep narrowing that way instead of
            # stopping, recording each better match as we go.
            if find_first:
                high = mid - 1
            else:
                low = mid + 1
        elif items[mid] < target:
            low = mid + 1
        else:
            high = mid - 1

    return result


def main():
    data = [5, 7, 7, 7, 8, 8, 10]
    for target in [7, 8, 6]:
        print(f"find_range({data}, {target}) -> {find_range(data, target)}")


if __name__ == "__main__":
    main()
