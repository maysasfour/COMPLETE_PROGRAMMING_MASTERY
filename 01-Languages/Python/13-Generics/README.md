# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

Python's type hints are **optional annotations** — the interpreter does not enforce them at runtime. They exist purely for documentation, editor autocomplete, and external static-analysis tools like `mypy` and `pyright`. This lesson covers the annotation syntax and how to write a generic class; keep in mind throughout that nothing here changes what code actually *executes*.

## Beginner: Type Hints Fundamentals

Type hints annotate function signatures and variables with the expected type:

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

age: int = 30
price: float = 19.99
is_active: bool = True
```

`name: str` says "callers should pass a `str`"; `-> str` says "this function returns a `str`." Python does **not** check this at runtime — `greet(42)` runs without error and just returns `"Hello, 42!"` because f-strings coerce with `str()`. Type hints only matter to tools that read them statically, before the code ever runs.

```python
def add(a: int, b: int) -> int:
    return a + b

add("2", "3")   # runs fine at runtime, returns "23" - the hint is not enforced
```

## Beginner: The `typing` Module

For anything beyond a plain built-in type, the `typing` module (and, since Python 3.9, generic builtin syntax) supplies the vocabulary:

```python
from typing import Optional, Union

def find_user(user_id: int) -> Optional[str]:
    """Returns the username, or None if not found."""
    return None  # Optional[str] means "str or None"

def parse(value: Union[int, str]) -> int:
    """Accepts either an int or a str, always returns an int."""
    return int(value)
```

- `Optional[X]` is shorthand for `Union[X, None]` — "this can be `X`, or it can be `None`."
- `Union[A, B]` means "either an `A` or a `B`."

**Modern syntax (3.9+ and 3.10+):** you rarely need to import container generics from `typing` anymore, and `Union` has a shorter spelling:

```python
# Python 3.9+ : built-in collection types are generic on their own
names: list[str] = ["Ana", "Bo"]          # instead of typing.List[str]
scores: dict[str, int] = {"Ana": 90}       # instead of typing.Dict[str, int]

# Python 3.10+ : the "|" operator replaces Union and Optional
def parse(value: int | str) -> int:         # instead of Union[int, str]
    return int(value)

def find_user(user_id: int) -> str | None:  # instead of Optional[str]
    return None
```

`typing.List`, `typing.Dict`, etc. still exist for backward compatibility with older Python versions, but `list[int]`/`dict[str, int]` (3.9+) and `X | Y` (3.10+) are now the preferred, more readable forms in new code.

## Intermediate: `TypeVar` and `Generic`

A `TypeVar` lets you write a class or function that works with *any* type while staying internally consistent about *which* type it is at a given use site:

```python
from typing import TypeVar, Generic

T = TypeVar("T")

class Box(Generic[T]):
    """A container that holds exactly one value of some type T."""

    def __init__(self, item: T) -> None:
        self._item = item

    def get(self) -> T:
        return self._item

    def set(self, item: T) -> None:
        self._item = item


int_box: Box[int] = Box(42)
int_box.get()          # 42, and a type checker knows this is an int

str_box: Box[str] = Box("hello")
str_box.get()          # "hello", and a type checker knows this is a str
```

`Box[int]` and `Box[str]` are the *same class* at runtime — `Generic[T]` doesn't create separate classes per type parameter. What it does is let a static type checker verify that `int_box.get()` returns an `int` and flag `int_box.set("oops")` as a type error, all *before* the code runs. At runtime, `Box` behaves identically regardless of what `T` was "supposed to be."

A slightly richer example — a generic `Stack`:

```python
class Stack(Generic[T]):
    """A last-in-first-out stack holding items of a single type T."""

    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    def is_empty(self) -> bool:
        return len(self._items) == 0
