# Exercise 01 — House Robber (Maximum Sum of Non-Adjacent Elements)

[Back to lesson](../README.md)

## Task

A row of houses each hold some amount of money, given as a list. A robber can rob any subset of houses, but **cannot rob two adjacent houses** (doing so trips an alarm). Write a function `max_non_adjacent_sum(amounts)` that returns the maximum total that can be robbed.

```python
max_non_adjacent_sum([1, 2, 3, 1])       # -> 4   (rob houses 0 and 2: 1 + 3 = 4)
max_non_adjacent_sum([2, 7, 9, 3, 1])    # -> 12  (rob houses 0, 2, and 4: 2 + 9 + 1 = 12)
max_non_adjacent_sum([])                  # -> 0
```

## Hint

For each house `i`, you have exactly two choices: **skip it** (the best answer is whatever the best answer was up through house `i-1`), or **rob it** (its own amount, plus the best answer up through house `i-2`, since house `i-1` is now off-limits). Define `best(i)` as the best achievable total considering only houses `0..i`, and find the recurrence relating `best(i)` to `best(i-1)` and `best(i-2)`.

## Reflection Questions

1. What are this problem's base cases (the smallest inputs you can answer directly, with no further recursion/lookup needed)?
2. This problem can be solved with an O(n) array (tabulation), but can also be solved with just two variables tracking the previous two answers, no array at all. Why does that work here specifically — what property of the recurrence makes it possible to avoid storing the entire table?
3. How is this problem's shape (a choice at each step: skip, or take-plus-look-back) similar to the 0/1 knapsack problem from this lesson's main `implementation.py`? How is it different?

## Deliverable

A working `max_non_adjacent_sum` function plus answers to the three reflection questions.
