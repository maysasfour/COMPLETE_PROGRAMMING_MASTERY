# 01 — Complexity Analysis

[Back to module overview](../README.md)

## Beginner: What Complexity Analysis Actually Answers

When you write code, two resources matter beyond "does it work": **how much time does it take**, and **how much memory does it use**, as the size of the input grows. Complexity analysis is the vocabulary for describing that growth without tying the answer to a specific machine, a specific programming language, or a specific input size.

The key insight: we don't care about the exact number of seconds an algorithm takes (that depends on your CPU). We care about the **shape of the curve** as input size `n` increases. Does time double when `n` doubles? Quadruple? Barely move at all? That shape is what Big O notation communicates.

## Beginner: Big O, Big Omega, Big Theta

These three describe different aspects of an algorithm's growth:

- **Big O (O)** — the **upper bound**. "This algorithm will never be worse than this." When people say an algorithm "is O(n)," they almost always mean this — the worst-case growth rate.
- **Big Omega (Ω)** — the **lower bound**. "This algorithm will never be better than this." Linear search is Ω(1) — in the best case (the target is the very first element), it finishes in one step.
- **Big Theta (Θ)** — a **tight bound**: the upper and lower bounds match. If an algorithm is Θ(n), it always takes time proportional to `n`, in the best, worst, and average case alike.

In everyday engineering conversation, "complexity" almost always means Big O (the worst case) because that's the bound you need to guarantee your system won't fall over under adversarial or unlucky input. This lesson (and the rest of the module) uses Big O notation unless explicitly stated otherwise.

## Beginner: Common Growth Rates, Smallest to Largest

| Notation | Name | Intuition | Example from this module |
|---|---|---|---|
| O(1) | Constant | Same cost regardless of input size | Indexing a list by position |
| O(log n) | Logarithmic | Cost grows by a fixed step each time input *doubles* | Binary search (Lesson 07) |
| O(n) | Linear | Cost grows directly with input size | Scanning a list once |
| O(n log n) | Linearithmic | A linear pass repeated log n times | Merge sort, quicksort average case (Lesson 06) |
| O(n^2) | Quadratic | Cost grows with the square of input size | Bubble sort, nested loops over the same data (Lesson 06) |
| O(2^n) | Exponential | Cost doubles with every additional input element | Naive recursive Fibonacci (Lesson 08) |

Big O notation drops constant factors and lower-order terms: an algorithm that does `3n + 100` operations is still O(n), because as `n` grows toward infinity, the `+100` and the `3x` multiplier become irrelevant next to the linear trend. This is a deliberate simplification — it's why two different O(n) algorithms can still have very different real-world speed, while remaining "the same" in Big O terms.

## Intermediate: Best Case, Average Case, Worst Case

The same algorithm can have different complexity depending on the *shape* of the input, not just its size. Linear search illustrates this cleanly:

- **Best case**: the target is the first element checked → O(1).
- **Average case**: the target is somewhere in the middle, roughly → O(n).
- **Worst case**: the target is the last element, or absent entirely → O(n).

Big O almost always describes the **worst case**, because that's the guarantee you can actually rely on in production — "usually fast" is not the same promise as "never worse than this." Quicksort (Lesson 06) is the classic cautionary example: its *average* case is O(n log n), but its *worst* case (already-sorted input with a naive pivot choice) is O(n^2). Relying on the average-case number without knowing the worst case is a real source of production incidents.

## Intermediate: Space Complexity

Everything above describes **time complexity**. **Space complexity** uses the same notation to describe how much *additional* memory an algorithm needs as input grows (beyond the input itself). An in-place sort like bubble sort is O(1) space — it rearranges the existing list without allocating a second one. Merge sort is O(n) space — it allocates new sublists during merging. Neither is "wrong"; it's a trade-off between time and memory that you choose based on your constraints (Lesson 06 covers this per-algorithm).

## Advanced: Why the Empirical Script in This Lesson Doesn't Assert Exact Timings

`implementation.py` measures real wall-clock time for O(1), O(log n), O(n), and O(n^2) operations across growing input sizes. It deliberately does **not** assert an exact number of milliseconds, because that number depends on your CPU, your OS scheduler, and what else is running — a hard-coded expected timing would be flaky by design. Instead it asserts the *relationship* Big O predicts: for example, that quadrupling `n` in the O(n^2) function increases time by roughly 16x (empirically closer to that on repeated runs, though a single run can vary — see verified output below), while the O(log n) function barely moves even across a 1000x increase in `n`. This mirrors how you should reason about complexity in real code review: not "is this fast," but "how does this scale."

## How to Run

```bash
cd 08-Data-Structures-and-Algorithms/01-Complexity-Analysis
python implementation.py
```

## Verified Output (one real run — your exact numbers will differ, but the shape will match)