```

A type checker will infer `Stack[int]` from `Stack[int]()` and then flag `stack.push("not an int")` as an error — again, only statically. Nothing in the runtime `Stack` class enforces this.

## Advanced: Static Checking Is Optional and External

Python ships **no built-in type checker**. Annotations are stored (mostly in `__annotations__`) and otherwise ignored by the interpreter at runtime. To actually get value from type hints — catching a whole class of bugs before running the program — you run a separate static analysis tool over your code:

- **`mypy`** — the original, most widely used type checker for Python.
- **`pyright`** — Microsoft's type checker, also what powers type checking in VS Code's Python extension (via Pylance).

```bash
pip install mypy
mypy my_script.py
```

Both tools read the same `typing`-based annotations described above; neither changes how the code executes. This "gradual typing" design is deliberate: you can annotate as much or as little of a codebase as you want, and unannotated code is simply treated as `Any` (anything goes, no checking).

## Real-World Usage

- Large Python codebases (Django, FastAPI, most modern libraries) are increasingly fully type-hinted, and CI pipelines commonly run `mypy`/`pyright` as a required check alongside tests.
- `Optional[X]` / `X | None` return types are the standard way to document "this function might not find/return anything" (e.g., a database lookup that may return no row).
- Generic containers like a type-hinted `Stack[T]` or `Repository[T]` class are common in larger applications to get autocomplete and type-safety on custom data structures without duplicating code per type.
- Editors (VS Code, PyCharm) use type hints to power autocomplete, inline errors, and "go to definition" even without ever running a separate checker command.

## Summary

- Type hints annotate function signatures and variables but are **not enforced by the interpreter at runtime** — they're purely for tooling and documentation.
- `Optional[X]` means "`X` or `None`"; `Union[A, B]` means "`A` or `B`."
- Since Python 3.9, builtin collections are generic on their own (`list[int]`, `dict[str, int]`) instead of needing `typing.List`/`typing.Dict`.
- Since Python 3.10, `X | Y` replaces `Union[X, Y]` and `X | None` replaces `Optional[X]`.
- `TypeVar` + `Generic` let you write a class (like a generic `Stack[T]` or `Box[T]`) that a static type checker can verify consistently for a specific type, without creating separate classes per type at runtime.
- `mypy` and `pyright` are external tools that actually check the hints; the interpreter itself never does.

## Key Terms

- **Type hint / annotation** — optional syntax (`name: type`) documenting the expected type of a variable, parameter, or return value.
- **`Optional[X]`** — shorthand for `Union[X, None]`, meaning the value may be `X` or may be `None`.
- **`Union[A, B]`** (or `A | B` in 3.10+) — a type that may be either `A` or `B`.
- **`TypeVar`** — a placeholder representing an unspecified type, used to write generic functions/classes.
- **`Generic[T]`** — a base class that marks a class as parameterized over a `TypeVar` `T`, enabling tools to check it as `MyClass[int]`, `MyClass[str]`, etc.
- **Static type checker** — an external tool (`mypy`, `pyright`) that analyzes type hints without executing the code, to catch type errors before runtime.

## Common Mistakes

- Assuming a type hint is enforced — passing the "wrong" type still runs without error unless a separate tool like `mypy` is run and its errors are treated as build failures.
- Importing `List`/`Dict`/`Optional` from `typing` out of habit in a 3.9+/3.10+ codebase when `list[int]`, `dict[str, int]`, and `X | None` are shorter and now preferred.
- Forgetting that `Generic[T]` produces one class, not a family of classes — `Box[int]` and `Box[str]` are the same runtime type, differing only in what a type checker infers.
- Adding type hints but never actually running `mypy`/`pyright` in CI, which means annotations silently rot out of sync with the real code.
- Over-annotating trivial local variables where the type is already obvious from the right-hand side (`count: int = 0` instead of just `count = 0`).

## Best Practices

- Annotate public function signatures (parameters and return types) even if you skip hints on obvious local variables — that's where hints pay off most for callers and tools.
- Prefer the modern syntax for your Python version: `list[int]`/`dict[str, int]` (3.9+) and `X | None` (3.10+) over the older `typing.List`/`typing.Optional` forms.
- Run a static type checker (`mypy` or `pyright`) in CI if your project relies on type hints for correctness, so the hints stay meaningful rather than becoming stale documentation.
- Use `TypeVar`/`Generic` when writing reusable containers or utilities (a stack, queue, repository) so callers and tools get accurate per-usage typing.
- Treat type hints as documentation-with-teeth-only-if-checked: don't rely on them for runtime validation — use explicit checks or a library like `pydantic` if you need real runtime enforcement.

## Interview Questions

1. **Are Python type hints enforced at runtime?**
   No. The interpreter stores annotations (accessible via `__annotations__`) but never checks them while running the program — you can pass a value of the "wrong" type and the code will still execute. Enforcement only happens if you run an external static type checker like `mypy` or `pyright` over the code before runtime.

2. **What is the difference between `Optional[X]` and `Union[A, B]`?**
   `Optional[X]` is shorthand for `Union[X, None]` — it says a value is either of type `X` or is `None`. `Union[A, B]` is more general and says a value can be either of two (or more) specific types, neither of which needs to be `None`.

3. **What changed with generic type syntax in Python 3.9 and 3.10?**
   In 3.9, builtin collection types became generic on their own, so you can write `list[int]` or `dict[str, int]` directly instead of importing `typing.List`/`typing.Dict`. In 3.10, the `|` operator was added as a shorthand for `Union`, so `int | str` replaces `Union[int, str]` and `str | None` replaces `Optional[str]`.

4. **How does `TypeVar` combined with `Generic` let you write a generic class like `Stack[T]`?**
   `TypeVar("T")` creates a placeholder type, and inheriting from `Generic[T]` marks the class as parameterized over that placeholder. A type checker can then verify that a specific instantiation like `Stack[int]` consistently only pushes and pops `int` values, even though at runtime there's only one `Stack` class — the type parameter has no runtime effect.

5. **If type hints aren't enforced, what actually checks them, and why bother adding them?**
   External tools like `mypy` and `pyright` statically analyze the annotated code (without running it) and report type mismatches as errors before the code ever executes. Hints are worth adding because they catch a class of bugs early, improve editor autocomplete/navigation, and serve as always-up-to-date documentation of a function's expected inputs and outputs — as long as a checker is actually run to keep them honest.

## Suggested Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
