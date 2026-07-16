# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Beginner: Lambda Expressions

A `lambda` is an anonymous, single-expression function:

```python
square = lambda x: x ** 2
square(5)          # 25

add = lambda a, b: a + b
add(2, 3)             # 5
```

A `lambda` is restricted to a **single expression** — no statements, no assignments, no multiple lines, no `if`/`for` blocks (only the conditional *expression* `a if cond else b`). It implicitly returns the value of that expression.

**When NOT to use a lambda:** if the logic needs a name for reuse, needs more than one statement, needs a docstring, or needs to be debugged with a meaningful traceback entry, write a `def` instead:

```python
# Bad - the intent gets lost, and there's no name in tracebacks/debuggers
validate = lambda user: user.age >= 18 and user.email and "@" in user.email

# Good - a real name, a docstring, and room to grow
def is_eligible_user(user):
    """Return True if the user is an adult with a plausible email address."""
    return user.age >= 18 and user.email and "@" in user.email
```

The only place a lambda is genuinely idiomatic is as a short, throwaway callback passed inline to something like `sorted(..., key=...)`, where naming it separately would add noise rather than clarity.

## Beginner: `map()` and `filter()`

```python
numbers = [1, 2, 3, 4, 5]

doubled = list(map(lambda n: n * 2, numbers))      # [2, 4, 6, 8, 10]
evens = list(filter(lambda n: n % 2 == 0, numbers))  # [2, 4]
```

`map(func, iterable)` applies `func` to every item and returns a lazy iterator. `filter(func, iterable)` keeps only the items where `func(item)` is truthy, also lazily. Both need `list(...)` (or another consumer) to materialize their results.

**In idiomatic Python, a comprehension is usually preferred over `map`/`filter`** because it reads left-to-right as a sentence and doesn't need a wrapping `list(...)`:

```python
doubled = [n * 2 for n in numbers]          # same result, more readable
evens = [n for n in numbers if n % 2 == 0]  # same result, more readable
```

`map`/`filter` earn their keep mainly when you already have a *named* function (not a lambda) to pass directly — `map(str, numbers)` is arguably cleaner than `[str(n) for n in numbers]`. But for anything involving a lambda, the comprehension is almost always clearer and is the style you'll see recommended by the core Python style guide (PEP 8) and in most real codebases.

## Intermediate: `functools.reduce`

`reduce(func, iterable, initial)` collapses an iterable down to a single value by repeatedly applying `func` to an accumulator and the next item:

```python
from functools import reduce

numbers = [1, 2, 3, 4]
total = reduce(lambda acc, n: acc + n, numbers, 0)   # 10
product = reduce(lambda acc, n: acc * n, numbers, 1)  # 24
```

`reduce` used to be a builtin in Python 2; it was demoted to `functools` in Python 3 specifically because Guido van Rossum considered it less readable than an explicit loop for most cases. For simple accumulation, prefer the builtins that already exist for the common cases: `sum(numbers)`, `max(numbers)`, `min(numbers)`, `"".join(strings)`. Reach for `reduce` only when the combining logic is genuinely custom and there's no builtin equivalent.

## Intermediate: Functions as First-Class Objects

Functions in Python are objects like any other value: they can be assigned to variables, stored in data structures, passed as arguments, and returned from other functions.

```python
def shout(text):
    return text.upper() + "!"

def whisper(text):
    return text.lower() + "..."

# Storing functions in a dict - a common way to replace a chain of if/elif
strategies = {"shout": shout, "whisper": whisper}
strategies["shout"]("hello")     # "HELLO!"

# Passing a function as an argument
def apply_twice(func, value):
    return func(func(value))

apply_twice(shout, "hi")   # "HI!!" -> shout("HI!") -> "HI!!"

# Returning a function from a function (a "factory")
def make_multiplier(factor):
    def multiplier(x):
        return x * factor
    return multiplier

triple = make_multiplier(3)
triple(7)    # 21
```

`make_multiplier` returns a **closure** — `multiplier` "remembers" the `factor` value from its enclosing scope even after `make_multiplier` has finished running. This is the mechanism decorators are built on.

## Advanced: Decorators

A decorator is a function that wraps another function to add behavior without modifying its source:

```python
import functools
import time

def timed(func):
    @functools.wraps(func)   # preserves func's __name__, __doc__, etc.
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__} took {elapsed:.6f}s")
        return result
    return wrapper

@timed
def slow_add(a, b):
    """Add two numbers (with a fake pause)."""
    time.sleep(0.01)
    return a + b

slow_add(2, 3)
# prints: slow_add took 0.0101...s
# returns: 5
```

`@timed` above `def slow_add` is exactly equivalent to `slow_add = timed(slow_add)`. The decorator replaces the original function with `wrapper`.

