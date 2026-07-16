"""
Solution 01 - Classify the Complexity
Empirically demonstrates the reflection-question-3 prediction for Function C
(quadratic growth: 10x more input -> ~100x more work), so the reasoning in
solution-01.md isn't just asserted, it's shown running.

Run with:
    python solution-01.py
"""

import time


def c(items):
    total = 0
    for x in items:
        for y in items:
            total += x * y
    return total


def main():
    small = list(range(10))
    large = list(range(100))

    start = time.perf_counter()
    c(small)
    small_time = time.perf_counter() - start

    start = time.perf_counter()
    c(large)
    large_time = time.perf_counter() - start

    print(f"c() on 10 items:  {small_time * 1e6:.3f} microseconds")
    print(f"c() on 100 items: {large_time * 1e6:.3f} microseconds")

    # Guard against a near-zero denominator (small_time can measure as ~0 on
    # a fast machine) so the ratio print never divides by zero.
    if small_time > 0:
        ratio = large_time / small_time
        print(f"Observed ratio: {ratio:.1f}x (O(n^2) predicts roughly 100x for a 10x input increase)")
    else:
        print("small_time measured too close to zero to compute a reliable ratio on this machine.")


if __name__ == "__main__":
    main()
