"""
pytest test suite for calculator.py.

Run with:
    pytest -v
or:
    python -m pytest -v
"""

import pytest

from calculator import add, subtract, divide


# A fixture provides reusable setup (and, if it used yield, teardown) that
# pytest injects into any test function that names it as a parameter. Here
# it just returns two numbers, but the same mechanism is how real test
# suites share things like a database connection or a temp directory.
@pytest.fixture
def sample_numbers():
    return 10, 5


def test_add(sample_numbers):
    a, b = sample_numbers
    # Plain `assert` is all pytest needs - unlike unittest, there's no
    # separate assertEqual/assertTrue API. pytest rewrites the assert
    # statement at import time so failures show the actual values involved.
    assert add(a, b) == 15


def test_subtract(sample_numbers):
    a, b = sample_numbers
    assert subtract(a, b) == 5


def test_divide(sample_numbers):
    a, b = sample_numbers
    assert divide(a, b) == 2


def test_divide_by_zero_raises():
    # pytest.raises is a context manager that asserts the enclosed code
    # raises the given exception type - the test FAILS if the exception
    # is never raised, and also fails if a different exception type is raised.
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)


def test_add_with_negative_numbers():
    # A plain assert with no fixture - not every test needs one.
    assert add(-3, -4) == -7
