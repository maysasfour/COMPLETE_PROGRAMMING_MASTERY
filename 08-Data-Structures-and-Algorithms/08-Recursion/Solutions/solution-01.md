# Solution 01 — Recursive Sum of Digits

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
sum_of_digits(0) -> 0
sum_of_digits(7) -> 7
sum_of_digits(123) -> 6
sum_of_digits(9999) -> 36
```

## Explanation

`sum_of_digits` peels off the last digit of `n` using `n % 10`, and recurses on whatever remains after removing that digit (`n // 10`, integer division that drops the last digit). The base case is `n < 10` — a single-digit number, which is its own digit sum, answered directly with no further recursion. For `sum_of_digits(123)`: `123 % 10 = 3`, recurse on `12`; `12 % 10 = 2`, recurse on `1`; `1 < 10`, return `1`. Unwinding: `1`, then `2 + 1 = 3`, then `3 + 3 = 6`.

## Reflection Answers

1. **Base case and why it's guaranteed to be reached.** The base case is `n < 10` (a single digit). Every recursive call replaces `n` with `n // 10`, which strictly removes one digit each time (a positive multi-digit integer divided by 10, using integer division, always has one fewer digit than before). Since `n` starts with a finite number of digits, repeatedly removing one digit per call must eventually reach a single-digit number — there's no way to remove digits forever from a finite starting number.

2. **Time complexity in terms of digit count.** `sum_of_digits(n)` is O(d), where `d` is the number of digits in `n` — one recursive call is made per digit, each doing O(1) work (`% 10`, `// 10`, one addition). Expressing it in terms of `n` itself would be misleading: the number of digits grows only logarithmically with the value of `n` (a number with `d` digits is roughly `10^d`), so in terms of the *value* `n`, this is really O(log n) — but "one step per digit" is the far more intuitive and directly meaningful way to describe what the recursion is actually doing, since it operates digit-by-digit, not value-by-value.

3. **Why memoization wouldn't help here.** `fibonacci_naive` is slow because it makes *two* recursive calls per step, and those calls' subtrees overlap heavily (the same smaller Fibonacci values get recomputed many times via different paths). `sum_of_digits` makes only *one* recursive call per step, on a strictly different (smaller) input each time (`n // 10` is different for every distinct `n`) — there are no overlapping subproblems to cache, because the recursion is a single straight chain, not a branching tree. Memoization only pays off when the same subproblem is reached via multiple different call paths; here, each subproblem (`n // 10` for a given `n`) is only ever computed once regardless, so a cache would add bookkeeping overhead for zero benefit.

## Common Pitfalls

- Using `n <= 10` instead of `n < 10` as the base case — this incorrectly treats the two-digit number 10 as a "single digit," returning `10` instead of the correct `1 + 0 = 1`.
- Forgetting `n // 10` must use integer (floor) division, not `/` (true division) — using `/` would produce a float, and further `% 10` / recursion on a float either misbehaves or never reaches the intended integer base case.
- Not handling `n = 0` explicitly — this implementation happens to handle it correctly anyway (`0 < 10` is true, so it returns `0` directly at the very first call), but it's worth checking any recursive numeric function against the zero case specifically, since "smallest input" edge cases are where off-by-one base case errors usually hide.
