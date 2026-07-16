# 01 — Pure Functions and Immutability

[Back to module overview](../README.md)

## Beginner: What Makes a Function "Pure"

A **pure function** has two properties: given the same inputs, it always returns the same output, and it causes no **side effects** — it doesn't modify anything outside its own scope (no mutating a global variable, no mutating an argument passed in, no writing to a file, no printing, no network call).

```python
def add(a, b):
    return a + b   # depends ONLY on a and b, changes nothing else -- PURE

total = 0
def add_to_total_impure(amount):
    global total
    total += amount    # mutates state OUTSIDE the function -- IMPURE
    return total
```

Verified live: calling `add_to_total_impure(5)` twice in a row gives `5`, then `10` — the *same argument* produced *different results* depending on when it was called, because the function depends on (and mutates) hidden external state. `add(2, 3)` always returns `5`, forever, no matter what else has happened in the program.

## Beginner: Side Effects Aren't Just Globals — Mutating Arguments Counts Too

```python
def append_impure(items, value):
    items.append(value)   # mutates the CALLER's list
    return items

def append_pure(items, value):
    return items + [value]   # returns a NEW list; the caller's original is untouched
```

Verified live: after `append_impure(original, 4)`, `original` itself became `[1, 2, 3, 4]` — the caller's list changed, even though the caller never explicitly asked for that. `append_pure` instead returns a brand-new list, leaving the caller's original list exactly as it was.

## Intermediate: Immutability — Tuples vs. Lists

Python's `tuple` is immutable; `list` is mutable. This isn't just a performance detail — it's a genuine guarantee:

```python
point = (1, 2)
point[0] = 99   # TypeError: 'tuple' object does not support item assignment

coords = [1, 2]
coords[0] = 99   # fine -- lists ARE mutable
```

Verified live: attempting to mutate a tuple raises `TypeError` immediately. Choosing a tuple (or a `frozenset`, or a frozen dataclass) over a list/dict/set is a way of encoding "this data should never change" directly into the type system, rather than relying on convention or hoping nobody mutates it.

## Advanced: Why Purity Enables Safe Caching (Memoization)

```python
from functools import lru_cache

@lru_cache
def slow_square(n):
    return n * n

slow_square(4)
slow_square(4)   # the function body does NOT run again -- the cached result is reused
```

Verified live: instrumenting `slow_square` with a call counter showed it was only actually invoked **once** for two identical calls — `lru_cache` (or any memoization strategy) is only *safe* to apply because the function is pure. If `slow_square` depended on hidden state or produced side effects, skipping the second call by returning a cached result would silently change the program's behavior. This is precisely why memoization, parallelization, and lazy evaluation are all dramatically easier to reason about — and safer to apply automatically — when working with pure functions.

## Real-World Usage

- **Testing**: pure functions need no setup/teardown, no mocking of global state — call it with an input, assert on the output. Impure functions (depending on a database, a clock, a random seed) require test doubles or dependency injection to test reliably.
- **Concurrency**: pure functions with immutable data have no shared mutable state to race over — a large part of why languages/paradigms leaning on immutability (Haskell, Clojure, and the functional subsets of Rust/Scala) find concurrent code easier to get right.
- **React/Redux and similar UI frameworks**: reducers are required to be pure functions of `(state, action) -> newState` specifically so the framework can predict, replay, and time-travel-debug state changes.
- **Caching layers**: an HTTP cache, a memoization decorator, or a build system's incremental-rebuild logic all depend on the assumption that "same input, same output" — the definition of purity — holds.

## Summary

- A pure function's output depends only on its inputs, and it produces no observable side effects (no mutating arguments, no mutating globals, no I/O).
- Mutating an argument passed by reference (like a list) is a side effect just as much as mutating a global variable — both make a function impure.
- Immutable types (`tuple`, `frozenset`, frozen dataclasses) enforce "this can't change" at the type level, rather than relying on convention.
- Purity is what makes memoization, safe caching, and easy testing possible — verified live via `lru_cache` skipping a second, identical call entirely.

## Key Terms

- **Pure function** — a function whose output depends only on its inputs and which has no observable side effects.
- **Side effect** — any observable change outside a function's own local scope: mutating a global, mutating an argument, I/O, etc.
- **Immutability** — a value that cannot be changed after creation; Python's `tuple`/`frozenset`/frozen dataclasses enforce this.
- **Referential transparency** — the property that a pure function call can be replaced by its result with no change in program behavior (the theoretical basis for memoization).
- **Memoization** — caching a function's results keyed by its arguments, safe only when the function is pure.

## Common Mistakes

- Assuming a function is pure just because it doesn't touch a global variable — mutating an argument (like appending to a passed-in list) is just as much a side effect.
- Using a mutable default argument in a function signature (`def f(items=[])`) — the same list object is reused across every call that doesn't supply its own, a classic Python gotcha covered in this repository's OOP module (Lesson 01) in the class-attribute context, and equally dangerous here.
- Applying `@lru_cache` (or any memoization) to a function that has side effects or depends on external mutable state — this silently breaks correctness, since the cached result may no longer reflect what a fresh call would actually do.

## Interview Questions

1. **What are the two defining properties of a pure function?**
   Its output depends only on its inputs (same arguments always produce the same result), and it has no observable side effects — it doesn't mutate anything outside its own local scope, whether that's a global variable, a mutable argument, or the outside world (files, network, console).

2. **Is a function that mutates one of its arguments pure?**
   No. Even though it might not touch any global state, mutating an argument (e.g., `list.append()`) is an observable side effect visible to the caller — verified live in this lesson, where `append_impure` changed the caller's original list. A pure equivalent must return a new value instead of mutating the one it was given.

3. **Why is memoization (caching) only safe to apply to pure functions?**
   Memoization works by skipping the function body on a repeat call with the same arguments and returning a previously-computed result instead. This is only correct if the function's result depends solely on those arguments — if the function were impure (depending on or affecting external state), skipping the real call could silently produce a stale or incorrect result, or fail to perform an expected side effect at all.

## Suggested Next Lesson

[02 — Higher-Order Functions](../02-Higher-Order-Functions/README.md)
