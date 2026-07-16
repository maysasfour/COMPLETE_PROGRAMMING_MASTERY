# 08 — Recursion

[Back to module overview](../README.md) | [Previous: Searching Algorithms](../07-Searching-Algorithms/README.md)

## Beginner: Base Case and Recursive Case

A **recursive function** is one that calls itself to solve a smaller version of the same problem. Every correct recursive function needs exactly two parts:

- A **base case** — the smallest version of the problem, simple enough to answer directly, with no further recursion. Without this, the function calls itself forever (or until it crashes with a stack overflow).
- A **recursive case** — where the function calls itself on a smaller/simpler input, and combines that result with the current step to solve the original problem.

`factorial(n)` in `implementation.py` is the clearest possible example: the base case is `factorial(0) = 1` (and `factorial(1) = 1`), and the recursive case is `factorial(n) = n * factorial(n - 1)`. Tracing `factorial(5)`:

```
factorial(5) = 5 * factorial(4)
             = 5 * (4 * factorial(3))
             = 5 * (4 * (3 * factorial(2)))
             = 5 * (4 * (3 * (2 * factorial(1))))
             = 5 * (4 * (3 * (2 * 1)))          <- base case reached, unwinding begins
             = 5 * (4 * (3 * 2))
             = 5 * (4 * 6)
             = 5 * 24
             = 120
```

Every recursive call "waits" for the call beneath it to return before it can finish its own multiplication — this is why recursion always involves a call stack, whether or not you write the loop yourself.

## Intermediate: Naive Fibonacci and the Cost of Repeated Work

The Fibonacci sequence is defined recursively already: `fib(n) = fib(n-1) + fib(n-2)`, with base cases `fib(0) = 0` and `fib(1) = 1`. This translates directly into code (`fibonacci_naive`) — but doing so naively hides an expensive problem: **the same subproblems get recomputed from scratch, many times over.**

`fib(5)` calls `fib(4)` and `fib(3)`. But `fib(4)` *also* calls `fib(3)` (a second, entirely separate computation of the same value), plus `fib(2)`. Every subproblem below the top branches into overlapping work:

```
                          fib(5)
                       /          \
                  fib(4)            fib(3)
                 /      \           /      \
             fib(3)    fib(2)   fib(2)    fib(1)
             /    \    /    \    /    \
         fib(2) fib(1) fib(1) fib(0) fib(1) fib(0)
         /    \
     fib(1) fib(0)
```

`fib(3)` is computed twice, `fib(2)` is computed three times, `fib(1)` and `fib(0)` many times each — and this redundancy compounds as `n` grows, because every duplicated call spawns its own duplicated sub-calls. `implementation.py` counts actual function invocations to make this measurable rather than theoretical:

```
fibonacci_naive(5)  -> 5,    function calls made: 15
fibonacci_naive(10) -> 55,   function calls made: 177
fibonacci_naive(20) -> 6765, function calls made: 21891
```

Going from n=10 to n=20 (only doubling n) makes the call count balloon from 177 to 21,891 — roughly 124x more calls for 2x the input. This is the signature of **exponential time complexity, O(2^n)** (technically closer to O(1.618^n), following the golden ratio, but the qualitative point — explosive, non-polynomial growth — is what matters here).

## Advanced: Memoization Fixes It

`fibonacci_memoized` makes exactly one change: before recursing, it checks a `cache` dictionary for whether this `n` has already been computed. If so, it returns the cached result instantly instead of recomputing the entire subtree beneath it. If not, it computes it (recursively, same as before) and **stores** the result in the cache before returning, so every future request for that same `n` is instant.

```
fibonacci_memoized(5)  -> 5,    function calls made: 9
fibonacci_memoized(10) -> 55,   function calls made: 19
fibonacci_memoized(20) -> 6765, function calls made: 39
```

Compare the growth: naive goes 15 -> 177 -> 21,891 (exponential); memoized goes 9 -> 19 -> 39 (roughly linear — each increase in n adds a small, bounded number of new calls, since every value from 0 to n is computed at most once). This is the direct payoff of trading O(n) space (the cache holding up to n values) for O(n) time instead of O(2^n) time. This exact technique — cache subproblem results to avoid recomputation — is the foundation of **Dynamic Programming**, covered fully in Lesson 12; recursion with memoization is DP's "top-down" formulation.

## Backtracking Preview: Generating All Subsets

`all_subsets(items)` generates the **power set** — every possible subset of a list, including the empty set and the full list itself. For `n` items there are always exactly `2^n` subsets, because each item is independently either "in" or "out" of any given subset.

The technique is **backtracking**: for each item starting from some index, explore the branch where it's *included* (recurse), then undo that choice and implicitly explore the branch where it's *excluded* (the loop simply moves to the next item without it). The pattern is always: **choose, recurse, un-choose**.

```
all_subsets([1, 2, 3]) -> [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
count: 8 (expected 2**3 = 8)
```

Every partial subset built along the way — including the empty list at the very start — is itself recorded as a valid subset the moment `backtrack` is entered, which is why `[]` appears first and `[1, 2, 3]` (every item chosen) appears once the deepest recursion is reached. The `current_subset.pop()` after each recursive call is the "backtrack" step: it undoes the most recent "choose" so the loop's next iteration explores a fresh alternative branch, using the *same* list object throughout rather than building a brand-new one at every step. This exact choose/recurse/un-choose shape reappears, more fully developed, in Trees, Graphs, and Dynamic Programming later in the curriculum — this lesson exists to make the shape familiar in its simplest possible form before it gets more complex.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/08-Recursion
python implementation.py
```

## Verified Output

```
=== factorial ===
factorial(0) -> 1
factorial(1) -> 1
factorial(5) -> 120
factorial(7) -> 5040

