# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Beginner: PEP 8 and Naming Conventions

**PEP 8** is Python's official style guide. Following it isn't about aesthetics for its own sake — consistent style is what lets any Python developer read unfamiliar code quickly.

```python
# snake_case for functions and variables
def calculate_total(item_prices):
    ...

user_age = 25

# PascalCase for classes
class ShoppingCart:
    ...

# UPPER_SNAKE_CASE for constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT_SECONDS = 30

# leading underscore signals "internal use" (Lesson 11)
class Circle:
    def __init__(self, radius):
        self._radius = radius
```

Other core PEP 8 rules: 4 spaces per indentation level (never tabs, never a different number of spaces), a soft line-length limit of 79–99 characters depending on team convention, two blank lines between top-level function/class definitions, and one blank line between methods inside a class.

## Beginner: Type Hints

Type hints document expected types without enforcing them at runtime — Python remains dynamically typed, but hints let editors and tools like `mypy`/`pyright` catch mismatches before you run the code.

```python
def greet(name: str, times: int = 1) -> str:
    return (f"Hello, {name}! " * times).strip()

def find_user(user_id: int) -> dict | None:   # 3.10+ union syntax
    ...

from typing import Optional
def find_user_older_syntax(user_id: int) -> Optional[dict]:  # equivalent, pre-3.10 style
    ...
```

Type hints are optional and unenforced at runtime — `greet(123, "twice")` will still run and likely misbehave, since nothing stops you from passing the wrong types. Their value comes entirely from static analysis (your editor, `mypy`) catching the mismatch *before* you run the code, and from documenting intent for the next person reading the function signature.

## Intermediate: Avoiding Mutable Default Arguments

Covered in Lesson 06, but important enough to restate as a best practice: **never use a mutable object (list, dict, set) as a default argument value.**

```python
# WRONG - the empty list is created ONCE at def time and shared across every call
def add_item(item, cart=[]):
    cart.append(item)
    return cart

# RIGHT - None is an immutable sentinel; a fresh list is made inside the function
def add_item_fixed(item, cart=None):
    if cart is None:
        cart = []
    cart.append(item)
    return cart
```

This bug is subtle because the function *appears* correct on a single call — it only misbehaves once called more than once without explicitly passing `cart`, at which point items silently accumulate across unrelated calls.

## Intermediate: Docstring Conventions

A docstring is the first statement in a module, function, class, or method, written as a string literal — it becomes that object's `__doc__` attribute and is what `help()` and IDE tooltips display.

```python
def calculate_discount(price: float, percent: float) -> float:
    """Calculate the discounted price.

    Args:
        price: The original price, must be non-negative.
        percent: The discount percentage (0-100).

    Returns:
        The price after applying the discount.

    Raises:
        ValueError: If percent is not between 0 and 100.
    """
    if not 0 <= percent <= 100:
        raise ValueError("percent must be between 0 and 100")
    return price * (1 - percent / 100)
```

This is **Google-style** docstring formatting (one of several common conventions, alongside NumPy-style and reST/Sphinx-style) — the important thing is picking one convention and using it consistently across a project, since docstring-parsing tools (like Sphinx, for auto-generated docs) rely on a recognizable structure.

## Advanced: Putting It Together

```python
from typing import Optional


class InventoryItem:
    """Represents a single item tracked in inventory."""

    LOW_STOCK_THRESHOLD: int = 5  # class-level constant, UPPER_SNAKE_CASE

    def __init__(self, name: str, quantity: int = 0) -> None:
        """Initialize an InventoryItem.

        Args:
            name: The item's display name.
            quantity: Starting quantity on hand. Defaults to 0.
        """
        self.name = name
        self.quantity = quantity

    def restock(self, amount: int, notes: Optional[list] = None) -> None:
        """Add to this item's quantity.

        Args:
            amount: How many units to add; must be positive.
            notes: Optional list to append a log entry to. A new list
                is created per call if none is provided - avoids the
                mutable default argument bug.
        """
        if amount <= 0:
            raise ValueError(f"amount must be positive, got {amount}")
        if notes is None:
            notes = []
        self.quantity += amount
        notes.append(f"restocked {amount} units of {self.name}")

    def is_low_stock(self) -> bool:
        """Return True if quantity is at or below the low-stock threshold."""
        return self.quantity <= self.LOW_STOCK_THRESHOLD
```

This combines every practice from this lesson: PEP 8 naming, type hints on every signature, a documented class-level constant, docstrings on the class and each method, and a mutable-default-argument-safe method signature.

## Real-World Usage

