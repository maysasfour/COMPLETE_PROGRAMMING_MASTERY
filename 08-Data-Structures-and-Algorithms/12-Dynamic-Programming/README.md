# 12 — Dynamic Programming

[Back to module overview](../README.md) | [Previous: Graphs](../11-Graphs/README.md)

## Beginner: Overlapping Subproblems and Optimal Substructure (Continuing Directly from Lesson 08)

[08-Recursion](../08-Recursion/README.md)'s naive-vs-memoized Fibonacci comparison is deliberately the true first half of this lesson: naive recursive Fibonacci recomputes the exact same subproblems from scratch many times over (**overlapping subproblems**), and the correct answer to a larger problem can always be built directly from correct answers to its smaller subproblems (**optimal substructure**) — those two properties together are the *definition* of a problem Dynamic Programming (DP) applies to. This lesson picks up from there with three progressively richer examples.

There are two implementation styles, both used in this lesson:

- **Top-down (memoization)**: write the natural recursive solution, then add a cache keyed by the subproblem's parameters, checked *before* recursing. `coin_change_memoized` is exactly `coin_change_naive` with one addition: a cache check at the top.
- **Bottom-up (tabulation)**: build a table of answers starting from the smallest subproblems, filling it in order so every larger subproblem's dependencies are already computed by the time it's reached. No recursion at all. `coin_change_tabulated` computes the identical answer with a single filled array.

## Intermediate: Coin Change — Measuring the Exact Same Blowup as Fibonacci

**Coin change**: given coin denominations and a target amount, find the minimum number of coins that sum to exactly that amount. The naive recursive solution tries every coin at every step and recurses on the remainder — and it suffers the identical overlapping-subproblems disease as naive Fibonacci, measured directly rather than just asserted:

```
amount=11: naive=2 (137 calls),   memoized=2 (45 calls),  tabulated=2
amount=20: naive=2 (2221 calls),  memoized=2 (81 calls),  tabulated=2
amount=32: naive=4 (87277 calls), memoized=4 (129 calls), tabulated=4
```

Going from amount 20 to 32 (barely more than 1.5x) makes naive's call count balloon from 2,221 to 87,277 — roughly 39x more calls. This lesson's implementation actually measured naive at `amount=63` once, off to the side: **1,154,223,045 calls** — over a billion — while memoized solved the identical problem in 253 calls. That specific run is recorded rather than re-run every time this lesson executes, purely so the lesson itself stays fast to re-verify; the number is real, not estimated.

## Advanced: Longest Common Subsequence and 0/1 Knapsack

**Longest Common Subsequence (LCS)**: the longest sequence of characters that appears (in order, not necessarily contiguously) in both of two strings. `longest_common_subsequence` builds a 2D table where `table[i][j]` is the LCS length of the first `i` characters of one string and the first `j` of the other — if the current characters match, extend the diagonal predecessor's answer by one; otherwise, take the better of dropping the last character of either string. `reconstruct_lcs` then walks that filled table *backward* to recover the actual matched characters, not just the length — verified independently by confirming the reconstructed string really is a genuine subsequence of both originals (using Python's own iterator-based subsequence check), not just trusting the table's numbers.

**0/1 Knapsack**: given items with weights and values and a weight capacity, choose a subset (each item taken *whole* or not at all — no fractional items, unlike the "fractional knapsack" problem in [13-Greedy-Algorithms](../13-Greedy-Algorithms/README.md)) maximizing total value without exceeding capacity. `knapsack_01`'s table tracks, for each prefix of items and each possible remaining capacity, the best value achievable — at each item, either skip it (carry forward the answer using one fewer item) or take it (its value plus the best achievable with the *remaining* capacity, using one fewer item). Verified here against a genuine brute-force check of every possible subset — for the demo's 4 items, all `2^4 = 16` subsets are checked directly, confirming the DP table's answer (`7`) is actually optimal, not merely plausible.

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/12-Dynamic-Programming
python implementation.py
```

## Verified Output

```
=== coin change: naive vs. memoized, measuring the exact same call-count blowup as Lesson 08's Fibonacci ===
amount=11: naive=2 (137 calls), memoized=2 (45 calls), tabulated=2
amount=20: naive=2 (2221 calls), memoized=2 (81 calls), tabulated=2
amount=32: naive=4 (87277 calls), memoized=4 (129 calls), tabulated=4

(naive is skipped above amount=32 -- it was actually measured once at amount=63 and made 1,154,223,045 calls, versus memoized's 253 and tabulated's direct O(amount * len(coins)) computation)
amount=63: memoized=6 (253 calls), tabulated=6

=== longest common subsequence ===
LCS("ABCBDAB", "BDCABA") length = 4
reconstructed subsequence = 'BCBA'
reconstructed length matches table length: True
is a genuine subsequence of a: True
is a genuine subsequence of b: True

