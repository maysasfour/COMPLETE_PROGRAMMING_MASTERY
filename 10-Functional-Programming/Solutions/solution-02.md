# Solution 02 — A Configurable Validator Registry

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-02-validator-registry.md)

## Approach

`min_length(n)` and `contains_digit()` are both **function factories**: calling them doesn't check anything directly — it returns a new `validator` function that closes over its configuration (`n`, in `min_length`'s case) and performs the actual check only when *it* is called later. `run_validators` uses `all()` (a built-in reduction) to require every validator to return `True`.

`logged` is a decorator following the pattern from Lesson 02: it wraps any function, prints a formatted call/result line, and returns the original result unchanged so the wrapped function is still usable normally. `functools.wraps` is used here to preserve the original function's `__name__`/docstring on the wrapper — worth flagging as good practice even though not central to the exercise's ask.

Verified by running: `'short1'` (6 characters) failed the length check regardless of containing a digit; `'longenough1'` (11 characters, contains a digit) passed both checks; `'nodigitshere'` (12 characters, no digit) failed the digit check despite being long enough. The `@logged`-wrapped validator correctly printed its call/result for both test strings.

## Reflection Answers

1. **Why must `min_length(8)` return a function rather than checking directly?** Because `run_validators` needs to hold a *list* of validators and apply each to a value *later*, without knowing in advance which specific length threshold each one checks — `min_length(8)` produces a function value that can be stored, passed around, and called uniformly alongside `contains_digit()`'s validator, all through the same `validator(value)` calling convention, regardless of what configuration each one closed over.

2. **What breaks without `*args, **kwargs` in `wrapper`?** The decorator would only work for functions matching `wrapper`'s exact fixed signature — since Python doesn't know in advance what arguments a decorated function will need, `*args, **kwargs` lets `wrapper` accept (and forward) *any* combination of positional/keyword arguments to the wrapped function. Without it, decorating any function whose signature doesn't happen to match `wrapper`'s hard-coded parameters would raise a `TypeError` at the call site.
