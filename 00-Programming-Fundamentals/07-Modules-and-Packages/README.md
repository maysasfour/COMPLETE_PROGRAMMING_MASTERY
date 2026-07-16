# 07 — Modules and Packages

[Back to module overview](../README.md) | [Previous: Error Handling](../06-Error-Handling/README.md)

## Beginner: What a Module Is

A **module** is simply a single `.py` file — any Python file can be imported by another. Splitting code into modules is how you avoid putting an entire program in one file: related functions/classes live together, unrelated ones live apart.

```python
# math_utils.py
def add(a, b):
    return a + b
```

```python
# main.py
import math_utils
print(math_utils.add(2, 3))   # 5
```

`import math_utils` runs `math_utils.py` once (top to bottom) the first time it's imported, then caches the resulting module object — later imports in the same program reuse that cached module instead of re-running the file.

## Beginner: Import Styles

```python
import math_utils                       # access everything via math_utils.add(...)
from math_utils import add               # bring `add` directly into this file's namespace
from math_utils import add as addition   # rename on import to avoid a name clash
import math_utils as mu                  # rename the module itself
```

`from module import *` imports everything public from a module directly into the current namespace. Avoid it in real code — it makes it unclear where a given name came from when reading the file later, and it can silently overwrite existing names.

## Intermediate: Packages

A **package** is a directory containing an `__init__.py` file (which can be empty) plus one or more modules — it lets you group related modules under a shared namespace.

```
shapes/
    __init__.py
    circle.py
    rectangle.py
```

```python
from shapes import circle
from shapes.rectangle import area

circle.area(radius=2)
area(width=3, height=4)
```

`__init__.py` runs when the package is first imported and can be used to control what the package exposes at its top level (e.g., re-exporting specific functions so callers don't need to know the internal file layout).

## Intermediate: How Python Finds Modules

When you `import something`, Python searches, in order:
1. Already-imported modules (the cache — `sys.modules`).
2. The directory of the script being run.
3. Directories listed in the `PYTHONPATH` environment variable.
4. Installed site-packages (third-party libraries).

This is why a script can `import` a sibling file in the same folder without any special configuration, but importing across unrelated folders requires either installing the package properly or manipulating the search path.

## Advanced: Dependency Management Basics

A **dependency** is external code your project relies on but doesn't write itself (a third-party library). Managing dependencies well means:

- **Declaring** exactly which packages (and ideally which versions) your project needs, typically in a `requirements.txt` or `pyproject.toml` file — so anyone else (or future you) can recreate the same environment.
- **Isolating** dependencies per project using a **virtual environment** (`python -m venv .venv`), so installing a library for one project doesn't silently change behavior in another project that needs a different version of the same library.
- **Pinning versions** for anything you deploy, so an upstream library releasing a breaking change doesn't break your project unexpectedly.

```bash
python -m venv .venv              # create an isolated environment
.venv\Scripts\activate             # activate it (Windows)
pip install requests==2.31.0        # install a pinned dependency
pip freeze > requirements.txt        # record exact installed versions
```

Without isolation, two projects on the same machine that need different versions of the same library will conflict — this is the single most common reason "it works on my machine" fails elsewhere.

## Real-World Usage

- Every non-trivial codebase is organized into modules/packages; understanding import mechanics is prerequisite to navigating any real project.
- Circular imports (module A imports module B, which imports module A) are a common real bug caused by poor module boundaries — usually fixed by restructuring what each module is responsible for, not by clever import tricks.
- Virtual environments are standard practice for every Python project beyond a single throwaway script — skipping this is one of the most common beginner mistakes that causes "works on my machine" bugs.

## Summary

- A module is a single `.py` file; a package is a directory of modules with an `__init__.py`.
- `import`, `from ... import ...`, and aliasing (`as`) control how names enter your namespace; avoid `import *` in real code.
- Python searches the module cache, the running script's directory, `PYTHONPATH`, then installed packages, in that order.
- Manage dependencies with a declared list (requirements file) and an isolated virtual environment per project; pin versions for anything deployed.

## Key Terms

- **Module** — a single Python file that can be imported.
- **Package** — a directory of modules, marked with `__init__.py`, providing a shared namespace.
- **Namespace** — the set of names currently accessible in a given scope.
- **`sys.modules`** — Python's cache of already-imported modules.
- **Virtual environment** — an isolated Python environment with its own installed packages, separate from other projects.
- **Dependency** — external code (a library/package) your project relies on but doesn't author itself.
- **Pinning** — specifying an exact version of a dependency to avoid unexpected upstream changes.

## Common Mistakes

- Using `from module import *`, making it unclear where a name in the current file actually came from.
- Installing packages globally instead of in a per-project virtual environment, causing version conflicts between unrelated projects.
- Forgetting to update/commit the requirements file after adding a new dependency, so the project fails to run in a fresh environment.
- Creating circular imports by letting two modules depend on each other directly, instead of extracting shared logic into a third module both can depend on.

## Interview Questions

1. **What's the difference between a module and a package?**
   A module is a single `.py` file. A package is a directory containing multiple modules plus an `__init__.py` file, providing a shared, hierarchical namespace (e.g., `shapes.circle`).

2. **Why is `from module import *` discouraged?**
   It imports every public name from the module directly into the current namespace without qualification, making it unclear later where any given name came from, and risking silently overwriting an existing name with the same identifier.

3. **What problem do virtual environments solve?**
   They isolate a project's installed dependencies from the system Python and from other projects, so two projects needing different versions of the same library don't conflict, and so a project's exact dependency set can be reliably reproduced elsewhere.

4. **What is a circular import, and why does it happen?**
   It's when module A imports module B, and module B (directly or indirectly) imports module A back, creating a dependency loop. It usually signals that the two modules' responsibilities are tangled together and should be restructured — often by moving shared logic into a third module both can depend on independently.

5. **Why should dependency versions be pinned for a deployed project?**
   An unpinned dependency can be silently upgraded to a new version (by anyone re-installing) that introduces a breaking change or different behavior, causing the project to fail somewhere unrelated to any code change you actually made. Pinning guarantees the exact same dependency code runs every time, until you deliberately choose to upgrade.

## Suggested Next Lesson

[08 — Concurrency Basics](../08-Concurrency-Basics/README.md)
