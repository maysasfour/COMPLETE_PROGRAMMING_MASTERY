# Functional Programming Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../10-Functional-Programming/README.md)

## Pure Functions and Immutability
A pure function's output depends only on its inputs, with no side effects — same input always produces the same output, and calling it twice is safe. Immutable data can't be changed after creation, eliminating a whole class of aliasing bugs where one part of a program unexpectedly mutates data another part relies on.

## Higher-Order Functions
```python
squared = list(map(lambda n: n ** 2, numbers))
evens = list(filter(lambda n: n % 2 == 0, numbers))
total = functools.reduce(lambda a, b: a + b, numbers, 0)
```
A function that takes another function as an argument or returns one — the foundation of `map`/`filter`/`reduce`.

## Closures
```python
def make_multiplier(factor):
    def multiply(n):
        return n * factor   # captures `factor` from the enclosing scope
    return multiply
double = make_multiplier(2)
```

## Function Composition
```python
def compose(f, g):
    return lambda x: f(g(x))
```
Building a new function by chaining simpler ones together, each handling one transformation step.

## Immutable Data Structures
Prefer returning a new, modified copy over mutating in place — this is what makes pure functions composable and safe to share across concurrent contexts without synchronization.

See the [full Functional Programming module](../../10-Functional-Programming/README.md) for verified, runnable Python lessons on every topic above.
