# 04 — Functions and Scope

[Back to module overview](../README.md) | [Previous: Control Flow](../03-Control-Flow/README.md)

## Beginner: Parameters, Arguments, and Return Values

- A **parameter** is the name a function declares to receive input (`def greet(name):` — `name` is a parameter).
- An **argument** is the actual value passed in at call time (`greet("Ana")` — `"Ana"` is the argument).
- A **return value** is what the function hands back to the caller via `return`. A function with no explicit `return` implicitly returns `None`.

```python
def add(a, b):        # a, b are parameters
    return a + b

result = add(2, 3)    # 2, 3 are arguments; result is the return value
```

Python also supports default parameter values and keyword arguments:

```python
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

greet("Ana")                     # uses the default: "Hello, Ana!"
greet("Ana", greeting="Hi")      # keyword argument overrides default: "Hi, Ana!"
```

## Intermediate: Scope

**Scope** determines where a name (variable) is visible and accessible. Python resolves names using the **LEGB rule** — it looks in this order and stops at the first match:

1. **Local** — names assigned inside the current function.
2. **Enclosing** — names in any enclosing (outer) function, for nested functions.
3. **Global** — names assigned at the top level of the module.
4. **Built-in** — names Python provides itself (`len`, `print`, `range`, ...).

```python
x = "global"

def outer():
    x = "enclosing"

    def inner():
        x = "local"
        print(x)      # "local" - found in Local scope first

    inner()
    print(x)          # "enclosing" - Local scope of outer(), unaffected by inner()

outer()
print(x)               # "global" - unaffected by either function
```

Assigning to a name *inside* a function creates a **new local variable** by default — it does not modify an outer variable of the same name, even if one exists. To explicitly modify an outer name, Python requires the `global` or `nonlocal` keyword (rarely needed in well-structured code; usually a sign to return a value instead).

## Advanced: Closures

A **closure** is a function that "remembers" variables from an enclosing scope even after that enclosing function has finished running.

```python
def make_multiplier(factor):
    def multiplier(n):
        return n * factor    # `factor` is captured from make_multiplier's scope
    return multiplier

double = make_multiplier(2)
triple = make_multiplier(3)
print(double(5))   # 10 - remembers factor=2 even though make_multiplier already returned
print(triple(5))   # 15 - a SEPARATE captured factor=3
```

Each call to `make_multiplier` creates a fresh, independent closure — `double` and `triple` each carry their own captured `factor`. Closures are the mechanism behind decorators, callback functions, and a lot of functional-style Python.

## Advanced: Recursion

**Recursion** is a function calling itself to solve a smaller version of the same problem, until it reaches a **base case** that stops the recursion.

```python
def factorial(n):
    if n <= 1:          # base case - stops the recursion
        return 1
    return n * factorial(n - 1)   # recursive case - smaller subproblem
```

Every recursive function needs:
1. A **base case** that returns a value directly, without recursing.
2. A **recursive case** that moves strictly closer to the base case on every call.

Without both, you get infinite recursion, which in Python raises `RecursionError` once the call stack depth limit is hit (Python has no automatic tail-call optimization, unlike some functional languages — deep recursion has a real memory cost; see Lesson 05 on the call stack).

**Recursion vs. iteration:** recursion often expresses tree-like or self-similar problems (traversing nested structures, divide-and-conquer algorithms) more naturally than a loop. But every recursive call consumes stack space, so a loop is usually preferred for simple linear repetition where recursion offers no clarity benefit.

## Real-World Usage

- Default parameter values and keyword arguments make library/API functions flexible without forcing every caller to specify every option.
- Closures power decorators (`@app.route(...)` in web frameworks), event handler callbacks, and memoization caches.
- Recursion is standard for tree/graph traversal (file system walking, JSON parsing, UI component trees) and divide-and-conquer algorithms (merge sort, binary search).
- Scope discipline (minimizing use of `global`) is a major factor in whether a codebase is easy or painful to reason about — functions that only depend on their parameters are far easier to test and reuse.

## Summary

- Parameters are declared names; arguments are the actual values passed at call time; `return` sends a value back to the caller.
- Scope (Local → Enclosing → Global → Built-in) determines where a name is visible; assignment inside a function is local by default.
- A closure is a function that captures and remembers variables from an enclosing scope after that scope has returned.
- Recursion solves a problem via self-calls that shrink toward a base case; every recursive function needs both a base case and a recursive case that progresses toward it.

## Key Terms

- **Parameter** — a name declared in a function's signature to receive input.
- **Argument** — the actual value passed to a function call.
- **Return value** — the value a function sends back via `return` (or `None` if omitted).
- **Scope** — the region of code where a name is visible.
- **LEGB rule** — Local, Enclosing, Global, Built-in — Python's name resolution order.
- **Closure** — a function that captures variables from an enclosing scope, persisting after that scope ends.
- **Recursion** — a function calling itself on a smaller subproblem.
- **Base case** — the recursion-stopping condition that returns without a further recursive call.

## Common Mistakes

- **Mutable default arguments** — `def f(items=[]):` reuses the *same* list object across every call that doesn't supply one, because the default is evaluated once at function definition time, not per call. Use `None` and create the list inside the function instead.
- Assuming assignment inside a function modifies an outer variable of the same name — it creates a new local variable unless `global`/`nonlocal` is used.
- Writing recursion without a base case, or with a recursive case that doesn't shrink toward it, causing `RecursionError`.
- Overusing `global` instead of passing values as parameters and returning results — makes functions hard to test and reason about in isolation.

## Interview Questions

1. **What's the difference between a parameter and an argument?**
   A parameter is the name declared in the function definition; an argument is the actual value supplied when the function is called. `def f(x)` — `x` is a parameter; `f(5)` — `5` is the argument.

2. **Explain the LEGB rule.**
   Python resolves a name by searching, in order: Local scope (current function), Enclosing scope (any outer function, for nested functions), Global scope (module level), Built-in scope (Python's own names like `len`). It stops and uses the first match found.

3. **What is a closure, and why is it useful?**
   A closure is a function that retains access to variables from the scope it was defined in, even after that outer scope has finished executing. It's useful for creating specialized functions on the fly (like `make_multiplier(2)`), implementing decorators, and encapsulating private state without a full class.

4. **Why is a mutable default argument a common bug source in Python?**
   Default argument values are evaluated once, when the function is defined — not on every call. A mutable default (like `[]` or `{}`) is therefore the *same object* shared across every call that doesn't override it, so mutations from one call leak into subsequent calls. The fix is to default to `None` and create the mutable object inside the function body.

5. **What two things does every correct recursive function need, and what happens if one is missing?**
   A base case (a condition that returns without recursing further) and a recursive case that makes measurable progress toward that base case. Missing either causes infinite recursion, which Python eventually stops with a `RecursionError` once the call stack's depth limit is exceeded.

## Suggested Next Lesson

[05 — Memory Concepts](../05-Memory-Concepts/README.md)
