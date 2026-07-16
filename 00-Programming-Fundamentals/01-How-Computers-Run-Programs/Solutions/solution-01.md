# Solution 01 — Identify the Paradigm

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

## Classifications

**Snippet A — Functional.**
`filter(lambda n: ..., range(10))` describes *what* to keep (a predicate) rather than a step-by-step loop. There's no mutable accumulator variable in the surrounding scope being edited — the transformation is expressed as a single composed expression.

**Snippet B — Object-Oriented.**
`Counter` bundles state (`self.count`) together with the behavior that changes it (`increment`). The defining OOP feature here is that the data and the operations on that data live in the same unit (the class), and external code interacts with the counter only through its methods.

**Snippet C — Imperative.**
Every step is spelled out explicitly: initialize an empty list, loop through a range, check a condition, mutate the list with `.append()`. This is the "how" written out longhand — the exact opposite of Snippet A doing the same job.

**Snippet D — Declarative-style.**
`CONFIG` states the desired settings as data (`debug: True`, `max_connections: 10`) with no procedural steps at all. Some other part of the system (not shown) reads this data and decides how to act on it — the same shape as SQL or HTML, where you describe an outcome and an engine handles execution.

## Bonus: Rewriting Snippet C Functionally

See `solution-01.py` for the runnable version. The key change:

```python
# Imperative (Snippet C)
result = []
for n in range(10):
    if n % 2 == 0:
        result.append(n)

# Functional rewrite
result = list(filter(lambda n: n % 2 == 0, range(10)))
```

Both produce `[0, 2, 4, 6, 8]`. The imperative version names every step (empty list, loop, condition, append). The functional version names only the rule ("keep even numbers") and lets `filter` handle iteration — this is the essence of the imperative/functional distinction: explicit control flow vs. composed expressions.

## Common Pitfalls

- Calling Snippet B "imperative" isn't wrong exactly (the method bodies *are* imperative statements), but the *organizing principle* — bundling state with behavior — is what OOP specifically contributes, so that's the more precise label.
- Snippet D has no "engine" shown, which is fine — declarative code is often just the data/description half of a system; the imperative interpreter for it lives elsewhere (a config loader, a database engine, a browser's HTML renderer).
