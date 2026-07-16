"""
Lesson 18 - Testing
Demonstrates: using the calculator.py module directly (this file is NOT the
test suite - see test_calculator.py for that), and shows the same behavior
that the pytest tests verify, so you can see it work before reading the
tests that check it automatically.

Run with:
    python example.py

To run the actual automated test suite (test_calculator.py), instead run:
    pytest -v
or:
    python -m pytest -v

Expected output of `python example.py`:
    --- calculator.add ---
    add(10, 5) = 15
    add(-3, -4) = -7

    --- calculator.subtract ---
    subtract(10, 5) = 5

    --- calculator.divide ---
    divide(10, 5) = 2.0
    Caught expected error dividing by zero: Cannot divide by zero

Expected output of `pytest -v` (run from this directory):
    ============================= test session starts =============================
    platform win32 -- Python 3.14.0, pytest-9.1.1, pluggy-1.6.0
    collected 5 items

    test_calculator.py::test_add PASSED                                      [ 20%]
    test_calculator.py::test_subtract PASSED                                 [ 40%]
    test_calculator.py::test_divide PASSED                                   [ 60%]
    test_calculator.py::test_divide_by_zero_raises PASSED                    [ 80%]
    test_calculator.py::test_add_with_negative_numbers PASSED                [100%]

    ============================== 5 passed in 0.03s ==============================
"""

from calculator import add, subtract, divide

print("--- calculator.add ---")
print(f"add(10, 5) = {add(10, 5)}")
print(f"add(-3, -4) = {add(-3, -4)}")

print("\n--- calculator.subtract ---")
print(f"subtract(10, 5) = {subtract(10, 5)}")

print("\n--- calculator.divide ---")
print(f"divide(10, 5) = {divide(10, 5)}")
# This mirrors what test_divide_by_zero_raises checks automatically with
# pytest.raises - here we catch it manually just to show the same behavior
# in a plain script, without the pytest machinery.
try:
    divide(10, 0)
except ZeroDivisionError as error:
    print(f"Caught expected error dividing by zero: {error}")
