# Solution 01 — Classify the Complexity

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

## Classifications

**Function A — O(1).**
It accesses `items[0]` directly (a single index operation) or returns `None` — neither path depends on how many elements `items` has.

**Function B — O(n).**
A single `for` loop visits every element exactly once; work grows directly and proportionally with `len(items)`.

**Function C — O(n^2).**
A `for` loop nested inside another `for` loop, both iterating over the same `items`. For every one of the `n` outer iterations, the inner loop does another full `n` iterations, giving `n * n = n^2` total operations.

**Function D — O(log n).**
`n` is cut in half every iteration (`n = n // 2`) until it's no longer greater than 1. The number of times you can halve a number before reaching 1 is `log2(n)` — this is the same halving pattern that makes binary search O(log n).

**Function E — O(n).**
Two separate loops, each O(n), run one after another: total work is `n + n = 2n`. Big O drops constant factors, so `2n` is still classified as O(n), not a distinct "O(2n)" category.

## Reflection Answers

1. **O(n).** Big O notation deliberately discards constant multipliers because it describes the growth *trend*, not the exact operation count. `2n` and `n` both scale linearly — doubling the input still roughly doubles the work in both cases, which is the property Big O is meant to capture. Calling it "O(2n)" wouldn't be wrong arithmetic, it's just not how the notation is used; the convention is to always simplify to the tightest standard class (O(n) here).

2. **Binary search** (covered fully in `07-Searching-Algorithms`). Both repeatedly cut the remaining problem size in half on each step rather than shrinking it by a fixed amount — that halving pattern is exactly what produces O(log n) growth, regardless of whether the thing being halved is a search range (binary search) or a bare integer (Function D).

3. **Roughly 100 milliseconds (100x longer), because 10x more input means the input squared grows by 10^2 = 100x.** Function C is O(n^2): going from 10 to 100 items is a 10x increase in `n`, and since work scales with `n^2`, the work scales by `10^2 = 100`. `solution-01.py` measures this empirically — see its verified output below, which lands in that ballpark (not exact, because millisecond-scale interpreter and measurement overhead dominate at such tiny input sizes, but clearly quadratic rather than linear, ruling out a 10x prediction).

## Verified Output (`solution-01.py`, one real run)

```
c() on 10 items:  8.800 microseconds
c() on 100 items: 409.700 microseconds
Observed ratio: 46.6x (O(n^2) predicts roughly 100x for a 10x input increase)
```

The observed ratio (46.6x) is below the theoretical 100x, which is expected and worth understanding rather than dismissing: at `n=10`, the "work" (100 multiply-add operations) is so small that fixed Python interpreter overhead (function call setup, loop bookkeeping) is a significant fraction of the measured time, inflating the small-input baseline. As `n` grows, that fixed overhead becomes relatively smaller and the measured ratio converges toward the theoretical 100x — this is exactly the "constants and lower-order terms matter more at small `n`" caveat from the lesson's Common Mistakes section.

## Common Pitfalls

- Classifying Function E as O(n^2) by pattern-matching "two loops" without noticing they're sequential, not nested — sequential loops add; nested loops multiply.
- Answering reflection question 3 with "10x longer" by linearly scaling the input increase instead of squaring it — this is the single most common real-world complexity-estimation mistake.
- Assuming the empirical ratio in `solution-01.py` should land exactly on 100x — real measurements always include fixed overhead that theory-only reasoning doesn't account for, especially at small `n`.
