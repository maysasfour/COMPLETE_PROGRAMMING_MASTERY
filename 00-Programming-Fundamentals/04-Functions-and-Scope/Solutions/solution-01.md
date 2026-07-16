# Solution 01 — Counter Factory and Recursive Sum

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Full runnable code is in `solution-01.py`. Verified output:

```
--- Part A: Closures ---
counter_a() = 1
counter_a() = 2
counter_b() = 1

--- Part B: Recursion ---
sum_digits(1234) = 10
sum_digits(7) = 7

--- Part C: Mutable default argument ---
Buggy   call 1 (user=Alice): ['Alice']
Buggy   call 2 (user=Bob):   ['Alice', 'Bob']  <- Bob's call sees Alice too, that's the bug
Fixed   call 1 (user=Alice): ['Alice']
Fixed   call 2 (user=Bob):   ['Bob']  <- correctly independent
```

## Part A Walkthrough

```python
def make_counter():
    count = 0
    def increment():
        nonlocal count
        count += 1
        return count
    return increment
```

`nonlocal count` is required because Python decides a variable is local to a function based on whether that function *assigns* to it anywhere in its body — and `count += 1` is an assignment. Without `nonlocal`, Python would treat `count` inside `increment()` as a brand-new local variable, and the `+= 1` (which first *reads* `count` before writing it) would fail with `UnboundLocalError` since the local `count` wouldn't exist yet at the point of the read.

`counter_a` and `counter_b` are independent because each call to `make_counter()` creates a fresh local scope with its own `count = 0`. The two `increment` closures each capture a reference to a *different* enclosing scope's `count` — they were never the same variable to begin with.

## Part B Walkthrough

```python
def sum_digits(n):
    if n < 10:
        return n
    return n % 10 + sum_digits(n // 10)
```

Base case: `n < 10` means `n` is already a single digit, so its digit sum is itself — return immediately, no further recursion. Recursive case: `n % 10` peels off the last digit, and `n // 10` is a strictly smaller number passed to the recursive call. Since integer division by 10 always reduces a positive number's magnitude, every call moves closer to the base case, guaranteeing termination.

## Part C Walkthrough

The buggy version's `log=[]` default is created exactly once, when `track_visit_buggy` is *defined* — not once per call. Every call that omits `log` shares that same list object, so Bob's call sees Alice still sitting in the list from the previous call. The fixed version defaults to `log=None` (immutable, safe to share) and only constructs a new list inside the function body when needed, guaranteeing each call gets its own list unless the caller explicitly passes one in.

## Common Pitfalls

- Forgetting `nonlocal` and getting `UnboundLocalError` — a good sign you actually understand *why* it's needed, not just that it's needed.
- Reversing the base/recursive case in `sum_digits` (e.g., checking `n == 0` instead of `n < 10`) — this would recurse one extra time on single-digit inputs and either produce wrong results or need extra defensive code.
- "Fixing" the mutable default bug by doing `log = log or []` instead of `if log is None: log = []` — this looks equivalent but silently replaces a *falsy but valid* argument (like an empty list explicitly passed in) with a new list, which is a subtler version of the same class of bug.
