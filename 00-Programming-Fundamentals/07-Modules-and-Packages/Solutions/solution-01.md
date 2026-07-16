# Solution 01 — Build a Small Package

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

The package lives in `stringutils/` (`casing.py`, `counting.py`, `__init__.py`), and the driver script is `solution-01.py`. Verified output:

```
shout('hello world') = HELLO WORLD!
word_count('hello world from python') = 4
```

## Structure

```
Solutions/
    solution-01.py
    stringutils/
        __init__.py
        casing.py
        counting.py
```

```python
# stringutils/casing.py
def shout(text):
    return text.upper() + "!"

# stringutils/counting.py
def word_count(text):
    return len(text.split())

# stringutils/__init__.py
from .casing import shout
from .counting import word_count
__all__ = ["shout", "word_count"]
```

## Reflection Answer

`__init__.py` must explicitly import from `.casing` and `.counting` because **a package's `__init__.py` is the only code Python runs automatically when the package itself is imported** — it does not automatically scan every file inside the package directory and pull names up to the top level. Without the `from .casing import shout` line, `from stringutils import shout` would fail with `ImportError: cannot import name 'shout' from 'stringutils'`, because as far as the `stringutils` package's own namespace is concerned, `shout` doesn't exist there — it only exists inside `stringutils.casing`, a namespace the caller would have to reach explicitly (`from stringutils.casing import shout`).

This is a deliberate design choice, not a limitation: it lets a package author freely reorganize internal files (split `casing.py` into two files, rename it, merge modules) without breaking any caller's `from stringutils import shout` — the caller depends on the package's declared public API in `__init__.py`, not on its internal file layout.

## Common Pitfalls

- Forgetting the `.` in `from .casing import shout` inside `__init__.py` — the leading dot means "the module named `casing` in this same package," a **relative import**. Without it, Python looks for a top-level module named `casing`, which doesn't exist, and raises `ModuleNotFoundError`.
- Running the driver script from the wrong directory — `stringutils/` needs to be a sibling of the script being run (or otherwise on the import path) for the plain `import stringutils` to resolve.
- Adding logic beyond re-exports to `__init__.py` — keeping it to imports (and maybe `__all__`) keeps the package's entry point predictable; real logic belongs in the inner modules.
