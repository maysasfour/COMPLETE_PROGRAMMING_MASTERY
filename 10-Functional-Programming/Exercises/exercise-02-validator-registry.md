# Exercise 02 — A Configurable Validator Registry

[Back to Exercises](README.md) | Covers: [Lesson 02 — Higher-Order Functions](../02-Higher-Order-Functions/README.md)

**Difficulty: Beginner**

## Task

Build a small validation system using higher-order functions — no classes needed.

1. Write a `min_length(n)` function that **returns** a validator function: a function taking a string and returning `True` if its length is at least `n`.
2. Write a `contains_digit()` function that **returns** a validator function checking whether a string contains at least one digit character.
3. Write `run_validators(value, validators)` that takes a value and a list of validator functions, returning `True` only if *every* validator passes (use a loop or a built-in like `all()`).
4. Write a `@logged` decorator that wraps any single-argument function, printing `f"{func.__name__}({arg!r}) -> {result!r}"` every time the wrapped function is called, then returns the original result.
5. Apply `@logged` to `run_validators` isn't possible directly (it takes two args) — instead, apply it to `min_length(8)` (a returned validator function) and call the decorated version on a couple of test strings.

## Reflection Questions

1. Why does `min_length(8)` need to *return* a function rather than directly checking the length itself?
2. What would go wrong if your `@logged` decorator's inner `wrapper` function didn't accept `*args, **kwargs`?

## Deliverable

A runnable `.py` file demonstrating `min_length`/`contains_digit` used via `run_validators` against a few example passwords (some passing, some failing), plus the `@logged`-decorated validator's console output, plus written answers to both reflection questions.
