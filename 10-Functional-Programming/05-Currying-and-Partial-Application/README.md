# 05 — Currying and Partial Application

[Back to module overview](../README.md) | [Previous: Function Composition](../04-Function-Composition/README.md)

## Beginner: What Currying Is

**Currying** transforms a function taking multiple arguments into a chain of functions that each take exactly *one* argument, where each call returns another function until all arguments have been supplied.

```python
def add_three_numbers(a, b, c):
    return a + b + c

def curry3(func):
    def curried(a):
        def with_b(b):
            def with_c(c):
                return func(a, b, c)
            return with_c
        return with_b
    return curried

curried = curry3(add_three_numbers)
step1 = curried(1)   # a function still WAITING for b
step2 = step1(2)       # a function still WAITING for c
result = step2(3)        # NOW it actually computes -- 6
```

Verified live: `curry3(add_three_numbers)(1)(2)(3)` returned `6`, identical to the step-by-step version — each call supplies exactly one argument and returns a new function, until the final call actually performs the computation.

## Intermediate: Partial Application — a Different, Related Idea

**Partial application** fixes *some* of a function's arguments ahead of time, producing a new function that only needs the rest — but unlike currying, it doesn't force one-argument-at-a-time calling; you can fix as many or as few arguments as you like in one step.

```python
from functools import partial

def greet(greeting, name):
    return f"{greeting}, {name}!"

say_hello = partial(greet, "Hello")   # "greeting" FIXED to "Hello"; "name" still required
say_hello("Ada")     # "Hello, Ada!"
say_hello("Grace")     # "Hello, Grace!"
```

```python
def add_three(a, b, c):
    return a + b + c

add_5_and_10 = partial(add_three, 5, 10)   # fixes BOTH a AND b in ONE step
add_5_and_10(3)   # 18 -- only c is still needed, supplied all at once
```

Verified live: `partial()` fixed two arguments (`5` and `10`) in a single call, unlike currying, which would require two *separate* single-argument calls to fix the same two values. Currying and partial application solve a similar-feeling problem (specializing a function for reuse) but are genuinely distinct: currying is about the *shape* of a function (always one argument per call), while partial application is about fixing specific argument values, however many at a time is convenient.

## Advanced: A Practical Use — Specializing a Generic Function

```python
def power(base, exponent):
    return base ** exponent

square = partial(power, exponent=2)   # specialize power() into a dedicated "square" function
cube = partial(power, exponent=3)
square(5), cube(2)   # 25, 8
```

Verified live: `square` and `cube` are each independent, specialized functions derived from the same general-purpose `power()` — this is partial application used for genuine code reuse, avoiding writing separate `square(x)`/`cube(x)` functions by hand.

## Real-World Usage

- Configuring callback functions: `partial(logger.log, level="ERROR")` creates a specialized error-logging function from a general `log(message, level)` function.
- Event handlers that need extra context: `button.on_click(partial(handle_click, user_id=current_user.id))` bakes in data the generic handler doesn't otherwise have access to.
- Functional-language standard libraries (Haskell's functions are curried by default; JavaScript libraries like Ramda/Lodash provide explicit `curry()` helpers) rely on currying to make function composition (Lesson 04) and partial specialization idiomatic and concise.

## Summary

- Currying transforms a multi-argument function into a chain of single-argument functions, each call returning the next, until all arguments are supplied.
- Partial application fixes some number of arguments (however many, in one step) ahead of time, producing a new function needing only the rest.
- Both are ways of specializing a general-purpose function for a specific, narrower use case — verified live with `square`/`cube` derived from a shared `power()` function via `functools.partial`.

## Key Terms

- **Currying** — transforming an n-argument function into a chain of n single-argument functions.
- **Partial application** — fixing some of a function's arguments ahead of time, producing a new function needing only the remaining ones.
- **`functools.partial`** — Python's standard library tool for partial application.

## Interview Questions

1. **What's the difference between currying and partial application?**
   Currying transforms a function so that it can *only* be called one argument at a time, with each call returning a new function until all arguments are supplied — verified live in this lesson with `curry3(add_three_numbers)(1)(2)(3)`. Partial application fixes some number of arguments in a single step (via `functools.partial`), producing a new function that takes however many arguments remain — verified live with `partial(add_three, 5, 10)`, which fixed two arguments at once, something a strictly curried function wouldn't allow directly (a curried function would require two separate single-argument calls to achieve the same fixing).

2. **Why might you use `functools.partial` instead of just writing a new wrapper function?**
   `partial()` avoids the boilerplate of writing `def square(x): return power(x, 2)` for every specialization you need — it directly derives a new, correctly-behaved function from an existing one by fixing specific arguments, verified live with `square = partial(power, exponent=2)` and `cube = partial(power, exponent=3)` both derived from the same `power()` function. This is especially useful when specializing callback functions for event handlers or logging, where writing a full wrapper function for every variant would be repetitive.

## Suggested Next Lesson

This completes the Functional Programming module's core lessons. See the [Exercises](../Exercises/README.md) to practice these concepts, or the [Mini-Project](../Mini-Project/README.md) to apply them together in a small, realistic program.