=== fibonacci_naive (with call counts, showing exponential blowup) ===
fibonacci_naive(5) -> 5, function calls made: 15
fibonacci_naive(10) -> 55, function calls made: 177
fibonacci_naive(20) -> 6765, function calls made: 21891

=== fibonacci_memoized (same results, linear call count) ===
fibonacci_memoized(5) -> 5, function calls made: 9
fibonacci_memoized(10) -> 55, function calls made: 19
fibonacci_memoized(20) -> 6765, function calls made: 39

=== all_subsets (backtracking preview) ===
all_subsets([1, 2, 3]) -> [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
count: 8 (expected 2**3 = 8)
```

## Summary

- Every correct recursive function needs a base case (stops the recursion) and a recursive case (reduces the problem and calls itself).
- Naive recursive Fibonacci recomputes overlapping subproblems from scratch, causing exponential O(2^n)-class time; the actual call counts (15, 177, 21,891 for n=5,10,20) make this concrete.
- Memoization caches each subproblem's result the first time it's computed, collapsing the same Fibonacci computation to roughly linear time (9, 19, 39 calls) at the cost of O(n) cache space — the foundational idea behind Dynamic Programming.
- Backtracking (choose, recurse, un-choose) generates all possibilities systematically, demonstrated here via generating all `2^n` subsets of a list.

## Key Terms

- **Base case** — the simplest input a recursive function can answer without recursing further; without one, recursion never terminates.
- **Recursive case** — the part of a recursive function that calls itself on a smaller/reduced input and combines that result with the current step.
- **Call stack** — the stack of in-progress function calls; each recursive call adds a frame, which is only removed once that call returns — this is why deep recursion can exhaust memory (a "stack overflow" / `RecursionError` in Python).
- **Memoization** — caching the result of a function call keyed by its input, so repeated calls with the same input return instantly instead of recomputing.
- **Backtracking** — a recursive pattern that builds a solution incrementally, exploring a choice, recursing, and then undoing ("backtracking") that choice to try alternatives.
- **Power set** — the set of all possible subsets of a set (including the empty set and the full set itself); has exactly `2^n` elements for a set of size `n`.

## Common Mistakes

- Forgetting the base case entirely, or writing one that's never actually reached (e.g., a base case for `n == 0` when the recursive case decrements by 2 and starts from an odd number) — both cause infinite recursion and an eventual `RecursionError`.
- Writing naive recursive Fibonacci (or similar overlapping-subproblem recursions) without memoization in a real program — it works correctly for small `n` and then becomes catastrophically slow (or effectively hangs) for only moderately larger `n`, exactly the exponential blowup measured above.
- Reusing the *same* mutable list across backtracking branches without undoing changes (`current_subset.pop()`) — forgetting this step means every recorded subset ends up being a reference to the *same* list object, mutated by every subsequent branch, so all recorded "subsets" incorrectly end up identical to the final, fully-built one.
- Assuming memoization is free — it trades space (a cache holding up to `n` entries) for time; for functions where subproblems don't overlap (like plain `factorial`), memoization adds overhead for no benefit, since each subproblem is only ever computed once anyway.

## Interview Questions

1. **What two parts must every correct recursive function have, and what happens if either is missing or unreachable?**
   A base case (the simplest input, answered directly, no further recursion) and a recursive case (reduces the problem, calls itself, combines results). Missing or unreachable base case: infinite recursion, eventually raising a `RecursionError` (Python) or stack overflow. Missing recursive case: the function can only ever solve the single base-case input, never anything larger.

2. **Why is naive recursive Fibonacci exponential time, and what's the fix?**
   Because `fib(n) = fib(n-1) + fib(n-2)` causes overlapping subproblems to be recomputed from scratch many times — `fib(n-2)` is recomputed as part of both the `fib(n-1)` branch and directly, and this duplication compounds at every level below it, producing roughly `O(1.618^n)` total calls. The fix is memoization: cache each `fib(k)` result the first time it's computed, so every subsequent request for the same `k` is an O(1) cache lookup instead of a full recomputation — collapsing the total work to O(n).

3. **What is the time and space trade-off memoization makes?**
   It spends O(n) extra space (a cache holding up to n previously computed results) to turn O(2^n) time into O(n) time for problems with overlapping subproblems, like Fibonacci. It's not "free" — for recursive functions whose subproblems never overlap (e.g., binary search's recursive calls, or plain factorial), there's nothing to cache, and adding a cache would only add overhead with no time-complexity benefit.

4. **Describe the choose/recurse/un-choose backtracking pattern used in `all_subsets`, and why the un-choose step matters.**
   For each candidate item, "choose" it (append to the current partial solution), "recurse" (explore all ways to extend that partial solution further), then "un-choose" it (remove it again) before trying the next alternative. The un-choose step matters because the same mutable list is reused across all branches of the recursion tree for efficiency (no new list allocated per branch) — without undoing the choice, every subsequent branch would incorrectly include an item that should have been excluded from it.

5. **Why does `all_subsets` for a list of length `n` always produce exactly `2^n` subsets?**
   Each of the `n` items is independently either included in a given subset or not — two choices per item, and the choices are independent of each other, so the total number of distinct combinations is `2 * 2 * ... * 2` (`n` times) = `2^n`. This holds regardless of the actual values in the list, including whether they contain duplicates (though duplicate *values* would then produce duplicate subsets by value, even though each subset is still structurally distinct by which indices were chosen).

## Suggested Next Lesson

[09 — Trees and Binary Search Trees](../09-Trees-and-Binary-Search-Trees/README.md) *(currently a planned-scope stub — see that folder's README)*
