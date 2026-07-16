"""
Solution 05 - Safe Division CLI with Custom Exceptions
See: ../20-Exercises/README.md#exercise-05--safe-division-cli-with-custom-exceptions-intermediate

Run with:
    python solution-05.py

Expected output:
    10 / 2 = 5.0
    Custom error caught: Cannot divide 5 by zero
    Custom error caught: Cannot divide '10' and 2 - unsupported operand type(s) for /: 'str' and 'int'
    8 / 4 = 2.0
"""


class DivisionByZeroCustomError(Exception):
    pass


def safe_divide(a, b):
    if b == 0:
        # We raise our OWN exception type instead of letting the built-in
        # ZeroDivisionError propagate, so callers of this function only
        # need to catch project-specific exception types, not built-ins
        # scattered across the codebase.
        raise DivisionByZeroCustomError(f"Cannot divide {a} by zero")
    try:
        return a / b
    except TypeError as err:
        # `raise ... from err` chains the original TypeError as the cause,
        # so the traceback still shows exactly what native error triggered
        # this, while giving callers a clearer, more specific message.
        raise TypeError(f"Cannot divide {a!r} and {b!r} - {err}") from err


if __name__ == "__main__":
    pairs = [(10, 2), (5, 0), ("10", 2), (8, 4)]
    for a, b in pairs:
        try:
            result = safe_divide(a, b)
            print(f"{a} / {b} = {result}")
        except DivisionByZeroCustomError as e:
            print(f"Custom error caught: {e}")
        except TypeError as e:
            print(f"Custom error caught: {e}")
