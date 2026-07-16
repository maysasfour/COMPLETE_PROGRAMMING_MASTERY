# 06 — Error Handling

[Back to module overview](../README.md) | [Previous: Memory Concepts](../05-Memory-Concepts/README.md)

## Beginner: Exceptions

An **exception** is Python's mechanism for signaling that something went wrong *during execution* — a condition the normal flow of the program can't continue past without being addressed. When an exception is raised and nothing handles it, the program terminates with a **traceback**.

```python
def divide(a, b):
    return a / b

divide(10, 0)   # raises ZeroDivisionError, program crashes if unhandled
```

Python has a hierarchy of built-in exception types (`ZeroDivisionError`, `ValueError`, `TypeError`, `KeyError`, `FileNotFoundError`, ...), all inheriting from `Exception`. You can also define custom exceptions by subclassing `Exception`.

## Beginner: try / except

`try` / `except` catches an exception and lets the program handle it instead of crashing.

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    result = None
    print("Cannot divide by zero")
```

Key pieces:
- **`try`** — the block where an exception might occur.
- **`except SomeError:`** — runs only if `SomeError` (or a subclass of it) was raised in the `try` block.
- **`else`** — runs only if the `try` block completed with *no* exception.
- **`finally`** — always runs, whether or not an exception occurred — used for cleanup (closing files, releasing locks).

```python
try:
    file = open("data.txt")
except FileNotFoundError:
    print("File missing")
else:
    print("File opened successfully")
finally:
    print("This always runs")
```

## Intermediate: Catching Specifically, Not Broadly

`except:` with no type (a **bare except**) or `except Exception:` catches *everything*, including bugs you didn't anticipate — this hides real problems instead of handling them. Always catch the most specific exception type you can meaningfully recover from.

```python
# Bad: hides EVERY possible error, including typos and bugs unrelated to parsing
try:
    value = int(user_input)
except:
    value = 0

# Good: catches exactly the failure mode you're prepared to handle
try:
    value = int(user_input)
except ValueError:
    value = 0
```

If `int(user_input)` were replaced with a call that had an unrelated bug (say, a typo causing a `NameError`), the bare `except:` would silently swallow that bug too, making it far harder to find.

## Advanced: Fail-Fast vs. Defensive Programming

These are two different philosophies about *when* to check for and react to invalid conditions:

- **Fail-fast**: validate inputs/assumptions immediately and raise/crash loudly the moment something is wrong, rather than letting bad data travel deeper into the program where the eventual failure is harder to trace back to its cause.
- **Defensive programming**: anticipate misuse and invalid states throughout the code, guarding against them with checks, so the program degrades gracefully instead of crashing.

These aren't opposites so much as different tools for different situations:

```python
# Fail-fast: reject bad input the moment it enters the system
def set_age(age):
    if age < 0:
        raise ValueError(f"Age cannot be negative: {age}")
    return age

# Defensive: assume the caller might misuse this, guard every path
def get_first_item(items):
    if not items:
        return None       # gracefully handle the empty case rather than raising IndexError
    return items[0]
```

A well-designed system is fail-fast at its **boundaries** (reject bad input immediately, with a clear error) and only defensive **internally** where genuine ambiguity exists (e.g., "empty list" being a legitimate, expected state rather than a bug). Being defensive everywhere hides bugs behind silently-returned defaults; being fail-fast everywhere makes normal edge cases (like an empty list) needlessly crash the program.

## Real-World Usage

- Parsing user input, API responses, and file contents is the most common real-world source of exceptions — always expect malformed data at these boundaries.
- `finally` (or a `with` statement, which uses the same underlying protocol) is essential for releasing resources (file handles, network connections, locks) even when something goes wrong mid-operation.
- Custom exception classes let large codebases distinguish error categories (`ValidationError`, `PermissionError`, `NotFoundError`) so calling code can react differently to each without parsing error message strings.

## Summary

- An exception signals something went wrong during execution; unhandled, it crashes the program with a traceback.
- `try`/`except`/`else`/`finally` catches and handles exceptions; `finally` always runs, for cleanup.
- Catch specific exception types, not bare `except:` — broad catches hide unrelated bugs.
- Fail-fast rejects bad input loudly and immediately at boundaries; defensive programming gracefully handles genuinely expected edge cases internally. Good systems use both, deliberately, not one everywhere.

## Key Terms

- **Exception** — an object representing an error condition raised during execution.
- **Traceback** — the report Python prints showing where an unhandled exception occurred and the call chain that led there.
- **`try` / `except`** — the block that might fail, and the handler that responds if it does.
- **`else` (in try/except)** — runs only if no exception occurred.
- **`finally`** — always runs, used for cleanup regardless of success or failure.
- **Bare except** — `except:` with no exception type specified; catches everything, generally discouraged.
- **Fail-fast** — validating and raising errors immediately at the point a problem is detected.
- **Defensive programming** — anticipating and gracefully handling invalid states throughout code.

## Common Mistakes

- Using a bare `except:` (or `except Exception:`) that silently swallows bugs unrelated to the operation you meant to guard.
- Catching an exception and doing nothing with it (`except Exception: pass`) — this hides failures completely instead of handling them.
- Using exceptions for routine control flow where a simple `if` check is clearer and cheaper (e.g., checking `if key in dict` instead of catching `KeyError` for something that isn't actually exceptional).
- Being defensive everywhere, which masks real bugs behind silently-returned default values instead of surfacing them.

## Interview Questions

1. **What's the difference between `except`, `else`, and `finally` in a try block?**
   `except` runs only if a matching exception was raised in `try`. `else` runs only if `try` completed with no exception at all. `finally` always runs, regardless of whether an exception occurred or was handled — typically used for cleanup like closing a file or releasing a lock.

2. **Why is a bare `except:` considered bad practice?**
   It catches every exception, including ones unrelated to the failure you intended to handle — a typo causing a `NameError`, a `KeyboardInterrupt`, or a genuine bug elsewhere in the block all get silently caught and hidden, making debugging far harder. Catching the specific exception type you expect keeps unrelated failures visible.

3. **What's the difference between fail-fast and defensive programming?**
   Fail-fast rejects invalid input or state immediately and loudly (raising an error right at the point of detection) so problems are caught close to their source. Defensive programming anticipates misuse throughout the code and handles it gracefully rather than crashing. They're complementary: fail-fast at system boundaries, defensive for genuinely expected edge cases internally.

4. **When should you use exceptions vs. a simple conditional check?**
   Use exceptions for genuinely exceptional, hard-to-predict-in-advance failures (a file not existing, a network call failing). Use a conditional check for expected, easily-tested-for conditions (checking `if key in dict` before accessing it, rather than wrapping the access in `try/except KeyError`) — it's clearer and usually faster.

5. **What happens to a `finally` block if the `try` block returns a value?**
   `finally` still runs before the function actually returns — it executes even when `try` (or `except`) contains a `return`, `break`, or `continue`. This makes it reliable for cleanup regardless of how the block exits, though a `return` inside `finally` itself will override any return value from `try`/`except` (generally considered a footgun to avoid).

## Suggested Next Lesson

[07 — Modules and Packages](../07-Modules-and-Packages/README.md)