```
--- O(1): constant time lookup, tested on two very different sizes ---
lookup in list of      1000: 8.300 microseconds
lookup in list of   1000000: 1.600 microseconds
(both are a single index operation - size of the list does not matter)

--- O(log n): binary search, doubling input size repeatedly ---
n=     1000:    7.600 microseconds
n=    10000:    6.200 microseconds
n=   100000:    9.600 microseconds
n=  1000000:   15.100 microseconds
(10x more data barely moves the timing - each doubling only adds ~1 comparison)

--- O(n): linear sum, doubling input size repeatedly ---
n=     1000:    0.035 milliseconds
n=    10000:    0.300 milliseconds
n=   100000:    6.300 milliseconds
n=  1000000:   70.501 milliseconds
(timing grows roughly in proportion to n)

--- O(n^2): quadratic pair sum, doubling a MUCH smaller input ---
n=      200:    6.921 milliseconds
n=      400:   20.287 milliseconds
n=      800:   89.141 milliseconds
n=     1600:  414.211 milliseconds
(doubling n roughly QUADRUPLES the time - this is why n^2 algorithms
 fall over on large inputs even though they look fine for small n)

--- Sanity checks on the relationships above ---
OK: linear_sum got slower as n grew, as expected for O(n).
OK: quadratic_pair_sum grew by a factor of 59.8x when n grew 8x (8x n -> ~64x work is expected for O(n^2); real-world noise means this won't be exact, but it should be well above an 8x linear-style increase).
```

Note the O(1) numbers: the *larger* list (1,000,000 items) actually measured faster than the small one in this run. That's not a bug — it's proof of the concept. O(1) means size doesn't determine the cost, so measurement noise (CPU cache state, OS scheduling) can easily outweigh any "expected" difference. If size mattered, the 1,000x larger list would reliably be slower; it isn't.

## Summary

- Big O describes the worst-case upper bound on growth; Big Omega the best-case lower bound; Big Theta a tight bound where both match.
- Common growth rates, fastest to slowest: O(1) < O(log n) < O(n) < O(n log n) < O(n^2) < O(2^n).
- Best/average/worst case describe how the *same* algorithm behaves differently depending on input shape, not just input size.
- Space complexity uses the same notation for memory instead of time.
- Big O drops constants and lower-order terms because it describes the trend as `n` approaches infinity, not the exact operation count.

## Key Terms

- **Big O (O)** — upper bound on growth rate (worst case).
- **Big Omega (Ω)** — lower bound on growth rate (best case).
- **Big Theta (Θ)** — tight bound where upper and lower bounds match.
- **Time complexity** — how runtime scales with input size.
- **Space complexity** — how memory usage scales with input size.
- **Best/average/worst case** — how an algorithm's complexity varies depending on the specific input, not just its size.
- **Amortized complexity** — the average cost per operation over a sequence of operations, even if individual operations occasionally cost more (e.g. a Python list's `append` is amortized O(1) even though it occasionally triggers an O(n) resize).

## Common Mistakes

- Treating Big O as an exact timing formula rather than a growth-rate trend — O(n) doesn't tell you *how fast*, only *how the speed changes as n changes*.
- Confusing "the algorithm ran fast on my test data" with "the algorithm has good worst-case complexity" — small or favorably-shaped test inputs hide quadratic and exponential blowups.
- Forgetting space complexity entirely and only ever discussing time — in memory-constrained environments (embedded systems, large-scale data processing), space complexity can matter more.
- Assuming a "simpler-looking" nested loop is automatically slower than a single loop with more code in it — always count actual growth behavior, not visual complexity of the code.
- Dropping constants so aggressively in casual reasoning that you ignore them when they matter in practice — an O(n) algorithm with a huge constant factor can be slower than an O(n log n) algorithm for realistic input sizes; Big O is about asymptotic behavior, not a promise about every `n` you'll actually see.

## Interview Questions

1. **What's the difference between Big O, Big Omega, and Big Theta?**
   Big O is the upper bound (worst case an algorithm will ever perform), Big Omega is the lower bound (best case), and Big Theta is a tight bound where the upper and lower bounds coincide — the algorithm reliably performs at that rate regardless of input shape.

2. **Why does Big O notation ignore constant factors?**
   Because it describes the growth *trend* as input size approaches infinity, not the exact runtime for a specific `n`. `2n` and `500n` are both O(n) because they both grow linearly — the constant only affects the slope, not the shape of the curve, and the shape is what determines whether an algorithm remains viable as data scales up.

3. **Give an example of an algorithm whose best case and worst case have different Big O complexity.**
   Linear search: best case O(1) (target is the first element), worst case O(n) (target is last or absent). Quicksort is a stronger example: average case O(n log n), worst case O(n^2) on adversarial or already-sorted input with a naive pivot strategy.

4. **What's the difference between time complexity and space complexity?**
   Time complexity describes how runtime scales with input size; space complexity describes how *additional* memory usage (beyond storing the input itself) scales with input size. They're independent axes — an algorithm can trade one for the other, such as using extra memory (space) to cache results and avoid recomputation (time), which is the core idea behind memoization (Lesson 08).

5. **Why is average-case complexity sometimes a misleading number to rely on in production systems?**
   Because "average" assumes a distribution of inputs that may not match what your system actually receives. If an attacker (or just unlucky real-world data) can reliably trigger the worst case, the average-case number never protected you — this is exactly why quicksort implementations use randomized or median-of-three pivot selection, to make the O(n^2) worst case practically unreachable rather than just statistically rare.

## Suggested Next Lesson

[02 — Arrays and Strings](../02-Arrays-and-Strings/README.md)
