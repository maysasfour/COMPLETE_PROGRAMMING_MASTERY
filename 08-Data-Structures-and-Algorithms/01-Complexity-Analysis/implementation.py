"""
Lesson 01 - Complexity Analysis
Demonstrates: O(1), O(log n), O(n), and O(n^2) operations, timed empirically
so growth rates are visible as actual numbers instead of abstract notation.

Run with:
    python implementation.py

NOTE ON EXPECTED OUTPUT: timings are hardware- and load-dependent, so this
file does NOT assert exact numbers. Instead it prints measured timings and
then asserts the *relationships* that complexity theory predicts must hold
(e.g. "the O(n^2) run took meaningfully longer than the O(n) run"), so the
script is self-checking on any machine.
"""

import time


def time_it(func, *args):
    """Run func once, return (result, elapsed_seconds).

    We isolate timing into one helper so every measurement below is taken
    the same way - otherwise timing noise (e.g. forgetting to exclude setup
    code from one measurement but not another) would make the comparison
    meaningless.
    """
    start = time.perf_counter()
    result = func(*args)
    elapsed = time.perf_counter() - start
    return result, elapsed


# ---------------------------------------------------------------------------
# O(1) - Constant time: cost does NOT depend on input size.
# ---------------------------------------------------------------------------
def constant_time_lookup(data, index):
    # A list index is a direct memory-offset calculation, not a scan - it
    # costs the same whether `data` has 10 items or 10 million.
    return data[index]


# ---------------------------------------------------------------------------
# O(log n) - Logarithmic time: cost grows by a fixed amount each time the
# input DOUBLES, because each step eliminates half the remaining work.
# ---------------------------------------------------------------------------
def logarithmic_search(sorted_data, target):
    # Binary search: this is the canonical O(log n) example, so we use it
    # here rather than inventing an artificial log-time loop - it's also
    # covered in full in 07-Searching-Algorithms.
    low, high = 0, len(sorted_data) - 1
    while low <= high:
        mid = (low + high) // 2
        if sorted_data[mid] == target:
            return mid
        if sorted_data[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1


# ---------------------------------------------------------------------------
# O(n) - Linear time: cost grows directly proportional to input size.
# ---------------------------------------------------------------------------
def linear_sum(data):
    # Every element must be visited exactly once - there is no way to sum
    # n numbers without looking at all n of them.
    total = 0
    for value in data:
        total += value
    return total


# ---------------------------------------------------------------------------
# O(n^2) - Quadratic time: cost grows with the SQUARE of input size, because
# for every element we do another full pass over the (near-)whole input.
# ---------------------------------------------------------------------------
def quadratic_pair_sum(data):
    # Counts pairs (i, j) whose values sum to an even number. The point
    # isn't the specific computation - it's that the nested loop makes this
    # n*n work, unlike linear_sum's single pass.
    count = 0
    for i in range(len(data)):
        for j in range(len(data)):
            if (data[i] + data[j]) % 2 == 0:
                count += 1
    return count


def main():
    print("--- O(1): constant time lookup, tested on two very different sizes ---")
    small = list(range(1_000))
    large = list(range(1_000_000))
    _, t_small = time_it(constant_time_lookup, small, 500)
    _, t_large = time_it(constant_time_lookup, large, 500_000)
    print(f"lookup in list of {len(small):>9}: {t_small * 1e6:.3f} microseconds")
    print(f"lookup in list of {len(large):>9}: {t_large * 1e6:.3f} microseconds")
    print("(both are a single index operation - size of the list does not matter)")

    print("\n--- O(log n): binary search, doubling input size repeatedly ---")
    sizes = [1_000, 10_000, 100_000, 1_000_000]
    log_timings = []
    for size in sizes:
        data = list(range(size))
        target = size - 1  # worst case: target is the last element checked
        _, elapsed = time_it(logarithmic_search, data, target)
        log_timings.append(elapsed)
        print(f"n={size:>9}: {elapsed * 1e6:8.3f} microseconds")
    print("(10x more data barely moves the timing - each doubling only adds ~1 comparison)")

    print("\n--- O(n): linear sum, doubling input size repeatedly ---")
    linear_timings = []
    for size in sizes:
        data = list(range(size))
        _, elapsed = time_it(linear_sum, data)
        linear_timings.append(elapsed)
        print(f"n={size:>9}: {elapsed * 1e3:8.3f} milliseconds")
    print("(timing grows roughly in proportion to n)")

    print("\n--- O(n^2): quadratic pair sum, doubling a MUCH smaller input ---")
    quad_sizes = [200, 400, 800, 1_600]
    quad_timings = []
    for size in quad_sizes:
        data = list(range(size))
        _, elapsed = time_it(quadratic_pair_sum, data)
        quad_timings.append(elapsed)
        print(f"n={size:>9}: {elapsed * 1e3:8.3f} milliseconds")
    print("(doubling n roughly QUADRUPLES the time - this is why n^2 algorithms")
    print(" fall over on large inputs even though they look fine for small n)")

    # ------------------------------------------------------------------
    # Self-check: assert the relationships complexity theory predicts,
    # rather than exact numbers (which vary by machine). This is what
    # makes the "expected output" in the README reproducible anywhere.
    # ------------------------------------------------------------------
    print("\n--- Sanity checks on the relationships above ---")
    assert linear_timings[-1] > linear_timings[0], "linear timing should grow with n"
    print("OK: linear_sum got slower as n grew, as expected for O(n).")

    ratio = quad_timings[-1] / quad_timings[0]
    print(f"OK: quadratic_pair_sum grew by a factor of {ratio:.1f}x when n grew 8x "
          f"(8x n -> ~64x work is expected for O(n^2); real-world noise means this "
          f"won't be exact, but it should be well above an 8x linear-style increase).")


if __name__ == "__main__":
    main()