**Why `functools.wraps` matters:** without it, `wrapper` would silently overwrite the original function's identity — `slow_add.__name__` would be `"wrapper"`, `slow_add.__doc__` would be `None`, and tools like debuggers, documentation generators, and introspection-based frameworks would all see the wrong metadata. `functools.wraps(func)` copies `__name__`, `__doc__`, `__module__`, and other metadata from `func` onto `wrapper`, so the decorated function still looks like itself from the outside.

## Real-World Usage

- Web frameworks (Flask, FastAPI, Django) use decorators extensively for routing (`@app.route("/users")`), authentication guards, and caching (`@functools.lru_cache`).
- `sorted(items, key=lambda x: x.created_at)` is the single most common legitimate use of a lambda in real code — a short, throwaway sort key.
- `reduce` shows up in data-pipeline code that folds a sequence of transformations into one, though a plain loop or comprehension is chosen far more often.
- Passing functions as arguments underlies dependency injection, event handler registration (`button.on_click(handler)`), and pluggable strategy patterns.

## Summary

- A `lambda` is a single-expression anonymous function; use `def` whenever logic needs a name, multiple statements, or a docstring.
- `map`/`filter` are lazy and functional, but comprehensions are usually more readable and are the more idiomatic default in Python.
- `functools.reduce` collapses an iterable to one value; prefer builtins (`sum`, `max`, `join`) when they already do the job.
- Functions are first-class objects: they can be stored in variables/data structures, passed as arguments, and returned from other functions (closures).
- A decorator wraps a function to add behavior; always use `@functools.wraps` inside a decorator to preserve the wrapped function's identity.

## Key Terms

- **Lambda** — an anonymous, single-expression function created with the `lambda` keyword.
- **Higher-order function** — a function that takes another function as an argument and/or returns one.
- **Closure** — an inner function that retains access to variables from its enclosing scope after that scope has finished executing.
- **Decorator** — a callable that wraps another function to add or modify behavior, typically applied with `@decorator_name` syntax.
- **`functools.wraps`** — a decorator-helper that copies `__name__`, `__doc__`, and other metadata from the original function onto the wrapper function.

## Common Mistakes

- Writing a multi-clause or hard-to-read lambda instead of a named `def` — if it needs a comment to explain it, it should be a function.
- Forgetting `list(...)` around `map()`/`filter()` and then being confused why printing shows `<map object at 0x...>` instead of the values.
- Using `reduce` for a sum or product when `sum()`/`math.prod()` already does exactly that, more readably.
- Writing a decorator without `@functools.wraps`, silently breaking `__name__`/`__doc__` and any code that introspects the decorated function.
- Forgetting that a decorator applied at import time runs immediately (the outer function body), while the inner `wrapper` only runs when the decorated function is later called.

## Best Practices

- Default to comprehensions over `map`/`filter` with a lambda; reserve `map`/`filter` for cases with an existing named function.
- Keep lambdas to short, single-purpose callbacks (typically `key=` arguments); anything more complex earns a `def`.
- Always decorate your decorator's inner wrapper with `@functools.wraps(func)`.
- Use `*args, **kwargs` in a decorator's wrapper so it works with any function signature, not just one specific one.
- Prefer `functools.lru_cache` over hand-rolled memoization decorators for simple caching needs.

## Interview Questions

1. **What's the difference between a lambda and a regular function defined with `def`?**
   A lambda is restricted to a single expression with an implicit return and no name of its own (though it can be assigned to a variable); a `def` function can contain multiple statements, have a docstring, and is named from the start, which makes it easier to debug and reuse. Anything beyond a trivial one-line expression should be a `def`.

2. **Why might a comprehension be preferred over `map()`/`filter()` in idiomatic Python?**
   A comprehension reads as a single, left-to-right expression and doesn't require wrapping the result in `list(...)` to materialize it, whereas `map`/`filter` return lazy iterator objects and usually need a lambda, adding an extra layer of indirection. `map`/`filter` are more justified when passing an already-named function directly.

3. **What is a closure, and how does it relate to decorators?**
   A closure is an inner function that captures and retains variables from its enclosing function's scope even after the outer function has returned. Decorators rely on this: the `wrapper` function defined inside a decorator closes over the original `func` (and any decorator arguments), letting it call `func` and add behavior around it.

4. **Why is `functools.wraps` necessary when writing a decorator?**
   Without it, the decorated function's `__name__`, `__doc__`, and other metadata get replaced by the wrapper's own metadata, which breaks introspection, documentation tools, and debugging output that rely on a function correctly identifying itself. `functools.wraps(func)` copies that metadata from the original function onto the wrapper.

5. **Why was `reduce` moved out of Python's builtins and into `functools` in Python 3?**
   Guido van Rossum judged that `reduce` was frequently less readable than an explicit loop or an existing builtin (`sum`, `max`, `any`, `all`) for the same task, and that keeping it as a builtin encouraged overly clever one-liners. Moving it to `functools` keeps it available for the legitimate custom-accumulation cases without promoting it as the default tool for simple aggregation.

## Suggested Next Lesson

[13 — Generics](../13-Generics/README.md)
