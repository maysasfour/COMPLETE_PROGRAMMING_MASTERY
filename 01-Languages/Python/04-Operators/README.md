# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Beginner: Arithmetic Operators

```python
7 + 3     # 10
7 - 3     # 4
7 * 3     # 21
7 / 3     # 2.3333333333333335 - true division, ALWAYS returns a float
7 // 3    # 2 - floor division, rounds down toward negative infinity
7 % 3     # 1 - modulo (remainder)
7 ** 3    # 343 - exponentiation
```

`/` always produces a `float` in Python 3, even for evenly divisible integers (`10 / 2 == 5.0`, not `5`). Use `//` when you specifically want integer (floor) division.

Floor division with negative numbers rounds **toward negative infinity**, not toward zero — `-7 // 2` is `-4`, not `-3`. This trips people coming from C-family languages where integer division truncates toward zero.

## Beginner: Comparison Operators

```python
5 == 5      # True - equal value
5 != 3      # True - not equal
5 > 3       # True
5 < 3       # False
5 >= 5      # True
5 <= 4      # False
```

These call `__eq__`, `__lt__`, etc. under the hood — custom classes can define their own comparison behavior (Lesson 11).

## Beginner: Logical Operators

```python
True and False    # False
True or False       # True
not True               # False
```

`and`/`or` are **short-circuiting**: `and` returns the first falsy operand (or the last, if all are truthy); `or` returns the first truthy operand (or the last, if all are falsy). They return one of the *original operands*, not necessarily a `bool`:

```python
0 and 5        # 0 - short-circuits, returns the falsy left operand without evaluating the right
"" or "default"  # "default" - left is falsy, so evaluate and return the right operand
5 and 10          # 10 - both truthy, "and" returns the LAST operand
```

This is the mechanism behind the common idiom `value = provided or default_value`.

## Intermediate: `is` vs. `==`

This is one of the most important distinctions in the language:

- `==` checks **value equality** (calls `__eq__`) — "do these represent the same value?"
- `is` checks **identity** — "are these literally the same object in memory?"

```python
a = [1, 2, 3]
b = [1, 2, 3]
a == b     # True - same contents
a is b       # False - two distinct list objects that happen to hold equal values

c = a
c is a         # True - c and a are literally bound to the same object
```

**Always use `is`/`is not` for `None` comparisons** (`x is None`), and generally reserve `is` for identity checks against singletons (`None`, sometimes `True`/`False`). Use `==` for everything else.

A subtlety: small integers (`-5` to `256`) and some short strings are cached/interned by CPython, so `a = 5; b = 5; a is b` can return `True` — but this is an implementation detail you should never rely on. Only `is None` is a safe, portable use of `is`.

## Intermediate: Membership Operators

```python
3 in [1, 2, 3]         # True
3 not in [1, 2, 3]        # False
"a" in "cat"                 # True - substring check for strings
"a" in {"a": 1, "b": 2}        # True - checks dict KEYS by default
"x" in {"a": 1, "b": 2}        # False - "x" is not a key (only "a" and "b" are)
```

`in` on a `set` or `dict` is average O(1) (hash lookup); `in` on a `list` is O(n) (linear scan). For large collections where membership testing matters, prefer a `set`.

## Advanced: Bitwise Operators

```python
5 & 3     # 1  - AND
5 | 3     # 7  - OR
5 ^ 3     # 6  - XOR
~5          # -6 - NOT (bitwise complement)
5 << 1        # 10 - left shift (multiply by 2)
5 >> 1          # 2  - right shift (divide by 2, floor)
```

Bitwise operators work on the integer's binary representation directly. They're common in low-level code, flag/permission bitmasks, and performance-sensitive numeric code — much less common in everyday application code than the other operator categories.

## Real-World Usage

