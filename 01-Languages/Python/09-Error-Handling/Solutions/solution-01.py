"""
Solution 01 - Build a Validating Parser
Runnable implementation of parse_age() with a custom InvalidAgeError,
exception chaining for the conversion-failure path, and a driver that
exercises every code path from exercise-01.

Run with:
    python solution-01.py

Expected output:
    "25"    -> valid age: 25
    "-5"    -> InvalidAgeError: age cannot be negative, got -5
    "200"   -> InvalidAgeError: age must be 150 or less, got 200
    "twenty" -> InvalidAgeError: 'twenty' is not a valid integer
                __cause__: invalid literal for int() with base 10: 'twenty'
    "0"     -> valid age: 0
"""


class InvalidAgeError(Exception):
    """Raised when a raw age value fails validation or cannot be parsed."""


def parse_age(raw: str) -> int:
    try:
        age = int(raw)
    except ValueError as conversion_error:
        # The underlying ValueError is genuinely the root cause here, so we
        # chain it with `from` - callers debugging this can see exactly
        # what int() rejected, not just that "something" went wrong.
        raise InvalidAgeError(f"{raw!r} is not a valid integer") from conversion_error

    if age < 0:
        # No underlying exception exists for this branch - the int()
        # conversion succeeded fine, the VALUE is simply out of range.
        # Chaining would have nothing meaningful to attach.
        raise InvalidAgeError(f"age cannot be negative, got {age}")

    if age > 150:
        raise InvalidAgeError(f"age must be 150 or less, got {age}")

    return age


if __name__ == "__main__":
    for raw_value in ["25", "-5", "200", "twenty", "0"]:
        try:
            result = parse_age(raw_value)
        except InvalidAgeError as error:
            print(f"{raw_value!r:>8} -> InvalidAgeError: {error}")
            if error.__cause__ is not None:
                print(f"{'':>8}    __cause__: {error.__cause__}")
        else:
            print(f"{raw_value!r:>8} -> valid age: {result}")
