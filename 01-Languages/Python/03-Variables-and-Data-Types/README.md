# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Beginner: The Built-in Types

Python has a small set of built-in primitive types you'll use constantly:

```python
age = 25            # int - whole numbers, arbitrary precision (no overflow)
price = 19.99        # float - IEEE-754 double-precision decimal numbers
name = "Ada"          # str - text
is_admin = False       # bool - True or False (a subclass of int)
result = None            # NoneType - represents "no value" / "nothing here"
```

Unlike some languages, Python's `int` has **no fixed size limit** — it grows automatically to fit however large the number is (limited only by available memory).

## Beginner: `type()` and `isinstance()`

```python
type(25)              # <class 'int'>
type("Ada")             # <class 'str'>

isinstance(25, int)      # True - prefer this for type checks
isinstance(True, int)      # True! bool is a subclass of int
```

Prefer `isinstance()` over `type(x) == SomeType` in real code — `isinstance()` correctly accounts for inheritance (a `Dog` instance passed to `isinstance(d, Animal)` returns `True` if `Dog` subclasses `Animal`; `type(d) == Animal` would incorrectly return `False`).

## Beginner: `None` Is Not Zero, Empty String, or False

`None` is Python's explicit "no value" — it is its own type (`NoneType`) and is not automatically equal to `0`, `""`, or `False`, even though all of those are "falsy" in a boolean context.

```python
None == 0        # False
None == ""         # False
None == False        # False
bool(None)              # False - None is falsy, but that's different from being equal to False
x is None              # the correct, idiomatic way to check for None
```

Always compare to `None` with `is`/`is not`, not `==` — this is a strong convention (and `is None` is faster, since it can't accidentally call a custom `__eq__`).

## Intermediate: Dynamic Typing

A variable name in Python has no fixed type — it's just a label that can be rebound to a value of any type at any time:

```python
value = 42          # value refers to an int
value = "now text"    # perfectly legal - value now refers to a str
value = [1, 2, 3]       # and now a list
```

This differs fundamentally from statically typed languages, where a variable's type is fixed once declared. Python decides whether an operation is valid **when that line actually runs**, not before.

## Intermediate: Type Hints (Optional, Not Enforced)

Python supports optional type hints for readability and tooling (editors, `mypy`), but the interpreter does **not** enforce them at runtime by itself:

```python
def greet(name: str) -> str:
    return f"Hello, {name}"

greet(123)   # runs without error at the interpreter level - hints are not runtime checks!
```

Type hints are a documentation + tooling layer, not a type system the interpreter enforces (Lesson 13 covers this in depth).

## Advanced: Truthiness

Every Python object has an implicit boolean value when evaluated in a boolean context (`if x:`, `while x:`, `bool(x)`):

```python
bool(0)          # False
bool(0.0)          # False
bool("")             # False - empty string
bool([])              # False - empty list
bool({})               # False - empty dict
bool(None)               # False

bool(1)                # True
bool("0")                 # True! non-empty string, even though it "looks like" zero
bool([0])                   # True! non-empty list (contains one element, even if that element is falsy)
```

This is a frequent source of bugs: `"0"` is truthy (it's a non-empty string), which trips people who expect string content to matter rather than just string *emptiness*.

## Real-World Usage

- Dynamic typing plus truthiness checks are everywhere in real code: `if user_input:` is idiomatic for "was anything provided," but only works correctly if you understand what counts as falsy.
- `isinstance()` checks are common in functions that accept "flexible" input (e.g., accept either a single item or a list of items) to branch behavior correctly.
- Type hints have become close to standard practice in production Python codebases specifically because dynamic typing alone doesn't scale to large teams without some static-analysis safety net.

## Summary

- Built-in types: `int`, `float`, `str`, `bool`, `NoneType`, plus the collection types covered in Lesson 07.
- Use `isinstance()` over `type() ==` for type checks — it respects inheritance.
- `None` represents "no value"; always compare with `is`/`is not`, never `==`.
- Python is dynamically typed: a name can be rebound to any type at any time; types are checked at runtime.
- Type hints document intent and enable tooling but are not enforced by the interpreter itself.
- Every object has a truthiness value; know what counts as falsy (`0`, `0.0`, `""`, `[]`, `{}`, `set()`, `None`, `False`).

## Key Terms

- **int / float / str / bool** — Python's built-in numeric, text, and boolean primitive types.
- **NoneType** — the type of `None`, representing the absence of a value.
- **`type()`** — returns an object's exact class.
- **`isinstance()`** — checks whether an object is an instance of a class or its subclasses.
- **Dynamic typing** — types are determined and checked at runtime, not compile time.
- **Type hint** — optional annotation documenting an expected type, not enforced at runtime.
- **Truthiness** — an object's implicit boolean value in a boolean context.

## Common Mistakes

- Comparing to `None` with `==` instead of `is`.
- Assuming type hints prevent passing the wrong type — they don't, without a separate checker like `mypy`.
- Using `type(x) == SomeClass` instead of `isinstance(x, SomeClass)`, breaking correct behavior for subclasses.
- Assuming `"0"` or `"False"` (as strings) are falsy — only the empty string `""` is falsy; any non-empty string is truthy.
- Forgetting `bool` is a subtype of `int` — `True + True == 2` is valid and can silently participate in arithmetic.

## Best Practices

- Add type hints to function signatures once code moves beyond a quick throwaway script.
- Prefer `is None` / `is not None` for `None` checks.
- Use `isinstance()` for type checks that need to work across inheritance.
- Rely on truthiness for genuinely boolean-ish checks (`if items:` for "non-empty"), but be explicit (`if x is not None:`) when zero/empty-but-present values are meaningfully different from "absent."

## Interview Questions

1. **What's the difference between `type(x) == T` and `isinstance(x, T)`?**
   `isinstance()` returns `True` for subclasses of `T` too, matching how inheritance is meant to work; `type(x) == T` only matches the exact class, incorrectly rejecting valid subclass instances.

2. **Why should you use `is None` instead of `== None`?**
   `is` checks identity against the single `None` singleton and can't be overridden by a custom `__eq__`, so it's both more correct in intent and marginally faster. `== None` works in practice for `None` itself but is not the idiomatic/safe pattern, especially if the left-hand object defines unusual equality behavior.

3. **Is Python statically or dynamically typed? What does that mean for type hints?**
   Dynamically typed — types are checked as the program runs, not before. Type hints are optional annotations for readability and external tooling (editors, `mypy`); the core interpreter does not enforce them, so passing a hinted-wrong type still runs unless you separately run a type checker.

4. **What values are falsy in Python?**
   `0`, `0.0`, `""`, `[]`, `{}`, `set()`, `None`, and `False` itself. Everything else, including non-empty strings/collections and any nonzero number, is truthy.

5. **Why does `True + True` equal `2`?**
   Because `bool` is a subclass of `int` in Python — `True` and `False` behave as `1` and `0` in arithmetic contexts, a quirk inherited from Python's type hierarchy rather than a special case.

## Suggested Next Lesson

[04 — Operators](../04-Operators/README.md)
