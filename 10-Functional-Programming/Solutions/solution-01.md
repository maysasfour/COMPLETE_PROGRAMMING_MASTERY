# Solution 01 — Purify These Functions

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-01-purify-these-functions.md)

## Approach

`sell_pure` uses dict unpacking (`{**inventory, item: ...}`) to build a **new** dictionary that copies every existing key and then overrides just the one being changed — the original `inventory` dict is never touched. `add_discount_pure` uses a list comprehension to build a **new** list of discounted prices, leaving the original list untouched.

Verified by running: `original_inventory` printed `{'widgets': 10}` both before and after calling `sell_pure`, confirming it was never mutated; `new_inventory` correctly showed `{'widgets': 7}`. Same story for the prices list.

## Reflection Answers

1. **Why is `add_discount_impure` harder to test reliably?** Because it mutates its input, a test must either accept that the input list is destroyed after one call (so a second test needing the original data must rebuild it), or explicitly copy the input before each test run to avoid one test's mutation leaking into the next. `add_discount_pure` has no such concern — the same input list can be reused across as many test calls as needed, since it's never modified.

2. **Would `lru_cache` be safe on `sell_impure`? On `sell_pure`?** Not on `sell_impure` — it depends on and mutates the external `inventory` dict, so caching a result based only on `(item, quantity)` would ignore that the *same* call at a different time (with a different `inventory` state) should produce a different result; worse, `dict` isn't hashable, so it couldn't even be used as a cache key without extra work. `sell_pure` is safe to cache *if* its `inventory` argument is itself hashable (e.g., converted to a `frozenset` of items) — being pure means its result depends only on its actual arguments, which is exactly the property `lru_cache` requires.
