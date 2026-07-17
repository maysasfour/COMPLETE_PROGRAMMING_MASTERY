# Solution 01 — House Robber (Maximum Sum of Non-Adjacent Elements)

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output, cross-checked against a brute-force solution that tries every valid subset directly:

```
[1, 2, 3, 1] -> dp=4, brute_force=4, match=True
[2, 7, 9, 3, 1] -> dp=12, brute_force=12, match=True
[] -> dp=0, brute_force=0, match=True
[5] -> dp=5, brute_force=5, match=True
[5, 1] -> dp=5, brute_force=5, match=True
[3, 2, 5, 10, 7] -> dp=15, brute_force=15, match=True
```

## Explanation

Define `best(i)` as the maximum robbable total considering only houses `0` through `i`. At each house, there are exactly two choices: **skip it** (`best(i) = best(i-1)`) or **rob it** (`best(i) = amounts[i] + best(i-2)`, since robbing house `i` rules out house `i-1`). `best(i)` is simply the larger of those two options. The solution only ever needs the *previous two* answers (`prev_two`, `prev_one`) to compute the next one — never the entire history — so it's implemented with two running variables instead of a full array.

## Reflection Answers

1. **Base cases.** With no houses (`amounts = []`), the answer is `0` — nothing to rob. With one house, the answer is that house's amount (nothing else to conflict with it). Both fall out naturally from starting `prev_two = prev_one = 0`: the first iteration computes `max(0, amounts[0] + 0) = amounts[0]`, correctly handling the one-house case without a special-cased branch.

2. **Why two variables suffice instead of a full array.** The recurrence `best(i) = max(best(i-1), amounts[i] + best(i-2))` only ever looks back **exactly two** steps, never further. Once `best(i)` has been computed, `best(i-2)` (and everything before it) is never needed again — only `best(i-1)` and `best(i)` matter for computing `best(i+1)`. This is a stronger property than a general DP table needs (many DP problems, like this lesson's LCS or knapsack, genuinely need to look back across the *entire* table, not just a fixed constant number of previous entries) — whenever a recurrence only depends on a fixed, small number of previous results, it can always be "rolled" into that many variables instead of a full array, trading a small amount of readability for O(1) space instead of O(n).

3. **Similarity and difference vs. 0/1 knapsack.** Both share the same fundamental shape: at each item/house, either skip it or take it, and taking it commits you to a smaller version of the same problem (fewer remaining houses to consider, or less remaining capacity). The difference is dimensionality: knapsack's state depends on *two* things — which items have been considered *and* how much capacity remains — requiring a full 2D table, since "how much capacity is left" can take on many different values that all need to be tracked simultaneously. House robber's state depends on only *one* thing — which house index has been considered — and its "look back" distance is a fixed constant (2), which is exactly why it collapses to O(1) space while knapsack cannot.

## Common Pitfalls

- Forgetting that robbing house `i` means looking back to `best(i-2)`, not `best(i-1)` — house `i-1` is specifically excluded because it's adjacent to `i`.
- Trying to solve this greedily (always take the larger of the current pair) instead of with DP — a genuinely larger amount two houses further along can make skipping a locally-larger house the globally correct choice, which a naive greedy comparison would miss.
- Not handling the empty-list and single-house cases explicitly when NOT using the two-variable formulation above (e.g., a table-based version needs to make sure indexing doesn't go out of bounds for these edge cases).
