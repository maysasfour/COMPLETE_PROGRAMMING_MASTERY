"""
Lesson 09 - Error Handling
Demonstrates: try/except/else/finally (all four clauses and when each
runs), specific exception types vs. bare except (and why bare except is
dangerous), raising exceptions, custom exception classes, re-raising with
a bare `raise`, and exception chaining with `raise X from Y`.

Run with:
    python example.py

Expected output:
    --- try/except/else/finally, all four clauses ---
    try: about to divide
    except ZeroDivisionError: can't divide by zero
    finally: this always runs

    try: about to divide
    else: no exception, result = 5.0
    finally: this always runs

    --- Specific exception vs bare except ---
    caught specific ValueError: invalid literal for int() with base 10: 'abc'
    (bare except would ALSO catch KeyboardInterrupt/SystemExit - avoided here on purpose)

    --- Custom exception class ---
    withdraw(100, 30) -> 70
    withdraw(100, 500) blocked: cannot withdraw 500, balance is only 100
    balance on exception object: 100
    amount on exception object: 500

    --- Re-raising with bare raise ---
    logged: something went wrong during risky_call
    re-raised and caught at outer level: original failure

    --- Exception chaining with raise X from Y ---
    caught ConfigError: config file is malformed
    __cause__ (the original exception): invalid literal for int() with base 10: 'not-a-number'
"""


print("--- try/except/else/finally, all four clauses ---")


def divide(a, b):
    print("try: about to divide")
    try:
        result = a / b
    except ZeroDivisionError:
        # Runs only because ZeroDivisionError specifically matched.
        print("except ZeroDivisionError: can't divide by zero")
    else:
        # Runs only when try raised NOTHING - keeps success-path code
        # separate from the risky division itself.
        print(f"else: no exception, result = {result}")
    finally:
        # Runs unconditionally - this is the guaranteed-cleanup clause.
        print("finally: this always runs")


divide(10, 0)
print()
divide(10, 2)


print("\n--- Specific exception vs bare except ---")
try:
    int("abc")
except ValueError as error:
    # Catching the SPECIFIC type we expect, not a bare `except:`, so
    # anything unrelated (like KeyboardInterrupt) still propagates normally.
    print(f"caught specific ValueError: {error}")
print("(bare except would ALSO catch KeyboardInterrupt/SystemExit - avoided here on purpose)")


print("\n--- Custom exception class ---")


class InsufficientFundsError(Exception):
    """Raised when a withdrawal would overdraw the account."""

    def __init__(self, balance, amount):
        # super().__init__ sets the human-readable message; the extra
        # attributes let callers act on structured data, not just text.
        super().__init__(f"cannot withdraw {amount}, balance is only {balance}")
        self.balance = balance
        self.amount = amount


def withdraw(balance, amount):
    if amount > balance:
        raise InsufficientFundsError(balance, amount)
    return balance - amount


print(f"withdraw(100, 30) -> {withdraw(100, 30)}")
try:
    withdraw(100, 500)
except InsufficientFundsError as error:
    print(f"withdraw(100, 500) blocked: {error}")
    # These attributes are only available because we built a real exception
    # class instead of raising a generic Exception with just a string.
    print(f"balance on exception object: {error.balance}")
    print(f"amount on exception object: {error.amount}")


print("\n--- Re-raising with bare raise ---")


def risky_call():
    raise ValueError("original failure")


def do_something():
    try:
        risky_call()
    except ValueError:
        print("logged: something went wrong during risky_call")
        # Bare `raise` re-raises the SAME exception with its original
        # traceback intact - we're logging, not swallowing or replacing it.
        raise


try:
    do_something()
except ValueError as error:
    print(f"re-raised and caught at outer level: {error}")


print("\n--- Exception chaining with raise X from Y ---")


class ConfigError(Exception):
    """Raised when application configuration cannot be parsed."""


def parse_config(raw_text):
    return int(raw_text)  # deliberately fails for non-numeric input


try:
    try:
        parse_config("not-a-number")
    except ValueError as parse_error:
        # We want callers to see a meaningful ConfigError, but `from`
        # preserves the low-level ValueError as the recorded root cause.
        raise ConfigError("config file is malformed") from parse_error
except ConfigError as config_error:
    print(f"caught ConfigError: {config_error}")
    print(f"__cause__ (the original exception): {config_error.__cause__}")
