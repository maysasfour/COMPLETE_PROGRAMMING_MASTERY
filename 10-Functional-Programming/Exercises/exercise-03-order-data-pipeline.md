# Exercise 03 — Order Data Pipeline

[Back to Exercises](README.md) | Covers: [Lesson 03 — Map, Filter, Reduce](../03-Map-Filter-Reduce/README.md)

**Difficulty: Intermediate**

## Task

Given a list of order dictionaries:

```python
orders = [
    {"id": 1, "customer": "Ada", "total": 42.50, "status": "shipped"},
    {"id": 2, "customer": "Grace", "total": 15.00, "status": "pending"},
    {"id": 3, "customer": "Ada", "total": 99.99, "status": "shipped"},
    {"id": 4, "customer": "Linus", "total": 5.25, "status": "cancelled"},
    {"id": 5, "customer": "Grace", "total": 30.00, "status": "shipped"},
]
```

1. Using `filter()` (or a comprehension), compute the list of orders with `status == "shipped"`.
2. Using `map()` (or a comprehension) on the result of (1), extract just the `total` values.
3. Using `functools.reduce()` (or `sum()`) on the result of (2), compute the total revenue from shipped orders.
4. Write the same computation as a **single** generator expression passed to `sum()`, with no intermediate lists.
5. Compute a dict mapping each customer name to their total spent across *all* their shipped orders (a small custom reduction — a plain loop or `reduce()` both work).

## Reflection Questions

1. Why might the single-generator-expression version in step 4 use less memory than the map/filter/reduce chain in steps 1–3, for a very large `orders` list?
2. `reduce()` and a plain `for` loop with an accumulator variable can express the same logic. When would you prefer one over the other for readability?

## Deliverable

A runnable `.py` file computing and printing all five results above against the sample data, plus written answers to both reflection questions.
