def max_non_adjacent_sum(amounts):
    """prev_two = best achievable considering houses up through i-2
    prev_one = best achievable considering houses up through i-1
    At each house i: either skip it (best stays prev_one) or rob it
    (amounts[i] + prev_two, since house i-1 is now off-limits)."""
    prev_two, prev_one = 0, 0
    for amount in amounts:
        current = max(prev_one, amount + prev_two)
        prev_two, prev_one = prev_one, current
    return prev_one


def max_non_adjacent_sum_brute_force(amounts):
    """Cross-check: try every valid (no two adjacent indices) subset directly."""
    n = len(amounts)
    best = 0
    for mask in range(1 << n):
        indices = [i for i in range(n) if mask & (1 << i)]
        if any(indices[k + 1] - indices[k] == 1 for k in range(len(indices) - 1)):
            continue  # two adjacent indices chosen -- not a valid robbery
        best = max(best, sum(amounts[i] for i in indices))
    return best


if __name__ == "__main__":
    test_cases = [
        [1, 2, 3, 1],
        [2, 7, 9, 3, 1],
        [],
        [5],
        [5, 1],
        [3, 2, 5, 10, 7],
    ]

    for amounts in test_cases:
        dp_result = max_non_adjacent_sum(amounts)
        brute_result = max_non_adjacent_sum_brute_force(amounts)
        print(f"{amounts} -> dp={dp_result}, brute_force={brute_result}, match={dp_result == brute_result}")
