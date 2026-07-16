# Exercise 01 — Counter Factory and Recursive Sum

[Back to lesson](../README.md)

## Part A — Closures

Write a function `make_counter()` that returns a function `increment()`. Each call to `increment()` should return the next integer starting from 1 (1, 2, 3, ...), using a closure to remember the count between calls (no global variables allowed).

```python
counter_a = make_counter()
counter_b = make_counter()
print(counter_a())  # 1
print(counter_a())  # 2
print(counter_b())  # 1  <- independent from counter_a
```

Explain in a comment why `counter_a` and `counter_b` don't interfere with each other.

**Hint:** a plain `count += 1` inside the inner function will raise an `UnboundLocalError` — you'll need `nonlocal`. Explain why in a comment (tie it back to the lesson's coverage of assignment creating a new local variable by default).

## Part B — Recursion

Write a recursive function `sum_digits(n)` that returns the sum of the digits of a non-negative integer `n` (e.g., `sum_digits(1234)` returns `10`). Identify and comment your base case and recursive case explicitly.

## Part C — Mutable Default Argument

Write a *buggy* function `track_visit(user, log=[])` that appends `user` to `log` and returns it, demonstrating the shared-default-list bug from the lesson. Then write a *fixed* version. Call each version twice with different users and print both results to show the difference.

## Deliverable

A single `.py` file with all three parts. Do not look at `Solutions/solution-01.py` until you've written and run your own version.
