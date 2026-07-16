# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Beginner: try / except / else / finally

Python signals problems by **raising exceptions** — objects that propagate up the call stack until something handles them, or the program crashes. `try` lets you attempt risky code and respond to failure instead of crashing.

```python
try:
    result = 10 / int(input("divisor: "))
except ValueError:
    print("that wasn't a number")
except ZeroDivisionError:
    print("can't divide by zero")
else:
    print(f"result: {result}")
finally:
    print("this always runs")
```

All four clauses have distinct, precise timing:

- **`try`** — the code that might fail.
- **`except`** — runs only if a matching exception was raised in `try`.
- **`else`** — runs only if `try` completed with **no** exception at all. It exists so you can separate "code that might fail" from "code that should only run on success," instead of accidentally catching exceptions raised by the success-path code too.
- **`finally`** — always runs, whether an exception happened or not, whether it was caught or not, even if the block returns or re-raises. Used for guaranteed cleanup (closing a file, releasing a lock).

## Beginner: Catching Specific Exceptions vs. Bare `except`

```python
try:
    risky_call()
except ValueError:
    handle_bad_value()
```

vs. the dangerous version:

```python
try:
    risky_call()
except:
    pass   # bare except - catches EVERYTHING, including things you don't want to catch
```

A bare `except:` (or `except BaseException:`) catches **every** exception, including `KeyboardInterrupt` (the user pressing Ctrl+C) and `SystemExit` (raised by `sys.exit()`). Swallowing those means your program can't be interrupted or shut down cleanly — Ctrl+C appears to do nothing, and `sys.exit()` calls silently fail to exit. Catching plain `Exception` (not `BaseException`) is safer, since `KeyboardInterrupt` and `SystemExit` inherit directly from `BaseException`, not `Exception` — but the real best practice is to catch the **specific** exception type(s) you know how to handle, and let everything else propagate.

## Intermediate: Raising Exceptions and Custom Exception Classes

Use `raise` to signal that your own code has hit an error condition, and subclass `Exception` to create a domain-specific exception type that callers can catch precisely.

```python
class InsufficientFundsError(Exception):
    """Raised when a withdrawal would overdraw the account."""
    def __init__(self, balance, amount):
        super().__init__(f"cannot withdraw {amount}, balance is only {balance}")
        self.balance = balance
        self.amount = amount

def withdraw(balance, amount):
    if amount > balance:
        raise InsufficientFundsError(balance, amount)
    return balance - amount
```

A custom exception class lets calling code do `except InsufficientFundsError:` instead of parsing a generic error message string, and lets you attach structured data (`.balance`, `.amount`) to the exception object itself for logging or recovery logic.

## Advanced: Re-raising and Exception Chaining

Inside an `except` block, a bare `raise` (no argument) re-raises the **current** exception with its original traceback intact — useful when you want to log or react to an error but still let it propagate.

```python
try:
    do_something()
except ValueError:
    log_error("something went wrong")
    raise   # re-raises the SAME ValueError, traceback preserved
```

**Exception chaining** (`raise NewException(...) from original_exception`) is different: it raises a *new* exception while explicitly recording what caused it, producing a "the above exception was the direct cause of the following exception" chain in the traceback. This is the right tool when a low-level exception needs to be translated into a higher-level, more meaningful one without losing the original diagnostic detail.

```python
try:
    config = parse_config(raw_text)
except ValueError as parse_error:
    raise ConfigError("config file is malformed") from parse_error
```

Without `from`, Python still shows the original exception (as "during handling of the above exception, another exception occurred") if one was active, but `from` makes the causal relationship explicit and intentional rather than incidental.

## Real-World Usage

- Web frameworks catch specific exceptions (e.g., `DoesNotExist`, `ValidationError`) at the request-handling boundary and translate them into proper HTTP error responses, rather than letting a raw traceback leak to the client.
- `finally` (or a `with` block, which uses the same guarantee under the hood) is how database connections, file handles, and network sockets get reliably closed even when something goes wrong mid-operation.
- Custom exception hierarchies (e.g., `AppError` → `ValidationError`, `NotFoundError`, `PermissionError`) let calling code catch broadly (`except AppError`) or narrowly (`except NotFoundError`) depending on context.
- Exception chaining (`raise ... from ...`) is standard practice in library code that wraps lower-level errors (e.g., a database library wrapping a raw connection error in a friendlier `RepositoryError`) while preserving the original stack trace for debugging.

