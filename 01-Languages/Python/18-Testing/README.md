# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Beginner: Why Automated Tests

Manually running a script and eyeballing its output (like `example.py` in every lesson so far) doesn't scale — it relies on a human remembering to check, and re-checking, every time the code changes. An automated test suite runs the same checks instantly, every time, and fails loudly the moment something breaks.

```python
# calculator.py - the code under test
def add(a, b):
    return a + b
```

```python
# test_calculator.py - the test suite
from calculator import add

def test_add():
    assert add(2, 3) == 5
```

`pytest` (not part of the standard library — `pip install pytest`) discovers any file named `test_*.py` (or `*_test.py`) and, within it, any function named `test_*`, then runs each one and reports pass/fail.

## Beginner: `assert` and Running Tests

```bash
pytest -v          # run all tests in the current directory, verbose output
python -m pytest -v  # equivalent, useful if `pytest` isn't directly on PATH
```

A test function passes if it runs to completion without an exception; it fails if any `assert` statement's condition is false (pytest raises `AssertionError` and reports it) or if any other exception is raised. Unlike the `unittest` standard library module (which needs `self.assertEqual(...)`, `self.assertTrue(...)`, etc.), pytest just uses plain `assert` — and rewrites it at import time so a failure message shows you the actual values involved, not just "assertion failed."

## Intermediate: Fixtures

A **fixture** provides reusable setup (and optional teardown) that pytest automatically injects into any test function that names it as a parameter.

```python
import pytest

@pytest.fixture
def sample_numbers():
    return 10, 5

def test_add(sample_numbers):
    a, b = sample_numbers
    assert a + b == 15
```

Any test function that lists `sample_numbers` as a parameter automatically receives whatever the fixture function returns — pytest matches them by name. This avoids repeating the same setup code (building test data, opening a temp file, connecting to a test database) at the top of every test function; more advanced fixtures use `yield` instead of `return` to run cleanup code after the test finishes.

## Intermediate: Testing for Expected Exceptions

```python
import pytest
from calculator import divide

def test_divide_by_zero_raises():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)
```

`pytest.raises(ExceptionType)` is a context manager asserting the code inside the `with` block raises exactly that exception type (or a subclass). The test **fails** if no exception is raised at all, and also fails if a *different* exception type is raised instead — it's a precise check, not just "something went wrong."

## Advanced: Structuring a Test Suite

Real test suites combine everything above: fixtures for shared setup, plain `assert` for straightforward checks, and `pytest.raises` for verifying error paths — all as small, independent, and clearly-named `test_*` functions:

```python
import pytest
from calculator import add, subtract, divide

@pytest.fixture
def sample_numbers():
    return 10, 5

def test_add(sample_numbers):
    a, b = sample_numbers
    assert add(a, b) == 15

def test_subtract(sample_numbers):
    a, b = sample_numbers
    assert subtract(a, b) == 5

def test_divide(sample_numbers):
    a, b = sample_numbers
    assert divide(a, b) == 2

def test_divide_by_zero_raises():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

def test_add_with_negative_numbers():
    assert add(-3, -4) == -7
```

This is exactly what `calculator.py`/`test_calculator.py` in this lesson's folder implement — run `pytest -v` from this directory to see all five tests pass.

## Real-World Usage

- Continuous Integration (CI) pipelines run the full test suite automatically on every commit/pull request, blocking merges if any test fails.
- Test-Driven Development (TDD) writes the failing test *before* the implementation, using it as an executable specification of correct behavior.
- Fixtures commonly set up (and tear down) things like temporary files, mocked API responses, or in-memory database connections shared across many tests.
- Regression tests — a test added specifically because a real bug once occurred — prevent that exact bug from silently reappearing later.

## Summary

- `pytest` discovers `test_*.py` files and `test_*` functions automatically; a test passes if it runs without raising, fails if any `assert` is false or an unexpected exception occurs.
- Plain `assert` is all pytest needs — it rewrites assertions to show the actual failing values, unlike `unittest`'s separate assertion methods.
- `@pytest.fixture` provides reusable setup, injected into any test function that names the fixture as a parameter.
- `pytest.raises(ExceptionType)` verifies that code raises a specific exception type — failing both if no exception occurs and if the wrong exception type is raised.
- Automated tests replace manually eyeballing script output, running instantly and consistently on every change.

## Key Terms

- **Test discovery** — pytest's automatic detection of `test_*.py` files and `test_*` functions, requiring no manual registration.
- **Fixture** — a reusable setup (and optional teardown) function, injected into tests that request it by parameter name.
- **Assertion** — a statement (`assert condition`) that raises `AssertionError` if `condition` is false; the mechanism pytest uses to detect a failing test.
- **`pytest.raises`** — a context manager asserting that enclosed code raises a specific exception type.
- **Regression test** — a test written specifically to catch the reoccurrence of a previously fixed bug.

## Common Mistakes

- Naming a test file or function without the `test_` prefix (or `_test` suffix for files), causing pytest to silently skip it during discovery.
- Writing one giant test function checking many unrelated things — if the first assertion fails, none of the later ones in that function even run, hiding other potential failures.
- Testing implementation details instead of behavior, making tests break on harmless refactors that don't change actual behavior.
- Forgetting that `pytest.raises` fails the test if the exception *never* happens — an accidentally-fixed bug can silently "pass" a test that no longer exercises the failure path meaningfully unless you check this.
- Not running the test suite locally before pushing, relying entirely on CI to catch failures.

## Best Practices

- Keep each test function focused on one behavior; prefer several small, clearly-named tests over one large one.
- Use fixtures for setup shared across multiple tests instead of duplicating the same setup code in every test function.
- Name tests descriptively (`test_divide_by_zero_raises`, not `test_1`) so a failure report is immediately meaningful without opening the test file.
- Write a test for every bug fix, reproducing the bug first, to prevent the same regression from reappearing later.
- Run the full suite (`pytest -v`) before committing, not just the tests you think are related to your change.

## Interview Questions

1. **How does pytest discover which functions to run as tests?**
   It automatically scans for files matching `test_*.py` or `*_test.py`, and within those files, functions (or methods) whose names start with `test_` — no explicit registration or base class is required, unlike some other testing frameworks.

2. **What's the difference between pytest's plain `assert` and `unittest`'s `self.assertEqual(...)`?**
   Both ultimately check a condition and fail the test if it's false, but pytest rewrites plain `assert` statements at import time so a failure shows the actual values involved (e.g., `assert 4 == 5` reports what each side evaluated to), while `unittest` requires calling specific methods (`assertEqual`, `assertTrue`, `assertRaises`) to get equivalently informative failure messages.

3. **What does a pytest fixture do, and how does a test function receive one?**
   A fixture is a function decorated with `@pytest.fixture` that returns (or yields) reusable setup data or objects. A test function receives it simply by including a parameter with the same name as the fixture function — pytest matches them by name and calls the fixture automatically before running the test.

4. **How would you test that a function raises a specific exception?**
   Wrap the call in `with pytest.raises(ExceptionType):`. The test fails if the code inside the block completes without raising, and also fails if it raises a different exception type than the one specified.

5. **Why is it considered bad practice to put many unrelated assertions into a single test function?**
   Because a test function stops executing at its first failing assertion (or first raised exception) — any assertions after that point never run, so if the first check fails, you have no idea whether the following unrelated checks would have passed or failed. Separate test functions ensure each behavior is checked and reported independently.

## Suggested Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
