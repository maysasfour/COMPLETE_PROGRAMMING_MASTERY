# Python

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Python Is

Python is a high-level, interpreted, dynamically-typed, general-purpose programming language created by Guido van Rossum and first released in 1991. It prioritizes readability and developer productivity over raw execution speed — the language's design philosophy (see `import this` in any Python shell, "The Zen of Python") explicitly favors explicit, simple, readable code over clever or terse code.

Python is executed by an interpreter (the reference implementation is **CPython**), which compiles source to bytecode and runs it on a virtual machine — you don't compile a binary yourself, you just run `python file.py`.

## Why / Where It's Used

- **Data science & machine learning** — the dominant language in the field (NumPy, pandas, PyTorch, TensorFlow, scikit-learn). Nearly every ML paper ships Python reference code.
- **Web backends** — Django and Flask/FastAPI power large-scale production APIs (Instagram, Pinterest, and countless SaaS backends run on Django; FastAPI is now a default choice for new APIs).
- **Automation & scripting** — glue code, build scripts, DevOps tooling (Ansible is Python), file processing, and "do this repetitive task for me" one-off scripts.
- **Scientific computing** — physics, bioinformatics, astronomy; readable syntax matters when domain experts (not just professional programmers) write the code.
- **Education** — the most common first language taught, because syntax overhead is minimal and the gap between "idea" and "working code" is small.
- **Testing & tooling** — many command-line tools and test frameworks across other ecosystems are themselves written in or scripted with Python.

## Advantages

- Extremely readable syntax; low ceremony to get from idea to working code.
- Enormous standard library ("batteries included") and the largest third-party package ecosystem (PyPI) of any language.
- Dynamic typing plus optional type hints gives you a spectrum from "quick script" to "type-checked production code."
- Excellent interoperability — C extensions, calling into Rust, embedding in other applications.
- Massive community, so almost every problem has prior art, tutorials, and Stack Overflow answers.

## Disadvantages