## Summary

- `try` attempts risky code; `except` handles specific matched exceptions; `else` runs only on success; `finally` always runs, for cleanup.
- Catch specific exception types, never use a bare `except:` — it also swallows `KeyboardInterrupt` and `SystemExit`, breaking Ctrl+C and clean shutdowns.
- `raise` signals an error; subclassing `Exception` creates precise, catchable, data-carrying custom error types.
- A bare `raise` inside `except` re-raises the current exception with its original traceback.
- `raise NewError(...) from original` explicitly chains a new exception to the one that caused it, keeping both visible in the traceback.

## Key Terms

- **Exception** — an object representing an error condition, raised and propagated up the call stack until handled.
- **Traceback** — the record of the call stack at the point an exception was raised, showing where the error originated.
- **Bare except** — an `except:` clause with no exception type, which catches everything including `BaseException` subclasses like `KeyboardInterrupt`.
- **Custom exception class** — a user-defined class subclassing `Exception` (or a more specific built-in) to represent a domain-specific error.
- **Exception chaining** — linking a newly raised exception to the exception that caused it via `raise ... from ...`.

## Common Mistakes

- Using a bare `except:` (or `except BaseException:`) to "catch everything," accidentally swallowing `KeyboardInterrupt`/`SystemExit` and hiding real bugs.
- Putting code that can itself fail inside `try` when it belongs in `else`, causing it to be accidentally caught by an `except` meant for something else.
- Forgetting that `finally` runs even after a `return` inside `try`/`except`, which can lead to surprising control flow if `finally` also returns.
- Raising a generic `Exception("something went wrong")` instead of a specific, catchable exception type or one of Python's built-in specific exceptions.
- Re-raising with `raise SomeError(str(original))` instead of `raise SomeError(...) from original`, which discards the causal link and makes debugging harder.

## Best Practices

- Catch the narrowest exception type that makes sense; let unexpected exceptions propagate rather than masking bugs.
- Reserve custom exception classes for conditions calling code genuinely needs to distinguish and handle differently.
- Use `finally` (or better, a `with` block/context manager) for any cleanup that must happen no matter what.
- When translating a low-level exception into a higher-level one, always chain it with `from` to preserve the original cause for debugging.
- Keep `try` blocks as small as possible — wrap only the specific call that can fail, not large swaths of unrelated code.

## Interview Questions

1. **What is the execution order and purpose of `try`, `except`, `else`, and `finally`?**
   `try` runs first; if it raises a matching exception, the corresponding `except` runs. If `try` completes with no exception, `else` runs (letting you separate success-path code from the risky code so it isn't accidentally caught by `except`). `finally` runs last in every case — exception or not, caught or not — making it the place for guaranteed cleanup.

2. **Why is a bare `except:` considered bad practice?**
   It catches every exception, including `KeyboardInterrupt` and `SystemExit`, which inherit from `BaseException` rather than `Exception`. That means a user's Ctrl+C or a deliberate `sys.exit()` call can get silently swallowed, making the program impossible to interrupt or shut down cleanly, and it also hides genuine bugs that should have crashed loudly during development.

3. **What does a bare `raise` (no arguments) do inside an `except` block, and how does it differ from `raise SomeError(...) from original`?**
   A bare `raise` re-raises the exception currently being handled, preserving its original traceback exactly. `raise SomeError(...) from original` raises a *different*, new exception while explicitly recording `original` as its cause, producing a chained traceback — used when you want to translate an error into a more meaningful type rather than simply propagate the same one.

4. **When would you define a custom exception class instead of raising a built-in one?**
   When calling code needs to catch and handle your specific error condition distinctly from other errors (e.g., `InsufficientFundsError` vs. a generic `ValueError`), or when you want to attach structured data to the exception (like `.balance` and `.amount`) for logging, retries, or recovery logic that a plain string message can't carry.

5. **Why does `finally` run even if `try` or `except` contains a `return` statement?**
   `finally` is guaranteed by the language to execute before control actually leaves the `try` statement, regardless of how it's leaving (normal completion, exception, `return`, `break`, or `continue`). This guarantee is exactly what makes it reliable for cleanup — but it also means a `return` inside `finally` itself would silently override a `return` from `try`/`except`, which is why you should avoid returning from `finally`.

## Suggested Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
