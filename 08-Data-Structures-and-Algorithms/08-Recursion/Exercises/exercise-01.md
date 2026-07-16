# Exercise 01 — Recursive Sum of Digits

[Back to lesson](../README.md)

## Task

Write a recursive function `sum_of_digits(n)` that returns the sum of the digits of a non-negative integer `n`, with no loops allowed — recursion only.

```python
sum_of_digits(0)     # -> 0
sum_of_digits(7)     # -> 7
sum_of_digits(123)   # -> 6   (1 + 2 + 3)
sum_of_digits(9999)  # -> 36  (9 + 9 + 9 + 9)
```

Hint: think about what the *last* digit of `n` is (`n % 10`) and what's left once you remove it (`n // 10`). What's the smallest input where you can answer directly without needing to recurse further — i.e., what's the base case?

## Reflection Questions

1. What is your base case, and why is it guaranteed to eventually be reached no matter how large `n` starts out?
2. What is the time complexity of `sum_of_digits(n)` in terms of the *number of digits* of `n` (not the value of `n` itself)? Why is expressing it in terms of digit count more meaningful here than in terms of `n`?
3. Unlike `fibonacci_naive`, this recursion never branches into two recursive calls per step — it only ever makes one. What does that tell you about whether memoization could speed this function up, and why?

## Deliverable

A working `sum_of_digits` function plus answers to the three reflection questions.