- `value = config.get("timeout") or DEFAULT_TIMEOUT` (the `or`-default idiom) is everywhere in real code, though it has a sharp edge: it also replaces a legitimately falsy value like `0`, so `config.get("retries") or 3` is *wrong* if `0` retries is a valid, meaningful setting — use `config.get("retries", 3)` or an explicit `is None` check instead.
- `is None` checks dominate real codebases for optional/nullable values — you will see this constantly in any nontrivial Python project.
- Membership tests (`in`) against a `set` built specifically for fast lookup is a routine performance optimization when checking "is this item one of many allowed/blocked values."

## Summary

- `/` always returns a float; `//` is floor division (rounds toward negative infinity); `%` is remainder.
- `and`/`or` short-circuit and return one of their original operands, not necessarily a bool.
- `==` compares value; `is` compares identity. Use `is` only for `None`/singleton checks.
- `in`/`not in` test membership; O(1) average on sets/dicts, O(n) on lists.
- Bitwise operators (`& | ^ ~ << >>`) operate on binary representation, mostly relevant to low-level/flag-based code.

## Key Terms

- **Floor division (`//`)** — division that rounds down toward negative infinity, always returning an int if both operands are int.
- **Short-circuit evaluation** — `and`/`or` stop evaluating as soon as the result is determined, and may skip evaluating the right operand entirely.
- **Identity** — whether two names refer to the exact same object in memory (`is`).
- **Equality** — whether two objects represent the same value (`==`, via `__eq__`).
- **Membership operator** — `in`/`not in`, testing whether a value exists within a collection.

## Common Mistakes

- Using `is` to compare values (e.g., `if x is 5:`) instead of `==` — this can appear to work due to CPython's small-integer caching, then break unpredictably for larger numbers or different objects.
- Using `value or default` when `0`, `""`, or `False` are legitimate values, accidentally overriding them with the default.
- Assuming `/` returns an int when both operands are int — it always returns a float in Python 3.
- Forgetting that floor division rounds toward negative infinity, not zero, for negative operands.
- Using `in` on a large list repeatedly in a hot loop instead of converting to a `set` first.

## Best Practices

- Reserve `is`/`is not` exclusively for `None` (and rarely, singleton sentinel objects you define yourself).
- Use `dict.get(key, default)` instead of `dict.get(key) or default` when `0`/`""`/`False` could be legitimate stored values.
- Convert a list to a `set` before doing repeated membership tests in a loop.
- Prefer `//` explicitly when integer division is intended, to make the intent clear rather than relying on `int(x / y)`.

## Interview Questions

1. **What's the difference between `is` and `==`?**
   `==` checks whether two objects have equal *value* (via `__eq__`); `is` checks whether two names refer to the *exact same object* in memory (identity). Two equal-valued objects are not necessarily the same object.

2. **Why does `10 / 2` return `5.0` instead of `5` in Python 3?**
   Python 3's `/` is "true division" and always returns a float, regardless of whether the division is exact. This was a deliberate change from Python 2, where `/` behaved like floor division for two ints. Use `//` for floor division that stays an int when both operands are int.

3. **What does short-circuit evaluation mean for `and`/`or`, and what do they actually return?**
   They stop evaluating as soon as the outcome is determined and return one of the original operands (not necessarily coerced to `bool`). `and` returns the first falsy operand or the last operand if all are truthy; `or` returns the first truthy operand or the last if all are falsy.

4. **Why is `value = config.get("retries") or 3` a bug if 0 retries is valid?**
   Because `or` falls through to the default whenever the left side is *falsy*, and `0` is falsy — so a deliberately configured `0` gets silently replaced by `3`. The fix is `config.get("retries", 3)` or an explicit `if x is None: x = 3`.

5. **Why should you almost never use `is` to compare two integers or strings for equality?**
   CPython caches small integers and some string literals for performance, so `is` can appear to "work" by coincidence for small values, then silently fail for larger integers or dynamically constructed strings — relying on this is relying on an implementation detail, not a language guarantee.

## Suggested Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
