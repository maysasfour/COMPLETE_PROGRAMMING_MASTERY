# Exercise 01 — Build a Validating Parser

[Back to lesson](../README.md)

## Task

You're writing a small function that parses a age value coming from untrusted user input (a string) and validates it before use.

Write a function `parse_age(raw: str) -> int` that:

1. Converts `raw` to an `int`. If the conversion fails (the string isn't a valid integer), catch the specific built-in exception this raises and **re-raise it as** a custom exception `InvalidAgeError` using `raise ... from ...` so the original conversion error is preserved as the cause.
2. If the converted integer is negative, raise `InvalidAgeError` directly (no chaining needed here, since there's no underlying exception — the value itself is simply out of range).
3. If the converted integer is greater than 150, raise `InvalidAgeError` directly, for the same reason as above.
4. Otherwise, return the valid integer age.

Then write a small driver that calls `parse_age` with each of these inputs, catching `InvalidAgeError` around each call and printing either the successful result or a friendly error message: `"25"`, `"-5"`, `"200"`, `"twenty"`, `"0"`.

## Requirements

- `InvalidAgeError` must be a custom exception class (subclassing `Exception`).
- The conversion-failure path must use exception chaining (`raise InvalidAgeError(...) from original_error`) — verify this by printing `error.__cause__` for that specific case.
- Do not use a bare `except:` anywhere.
- Every code path must be exercised by your driver code (valid age, negative, too large, non-numeric, boundary case of `0`).

## Reflection Questions

1. Why does the negative-age and too-large-age case *not* need `from` chaining, while the non-numeric case does?
2. What would change in the traceback / `__cause__` if you wrote `raise InvalidAgeError(...)` (no `from`) inside the `except ValueError:` block instead of chaining it explicitly?

## Deliverable

A runnable Python file solving the task above, plus written answers to the two reflection questions. Do not peek at `Solutions/solution-01.md` until you've attempted this yourself.
