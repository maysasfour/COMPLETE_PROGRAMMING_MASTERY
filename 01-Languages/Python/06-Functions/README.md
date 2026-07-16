# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Beginner: Defining Functions, Positional vs. Keyword Arguments

```python
def greet(name, greeting):
    return f"{greeting}, {name}!"

greet("Ada", "Hello")               # positional - matched by order
greet(name="Ada", greeting="Hello")  # keyword - matched by name
greet(greeting="Hello", name="Ada")  # keyword args can be reordered freely
```

**Positional arguments** are matched to parameters by their position in the call. **Keyword arguments** are matched by name, so their order in the call doesn't matter. You can mix both, but every positional argument must come before any keyword argument in the call:

```python
greet("Ada", greeting="Hello")   # fine - positional first, then keyword
greet(name="Ada", "Hello")       # SyntaxError - positional after keyword
```

A function that reaches the end of its body without an explicit `return` statement — or that uses a bare `return` with no value — returns `None` implicitly. This trips people who assume "no return statement" means "no return value":

```python
def log_message(msg):
    print(msg)
    # no return statement here

result = log_message("hi")
print(result)   # None - log_message never explicitly returned anything
```

## Beginner: Default Arguments

A parameter can have a default value, making it optional at the call site:

```python
def power(base, exponent=2):
    return base ** exponent

power(3)        # 9  - exponent defaults to 2
power(3, 3)     # 27 - exponent explicitly overridden
```

Parameters with defaults must come after parameters without defaults in the function signature — you can't have a required parameter after an optional one.

### The Mutable Default Argument Pitfall

This is one of Python's most notorious gotchas. **Default argument values are evaluated exactly once, at function definition time — not on every call.** If the default is a mutable object (a list, dict, or set), every call that relies on that default shares the *same* object.

```python
# BROKEN - do not do this
def add_item(item, basket=[]):
    basket.append(item)
    return basket

print(add_item("apple"))    # ['apple']
print(add_item("banana"))   # ['apple', 'banana'] - NOT ['banana']!
```

The second call's `basket=[]` isn't a fresh empty list — it's the exact same list object left over from the first call, because that one `[]` was created a single time when `def` executed, not each time `add_item` runs. Every caller who omits `basket` shares one persistent, silently-accumulating list.

**The fix** is to default to `None` (an immutable sentinel) and create the actual mutable object fresh inside the function body:

```python
# FIXED
def add_item(item, basket=None):
    if basket is None:
        basket = []
    basket.append(item)
    return basket

print(add_item("apple"))    # ['apple']
print(add_item("banana"))   # ['banana'] - a brand-new list each time
```

## Intermediate: `*args` and `**kwargs`

`*args` collects any extra **positional** arguments into a `tuple`; `**kwargs` collects any extra **keyword** arguments into a `dict`. They let a function accept an arbitrary, not-known-in-advance number of arguments.

```python
def summarize(*args, **kwargs):
    print("positional:", args)
    print("keyword:", kwargs)

summarize(1, 2, 3, name="Ada", role="engineer")
# positional: (1, 2, 3)
# keyword: {'name': 'Ada', 'role': 'engineer'}
```

The names `args`/`kwargs` are convention, not syntax — the `*` and `**` are what matter. This same `*`/`**` syntax also **unpacks** a sequence or dict into arguments at a call site (the mirror-image use):

```python
def add(a, b, c):
    return a + b + c

numbers = [1, 2, 3]
add(*numbers)          # unpacks the list into three positional args -> 6

values = {"a": 1, "b": 2, "c": 3}
add(**values)          # unpacks the dict into keyword args, matched by key -> 6
```

A common real pattern combines fixed parameters with both catch-alls, in this required order: regular params, then `*args`, then keyword-only params, then `**kwargs`.

## Intermediate: Docstrings and `help()`

A **docstring** is a string literal as the very first statement in a function (or module, or class) body. Unlike a `#` comment, it's stored as the object's `__doc__` attribute and is readable at runtime by tools:

```python
def celsius_to_fahrenheit(celsius):
    """Convert a Celsius temperature to Fahrenheit.

    Args:
        celsius: temperature in degrees Celsius.

    Returns:
        The equivalent temperature in degrees Fahrenheit.
    """
    return celsius * 9 / 5 + 32
```

Calling `help(celsius_to_fahrenheit)` in an interactive session prints that docstring formatted alongside the function's signature — this is how IDEs show inline documentation and how `pydoc`-style tools generate reference docs, all from the same source of truth instead of a separately maintained comment.