- Linters (`flake8`, `ruff`) and formatters (`black`, `ruff format`) automate PEP 8 enforcement so style reviews aren't a manual, subjective back-and-forth.
- Type hints plus `mypy`/`pyright` in CI catch a real class of bugs (wrong types passed across module boundaries) before code ships, especially valuable as a codebase grows past what one person can hold in their head.
- Auto-generated documentation sites (Sphinx, `pdoc`) parse docstrings directly into browsable API reference pages — consistent docstring format is what makes that automation possible.
- Code review checklists at most companies explicitly call out mutable default arguments and missing type hints on public functions as things to flag.

## Summary

- PEP 8: `snake_case` for functions/variables, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants, 4-space indentation.
- Type hints (`param: type`, `-> return_type`) document intent and enable static analysis, but are not enforced at runtime.
- Never use a mutable object (list/dict/set) as a default argument value — use `None` as a sentinel and create the mutable object inside the function body.
- Docstrings (Google-style, NumPy-style, or reST) document what a function/class/module does, its parameters, return value, and possible exceptions — pick one convention and apply it consistently.
- These practices compound: a well-typed, well-documented, PEP-8-compliant function is dramatically easier for both tools and humans to work with correctly.

## Key Terms

- **PEP 8** — Python's official style guide covering naming, whitespace, and layout conventions.
- **Type hint** — optional syntax (`x: int`, `-> str`) documenting expected types, checked by external tools, not the Python runtime itself.
- **Linter** — a tool (`flake8`, `ruff`) that flags style and some correctness issues without executing the code.
- **Formatter** — a tool (`black`, `ruff format`) that automatically rewrites code to match a consistent style.
- **Docstring** — a string literal as the first statement of a module/function/class, accessible via `.__doc__` and `help()`.
- **Mutable default argument** — a default parameter value that's a mutable object, created once at `def` time and dangerously shared across calls that don't override it.

## Common Mistakes

- Mixing naming conventions inconsistently within the same codebase (some functions `camelCase`, others `snake_case`).
- Adding type hints but never actually running a type checker — hints alone catch nothing; a tool has to read them.
- Reaching for a mutable default argument out of habit, not realizing it's created once, not per call.
- Writing a docstring that just restates the function name ("""Calculates the discount.""" on a function called `calculate_discount`) instead of documenting parameters, return value, and edge cases.
- Ignoring linter/formatter warnings instead of either fixing the code or deliberately configuring the tool to allow a specific, justified exception.

## Best Practices

- Run a formatter (`black` or `ruff format`) automatically (e.g., as a pre-commit hook) so style is never a manual judgment call or review debate.
- Add type hints to every public function/method signature at minimum; run `mypy`/`pyright` in CI so hints are actually checked, not just decorative.
- Default mutable arguments to `None` and construct the real default inside the function body, every time, no exceptions.
- Write docstrings for anything with a public API surface — modules, classes, and functions other code will call — describing parameters, return value, and any exceptions raised.
- Treat linter warnings as real signal; either fix the underlying issue or add a scoped, commented suppression explaining why it's a deliberate exception.

## Interview Questions

1. **What are the core PEP 8 naming conventions for functions, classes, and constants?**
   Functions and variables use `snake_case` (all lowercase, words separated by underscores), classes use `PascalCase` (each word capitalized, no underscores), and constants use `UPPER_SNAKE_CASE` (all uppercase, words separated by underscores).

2. **Do type hints change how Python executes code at runtime?**
   No — type hints are purely optional annotations. Python does not enforce them at runtime by default; passing a value of the "wrong" type still executes normally and may only fail later, indirectly, if the code does something incompatible with that value. Their value comes from external static-analysis tools (`mypy`, `pyright`) and editor tooling, not the interpreter itself.

3. **Why is `def f(items=[]):` considered a bug waiting to happen?**
   Default argument values are evaluated exactly once, when the function is defined, not on each call. Since a list is mutable, every call that doesn't explicitly pass its own `items` argument shares that exact same list object — mutations from one call (like `.append()`) persist and are visible on the next call, which is almost never the intended behavior.

4. **What's the standard fix for the mutable default argument problem?**
   Use `None` as the default (an immutable sentinel value), then inside the function body check `if items is None: items = []` to create a brand-new list on each call that needs one, rather than reusing a single shared object across calls.

5. **What's the purpose of a docstring versus a regular `#` comment?**
   A docstring is a string literal as the first statement in a module, function, or class; it's stored as that object's `__doc__` attribute and is retrievable at runtime via `help()` or introspection, and is what documentation-generation tools parse. A `#` comment is discarded by the interpreter entirely and exists only in the source file — it's invisible to `help()`, IDEs' quick-info tooltips, and doc generators.

## Suggested Next Lesson

[20 — Exercises](../20-Exercises/README.md)
