# Exercise 01 — Build a Small Package

[Back to lesson](../README.md)

## Task

Create a package named `stringutils/` (a directory with an `__init__.py`) containing two modules:

- `stringutils/casing.py` with a function `shout(text)` that returns `text` uppercased with an exclamation mark appended (e.g., `shout("hello")` returns `"HELLO!"`).
- `stringutils/counting.py` with a function `word_count(text)` that returns the number of whitespace-separated words in `text`.

In `stringutils/__init__.py`, re-export both `shout` and `word_count` so a caller can do:

```python
from stringutils import shout, word_count
```

without knowing which inner file each function lives in (mirror the pattern used by `shapes/__init__.py` in this lesson's `example.py`).

Then write a small script (in the same folder as your `stringutils/` package, so the import resolves) that imports both functions and calls each with a sample string, printing the results.

## Reflection Question

Why does `stringutils/__init__.py` need to explicitly import from `.casing` and `.counting`? What would happen if a caller tried `from stringutils import shout` without that re-export line in `__init__.py` — would Python find `shout` automatically by searching inside the package's files? (Test this by removing the re-export line temporarily and observing the error.)

## Deliverable

The `stringutils/` package (two modules + `__init__.py`) plus a driver script that imports and calls both functions, with output printed. Attempt this before checking `Solutions/`.
