"""
Lesson 08 - Recursion
Covers the base case / recursive case pattern through factorial,
Fibonacci (naive vs. memoized), and a backtracking-flavored example
(generating all subsets of a list) that previews later topics like
Dynamic Programming and Greedy Algorithms.

Run with:
    python implementation.py
"""


def factorial(n):
    """Computes n! = n * (n-1) * (n-2) * ... * 1.

    Base case: factorial(0) = 1 (and factorial(1) = 1) - the point
    where the function can answer directly without recursing further.
    Recursive case: factorial(n) = n * factorial(n-1) - trusts that a
    smaller version of the exact same problem, once solved, can be
    combined with the current step to solve the whole thing.
    """
    if n <= 1:
        return 1
    return n * factorial(n - 1)


def fibonacci_naive(n, call_counter=None):
    """Computes the nth Fibonacci number (0-indexed: fib(0)=0, fib(1)=1)
    via direct recursion, with NO caching of repeated subproblems.

    Base cases: fib(0) = 0, fib(1) = 1.
    Recursive case: fib(n) = fib(n-1) + fib(n-2).

    call_counter (a single-item list used as a mutable "out parameter")
    tracks how many times this function is actually invoked, to make
    the exponential blowup from redundant recomputation measurable
    rather than theoretical - see the README for why fib(n-2) gets
    computed from scratch many times over instead of being reused.
    """
    if call_counter is not None:
        call_counter[0] += 1

    if n <= 1:
        return n
    return fibonacci_naive(n - 1, call_counter) + fibonacci_naive(n - 2, call_counter)


def fibonacci_memoized(n, cache=None, call_counter=None):
    """Same recursive definition as fibonacci_naive, but stores every
    result the first time it's computed in `cache`, so any later call
    asking for a value already computed returns it in O(1) instead of
    recomputing the entire subtree beneath it.

    This trades O(1) extra recursive-call overhead for O(n) space (the
    cache) to turn exponential time into linear time - the technique
    this previews is the core idea behind Dynamic Programming (Lesson 12).
    """
    if cache is None:
        cache = {}
    if call_counter is not None:
        call_counter[0] += 1

    if n in cache:
        return cache[n]
    if n <= 1:
        return n

    result = fibonacci_memoized(n - 1, cache, call_counter) + fibonacci_memoized(n - 2, cache, call_counter)
    cache[n] = result
    return result


def all_subsets(items):
    """Generates every possible subset (the power set) of `items`,
    using a backtracking pattern: for each element, recursively explore
    BOTH the choice of "include it" and the choice of "exclude it," then
    undo the choice (backtrack) before trying the next branch.

    This is a preview of the general backtracking pattern used more
    fully once Trees, Graphs, and Dynamic Programming are covered later
    in the curriculum - the core shape (choose, recurse, un-choose) is
    identical, just applied to a plain list here for simplicity.

    Returns a list of lists; for n items there are always 2**n subsets,
    since each of the n elements independently is either in or out.
    """
    results = []

    def backtrack(start_index, current_subset):
        # Every partial `current_subset` built so far - including the
        # empty one at the very first call - is itself a valid subset,
        # so it's recorded before any further branching happens.
        results.append(current_subset.copy())

        for i in range(start_index, len(items)):
            current_subset.append(items[i])       # choose
            backtrack(i + 1, current_subset)       # recurse
            current_subset.pop()                   # un-choose (backtrack)

    backtrack(0, [])
    return results


def main():
    print("=== factorial ===")
    for n in [0, 1, 5, 7]:
        print(f"factorial({n}) -> {factorial(n)}")

    print("\n=== fibonacci_naive (with call counts, showing exponential blowup) ===")
    for n in [5, 10, 20]:
        counter = [0]
        result = fibonacci_naive(n, counter)
        print(f"fibonacci_naive({n}) -> {result}, function calls made: {counter[0]}")

    print("\n=== fibonacci_memoized (same results, linear call count) ===")
    for n in [5, 10, 20]:
        counter = [0]
        result = fibonacci_memoized(n, call_counter=counter)
        print(f"fibonacci_memoized({n}) -> {result}, function calls made: {counter[0]}")

    print("\n=== all_subsets (backtracking preview) ===")
    items = [1, 2, 3]
    subsets = all_subsets(items)
    print(f"all_subsets({items}) -> {subsets}")
    print(f"count: {len(subsets)} (expected 2**{len(items)} = {2 ** len(items)})")


if __name__ == "__main__":
    main()
