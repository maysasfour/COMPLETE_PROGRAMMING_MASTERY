# Exercises — Collections

Attempt these yourself before checking [../Solutions](../Solutions/README.md).

## Exercise 1 — Word Frequency Counter

Given the string `"the quick brown fox jumps over the lazy dog the fox runs"`, split it into words and build a Hash mapping each word to how many times it appears, using `each_with_object` and a `Hash.new(0)` default. Print the result sorted by count descending (highest-frequency word first), using `sort_by`.

## Exercise 2 — Inventory Summary with `group_by` and `sum`

Given an array of inventory item hashes: `[{name: "Widget", category: :hardware, qty: 5}, {name: "Bolt", category: :hardware, qty: 100}, {name: "Manual", category: :docs, qty: 20}]`, group the items by `:category` using `group_by`, then produce a Hash mapping each category to the **total quantity** across all items in that category (using `sum` on the grouped values). Print the final per-category totals.
