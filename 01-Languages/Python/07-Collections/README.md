# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Beginner: Lists

A `list` is an ordered, mutable sequence that can hold mixed types, though in practice most lists are homogeneous.

```python
fruits = ["apple", "banana", "cherry"]
fruits.append("date")          # add to the end
fruits.insert(1, "avocado")    # insert at a specific index
fruits.remove("banana")        # remove by value (first match)
last = fruits.pop()            # remove and return the last item
print(fruits[0])               # indexing
print(fruits[-1])              # negative indices count from the end
print(fruits[1:3])             # slicing - stop index is exclusive
```

Lists are mutable — `.append()`, `.insert()`, `.remove()`, `.pop()`, `.sort()`, and `.reverse()` all change the list **in place** and return `None`, which is why `sorted_list = fruits.sort()` is a classic bug (it assigns `None`, not the sorted list).

## Beginner: Tuples

A `tuple` looks like a list but is **immutable** — once created, it can't be resized or have its elements reassigned.

```python
point = (3, 4)
x, y = point   # unpacking
print(point[0])

# point[0] = 10  # TypeError: 'tuple' object does not support item assignment
```

Because tuples are immutable (and hashable, if their contents are), they can be used as dictionary keys or set members — lists never can, since mutable objects aren't hashable. Tuples are the natural choice for fixed-size, heterogeneous records (`(name, age, city)`), while lists suit variable-length, homogeneous collections.

A single-element tuple needs a trailing comma: `(1,)` is a tuple, `(1)` is just the integer `1` in parentheses.

## Intermediate: Sets

A `set` is an unordered collection of **unique**, hashable elements — duplicates are automatically dropped.

```python
tags = {"python", "code", "python", "tutorial"}
print(tags)              # {'python', 'code', 'tutorial'} - duplicate dropped, order not guaranteed

a = {1, 2, 3}
b = {2, 3, 4}
print(a | b)   # union -> {1, 2, 3, 4}
print(a & b)   # intersection -> {2, 3}
print(a - b)   # difference -> {1}
print(a ^ b)   # symmetric difference -> {1, 4}
```

Sets are the right tool whenever you need fast membership testing (`x in my_set` is O(1) average, versus O(n) for `x in my_list`) or need to deduplicate a collection without caring about order.

## Intermediate: Dictionaries

A `dict` maps hashable keys to values. Since Python 3.7, dicts preserve **insertion order** as a language guarantee (not just an implementation detail).

```python
person = {"name": "Ada", "age": 36}
person["email"] = "ada@example.com"   # add/update a key
print(person.get("age"))              # safe lookup - returns None (or a default) if missing
print(person.get("phone", "N/A"))     # explicit default instead of None

for key, value in person.items():
    print(key, value)

person.setdefault("roles", []).append("admin")   # get-or-create in one call
```

`person["missing"]` raises `KeyError` if the key doesn't exist; `.get()` never raises — it returns `None` or your chosen default instead. `.setdefault(key, default)` returns the existing value if the key is present, otherwise inserts `default` and returns it, which is handy for "append to a list that might not exist yet" patterns.

## Advanced: Comprehensions

Comprehensions build a new collection from an iterable in a single, readable expression instead of a manual loop with `.append()`.

```python
squares = [n ** 2 for n in range(6)]                  # list comprehension
evens = [n for n in range(10) if n % 2 == 0]          # with a filter condition
unique_lengths = {len(w) for w in ["a", "bb", "cc"]}  # set comprehension
squares_by_n = {n: n ** 2 for n in range(5)}          # dict comprehension

# Nested loops read left-to-right, same order as writing them as nested `for`s.
pairs = [(x, y) for x in range(2) for y in range(2)]  # [(0,0), (0,1), (1,0), (1,1)]
```

A comprehension is equivalent to the loop it replaces, just built as a single expression:

```python
squares = []
for n in range(6):
    squares.append(n ** 2)
# is the same as:
squares = [n ** 2 for n in range(6)]
```

Comprehensions are appropriate for straightforward "transform and/or filter" logic; once you need multiple statements, side effects, or several levels of nested conditionals, a plain loop is more readable and comprehensions should be avoided.

## Real-World Usage

