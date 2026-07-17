# 13 — Greedy Algorithms

[Back to module overview](../README.md) | [Previous: Dynamic Programming](../12-Dynamic-Programming/README.md)

## Beginner: The Greedy Strategy, Taught by Contrast with DP

A **greedy algorithm** makes the locally best choice at each step, with no backtracking and no reconsidering earlier decisions, hoping (and ideally *proving*) that a sequence of locally-best choices adds up to a globally optimal answer. This is a genuinely narrower tool than [Dynamic Programming](../12-Dynamic-Programming/README.md): DP explores (and caches) however many subproblems a correct answer actually requires; greedy problems are specifically the subset of DP-shaped problems where you can *prove* you never need to look back or reconsider — the locally obvious choice is always safe. The entire hard part of using greedy correctly is knowing *which* problems that's actually true for — and this lesson proves both sides directly: one problem where greedy is provably correct, and one where it produces a real, confidently-wrong answer.

## Intermediate: Activity Selection and Fractional Knapsack

**Activity selection**: given a set of activities with start/end times, and only one resource (e.g., one room), select the maximum possible number of non-overlapping activities. The correct greedy rule is sorting by **end time** (not start time, not duration) and always taking the next compatible activity that finishes soonest — this specifically leaves the most possible remaining time for whatever else might still fit. On this lesson's 11-activity demo set, greedy selects exactly 4 non-overlapping activities: `(1,4), (5,7), (8,11), (12,16)`.

