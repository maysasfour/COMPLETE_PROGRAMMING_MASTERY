# 02 — Higher-Order Functions

[Back to module overview](../README.md) | [Previous: Pure Functions and Immutability](../01-Pure-Functions-and-Immutability/README.md)

## Beginner: Functions Are First-Class Values

In Python, a function is a value just like a number or a string — it can be assigned to a variable, stored in a list, or passed around, without calling it.

```python
def shout(text):
    return text.upper() + "!"

greeting_style = shout   # no () -- this references the FUNCTION ITSELF, not a call to it
print(greeting_style("hello"))   # HELLO!
```

A **higher-order function** is any function that takes another function as an argument, returns a function, or both. This is the foundation of the rest of this module.

## Beginner: Passing a Function as an Argument

```python
def apply_twice(func, value):
    return func(func(value))

apply_twice(shout, "hi")   # shout(shout("hi")) -- "HI!!"
```

This is exactly what Python's built-in `sorted()` does with its `key` argument:

```python
words = ["banana", "kiwi", "apple", "fig"]
sorted(words, key=len)   # ['fig', 'kiwi', 'apple', 'banana'] -- sorted by LENGTH, not alphabetically
```

`len` here is passed as a value — `sorted` calls `len(word)` internally for each word to determine sort order, without `sorted` needing to know anything about strings specifically.

## Intermediate: Returning a Function — a "Function Factory"

```python
def make_multiplier(factor):
    def multiplier(x):
        return x * factor   # `factor` is captured from the ENCLOSING scope -- a closure
    return multiplier   # returns the FUNCTION itself

double = make_multiplier(2)
triple = make_multiplier(3)
double(5), triple(5)   # 10, 15 -- each remembers its OWN factor independently
```

Verified live: `double` and `triple` are two separate functions, each carrying its own captured `factor` value — this is a **closure**: the inner function "closes over" the variable from its enclosing scope, keeping it alive even after `make_multiplier` has returned.

## Advanced: Decorators — Higher-Order Functions That Wrap Behavior

```python
def timed(func):
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        print(f"{func.__name__} took {time.perf_counter() - start:.6f}s")
        return result
    return wrapper

@timed
def slow_sum(n):
    return sum(range(n))
```

`@timed` is syntactic sugar for `slow_sum = timed(slow_sum)` — `timed` is a higher-order function that takes `slow_sum` as an argument and returns a *new* function (`wrapper`) that adds timing behavior around a call to the original. Verified live: calling the decorated `slow_sum(1_000_000)` printed its actual elapsed time before returning the correct sum, confirming the wrapper genuinely runs the original function and augments its behavior.

## Real-World Usage

- Python's standard library leans heavily on higher-order functions: `sorted(key=...)`, `map()`/`filter()` (Lesson 03), `functools.reduce` (Lesson 03), event handler registration (`button.on_click(my_handler)`), and the entire decorator ecosystem (`@app.route(...)` in Flask, `@pytest.fixture`, `@property`).
- Callback-based APIs (JavaScript's `addEventListener`, Python's `asyncio` callbacks) are fundamentally higher-order functions: you pass a function to be called later.
- Dependency injection frequently takes the form of passing a function (a "strategy") into another function or class, rather than hardcoding one specific behavior.

## Summary

- Functions are first-class values in Python: assignable, passable, returnable, just like any other value.
- A higher-order function takes a function as an argument, returns one, or both.
- Closures let a returned inner function retain access to variables from its enclosing scope — verified live with two independently-configured multiplier functions.
- Decorators are higher-order functions applied via `@` syntax, wrapping a function with additional behavior while preserving its original purpose.

## Key Terms

- **First-class function** — a function treated as an ordinary value: assignable, passable as an argument, returnable from another function.
- **Higher-order function** — a function that takes a function as a parameter, returns a function, or both.
- **Closure** — a function that "remembers" variables from the scope it was defined in, even after that scope has finished executing.
- **Decorator** — Python's `@` syntax for applying a higher-order function that wraps another function's behavior.

## Common Mistakes

- Writing `greeting_style = shout()` (with parentheses) when the intent was to reference the function itself — this calls `shout` immediately (with no arguments, likely raising an error or storing the wrong thing) instead of storing a reference to the function.
- Forgetting a decorator's inner `wrapper` function must accept and forward `*args, **kwargs` if the decorated function might take any arguments — otherwise the decorator breaks for any function whose signature doesn't match `wrapper`'s exactly.
- Confusing "a function that returns a function" with "a function that returns the *result of calling* a function" — `make_multiplier` returns `multiplier` (the function itself), not `multiplier(x)` (a number).

## Interview Questions

1. **What makes a function "higher-order"?**
   It either accepts another function as one of its arguments, returns a function as its result, or both — treating functions as ordinary, passable values rather than only as named, directly-callable procedures.

2. **What is a closure, and how does `make_multiplier` in this lesson demonstrate one?**
   A closure is an inner function that retains access to variables from the scope it was defined in, even after that outer scope has finished running. `make_multiplier(factor)` returns an inner `multiplier` function that still has access to `factor` long after `make_multiplier` itself has returned — verified live, with `double` and `triple` each independently remembering their own `factor` value (`2` and `3` respectively).

3. **What does the `@decorator` syntax actually do under the hood?**
   `@decorator` above a function definition is syntactic sugar for `func = decorator(func)` — it calls the decorator (a higher-order function) with the original function as its argument, and rebinds the original name to whatever the decorator returns (typically a wrapper function that calls the original and adds some behavior around it, as demonstrated with `@timed` in this lesson).

## Suggested Next Lesson

[03 — Map, Filter, Reduce](../03-Map-Filter-Reduce/README.md)
