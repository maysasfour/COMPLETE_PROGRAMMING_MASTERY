# Exercise 01 — Purify These Functions

[Back to Exercises](README.md) | Covers: [Lesson 01 — Pure Functions and Immutability](../01-Pure-Functions-and-Immutability/README.md)

**Difficulty: Beginner**

## Task

Below are two impure functions. Rewrite each as a pure equivalent (same behavior, but no side effects), then verify both versions side by side.

```python
inventory = {"widgets": 10}

def sell_impure(item, quantity):
    inventory[item] -= quantity   # mutates a variable OUTSIDE the function
    return inventory[item]

def add_discount_impure(prices):
    for i in range(len(prices)):
        prices[i] = prices[i] * 0.9   # mutates the CALLER's list
    return prices
```

1. Write `sell_pure(inventory, item, quantity)` that returns a **new** dict reflecting the sale, leaving the original `inventory` dict untouched.
2. Write `add_discount_pure(prices)` that returns a **new** list with the discount applied, leaving the original list untouched.
3. In a script, call both the impure and pure versions with the same starting data, and print the "before" and "after" state of the original data structure in each case to demonstrate the difference.

## Reflection Questions

1. Why is `add_discount_impure` harder to test reliably than `add_discount_pure`? (Think about what state you'd need to reset between test runs.)
2. Would it be safe to apply `functools.lru_cache` to `sell_impure`? What about to `sell_pure`? Explain why.

## Deliverable

A runnable `.py` file demonstrating both impure/pure pairs, printed evidence that the pure versions leave their inputs unchanged, and written answers to both reflection questions.
