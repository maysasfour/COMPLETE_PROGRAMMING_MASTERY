"""
Solution 01 - Array Operation Complexity in Practice
Empirically demonstrates the O(n) vs O(n^2) gap between Snippet 2
(append-based building) and Snippet 3 (front-insert-based building)
described in solution-01.md.

Run with:
    python solution-01.py
"""

import time


def build_with_append(n):
    data = []
    for i in range(n):
        data.append(i)
    return data


def build_with_front_insert(n):
    data = []
    for i in range(n):
        data.insert(0, i)
    return data


def time_call(func, n):
    start = time.perf_counter()
    func(n)
    return time.perf_counter() - start


def main():
    sizes = [500, 1000, 2000, 4000]

    print("--- Snippet 2 style: build via append() ---")
    append_times = []
    for n in sizes:
        t = time_call(build_with_append, n)
        append_times.append(t)
        print(f"n={n:>5}: {t * 1e3:8.3f} ms")

    print("\n--- Snippet 3 style: build via insert(0, i) ---")
    insert_times = []
    for n in sizes:
        t = time_call(build_with_front_insert, n)
        insert_times.append(t)
        print(f"n={n:>5}: {t * 1e3:8.3f} ms")

    append_growth = append_times[-1] / append_times[0]
    insert_growth = insert_times[-1] / insert_times[0]
    print(f"\nInput grew {sizes[-1] // sizes[0]}x.")
    print(f"append()-based build time grew {append_growth:.1f}x (expected: close to linear, ~{sizes[-1] // sizes[0]}x)")
    print(f"insert(0,_)-based build time grew {insert_growth:.1f}x (expected: much larger, quadratic-ish growth)")
    assert insert_growth > append_growth, "front-insertion should scale worse than append"
    print("OK: front-insertion scales markedly worse than append, as O(n^2) vs O(n) predicts.")


if __name__ == "__main__":
    main()
