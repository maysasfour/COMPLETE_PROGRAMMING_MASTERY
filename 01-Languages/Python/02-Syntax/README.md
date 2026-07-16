# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Beginner: Indentation Is Syntax

Most languages use braces `{}` to mark a block of code. Python uses **indentation** — the whitespace itself defines where a block starts and ends. There is no equivalent of a closing brace.

```python
if True:
    print("inside the if block")   # 4 spaces of indentation
    print("still inside")
print("outside the if block")       # back to column 0 - no longer inside
```

Mixing tabs and spaces, or using inconsistent indentation widths within the same block, raises an `IndentationError` or `TabError`. The convention (PEP 8) is **4 spaces per level, never tabs** — configure your editor to insert spaces when you press Tab.

## Beginner: Comments

```python
# A single-line comment starts with a hash and runs to the end of the line.

"""
A triple-quoted string used at the top of a module/function/class becomes
a docstring (Lesson 06) if it's the first statement - otherwise it's just
a multi-line string that happens to be discarded if unused as an expression
statement. It's commonly (mis)used as a "block comment" but that's not
really what it is under the hood.
"""
```

Good comments explain **why**, not **what** — the code already shows what it does.

## Beginner: Statements vs. Expressions

- A **statement** performs an action and doesn't itself have a value: `x = 5`, `if condition:`, `import os`, `return value`.
- An **expression** evaluates to a value: `5 + 3`, `x > 10`, `"a" + "b"`, a function call like `len(items)`.

```python
x = 5 + 3        # "5 + 3" is an expression (evaluates to 8); the whole line is an assignment statement
if x > 10:        # "x > 10" is an expression (evaluates to True/False); "if ...:" is a statement
    pass
```

Because assignment is a statement in Python (not an expression, unlike C or JavaScript), you cannot write `if (x = 5):` — that's a syntax error. Python 3.8+ introduced the **walrus operator** `:=` specifically to allow assignment *within* an expression when you deliberately want that:

```python
# Without walrus: call len() twice
if len(data) > 0:
    print(len(data))

# With walrus: assign and use the value in one expression
if (n := len(data)) > 0:
    print(n)
```

## Intermediate: Line Structure

A **logical line** normally ends at a newline. Two ways to span multiple physical lines:

```python
# Implicit continuation inside brackets - the preferred, common way
total = (1 + 2 + 3
         + 4 + 5)

# Explicit continuation with a trailing backslash - works but discouraged;
# fragile (a trailing space after \ breaks it) and less readable
total = 1 + 2 + 3 \
        + 4 + 5
```

Multiple statements can technically share one physical line separated by `;`, but this is discouraged by PEP 8 outside of very short, obvious cases.

## Advanced: The `pass`, `...`, and Blocks That Need *Something*

Every colon-introduced block (`if`, `for`, `def`, `class`, etc.) requires at least one statement inside it — you cannot leave it syntactically empty.

```python
def not_implemented_yet():
    pass          # a no-op statement, used as an explicit placeholder

class Marker:
    ...           # Ellipsis, also commonly used as a placeholder (e.g. in type stubs)
```

`pass` and `...` are both valid ways to satisfy "a block needs a statement" while doing nothing — `pass` is idiomatic for "this function/branch intentionally does nothing (yet)"; `...` shows up a lot in type stub files (`.pyi`) and abstract method bodies.

## Real-World Usage

- Indentation-as-syntax is the single biggest adjustment for developers coming from brace languages — misconfigured editors (tabs vs. spaces) are a common source of "works on my machine" bugs across a team.
- The walrus operator shows up constantly in real code for tightening `while (chunk := file.read(1024)):` style read loops.
- Linters (`flake8`, `ruff`) and formatters (`black`) exist specifically because Python's syntax has few structural guardrails beyond indentation — teams enforce consistency with tooling instead.

## Summary

- Python uses indentation, not braces, to define blocks — 4 spaces per level is the convention.
- Comments start with `#`; triple-quoted strings are docstrings only when they're the first statement in a module/function/class.
- Statements perform actions and have no value; expressions evaluate to a value.
- The walrus operator `:=` lets you assign inside an expression when needed.
- Every block needs at least one statement; `pass` or `...` satisfy that when there's intentionally nothing to do yet.

## Key Terms

- **Indentation block** — a group of statements defined by a shared indentation level, Python's equivalent of `{}`.
- **Docstring** — a string literal that is the first statement in a module, function, or class, used as documentation.
- **Statement** — an instruction that performs an action; has no value.
- **Expression** — code that evaluates to a value.
- **Walrus operator (`:=`)** — assignment usable inside an expression.
- **`pass`** — a no-op statement used to satisfy a syntactically required but intentionally empty block.

## Common Mistakes

- Mixing tabs and spaces in the same file (invisible in many editors, but Python rejects it).
- Assuming a triple-quoted string anywhere acts as a "comment" — it's a real string literal/expression statement unless it's a docstring position.
- Trying to assign inside a condition with `=` instead of `:=`, which is a syntax error.
- Forgetting the trailing colon `:` on `if`/`for`/`while`/`def`/`class` lines.
- Leaving a trailing space after a `\` line continuation, which silently breaks it.

## Best Practices

- Configure your editor to insert 4 spaces on Tab, and to show whitespace characters.
- Prefer implicit line continuation (parentheses) over backslash continuation.
- Use `pass` for "nothing here yet" in real code; reserve `...` mostly for stubs/abstract bodies.
- Run a formatter (`black`) and linter (`ruff`/`flake8`) in CI so style issues never reach code review discussions.

## Interview Questions

1. **Why does Python use indentation instead of braces?**
   A deliberate design choice for readability — since indentation is significant, the visual structure of the code always matches its actual logical structure; there's no way for indentation to "lie" about the block structure the way it can in brace languages.

2. **What's the difference between a statement and an expression?**
   An expression evaluates to a value and can appear anywhere a value is expected; a statement performs an action and does not itself produce a usable value. `x = 5` is a statement; `5 + 3` is an expression.

3. **Why can't you write `if x = 5:` in Python?**
   Assignment (`=`) is a statement, not an expression, so it cannot appear inside the expression position of an `if`. Python 3.8 added `:=` specifically to cover the legitimate cases where assigning inside an expression is useful.

4. **What does `pass` do, and when would you use it?**
   It's a no-op statement that does nothing, used to satisfy Python's requirement that every block contain at least one statement — typically as a placeholder for a function or branch you haven't implemented yet, or where a language feature (like an empty exception handler) genuinely requires no action.

## Suggested Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
