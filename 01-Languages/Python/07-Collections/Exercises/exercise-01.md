# Exercise 01 — Inventory Aggregator

[Back to lesson](../README.md)

## Task

You're given a list of purchase records, where each record is a tuple of `(item_name, quantity, category)`:

```python
purchases = [
    ("widget", 3, "hardware"),
    ("gadget", 1, "hardware"),
    ("widget", 2, "hardware"),
    ("banana", 5, "produce"),
    ("apple", 4, "produce"),
    ("banana", 1, "produce"),
]
```

Write the following functions, using dict/set/list features from the lesson (no external libraries):

1. `total_quantities(purchases)` — returns a dict mapping each `item_name` to its **total** quantity across all records, using `.setdefault()` or `.get()` (not a `defaultdict`, which this lesson doesn't cover).
2. `categories(purchases)` — returns a **set** of all distinct categories present.
3. `top_item(totals)` — takes the dict from `total_quantities` and returns the `(item_name, quantity)` pair with the highest quantity. Do this without importing anything (a plain loop or a comprehension + built-in is fine).
4. `summary_by_category(purchases)` — returns a dict mapping each category to a **list** of item names (not quantities) purchased in that category, in first-seen order, with no duplicate item names within a category's list.

Print all four results for the `purchases` list above.

## Reflection Questions

1. In `total_quantities`, why does `.setdefault(item_name, 0)` followed by `+=` work correctly even the first time a given `item_name` is seen? Walk through exactly what `.setdefault` returns on that first call.
2. Why is a `set` the right choice for `categories`, rather than a list you deduplicate afterward?
3. In `summary_by_category`, you need order-preserving deduplication *within* each category's list. Which approach did you use, and why didn't a plain `set` work here even though sets deduplicate?

## Deliverable

A working script implementing all four functions, run against the given `purchases` list, plus answers to the three reflection questions. Do not peek at `Solutions/solution-01.py` until you've attempted your own version.