**Fractional knapsack**: choose items (weights/values given) to maximize value within a weight capacity — but unlike [Lesson 12's 0/1 knapsack](../12-Dynamic-Programming/README.md), items here *can* be split, taking any fraction of one for that same fraction of its value. This is exactly what makes greedy (sort by value-per-weight ratio, always take as much as possible of the best remaining ratio) **provably optimal** here, in a way it is *not* for 0/1 knapsack: there's never any wasted leftover capacity from being forced to skip a partial item. Run on the identical items/capacity as Lesson 12's 0/1 knapsack demo, fractional and 0/1 happen to reach the same value (`7`) here, but fractional is always `>= ` 0/1 for the same inputs in general, since being allowed to split items can only ever help, never hurt.

## Advanced: When Greedy Actually Fails — A Real, Reproduced Wrong Answer

**Coin change with a canonical coin system** (standard currency like US coins `[1, 5, 10, 25]`): the greedy rule "always take the largest coin that still fits" happens to be provably optimal, verified directly against [Lesson 12](../12-Dynamic-Programming/README.md)'s DP solution across multiple amounts — greedy and DP agree every time.

**Coin change with a NON-canonical coin system** (`[1, 3, 4]`) is where this lesson deliberately breaks greedy, on purpose, to prove the point rather than just assert it: for `amount=6`, greedy takes the largest coin first (4), leaving 2, which then needs two 1-coins — `4 + 1 + 1 = 3 coins`. The DP-verified *actual* optimum is `3 + 3 = 2 coins`. Greedy's confidently-produced answer (3) is simply **wrong** — not slower, not a valid-but-suboptimal alternative, genuinely incorrect — because this coin system isn't canonical (its coin values don't have the specific "each coin is enough larger than the sum of all smaller ones" property that makes the greedy largest-coin rule always safe). This is the single most important takeaway of this lesson: greedy's local reasoning ("obviously take the biggest coin") can look completely sound step-by-step and still land on a demonstrably wrong final answer — the only way to trust greedy for a given problem is an actual correctness proof (or, as done here, a cross-check against DP for cases where a wrong answer would be caught).

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/13-Greedy-Algorithms
python implementation.py
```

## Verified Output

```
=== Activity Selection ===
selected (max non-overlapping, greedy by earliest finish time): [(1, 4), (5, 7), (8, 11), (12, 16)]
count selected: 4

=== Fractional Knapsack vs. 0/1 Knapsack (Lesson 12) -- same items, different answers ===
fractional knapsack (greedy, provably optimal here): 7.0
0/1 knapsack (DP, Lesson 12): 7
Fractional >= 0/1, as expected: True

=== Coin Change: greedy works for a CANONICAL coin system ===
amount=30, coins=[1, 5, 10, 25]: greedy=2, dp=2, match=True
amount=41, coins=[1, 5, 10, 25]: greedy=4, dp=4, match=True
amount=63, coins=[1, 5, 10, 25]: greedy=6, dp=6, match=True

=== Coin Change: greedy FAILS for a NON-canonical coin system -- a real, reproduced wrong answer ===
amount=6, coins=[1, 3, 4]: greedy=3, dp=2, match=False
  Greedy picks the largest coin first (4), leaving 2, which needs two 1-coins: 4+1+1 = 3 coins.
  The DP-verified OPTIMAL answer uses 3+3 = 2 coins instead.
  Greedy's local 'take the biggest coin now' choice is provably WRONG here.
```

## Summary

- Greedy algorithms make the locally best choice at each step with no backtracking; they are a strict subset of DP-shaped problems, applicable only when the locally-best choice is *provably* always safe.
- Activity selection's correct greedy rule is sorting by end time (not start time or duration) — proven directly, selecting the maximum 4 non-overlapping activities from an 11-activity set.
- Fractional knapsack (items splittable) is provably optimal with a value-per-weight greedy rule; 0/1 knapsack (Lesson 12) is not, because forced-whole-or-nothing choices can waste capacity a greedy rule can't see coming.
- Greedy coin change works for canonical coin systems (verified to match DP across multiple amounts) but genuinely fails for non-canonical ones — reproduced directly: `[1,3,4]` coins for amount 6 gives a wrong greedy answer of 3 coins versus the true optimum of 2.
- The only way to trust a greedy algorithm on a new problem is an actual correctness proof (or a cross-check against a known-correct method, like DP, for cases where a wrong answer would surface) — "the locally obvious choice" is not evidence of correctness on its own.

## Key Terms

- **Greedy algorithm** — makes the locally optimal choice at each step, without backtracking or reconsidering earlier decisions.
- **Activity selection** — choosing the maximum number of non-overlapping intervals from a resource-constrained schedule; correctly solved greedily by sorting on end time.
- **Fractional vs. 0/1 knapsack** — whether items can be split (fractional: greedy-optimal) or must be taken whole-or-nothing (0/1: requires DP, greedy can be wrong).
- **Canonical coin system** — a set of coin denominations for which the greedy "always take the largest fitting coin" rule is provably always optimal (e.g., standard currency); not all coin systems have this property.
- **Correctness proof (for a greedy algorithm)** — a demonstration that the locally greedy choice never forecloses a globally optimal solution; without one, a greedy algorithm's answer cannot be trusted to be correct, only plausible.

## Common Mistakes

- Assuming any "obviously reasonable" greedy rule is automatically correct — this lesson's own coin-change demo reproduces a case where it confidently isn't.
- Sorting activity selection by *start* time or by *duration* instead of *end* time — both are tempting but neither is provably correct the way end-time sorting is (a longer-first-available activity sorted by start time might block two shorter, non-overlapping ones that would otherwise both fit).
- Applying a fractional-knapsack-style greedy solution to a 0/1 knapsack problem — a genuinely common, real mistake, since the two problems look almost identical on the surface but have different optimal-strategy requirements.
- Trusting a greedy algorithm on a new coin system (or any new problem) without either proving it or cross-checking it against a known-correct approach — as demonstrated directly, "it happened to work on the examples I tried" is not the same as "it always works."

## Interview Questions

1. **What defines a greedy algorithm, and how does it differ fundamentally from Dynamic Programming?**
   A greedy algorithm makes the locally best choice at each step and never reconsiders it. DP considers however many subproblems' worth of information a correct answer actually requires, potentially exploring multiple options and combining results. Greedy problems are the subset of DP-shaped problems where it can be proven that reconsidering is never necessary — the locally best choice is always part of *some* globally optimal solution.

2. **Why does sorting activities by end time (not start time) produce the correct greedy solution to activity selection?**
   Taking the compatible activity that finishes *soonest* leaves the maximum possible remaining time for whatever activities come after it — no other choice among the currently-compatible options can ever leave *more* room. Sorting by start time or duration doesn't have this guarantee; a longer activity that starts early could be chosen greedily by those orderings while blocking two or more shorter activities that would have fit instead.

3. **Why is greedy provably optimal for fractional knapsack but not for 0/1 knapsack?**
   Fractional knapsack allows taking partial items, so a greedy value-per-weight-ratio strategy never leaves any usable capacity "wasted" — whatever capacity remains after taking as much of the best-ratio item as possible is always exactly filled with the next-best ratio, and so on. 0/1 knapsack forces whole-item-or-nothing choices, so a greedy strategy can be forced to either take an item that doesn't perfectly use remaining capacity (wasting some of it) or skip an item that would have combined better with others — genuinely different combinations of whole items can beat the greedy ratio-based choice, which is exactly why 0/1 knapsack needs DP's fuller exploration instead.

4. **Describe a concrete case where greedy coin change gives the wrong answer, and explain exactly why.**
   With coins `[1, 3, 4]` and a target of 6: greedy takes the largest fitting coin first (4), leaving 2, which then requires two more 1-coins — 3 coins total (4+1+1). But 3+3 = 6 using only 2 coins is strictly better. Greedy fails here because taking the single largest coin available at each step is not always compatible with the fewest coins overall — this coin system lacks the specific "canonical" property (each coin sufficiently larger than combinations of smaller ones) that guarantees the greedy largest-coin choice never forecloses a better combination.

5. **How would you actually verify whether a greedy approach is safe to use for a new problem, rather than just assuming it based on intuition?**
   Either prove it directly — typically via an "exchange argument" (show that any optimal solution can be transformed into the greedy solution without making it worse, step by step) — or, when a rigorous proof isn't practical, cross-check the greedy algorithm's answers against a known-correct method (like DP, or brute force for small cases) across a range of inputs specifically chosen to stress unusual structure, the way this lesson's non-canonical `[1,3,4]` coin system was deliberately chosen to test whether the "obvious" greedy coin rule actually holds up.

## Suggested Next Lesson

This is the last lesson in `08-Data-Structures-and-Algorithms`. Return to the [module overview](../README.md) for the full lesson index, or continue to [02-Markup-and-Styling](../../02-Markup-and-Styling/README.md) per this repository's `ROADMAP.md` Phase 4 ordering (this module maps to Phase 3 — Problem Solving).