## Real-World Usage

- The mutable default argument bug is one of the most common real bugs in production Python — it typically surfaces as "state mysteriously leaking between unrelated calls" and is often mistaken for a threading bug before someone spots the `def f(x, cache={}):` signature.
- `*args, **kwargs` are everywhere in decorator code (Lesson 12) and wrapper/proxy functions that need to forward an arbitrary call through to another function unchanged.
- Docstrings following a consistent format (Google-style, as above, or NumPy/Sphinx style) are what auto-generated API documentation sites are built from — writing them well is not optional in any codebase with more than one contributor.

## Summary

- Positional args are matched by order; keyword args by name; positional must precede keyword in a call.
- A function with no explicit `return` (or a bare `return`) implicitly returns `None`.
- Default argument values are evaluated once, at definition time — never use a mutable literal as a default; default to `None` and create the mutable object inside the function.
- `*args` collects extra positional args into a tuple; `**kwargs` collects extra keyword args into a dict; the same syntax unpacks collections into a call.
- Docstrings are runtime-readable documentation (`__doc__`), inspectable via `help()`, distinct from `#` comments.

## Key Terms

- **Positional argument** — an argument matched to a parameter by its position in the call.
- **Keyword argument** — an argument matched to a parameter by name.
- **Default argument** — a parameter value used when the caller omits that argument; evaluated once at `def` time.
- **Mutable default argument pitfall** — the bug where a mutable default object is shared and silently mutated across calls.
- **`*args`** — collects extra positional arguments into a tuple.
- **`**kwargs`** — collects extra keyword arguments into a dict.
- **Docstring** — a string literal as a function/module/class's first statement, stored as `__doc__` and readable via `help()`.
- **Implicit `None` return** — the value returned by a function that falls off its end or uses a bare `return`.

## Common Mistakes

- Using a mutable literal (`[]`, `{}`, `set()`) as a default argument value.
- Assuming a function without a `return` statement returns nothing observable, rather than realizing it returns `None`, which can then propagate silently into further code.
- Putting a positional argument after a keyword argument in a call (`SyntaxError`).
- Forgetting that `*args`/`**kwargs` must come after regular positional/keyword parameters in a `def` signature.
- Writing `#`-style comments instead of a proper docstring for public functions, losing `help()`/tooling support for no benefit.

## Best Practices

- Default optional mutable parameters to `None`, and construct the real mutable object on the first line of the function body.
- Write a docstring for every public function — at minimum, one sentence describing what it does; add Args/Returns sections for anything non-trivial.
- Prefer explicit keyword arguments at call sites for functions with several parameters of the same type, to avoid positional mix-ups (`resize(width=200, height=100)` over `resize(200, 100)`).
- Use `*args`/`**kwargs` sparingly in application code — they're powerful for generic wrappers/decorators, but overusing them in regular functions hides the real signature from readers and tooling.

## Interview Questions

1. **What does Python return from a function that has no `return` statement?**
   `None`, implicitly. Reaching the end of a function body (or executing a bare `return` with no expression) is equivalent to `return None`.

2. **Explain the mutable default argument bug and how to fix it.**
   Default values are evaluated exactly once, when the `def` statement executes, not on each call. A mutable default (like `[]`) is therefore one single object shared across every call that doesn't override it, and any in-place mutation persists between unrelated calls. The fix is to default the parameter to `None` and create a fresh mutable object inside the function body when it's `None`.

3. **What's the difference between `*args` and `**kwargs`?**
   `*args` gathers any extra positional arguments a caller supplies into a `tuple` inside the function. `**kwargs` gathers any extra keyword arguments into a `dict`, keyed by argument name. Both let a function's signature accept a variable, open-ended number of arguments of that kind.

4. **Why must positional arguments come before keyword arguments in a function call?**
   Because positional matching is order-dependent — the interpreter assigns positional arguments to parameters left to right as it encounters them. Once a keyword argument appears, matching switches to name-based; allowing a positional argument afterward would make the argument's target parameter ambiguous, so Python disallows it as a syntax error.

5. **What is a docstring, and how is it different from a regular comment?**
   A docstring is a string literal placed as the first statement in a function, class, or module, and Python stores it as that object's `__doc__` attribute — it exists at runtime and can be introspected (`help()`, IDEs, doc generators). A `#` comment is discarded entirely at parse time and is invisible to any tool inspecting the running program.

## Suggested Next Lesson

[07 — Collections](../07-Collections/README.md)
