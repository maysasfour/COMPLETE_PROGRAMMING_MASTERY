# 10 — Functional Programming

[Back to repository root](../README.md)

## What Is Functional Programming?

Functional Programming (FP) is a way of structuring code around **pure functions** and **immutable data**, rather than around objects with internal, mutable state. Instead of a `BankAccount` object that mutates its own `balance` in place (the OOP approach, see [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md)), an FP approach passes the current balance into a function and gets a *new* balance back, leaving the original untouched.

This module covers five core FP ideas, each in its own lesson:

- **Pure functions and immutability** — functions with no side effects, and data that can't be changed after creation.
- **Higher-order functions** — functions that take other functions as arguments or return them.
- **Map, filter, reduce** — the classic trio for transforming, selecting, and aggregating collections.
- **Function composition** — building complex behavior by combining small, focused functions.
- **Currying and partial application** — specializing general-purpose functions for specific use cases.

This module uses **Python** as the reference language (consistent with the rest of this repository's concept modules — see [00-Programming-Fundamentals](../00-Programming-Fundamentals/README.md) and [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md)). Python isn't a purely functional language, but it supports every idea in this module directly, and every idea here transfers to JavaScript, Kotlin, Rust, Scala, Haskell, and any other language with first-class functions — only the syntax changes (see this repository's `01-Languages` module, where several of these same concepts — closures, `map`/`filter`/`reduce`, function composition — were verified live in Kotlin, Swift, Dart, Rust, and others).

## Why It Matters / Where It's Used

- **Predictability and testability**: a pure function needs no setup/teardown or mocking — call it with an input, assert on the output (Lesson 01).
- **Concurrency**: immutable data has no shared mutable state to race over, a large part of why functional-leaning code is often easier to parallelize safely.
- **Data pipelines**: map/filter/reduce (Lesson 03) is the exact shape of SQL queries, pandas/Spark transformations, and most stream-processing APIs.
- **Framework design**: React/Redux-style UI frameworks require pure reducer functions specifically so state changes are predictable and replayable.
- **Interviews**: "write a pure function," "avoid mutating the input," and "compose these transformations" are common, direct interview prompts, and FP-style thinking underlies many coding-interview problem patterns.

## Advantages

- **Easier to reason about**: a pure function's behavior is fully determined by its inputs — no hidden state to trace through.
- **Easier to test**: no mocking of global state, databases, or singletons required for pure logic.
- **Safer to cache/parallelize**: memoization (Lesson 01) and concurrent execution are both straightforward and safe when functions are pure.
- **Encourages small, composable pieces**: function composition (Lesson 04) rewards breaking logic into small, independently-testable units.

## Disadvantages / Trade-offs

- **Can be less efficient**: returning new data structures instead of mutating in place has a real (usually small) memory/CPU cost — though Python's `tuple`s and other languages' persistent data structures mitigate this.
- **Overuse can obscure intent**: deeply nested `compose()`/`pipe()` chains can be harder to debug than an equivalent imperative loop, if taken too far.
- **Not always the natural fit**: some problems (stateful simulations, UI widget trees with genuinely mutable state) map more naturally onto objects — see [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md)'s own disadvantages section for the mirror image of this trade-off.
- **Python isn't a purely functional language**: mutable default arguments, mutable list/dict types, and no compiler-enforced immutability mean discipline (not the type system) is what keeps functions pure in Python, unlike languages such as Haskell.

## How to Run the Examples

Every lesson folder has a runnable `example.py`. From inside that folder:

```bash
python example.py
```

Requires Python 3.8+ (no version-specific syntax is used in this module). Verify with `python --version`. No third-party packages are required anywhere in this module — everything uses the standard library (`functools`, `re`).

## Common Beginner Mistakes

- **Assuming a function is pure just because it doesn't touch a global variable** — mutating an argument (like appending to a passed-in list) is just as much a side effect (Lesson 01).
- **Forgetting `map()`/`filter()` return lazy iterators in Python 3**, not lists — `list(...)` or iteration is needed to see the values (Lesson 03).
- **Confusing currying with partial application** — currying forces one argument per call; `functools.partial` can fix any number of arguments in one step (Lesson 05).
- **Writing a decorator's inner function without `*args, **kwargs`** — breaks for any wrapped function whose signature doesn't happen to match exactly (Lesson 02).
- **Using a mutable default argument** (`def f(items=[])`) — the same object is shared and mutated across every call that doesn't supply its own, a classic Python trap covered in this repository's OOP module in the class-attribute context and equally relevant here.

## Best Practices

- Default to returning new data rather than mutating arguments, even in a language (like Python) that doesn't enforce this.
- Prefer `tuple`/`frozenset`/frozen dataclasses over `list`/`dict`/`set` when a value genuinely shouldn't change after creation.
- Build complex transformations from small, independently-testable functions combined via composition, rather than one large function that does everything (Lesson 04's mini-project payoff).
- Use `functools.partial` to specialize general-purpose functions for specific, recurring use cases instead of writing near-duplicate wrapper functions by hand.

## Interview Questions

1. What are the two defining properties of a pure function?
2. What's the difference between currying and partial application?
3. Why are `map()` and `filter()` lazy in Python 3, and why does that matter?
4. What is a closure, and how does it enable a "function factory" pattern?
5. Why is memoization only safe to apply to pure functions?
6. What's the difference between `compose()` (right-to-left) and `pipe()` (left-to-right)?

(Detailed answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Pure Functions and Immutability](01-Pure-Functions-and-Immutability/README.md) | Side effects, referential transparency, `tuple` immutability, memoization |
| 02 | [Higher-Order Functions](02-Higher-Order-Functions/README.md) | First-class functions, closures, function factories, decorators |
| 03 | [Map, Filter, Reduce](03-Map-Filter-Reduce/README.md) | `map()`/`filter()`/`functools.reduce`, laziness, comprehensions |
| 04 | [Function Composition](04-Function-Composition/README.md) | `compose()`/`pipe()`, building pipelines from small functions |
| 05 | [Currying and Partial Application](05-Currying-and-Partial-Application/README.md) | Manual currying, `functools.partial`, specializing functions |

Also in this module:

- [Exercises/](Exercises/README.md) — 5 problems, one per lesson.
- [Solutions/](Solutions/README.md) — matching worked solutions, each run and verified.
- [Mini-Project/](Mini-Project/README.md) — a sales transaction analytics pipeline tying together all five lessons.

## Suggested Path

Work through 01 → 05 in order — each lesson builds on ideas from the previous ones (composition in Lesson 04 uses higher-order functions from Lesson 02; currying in Lesson 05 echoes the closures introduced in Lesson 02). Do the Exercises after Lesson 05, then work through the Mini-Project, which combines every lesson's ideas into one small, realistic, fully-tested program.

**Previous module:** [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md) | **Next module:** [08-Data-Structures-and-Algorithms](../08-Data-Structures-and-Algorithms/README.md)