- Slower than compiled languages (C, Rust, Go) and most statically-typed JIT languages (Java, C#) for raw CPU-bound work, because of interpretation overhead and dynamic typing.
- The Global Interpreter Lock (GIL) in CPython means true CPU-bound parallelism across threads within one process is limited (see Lesson 14) — you reach for multiprocessing or async I/O instead.
- Dynamic typing catches type errors at runtime instead of before you ship, unless you invest in type hints + a checker (`mypy`, `pyright`).
- Packaging/dependency management historically had a rockier story than some ecosystems (`pip`, `venv`, `poetry`, `pyproject.toml` all coexist) — improving, but still more choices than, say, Cargo in Rust.
- Mobile and native GUI development are not Python's strong suit compared to native platform languages.

## How to Install

### Windows
- Download the installer from [python.org/downloads](https://www.python.org/downloads/) and **check "Add python.exe to PATH"** during install, or run in PowerShell:
  ```powershell
  winget install Python.Python.3.12
  ```

### macOS
```bash
brew install python@3.12
```

### Linux (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install python3 python3-pip python3-venv
```

### Verify the install
```bash
python --version     # Windows typically uses `python`
python3 --version    # macOS/Linux typically use `python3`
pip --version
```

This course was written and verified against **Python 3.14** but everything in it works on **Python 3.10+** unless a lesson explicitly says otherwise (e.g. `match` statements need 3.10+, some `typing` syntax needs 3.9+/3.10+).

## How to Run the Examples

Every lesson folder (01 through 19) has a `README.md` and a runnable `example.py`. From the repository root:

```bash
cd 01-Languages/Python/03-Variables-and-Data-Types
python example.py
```

Lessons with an `Exercises/` and `Solutions/` folder work the same way — read the exercise, attempt it yourself, then run the matching solution file:

```bash
python Solutions/solution-01.py
```

For **16-Database-Access**, `18-Testing`, and the mini-project's test file, you additionally need:

```bash
pip install pytest requests
```

(`sqlite3` and `asyncio` are part of the standard library — no install needed.) Run pytest-based tests from inside the relevant folder with:

```bash
pytest -v
```

## Common Beginner Mistakes

- **Mixing tabs and spaces**, or inconsistent indentation — Python uses indentation as syntax, not just style (Lesson 02).
- **Mutable default arguments** — `def f(items=[]):` reuses the *same* list object across every call that doesn't pass one explicitly (Lesson 06/19).
- **Confusing `is` with `==`** — `is` checks identity (same object in memory), `==` checks equality (same value) (Lesson 04).
- **Catching exceptions too broadly** with a bare `except:`, hiding real bugs including `KeyboardInterrupt` and `SystemExit` (Lesson 09).
- **Not using a virtual environment**, causing dependency conflicts between projects (Lesson 01).
- **Believing `python` and `python3` are always the same command** — on some systems only one exists; on others both exist but point to different versions.
- **Modifying a list while iterating over it**, which silently skips elements.
- **Off-by-one slicing errors** — forgetting that `range(n)` and slices are half-open (`stop` is exclusive) (Lesson 08).

## Best Practices

- Follow [PEP 8](https://peps.python.org/pep-0008/) for style — 4-space indentation, `snake_case` for functions/variables, `PascalCase` for classes (Lesson 19).
- Use a virtual environment (`venv`) per project; never install project dependencies globally.
- Add type hints to public function signatures in anything beyond a throwaway script; run `mypy` or rely on your editor's type checker.
- Prefer f-strings for formatting (`f"{name} is {age}"`) over `%`-formatting or `.format()`.
- Write docstrings for public functions/classes/modules — they're not just comments, tools like `help()` and IDEs read them.
- Handle specific exceptions, not bare `except:`.
- Use `with` for anything that needs cleanup (files, DB connections, locks) instead of manual open/close.
- Keep functions small and single-purpose; prefer composing small functions over one large one.

## Interview Questions

1. **What's the difference between a list and a tuple?**
   Lists are mutable and typically hold homogeneous, variable-length sequences; tuples are immutable and often represent fixed-size, heterogeneous records. Tuples are hashable (usable as dict keys / set members) if their contents are; lists never are.

2. **What is the GIL and why does it matter?**
   The Global Interpreter Lock is a mutex in CPython that allows only one thread to execute Python bytecode at a time, even on multi-core machines. It means threading doesn't give you CPU-bound parallelism (use `multiprocessing` for that), though it doesn't block I/O-bound concurrency (threads still help there, and `asyncio` is often a better fit).

3. **What's the difference between `is` and `==`?**
   `==` calls `__eq__` and compares values for equality. `is` compares object identity (same memory location). Two equal-valued objects are not necessarily the same object — `is` should almost only be used against singletons like `None`.

4. **What happens when you use a mutable default argument?**
   The default value is created **once**, at function definition time, not on each call. If it's mutable (like a list) and the function mutates it, that mutation persists across calls that rely on the default. Fix: use `None` as the sentinel default and create the mutable object inside the function body.

5. **What's the difference between a shallow copy and a deep copy?**
   A shallow copy (`list.copy()`, `copy.copy()`) creates a new outer container but still shares references to any nested mutable objects inside it. A deep copy (`copy.deepcopy()`) recursively copies everything, so no nested object is shared with the original.

6. **How does Python manage memory?**
   Primarily reference counting — every object tracks how many references point to it, and is freed when that count hits zero — plus a cyclic garbage collector to catch reference cycles that reference counting alone can't clean up.

7. **What's a decorator?**
   A function that takes a function (or class) and returns a modified version of it, typically used to add behavior (logging, timing, access control, caching) without changing the original function's code (Lesson 12).

8. **What's the difference between `*args` and `**kwargs`?**
   `*args` collects extra positional arguments into a tuple; `**kwargs` collects extra keyword arguments into a dict. Both let a function accept a variable, unknown-in-advance number of arguments (Lesson 06).

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing Python, `venv`, `pip`, project layout, running scripts |
| 02 | [Syntax](02-Syntax/README.md) | Indentation rules, comments, statements vs. expressions |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | int/float/str/bool/None, `type()`/`isinstance()`, dynamic typing |
| 04 | [Operators](04-Operators/README.md) | Arithmetic, comparison, logical, `is` vs `==`, membership |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/elif/else, for, while, break/continue/else-on-loops, `match` |
| 06 | [Functions](06-Functions/README.md) | `def`, default args, `*args`/`**kwargs`, return, docstrings |
| 07 | [Collections](07-Collections/README.md) | list, tuple, set, dict, comprehensions |
| 08 | [Strings](08-Strings/README.md) | Slicing, f-strings, common string methods, encoding basics |
| 09 | [Error Handling](09-Error-Handling/README.md) | try/except/else/finally, custom exceptions, `raise` |
| 10 | [File Handling](10-File-Handling/README.md) | `open`/`with`, text and JSON files, `pathlib` |
| 11 | [OOP](11-OOP/README.md) | Classes, `__init__`, instance vs. class attributes, inheritance, dunder methods, properties |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | `lambda`, `map`/`filter`/`reduce`, first-class functions, decorators |
| 13 | [Generics](13-Generics/README.md) | Type hints, the `typing` module, `Generic`/`TypeVar` |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | `asyncio` basics, threading vs. multiprocessing |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Import system, `__init__.py`, `pip`, `requirements.txt`/`pyproject.toml` |
| 16 | [Database Access](16-Database-Access/README.md) | `sqlite3` CRUD, no external DB server needed |
| 17 | [API Integration](17-API-Integration/README.md) | `requests` against a public test API |
| 18 | [Testing](18-Testing/README.md) | `pytest` basics: tests, assertions, fixtures |
| 19 | [Best Practices](19-Best-Practices/README.md) | PEP 8, naming, type hints, mutable defaults, docstrings |
| 20 | [Exercises](20-Exercises/README.md) | Standalone practice problems spanning the whole course |
| 21 | [Solutions](21-Solutions/README.md) | Matching solutions for 20-Exercises |
| 22 | [Mini Projects](22-Mini-Projects/README.md) | A complete CLI expense tracker built on `sqlite3` |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md) for a dense one-page syntax reference.

## Suggested Path

Work through 01 → 19 in order — each lesson assumes the previous ones. Then do 20-Exercises (checking yourself against 21-Solutions only after attempting each problem), and finish with the 22-Mini-Projects build to see everything combined in one program.

**Previous module:** [00-Programming-Fundamentals](../../00-Programming-Fundamentals/README.md)
