# Exercise 01 — Identify the Paradigm

[Back to lesson](../README.md)

## Task

Below are four short Python snippets. For each one:

1. Name which paradigm it best demonstrates (imperative, OOP, functional, or declarative-style).
2. Write one sentence explaining *why* — point to a specific feature of the code (mutation, bundled state, no side effects, description of "what" vs "how").

```python
# Snippet A
even_numbers = list(filter(lambda n: n % 2 == 0, range(10)))
```

```python
# Snippet B
class Counter:
    def __init__(self):
        self.count = 0

    def increment(self):
        self.count += 1
```

```python
# Snippet C
result = []
for n in range(10):
    if n % 2 == 0:
        result.append(n)
```

```python
# Snippet D — a config loader that just states desired settings
CONFIG = {
    "debug": True,
    "max_connections": 10,
}
```

## Bonus

Rewrite Snippet C so that it produces the same `result` list but in the functional style used in Snippet A.

## Deliverable

A short markdown or text answer with your four (or five, with the bonus) classifications and justifications. No solution is provided in this file — check your reasoning against `Solutions/solution-01.md` only after you've attempted it yourself.
