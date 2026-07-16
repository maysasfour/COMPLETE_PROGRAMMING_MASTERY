"""
A tiny calculator module used as the subject-under-test for this lesson.

Kept deliberately simple - the point of this file is to give pytest
something real to exercise in test_calculator.py, not to teach arithmetic.
"""


def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def divide(a, b):
    # Raising an explicit, specific exception here (rather than letting the
    # ZeroDivisionError happen implicitly) makes the failure mode obvious to
    # both callers and to pytest.raises in the test suite.
    if b == 0:
        raise ZeroDivisionError("Cannot divide by zero")
    return a / b
