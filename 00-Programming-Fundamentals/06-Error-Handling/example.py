"""
Lesson 06 - Error Handling
Demonstrates: try/except/else/finally, why bare except is dangerous
(it hides unrelated bugs), a custom exception class, and fail-fast vs
defensive handling of the same problem.

Run with:
    python example.py

Expected output:
    --- try/except/else/finally ---
    Cannot divide by zero
    This always runs

    result = 5.0
    Division succeeded
    This always runs

    --- Catching specifically vs bare except ---
    Specific catch handled the real problem: invalid literal for int() with base 10: 'abc'
    Bare except swallowed a NameError and returned: "silently swallowed - you'd never know WHAT failed"
    The real, hidden bug was: name 'undefined_variable' is not defined

    --- Custom exception ---
    Caught custom exception: Age cannot be negative: -5

    --- Fail-fast vs defensive for the same situation ---
    Fail-fast correctly rejected invalid age: Age cannot be negative: -5
    Defensive get_first_item on empty list returned: None
    Defensive get_first_item on populated list returned: 1
"""

print("--- try/except/else/finally ---")


def divide(a, b):
    return a / b


try:
    result = divide(10, 0)
except ZeroDivisionError:
    result = None
    print("Cannot divide by zero")
finally:
    print("This always runs")

print()

try:
    result = divide(10, 2)
except ZeroDivisionError:
    result = None
    print("Cannot divide by zero")
else:
    # else runs only because the try block completed WITHOUT raising -
    # keeping success-path logic out of the try block makes it clear
    # this code assumes the division already succeeded.
    print(f"result = {result}")
    print("Division succeeded")
finally:
    print("This always runs")

print("\n--- Catching specifically vs bare except ---")


def parse_specific(text):
    try:
        return int(text)
    except ValueError as error:
        # This ONLY catches the failure mode we expect (bad numeric text).
        print(f"Specific catch handled the real problem: {error}")
        return None


parse_specific("abc")


def parse_with_bare_except(text):
    try:
        # Deliberately reference an undefined name to simulate an
        # UNRELATED bug living in the same try block as the real
        # operation we meant to guard.
        return int(text) + undefined_variable  # noqa: F821 (intentional bug for the demo)
    except:  # noqa: E722 - intentionally bare, to prove the point
        return "silently swallowed - you'd never know WHAT failed"


swallowed_result = parse_with_bare_except("5")
print(f"Bare except swallowed a NameError and returned: {swallowed_result!r}")

# Prove what actually failed by running the same broken line WITHOUT a
# bare except - this is the real bug the previous call hid from us.
try:
    int("5") + undefined_variable  # noqa: F821
except NameError as error:
    print(f"The real, hidden bug was: {error}")

print("\n--- Custom exception ---")


class InvalidAgeError(Exception):
    # A custom exception lets calling code distinguish THIS specific
    # failure from any other ValueError-shaped problem in the system.
    pass


def set_age(age):
    if age < 0:
        raise InvalidAgeError(f"Age cannot be negative: {age}")
    return age


try:
    set_age(-5)
except InvalidAgeError as error:
    print(f"Caught custom exception: {error}")

print("\n--- Fail-fast vs defensive for the same situation ---")


def set_age_fail_fast(age):
    # Fail-fast: reject bad input immediately and loudly at the boundary.
    if age < 0:
        raise InvalidAgeError(f"Age cannot be negative: {age}")
    return age


try:
    set_age_fail_fast(-5)
except InvalidAgeError as error:
    print(f"Fail-fast correctly rejected invalid age: {error}")


def get_first_item(items):
    # Defensive: an empty list is an EXPECTED, valid state here (not a
    # bug), so we handle it gracefully instead of letting IndexError
    # propagate for something the caller didn't do wrong.
    if not items:
        return None
    return items[0]


print("Defensive get_first_item on empty list returned:", get_first_item([]))
print("Defensive get_first_item on populated list returned:", get_first_item([1, 2, 3]))
