"""
Solution 04 - Deduplicate While Preserving Order
See: ../20-Exercises/README.md#exercise-04--deduplicate-while-preserving-order-intermediate

Run with:
    python solution-04.py

Expected output:
    Loop version:    [3, 1, 2, 4]
    One-liner (dict): [3, 1, 2, 4]
    Both match: True
"""


def dedupe_loop(items: list) -> list:
    seen = set()
    result = []
    for item in items:
        # A set gives O(1) average membership checks, so this stays O(n)
        # overall instead of the O(n^2) that "if item not in result" would cause.
        if item not in seen:
            seen.add(item)
            result.append(item)
    return result


def dedupe_oneliner(items: list) -> list:
    # dict.fromkeys() keeps only the FIRST occurrence of each key (later
    # duplicate keys don't move position), and since Python 3.7 dicts
    # preserve insertion order - so converting back to a list preserves
    # first-seen order for free.
    return list(dict.fromkeys(items))


if __name__ == "__main__":
    data = [3, 1, 2, 3, 1, 4]
    loop_result = dedupe_loop(data)
    oneliner_result = dedupe_oneliner(data)
    print(f"Loop version:    {loop_result}")
    print(f"One-liner (dict): {oneliner_result}")
    print(f"Both match: {loop_result == oneliner_result}")
