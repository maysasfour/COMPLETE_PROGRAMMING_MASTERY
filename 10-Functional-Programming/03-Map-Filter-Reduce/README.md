# 03 — Map, Filter, Reduce

[Back to module overview](../README.md) | [Previous: Higher-Order Functions](../02-Higher-Order-Functions/README.md)

## Beginner: `map()` — Transform Every Element

`map(func, iterable)` applies `func` to every element, producing a new sequence of results.

```python
numbers = [1, 2, 3, 4, 5]
doubled = map(lambda n: n * 2, numbers)
list(doubled)   # [2, 4, 6, 8, 10]
```

Python's more idiomatic equivalent is usually a **list comprehension**:

```python
[n * 2 for n in numbers]   # identical result, more Pythonic
```

## Beginner: `filter()` — Select Matching Elements

`filter(predicate, iterable)` keeps only the elements for which `predicate` returns `True`.

```python
evens = filter(lambda n: n % 2 == 0, numbers)
list(evens)   # [2, 4]

[n for n in numbers if n % 2 == 0]   # the comprehension equivalent
```

## Intermediate: `reduce()` — Aggregate Down to One Value

`functools.reduce(func, iterable, initial)` repeatedly applies `func(accumulator, element)`, folding the whole sequence down to a single result.

```python
from functools import reduce
total = reduce(lambda acc, n: acc + n, numbers, 0)   # 0 is the starting accumulator
```

Python's built-in `sum()`/`max()`/`min()`/`any()`/`all()` cover the most common reduce cases directly and are preferred when they apply — `reduce()` is for genuinely custom aggregation logic that these don't cover.

## Intermediate: Chaining Them Together

```python
# sum of the squares of the even numbers
reduce(lambda acc, n: acc + n, map(lambda n: n * n, filter(lambda n: n % 2 == 0, numbers)), 0)

# the more Pythonic equivalent: a single generator expression + sum()
sum(n * n for n in numbers if n % 2 == 0)
```

Both produce identical results, verified live. The nested `map`/`filter` version demonstrates the classic functional pipeline shape; the generator-expression version is idiomatic Python and considered more readable for most cases — knowing both is valuable since the pipeline shape (`reduce(f, map(g, filter(p, xs)))`) appears in essentially the same form across JavaScript, Kotlin, Rust, and every other language covered in this repository's `01-Languages` module.

## Advanced: `map()` and `filter()` Are Lazy

```python
call_log = []
def logged_square(n):
    call_log.append(n)
    return n * n

lazy_map = map(logged_square, numbers)
print(call_log)          # [] -- EMPTY! Nothing has run yet.
first_value = next(lazy_map)
print(call_log)           # [1] -- NOW logged_square(1) actually ran
```

Verified live: `map()` returned immediately with an empty call log — no element was actually processed until `next()` pulled a value from it. `map()`/`filter()` in Python 3 are lazy iterators, not eagerly-computed lists (a real difference from Python 2, where they returned lists directly) — this matters for large or infinite sequences, since transformations only run on the elements actually consumed, not the entire input upfront.

## Real-World Usage

- Data processing pipelines (pandas' `.apply()`, Spark's RDD transformations, SQL's `SELECT`/`WHERE`/`SUM`) are conceptually map/filter/reduce operating on much larger datasets.
- Any language's stream/iterator API — Java Streams, C#'s LINQ, JavaScript's `Array.prototype.map/filter/reduce`, Rust's iterator adapters (all covered in this repository's `01-Languages` module) — follows this exact same shape.
- Lazy evaluation (as demonstrated with `map`/`filter` here) underlies generators and is essential for processing datasets too large to fit in memory, or infinite sequences (e.g., an endless stream of sensor readings).

## Summary

- `map()` transforms every element; `filter()` selects a subset matching a predicate; `reduce()` folds a sequence down to a single aggregate value.
- List/generator comprehensions are usually the more idiomatic Python equivalent, though `map`/`filter`/`reduce` remain useful (and are the standard vocabulary in most other languages).
- `map()` and `filter()` are lazy in Python 3 — verified live, no element is processed until the result is actually consumed.

## Key Terms

- **`map()`** — applies a function to every element of an iterable, lazily.
- **`filter()`** — selects elements from an iterable matching a predicate function, lazily.
- **`functools.reduce()`** — folds an iterable down to a single accumulated value using a binary function.
- **Lazy evaluation** — computing a value only when it's actually needed/consumed, not eagerly ahead of time.

## Common Mistakes

- Forgetting `map()`/`filter()` return lazy iterators in Python 3, not lists — printing `map(...)` directly shows a `<map object at ...>`, not the values; `list(...)` (or iterating) is needed to materialize them.
- Trying to iterate over the same `map`/`filter` object twice — once consumed, an iterator is exhausted and yields nothing on a second pass; convert to a list first if multiple passes are needed.
- Forgetting `reduce()`'s initial value argument — without it, `reduce()` uses the iterable's first element as the initial accumulator, which fails outright (`TypeError`) on an empty iterable.

## Interview Questions

1. **What's the difference between `map()`/`filter()` in Python 3 and a list comprehension that does the same thing?**
   Functionally, both produce the same transformed/filtered results, but `map()`/`filter()` return lazy iterators (values computed on demand as consumed) while a list comprehension eagerly builds a full list immediately. Python style generally favors comprehensions for readability, but `map`/`filter` remain useful when a function reference is already at hand (`map(str.upper, words)`) or when composing with other iterator-based tools that expect a lazy iterable.

2. **How does `reduce()` differ from `sum()`, and when would you reach for `reduce()` instead?**
   `sum()` is a specialized, built-in reduction specifically for addition (with an optional starting value). `reduce(func, iterable, initial)` is the fully general version, accepting *any* binary combining function — multiplication, string concatenation, finding the maximum, building up a dictionary, or any other custom fold. Use `sum()`/`max()`/`min()`/`any()`/`all()` when they directly express the intended operation; reach for `reduce()` when the aggregation logic is genuinely custom and doesn't match one of those built-ins.

3. **What does it mean for `map()`/`filter()` to be "lazy," and why does this matter?**
   It means no element is actually processed until the result is consumed (via `next()`, a `for` loop, or `list()`) — verified live in this lesson, where creating a `map()` object triggered zero calls to the mapped function until the first value was explicitly pulled from it. This matters for efficiency (nothing is computed that's never used) and for correctness with infinite or very large sequences, where eagerly computing every result upfront would be impossible or wasteful.

## Suggested Next Lesson

[04 — Function Composition](../04-Function-Composition/README.md)
