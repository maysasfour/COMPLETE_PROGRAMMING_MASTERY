# 08 — Generics and Static Members

[Back to module overview](../README.md) | [Previous: Interfaces and Abstract Classes](../07-Interfaces-and-Abstract-Classes/README.md)

## Beginner: Instance Methods vs. `@staticmethod` vs. `@classmethod`

Three kinds of callables can live in a class body, and they differ in what they automatically receive:

```python
class Temperature:
    unit_name = "Celsius"

    def __init__(self, degrees: float):
        self.degrees = degrees

    def describe(self) -> str:                    # instance method
        return f"{self.degrees}°{self.unit_name[0]}"

    @classmethod
    def from_fahrenheit(cls, f: float) -> "Temperature":   # classmethod
        return cls((f - 32) * 5 / 9)

    @staticmethod
    def is_freezing(celsius: float) -> bool:        # staticmethod
        return celsius <= 0
```

- **Instance method** — receives `self` (the specific object); use it when behavior needs that object's data.
- **`@classmethod`** — receives `cls` (the class itself, not an instance); commonly used for **alternative constructors** (`from_fahrenheit` builds a `Temperature` without calling `__init__` directly with Celsius).
- **`@staticmethod`** — receives neither `self` nor `cls`; it's a plain function that's namespaced inside the class purely because it's conceptually related (`is_freezing` doesn't need any instance or class data to do its job).

```python
temp = Temperature.from_fahrenheit(98.6)   # classmethod called on the class
print(Temperature.is_freezing(-5))          # staticmethod called on the class
```

## Intermediate: When to Choose Which

- If the method needs `self.something`, it must be an instance method.
- If the method needs to know *which class* it's operating on (important for subclasses — `cls(...)` in a classmethod respects subclassing, while hardcoding `Temperature(...)` would not), use `@classmethod`. This is exactly why alternative constructors use `cls(...)`: a subclass calling `Subclass.from_fahrenheit(...)` correctly builds a `Subclass`, not a `Temperature`.
- If the method is a pure utility that happens to relate to the class conceptually but touches no instance or class state, `@staticmethod` is appropriate — though it's worth asking whether it should just be a module-level function instead. A `@staticmethod` is really only worth it for organization/namespacing (`Temperature.is_freezing(...)` reads clearly at the call site).

## Advanced: Generics with `TypeVar` and `Generic`

A **generic** class is one that works with any type, but *consistently* — a `Stack[int]` should only ever contain `int`s once you commit to that type, and a type checker should catch a `Stack[int]` mixing in a `str`. Python expresses this with `typing.TypeVar` and `typing.Generic`.

```python
from typing import TypeVar, Generic

T = TypeVar("T")

class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    def is_empty(self) -> bool:
        return len(self._items) == 0
```

```python
int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)
# int_stack.push("oops")   # a type checker (mypy/pyright) flags this - str isn't int
```

At runtime, Python doesn't actually enforce `T` — `int_stack.push("oops")` would run without error, since Python's generics are primarily a **static typing / tooling** feature (this is why the line above is commented out rather than raising at runtime; a checker, not the interpreter, is what catches it). The value of `Generic`/`TypeVar` is documentation plus IDE/type-checker support: callers and reviewers immediately know "this `Stack` is committed to holding `int`s," and tooling verifies it stays that way.

## Real-World Usage

- `@classmethod` alternative constructors are everywhere: `dict.fromkeys(...)`, `datetime.fromtimestamp(...)`, and countless `from_json`/`from_config` methods in application code.
- `@staticmethod` shows up for validation helpers and formatting utilities that logically belong with a class but don't touch its state (`Temperature.is_freezing` above).
- Generic containers are the backbone of type-safe code in typed Python codebases — `list[int]`, `dict[str, User]`, and custom generics like a type-safe `Repository[T]` in a typed data-access layer all rely on this mechanism.

## Summary

- Instance methods need `self` and operate on one object's data; `@classmethod` receives `cls` and is the standard way to write alternative constructors that respect subclassing; `@staticmethod` receives neither and is just a namespaced plain function.
- Prefer `@classmethod` over hardcoding the class name when building alternative constructors, so subclasses build the right type.
- `TypeVar` + `Generic` let a class be written once and used with any type consistently, checked by static type checkers — Python itself does not enforce the type parameter at runtime.
- Generics are primarily a documentation and tooling feature in Python, not a runtime guarantee like they are in Java or C#.

## Key Terms

- **Instance method** — a method receiving `self`, operating on one object's data.
- **`@classmethod`** — a method receiving `cls` (the class), commonly used for alternative constructors.
- **`@staticmethod`** — a method receiving neither `self` nor `cls`; a plain function namespaced inside a class.
- **`TypeVar`** — a placeholder representing "some type, to be determined by the caller," used to parameterize generics.
- **`Generic[T]`** — a base class that makes a class parameterizable by a type variable like `T`.

## Common Mistakes

- Using `@staticmethod` when the method actually needs to reference the class (e.g., to construct an instance) — that should be `@classmethod` so subclassing behaves correctly.
- Hardcoding the class name in an alternative constructor (`return Temperature(...)`) instead of `cls(...)` — breaks correctly for subclasses, since `cls` refers to whatever class the method was actually called on.
- Assuming `Stack[int]` prevents pushing a `str` at runtime — it doesn't; the guarantee is enforced by a type checker (mypy/pyright), not the Python interpreter.
- Overusing `@staticmethod` for functions that have nothing to do with the class at all — often better as a plain module-level function instead of manufactured class ceremony.

## Interview Questions

1. **What's the difference between `@staticmethod` and `@classmethod`?**
   `@classmethod` receives the class itself as `cls`, commonly used for alternative constructors that should respect subclassing. `@staticmethod` receives neither `self` nor `cls` — it's a plain function grouped inside the class namespace for organizational reasons only.

2. **Why do alternative constructors typically use `@classmethod` with `cls(...)` instead of hardcoding the class name?**
   So that calling the alternative constructor on a subclass correctly builds an instance of that subclass, not the base class — `cls` is bound to whatever class the method was actually invoked on.

3. **Does Python enforce generic type parameters at runtime?**
   No. `TypeVar`/`Generic` are primarily for static type checkers (mypy, pyright) and documentation/IDE support — the Python interpreter itself does not stop you from pushing a `str` into a `Stack[int]` at runtime.

4. **When would you choose a plain module-level function over a `@staticmethod`?**
   When the function has no meaningful conceptual tie to the class's data or purpose — if it doesn't reference the class or instance at all and isn't really "about" that class, a module-level function is simpler and avoids implying a relationship that doesn't exist.

5. **Give an example of a generic class and explain what `TypeVar` buys you.**
   A `Stack(Generic[T])` with `push(self, item: T)`/`pop(self) -> T`. `TypeVar` lets one class definition serve `Stack[int]`, `Stack[str]`, etc., while a type checker verifies that a given `Stack[int]` instance is never mixed with non-`int` items — without `TypeVar`, you'd either write a separate class per type or lose that type-safety guarantee entirely.

## Suggested Next Lesson

Return to the [module overview](../README.md) for the Exercises, Diagrams, and Mini-Project that tie every lesson together.
