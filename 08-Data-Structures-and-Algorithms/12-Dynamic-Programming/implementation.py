"""Dynamic Programming -- coin change (top-down memoization vs. bottom-up
tabulation), longest common subsequence (with actual reconstruction), and 0/1
knapsack. Lesson 08's naive-vs-memoized Fibonacci is this lesson's true
starting point; see that lesson before this one."""


def coin_change_naive(coins, amount, call_counter=None):
    """The BRUTE-FORCE recursive solution: try every coin, recurse on the
    remainder, take the best result. Correct, but re-solves the exact same
    sub-amount many times via different coin orderings -- the same
    overlapping-subproblems issue as naive Fibonacci in Lesson 08."""
    if call_counter is not None:
        call_counter[0] += 1
    if amount == 0:
        return 0
    if amount < 0:
        return float("inf")

    best = float("inf")
    for coin in coins:
        result = coin_change_naive(coins, amount - coin, call_counter)
        if result + 1 < best:
            best = result + 1
    return best


def coin_change_memoized(coins, amount, cache=None, call_counter=None):
    """Top-down: same recursive shape as the naive version, but checks a
    cache keyed by `amount` FIRST -- every distinct amount is solved from
    scratch only once, no matter how many different coin sequences would
    otherwise re-derive it."""
    if cache is None:
        cache = {}
    if call_counter is not None:
        call_counter[0] += 1

    if amount == 0:
        return 0
    if amount < 0:
        return float("inf")
    if amount in cache:
        return cache[amount]

    best = float("inf")
    for coin in coins:
        result = coin_change_memoized(coins, amount - coin, cache, call_counter)
        if result + 1 < best:
            best = result + 1

    cache[amount] = best
    return best


def coin_change_tabulated(coins, amount):
    """Bottom-up: build the answer for EVERY amount from 0 up to the target,
    smallest first, so by the time a larger amount is being solved, every
    smaller amount it depends on is already a known, filled-in table entry --
    no recursion, no cache dictionary, just one array filled left to right."""
    table = [float("inf")] * (amount + 1)
    table[0] = 0
    for current_amount in range(1, amount + 1):
        for coin in coins:
            if coin <= current_amount and table[current_amount - coin] + 1 < table[current_amount]:
                table[current_amount] = table[current_amount - coin] + 1
    return table[amount]


def longest_common_subsequence(a, b):
    """Bottom-up tabulation: table[i][j] = length of the LCS of a[:i] and
    b[:j]. If a[i-1] == b[j-1], that character extends the LCS found for the
    strings one character shorter on both sides (table[i-1][j-1] + 1).
    Otherwise, the best LCS so far is the better of dropping the last
    character of EITHER string (table[i-1][j] or table[i][j-1])."""
    rows, cols = len(a) + 1, len(b) + 1
    table = [[0] * cols for _ in range(rows)]

    for i in range(1, rows):
        for j in range(1, cols):
            if a[i - 1] == b[j - 1]:
                table[i][j] = table[i - 1][j - 1] + 1
            else:
                table[i][j] = max(table[i - 1][j], table[i][j - 1])

    return table[rows - 1][cols - 1], table


def reconstruct_lcs(a, b, table):
    """Walks the filled table BACKWARD from the bottom-right corner to
    recover the actual subsequence, not just its length -- at each cell,
    either the characters matched (move diagonally, record the character) or
    the value came from whichever neighbor (up/left) was larger."""
    i, j = len(a), len(b)
    result = []
    while i > 0 and j > 0:
        if a[i - 1] == b[j - 1]:
            result.append(a[i - 1])
            i -= 1
            j -= 1
        elif table[i - 1][j] >= table[i][j - 1]:
            i -= 1
        else:
            j -= 1
    return "".join(reversed(result))


def knapsack_01(weights, values, capacity):
    """0/1 knapsack: each item is either taken whole or not at all (no
    fractional items, no repeats). table[i][c] = best value achievable using
    only the first i items with capacity c. For each item, either skip it
    (carry forward table[i-1][c]) or take it (if it fits: its own value plus
    the best achievable with the REMAINING capacity using only prior items)."""
    n = len(weights)
    table = [[0] * (capacity + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        weight, value = weights[i - 1], values[i - 1]
        for c in range(capacity + 1):
            table[i][c] = table[i - 1][c]  # option 1: skip item i
            if weight <= c:
                table[i][c] = max(table[i][c], value + table[i - 1][c - weight])  # option 2: take it
    return table[n][capacity]


if __name__ == "__main__":
    print("=== coin change: naive vs. memoized, measuring the exact same call-count blowup as Lesson 08's Fibonacci ===")
    coins = [1, 5, 10, 25]
    # amount=63 for the naive version alone made over 1.15 BILLION recursive
    # calls (confirmed by actually running it) -- dramatic proof of the
    # blowup, but far too slow to include in a lesson meant to be re-run
    # repeatedly. Capped naive's own test amounts at 32 (still a real,
    # visible explosion) while memoized/tabulated ALSO get the larger amount,
    # to show they stay fast exactly where naive becomes infeasible.
    for amount in [11, 20, 32]:
        naive_counter = [0]
        naive_result = coin_change_naive(coins, amount, naive_counter)
        memo_counter = [0]
        memo_result = coin_change_memoized(coins, amount, call_counter=memo_counter)
        tab_result = coin_change_tabulated(coins, amount)
        print(f"amount={amount}: naive={naive_result} ({naive_counter[0]} calls), "
              f"memoized={memo_result} ({memo_counter[0]} calls), tabulated={tab_result}")

    print("\n(naive is skipped above amount=32 -- it was actually measured once at "
          "amount=63 and made 1,154,223,045 calls, versus memoized's 253 and "
          "tabulated's direct O(amount * len(coins)) computation)")
    large_amount = 63
    memo_counter = [0]
    memo_result = coin_change_memoized(coins, large_amount, call_counter=memo_counter)
    tab_result = coin_change_tabulated(coins, large_amount)
    print(f"amount={large_amount}: memoized={memo_result} ({memo_counter[0]} calls), tabulated={tab_result}")

    print("\n=== longest common subsequence ===")
    a, b = "ABCBDAB", "BDCABA"
    length, table = longest_common_subsequence(a, b)
    actual_subsequence = reconstruct_lcs(a, b, table)
    print(f'LCS("{a}", "{b}") length = {length}')
    print(f"reconstructed subsequence = {actual_subsequence!r}")
    print("reconstructed length matches table length:", len(actual_subsequence) == length)
    # Independently verify the reconstructed string really IS a subsequence of both.
    def is_subsequence(sub, full):
        it = iter(full)
        return all(char in it for char in sub)
    print("is a genuine subsequence of a:", is_subsequence(actual_subsequence, a))
    print("is a genuine subsequence of b:", is_subsequence(actual_subsequence, b))

    print("\n=== 0/1 knapsack ===")
    weights = [2, 3, 4, 5]
    values = [3, 4, 5, 6]
    capacity = 5
    best_value = knapsack_01(weights, values, capacity)
    print(f"weights={weights}, values={values}, capacity={capacity}")
    print("best achievable value:", best_value)

    # Brute-force cross-check: try every subset, confirm the DP answer matches.
    from itertools import combinations
    best_brute = 0
    n = len(weights)
    for size in range(n + 1):
        for subset in combinations(range(n), size):
            total_weight = sum(weights[i] for i in subset)
            total_value = sum(values[i] for i in subset)
            if total_weight <= capacity and total_value > best_brute:
                best_brute = total_value
    print("brute-force best value (every subset checked):", best_brute)
    print("DP matches brute force:", best_value == best_brute)
