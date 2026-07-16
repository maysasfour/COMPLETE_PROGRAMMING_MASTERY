# Solution 01 — Inventory Aggregator

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
total_quantities -> {'widget': 5, 'gadget': 1, 'banana': 6, 'apple': 4}
categories -> {'hardware', 'produce'}
top_item -> ('banana', 6)
summary_by_category -> {'hardware': ['widget', 'gadget'], 'produce': ['banana', 'apple']}
```

## Explanation

`total_quantities` walks every record once, using `.setdefault(item_name, 0)` to fetch the running total (creating it at `0` the first time a name is seen) and then adds this record's quantity to it:

```python
totals = {}
for item_name, quantity, _category in purchases:
    totals[item_name] = totals.setdefault(item_name, 0) + quantity
```

`categories` is a one-line set comprehension — the set itself is what removes duplicates, so no manual "have I seen this before" check is needed:

```python
{category for _name, _qty, category in purchases}
```

`top_item` uses the built-in `max()` with a `key=` function pulling the quantity out of each `(name, quantity)` pair, avoiding a manual "track the biggest so far" loop:

```python
max(totals.items(), key=lambda pair: pair[1])
```

`summary_by_category` needs order-preserving deduplication *within* each category's list, so a plain `set` won't do (sets don't preserve order, and this lesson wants first-seen order). The fix is to check membership before appending:

```python
by_category = {}
for item_name, _quantity, category in purchases:
    items_list = by_category.setdefault(category, [])
    if item_name not in items_list:
        items_list.append(item_name)
```

## Reflection Answers

1. `.setdefault(item_name, 0)` checks whether `item_name` is already a key. The first time a name appears, it isn't, so `.setdefault` inserts `item_name: 0` into the dict *and returns that same `0`* — meaning `totals[item_name] = 0 + quantity` on that first encounter, which correctly seeds the running total with the first record's quantity rather than accidentally skipping it or requiring a separate "is this the first time" branch.

2. A `set` is the right choice for `categories` because the requirement is purely "give me the distinct values, order doesn't matter." Building a list and deduplicating afterward (e.g. `list(dict.fromkeys(...))`) would work too but does unnecessary extra work (preserving an order nobody asked for) — a set says exactly what's needed and lets the data structure enforce uniqueness automatically as items are added.

3. A plain `set` doesn't work for `summary_by_category` because sets don't preserve insertion order, and the exercise explicitly wants "first-seen order" within each category's list. The solution above uses an explicit `if item_name not in items_list` membership check against the growing list before appending — this is O(n) per check on a list, but for small per-category lists that's a perfectly reasonable, simple approach; the order-preserving `dict.fromkeys()` trick from Lesson 07 README's "Common Mistakes" section is a faster alternative if performance mattered more than this exercise requires.

## Common Pitfalls

- Using `totals[item_name] += quantity` directly without `.setdefault` or `.get(..., 0)` first, which raises `KeyError` on the first occurrence of any new item name.
- Building `categories` as a list and manually checking `if category not in categories_list` — functionally correct, but reinventing what a `set` already does for free.
- Forgetting that a `set` for the per-category item lists would silently reorder (or appear to reorder) results, since sets don't guarantee iteration order.
