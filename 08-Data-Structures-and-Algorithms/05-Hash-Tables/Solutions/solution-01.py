"""
Solution 01 - Detect the First Duplicate

Run with:
    python solution-01.py
"""


def first_duplicate(items):
    """Returns the first value seen a second time while scanning left to
    right, or None if every value is unique.

    A `set` gives average-case O(1) membership testing, which is what
    keeps this a single O(n) pass instead of the O(n^2) alternative of
    comparing every pair of elements.
    """
    seen = set()
    for item in items:
        if item in seen:
            return item
        seen.add(item)
    return None


def main():
    case_1 = [3, 1, 4, 1, 5, 9, 2, 6]
    case_2 = [3, 1, 4, 5, 9, 2, 6]
    case_3 = [7, 7, 7]

    print(f"first_duplicate({case_1}) -> {first_duplicate(case_1)}")
    print(f"first_duplicate({case_2}) -> {first_duplicate(case_2)}")
    print(f"first_duplicate({case_3}) -> {first_duplicate(case_3)}")


if __name__ == "__main__":
    main()
