# Solution 03 — Order Data Pipeline

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-03-order-data-pipeline.md)

## Approach

Steps 1–3 build the pipeline explicitly, stage by stage (filter → map → reduce), materializing an intermediate list at each step — useful for understanding what each stage produces. Step 4 collapses all three stages into a single generator expression passed directly to `sum()`, computing the identical result (`172.49` both ways, verified by running) without ever building an intermediate `shipped`/`totals` list. Step 5 uses `dict.get(key, default)` as a simple accumulator pattern to build up per-customer totals in one pass over the shipped orders.

## Reflection Answers

1. **Why might the single-generator-expression version use less memory for a very large list?** The three-stage version (steps 1–3) builds two full intermediate lists (`shipped`, then `totals`) before reducing — for a very large `orders` list, both intermediate lists occupy memory simultaneously. A generator expression, by contrast, produces one order's total at a time, lazily, and `sum()` consumes it immediately without ever holding more than one item's data in memory at once — no intermediate list is ever fully materialized.

2. **When would you prefer `reduce()` vs. a plain `for` loop with an accumulator?** A `for` loop with an explicit accumulator (as used in step 5) is usually more readable when the aggregation involves multiple related pieces of state (here, a whole dictionary being built up) or conditional logic mixed into the accumulation. `reduce()` tends to read more cleanly for a single, simple running value (a sum, a product, a single running maximum) where the combining logic fits naturally into one short lambda — beyond that, an explicit loop is often clearer to a reader, even though both express the same underlying "fold" operation.