- Dicts are the backbone of JSON-like data — API responses, config files, and `**kwargs` all naturally map onto Python dicts (see Lesson 10 for reading JSON directly into dicts).
- Sets are used for deduplication (`list(set(items))` to remove duplicates when order doesn't matter) and for fast "is this ID in the allowed set" membership checks.
- List comprehensions are the idiomatic way to transform data pulled from a database or API response into a shape your code needs, replacing verbose manual loops.
- Tuples are common as function return values for multiple results (`return min_val, max_val`) since Python auto-packs/unpacks them.

## Summary

- Lists are ordered and mutable; tuples are ordered and immutable; both allow duplicates and preserve insertion order.
- Sets are unordered, deduplicated, and optimized for fast membership testing; set operations (`|`, `&`, `-`, `^`) mirror mathematical set theory.
- Dicts map keys to values, preserve insertion order (3.7+), and offer `.get()`/`.setdefault()` for safe, no-`KeyError` access patterns.
- List/set/dict comprehensions build a new collection in one expression; they're sugar for a simple loop, not a replacement for every loop.
- Mutating methods (`.append()`, `.sort()`, etc.) return `None` — never assign their result back to a variable expecting the changed collection.

## Key Terms

- **Mutable / immutable** — whether an object's contents can be changed after creation (list: mutable; tuple: immutable).
- **Hashable** — an object with a stable hash value, required for dict keys and set members; mutable containers (list, dict, set) are not hashable.
- **Membership test** — checking `x in collection`; O(1) average for sets/dicts, O(n) for lists/tuples.
- **Comprehension** — a single-expression syntax for building a list, set, or dict from an iterable, optionally filtered and/or transformed.
- **Insertion order** — the guarantee (since Python 3.7) that dict keys iterate in the order they were first added.

## Common Mistakes

- Writing `sorted_list = my_list.sort()` and getting `None`, because `.sort()` sorts in place and returns `None` (use `sorted(my_list)` if you need a new sorted list returned).
- Trying to use a list as a dict key or set member and hitting `TypeError: unhashable type: 'list'` — use a tuple instead if you need a fixed, hashable collection.
- Assuming set/dict iteration order is meaningful for logic (older habits from other languages) — dicts do preserve insertion order in modern Python, but sets do not guarantee any particular order.
- Forgetting the trailing comma on a single-element tuple: `(1)` is just `1`, not a tuple.
- Overusing nested comprehensions until they're harder to read than the loop they replaced.

## Best Practices

- Reach for a tuple when the collection's size and meaning are fixed (a coordinate, a database row); reach for a list when it will grow, shrink, or be reordered.
- Use `.get()` or `.setdefault()` instead of a `try`/`except KeyError` when a missing key is an expected, normal case rather than an error.
- Use a set for membership testing against more than a handful of items instead of `if x in some_list`.
- Keep comprehensions to one, at most two, levels of nesting/conditions — extract a loop (or a named function) once it stops being a one-glance read.
- Prefer `dict.items()` when you need both key and value in a loop, rather than looking up `d[key]` again inside a `for key in d:` loop.

## Interview Questions

1. **What's the difference between a list and a tuple, beyond mutability?**
   Tuples are hashable (if their elements are), so they can be dict keys or set members; lists never can be, since they're mutable. Tuples are conventionally used for fixed-size heterogeneous records, lists for variable-length homogeneous sequences — though Python doesn't enforce either convention.

2. **Why is checking membership in a set faster than in a list?**
   A set is backed by a hash table, so checking `x in my_set` computes a hash and does an (average) O(1) lookup. A list has no such index — `x in my_list` must scan elements one by one, which is O(n) in the worst case.

3. **What does `dict.get("key", default)` do differently from `dict["key"]`?**
   `dict["key"]` raises `KeyError` if the key isn't present. `dict.get("key", default)` returns `default` (or `None` if no default is given) instead of raising, making it the safer choice when a missing key is a normal, expected possibility rather than a bug.

4. **How would you remove duplicates from a list while preserving order?**
   `list(set(my_list))` removes duplicates but does not guarantee order. To preserve first-seen order, use `list(dict.fromkeys(my_list))`, which relies on both dicts rejecting duplicate keys and modern Python dicts preserving insertion order.

5. **What's the difference between a list comprehension and a generator expression?**
   `[x for x in items]` (square brackets) eagerly builds the entire list in memory immediately. `(x for x in items)` (parentheses) creates a generator that produces values lazily, one at a time, which is more memory-efficient for large or infinite sequences but can only be iterated once.

## Suggested Next Lesson

[08 — Strings](../08-Strings/README.md)