=== 0/1 knapsack ===
weights=[2, 3, 4, 5], values=[3, 4, 5, 6], capacity=5
best achievable value: 7
brute-force best value (every subset checked): 7
DP matches brute force: True
```

## Summary

- DP applies exactly when a problem has overlapping subproblems (the same smaller problem gets solved repeatedly) and optimal substructure (a bigger answer can be built from smaller correct answers).
- Top-down memoization is the naive recursive solution plus a cache check; bottom-up tabulation builds a table from the smallest subproblems up, with no recursion.
- Coin change's naive-vs-memoized call counts (measured directly, up to a real 1.15 billion calls at amount=63) mirror Lesson 08's Fibonacci blowup exactly — the same underlying disease, a different problem.
- LCS's table gives the *length* of the answer; reconstructing the actual matched subsequence requires walking the filled table backward, verified here to actually be a real subsequence of both original strings.
- 0/1 knapsack's table has two dimensions (items considered AND remaining capacity) because its state genuinely depends on both — verified against a full brute-force check of every possible subset.

## Key Terms

- **Overlapping subproblems** — the same smaller subproblem needs to be solved multiple times by a naive recursive approach; the property memoization directly exploits.
- **Optimal substructure** — an optimal solution to a problem can be constructed from optimal solutions to its subproblems.
- **Memoization (top-down)** — caching a recursive function's results keyed by its parameters, checked before recomputing.
- **Tabulation (bottom-up)** — building a table of subproblem answers iteratively, smallest first, with no recursion.
- **0/1 knapsack** — choose a subset of items (each whole-or-nothing) maximizing value under a weight constraint; contrast with the *fractional* knapsack in [13-Greedy-Algorithms](../13-Greedy-Algorithms/README.md), which allows partial items and is solvable greedily instead.

## Common Mistakes

- Writing a memoized solution but forgetting to check the cache *before* doing the recursive work — this defeats memoization entirely, since the expensive computation still happens every time, and the cache is only ever used for a value already about to be thrown away.
- Assuming any recursive problem benefits from memoization — as Lesson 08 noted for `sum_of_digits`, a recursion with no overlapping subproblems (each subproblem reached exactly once) gains nothing from a cache, only overhead.
- For knapsack specifically: solving it greedily (always take the best value-per-weight item first) — this works for the *fractional* knapsack (see Lesson 13) but can be provably wrong for 0/1 knapsack, since taking a locally-attractive item can block a better combination of other items that would have fit instead.
- For LCS: confusing "longest common subsequence" (order preserved, not necessarily contiguous) with "longest common substring" (must be contiguous) — these are different problems with different (though related) DP formulations.

## Interview Questions

1. **What two properties must a problem have for Dynamic Programming to apply, and what does each one mean concretely?**
   Overlapping subproblems (a naive recursive/brute-force approach solves the exact same smaller subproblem multiple times) and optimal substructure (an optimal solution to the whole problem can be assembled from optimal solutions to its subproblems). Coin change's naive version repeatedly re-solves the same remaining-amount subproblem via different coin orderings (overlapping), and the minimum coins for amount N is always built from the minimum coins for some smaller amount plus one more coin (optimal substructure).

2. **What's the difference between top-down memoization and bottom-up tabulation, and when might you prefer one over the other?**
   Memoization keeps the natural recursive structure and adds a cache; it's often easier to derive directly from a brute-force recursive solution, and it only computes subproblems that are actually needed. Tabulation builds an explicit table bottom-up with no recursion, avoiding any recursion-depth concerns and often running slightly faster due to no function-call overhead, but it computes every subproblem in the table's range whether or not the final answer actually needed all of them.

3. **Why does 0/1 knapsack need a 2D table, while a problem like coin change (or the House Robber exercise) can use a 1D table (or even fewer variables)?**
   0/1 knapsack's state genuinely depends on two independent things simultaneously: which prefix of items has been considered, AND how much capacity remains — both can vary independently, so both dimensions must be tracked together in the table. Coin change's state depends on only one thing (the current target amount); House Robber's recurrence additionally only ever looks back a fixed 2 steps, letting it collapse all the way to O(1) space.

4. **How would you reconstruct the actual longest common subsequence, not just its length, from a filled LCS table?**
   Walk the table backward from the bottom-right corner. At each cell, if the corresponding characters in both strings match, that character is part of the LCS — record it and move diagonally (both indices decrease by one). If they don't match, move toward whichever neighboring cell (one row up, or one column left) holds the larger value, since that's the direction the optimal answer actually came from. Reverse the recorded characters at the end, since they were collected back-to-front.

5. **Why is naive recursive coin change's call count so much worse than naive Fibonacci's for a similarly-sized input, even though both suffer from the same overlapping-subproblems issue?**
   Naive Fibonacci branches into exactly 2 recursive calls per step. Naive coin change branches into one recursive call *per coin denomination* at every step (4 branches per step for the `[1, 5, 10, 25]` coin set used here) — a wider branching factor at every level compounds far more severely than Fibonacci's fixed 2-way branch, which is exactly why coin change's naive call count (over a billion at amount=63) dwarfs naive Fibonacci's call count for inputs of a "similar" conceptual size.

## Suggested Next Lesson

[13 — Greedy Algorithms](../13-Greedy-Algorithms/README.md)
