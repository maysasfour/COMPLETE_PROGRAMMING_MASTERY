# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Beginner: Modules and `import`

Any `.py` file is a **module** — its top-level names (functions, classes, variables) become accessible to other files via `import`.

```python
# math_utils.py
def add(a, b):
    return a + b
```

```python
# main.py
import math_utils
print(math_utils.add(2, 3))          # 5 - access via the module name

from math_utils import add
print(add(2, 3))                     # 5 - imported directly into this file's namespace

import math_utils as mu
print(mu.add(2, 3))                  # 5 - aliased, common for long module names
```

`import module_name` runs the module's top-level code **once** (the first time it's imported in a process) and caches the result in `sys.modules` — importing it again elsewhere in the same run doesn't re-execute it, just reuses the cached module object.

## Beginner: Packages and `__init__.py`

A **package** is a directory containing an `__init__.py` file (even an empty one), which makes Python treat the directory as an importable package rather than just a folder.

```
mini_package/
├── __init__.py
├── greetings.py
└── math_utils.py
```

```python
# mini_package/__init__.py
from .greetings import greet
from .math_utils import add

__all__ = ["greet", "add"]
```

```python
# using the package from outside
import mini_package
print(mini_package.greet("Ada"))     # works because __init__.py re-exported it
print(mini_package.add(2, 3))
```

`__init__.py` runs whenever the package is first imported — putting re-exports there (`from .submodule import thing`) is what lets callers write `mini_package.greet(...)` instead of the more verbose `mini_package.greetings.greet(...)`. The dot in `from .greetings import greet` is a **relative import** — it means "the `greetings` module in this same package," and only works inside a package (not in a standalone script).

## Intermediate: `pip` and `requirements.txt`

`pip` is Python's package installer, pulling packages from PyPI (the Python Package Index).

```bash
pip install requests            # install a single package
pip install requests==2.31.0    # install a specific version
pip list                        # show installed packages
pip freeze > requirements.txt   # capture exact installed versions to a file
pip install -r requirements.txt # install everything listed in that file
```

`requirements.txt` is a plain text file, one package (optionally pinned to a version) per line:

```
requests==2.31.0
pytest>=7.0
```

Always install project dependencies inside a **virtual environment** (`python -m venv venv`, Lesson 01), never globally — otherwise different projects on the same machine fight over incompatible versions of the same package.

## Advanced: `pyproject.toml`

`pyproject.toml` is the modern, standardized way to describe a Python project — its metadata, dependencies, and build configuration — replacing the older, less standardized `setup.py`.

```toml
[project]
name = "mini-package"
version = "0.1.0"
description = "A tiny demo package"
requires-python = ">=3.10"
dependencies = [
    "requests>=2.31.0",
]

[project.optional-dependencies]
dev = ["pytest>=7.0"]

[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.build_meta"
```

This one file replaces what used to require several separate files (`setup.py`, `setup.cfg`, sometimes `requirements.txt`) — a single, tool-agnostic format that `pip`, `poetry`, `hatch`, and other tools all understand. For an application (not a distributable library), a simple `requirements.txt` is often still enough; `pyproject.toml` matters most once you're publishing a package to PyPI or want a single source of truth for project metadata.

## Real-World Usage

- Every real Python project beyond a single script is organized into packages/modules — separating, e.g., `models/`, `services/`, `utils/` into their own importable units.
- `requirements.txt` (or `pyproject.toml`) is committed to version control so any teammate (or CI system) can recreate the exact same environment with one command.
- Relative imports (`from .submodule import x`) are the standard way modules within the same package reference each other, keeping the package portable (independent of its absolute install location).
- `__all__` in an `__init__.py` documents and controls a package's public API surface, hiding internal helper modules from casual `from package import *` usage.

## Summary

- Any `.py` file is a module; `import` runs it once and caches the result, regardless of how many times it's imported afterward.
- A directory with `__init__.py` is a package; `__init__.py` can re-export names from submodules so callers use a shorter, cleaner import path.
- Relative imports (`from .module import x`) reference sibling modules within the same package.
- `pip install` pulls packages from PyPI; `requirements.txt` pins exact dependency versions for reproducible environments.
- `pyproject.toml` is the modern standardized file for project metadata, dependencies, and build configuration, superseding `setup.py`.

## Key Terms

- **Module** — a single `.py` file, importable by name.
- **Package** — a directory containing `__init__.py`, treated as a single importable unit that can contain multiple modules.
- **Relative import** — `from .module import x`, referencing a sibling module within the same package.
- **`sys.modules`** — the cache of already-imported modules; re-importing a cached module doesn't re-run its top-level code.
- **PyPI** — the Python Package Index, the default public repository `pip install` pulls from.
- **`pyproject.toml`** — the modern standardized file describing a Python project's metadata, dependencies, and build system.

## Common Mistakes

- Forgetting `__init__.py` in older Python versions expecting a directory to "just work" as a package (modern Python supports namespace packages without it in some cases, but an explicit `__init__.py` remains the clear, standard choice for typical packages).
- Using a relative import (`from .module import x`) in a file that's run directly as a script rather than imported as part of a package — this raises `ImportError: attempted relative import with no known parent package`.
- Installing packages globally instead of inside a virtual environment, causing version conflicts across projects.
- Committing a `requirements.txt` without pinned versions (no `==`), letting an unrelated future package release silently break the project when reinstalled.
- Circular imports — module A imports module B, and module B imports module A — causing confusing `ImportError`s partway through initialization.

## Best Practices

- Always develop inside a virtual environment; never `pip install` directly into a system-wide Python.
- Pin exact versions in `requirements.txt` for applications (reproducibility); use looser bounds (`>=`) for libraries meant to be installed alongside other packages with their own constraints.
- Keep `__init__.py` files thin — re-exports and minimal setup, not business logic — so the actual implementation stays easy to find in its own submodule.
- Use `pyproject.toml` for anything you intend to publish or that needs precise build configuration; a simple `requirements.txt` remains fine for straightforward applications.
- Avoid `from module import *` in real code — it pollutes the namespace and obscures where each name actually came from; prefer explicit imports or a module-qualified reference.

## Interview Questions

1. **What's the difference between a module and a package?**
   A module is a single `.py` file. A package is a directory (containing `__init__.py`) that groups multiple modules (and possibly sub-packages) together as one importable unit.

2. **What happens the second time you `import` the same module in a running program?**
   Nothing is re-executed — Python caches every imported module in `sys.modules` after its first import, so subsequent `import` statements for the same module just return the already-created module object instead of running its top-level code again.

3. **What does `__init__.py` do, and why would you put `from .submodule import thing` inside it?**
   `__init__.py` marks a directory as a package and runs automatically when the package is first imported. Re-exporting names there lets external code write the shorter `package.thing` instead of `package.submodule.thing`, hiding the internal file layout behind a clean public interface.

4. **What's the difference between `requirements.txt` and `pyproject.toml`?**
   `requirements.txt` is a simple, flat list of dependencies (often with pinned versions) consumed by `pip install -r`. `pyproject.toml` is a broader, standardized file covering project metadata, dependencies, and build system configuration in one place, and is understood by multiple tools (`pip`, `poetry`, `hatch`), not just a single `pip` workflow.

5. **What causes a circular import, and why is it a problem?**
   It happens when module A imports module B while module B (directly or indirectly) imports module A, creating a cycle. Because each module's code only finishes running once its imports resolve, this can leave one module partially initialized when the other tries to use it — resulting in `ImportError` or `AttributeError` for names that "should" exist but haven't been defined yet at that point in the cycle.

## Suggested Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
