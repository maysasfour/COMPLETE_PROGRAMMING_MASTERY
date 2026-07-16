"""
test_db.py - pytest suite for db.py, run against an in-memory SQLite
database so tests never touch the real expenses.db file on disk.

Run with (from the expense_tracker/ directory):
    pytest tests/ -v
"""

import sqlite3
import sys
from pathlib import Path

import pytest

# db.py lives one directory up from tests/ - add it to sys.path so this
# test file can `import db` without expense_tracker needing to be an
# installed package.
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from db import ExpenseNotFoundError, add_expense, delete_expense, init_db, list_expenses, total_expenses


@pytest.fixture
def conn():
    """A fresh in-memory database per test - each test starts with an
    empty expenses table and nothing persists between tests."""
    connection = sqlite3.connect(":memory:")
    init_db(connection)
    yield connection
    connection.close()


def test_init_db_creates_table(conn):
    # If the table didn't exist, this query would raise sqlite3.OperationalError.
    result = conn.execute("SELECT COUNT(*) FROM expenses").fetchone()
    assert result[0] == 0


def test_add_expense_returns_id(conn):
    new_id = add_expense(conn, 42.50, "groceries", "Weekly shop")
    assert new_id == 1


def test_list_expenses_returns_all(conn):
    add_expense(conn, 42.50, "groceries", "Weekly shop")
    add_expense(conn, 15.00, "transport", "Bus pass")

    expenses = list_expenses(conn)

    assert len(expenses) == 2
    assert expenses[0].category == "groceries"
    assert expenses[1].category == "transport"


def test_list_expenses_filters_by_category(conn):
    add_expense(conn, 42.50, "groceries", "Weekly shop")
    add_expense(conn, 15.00, "transport", "Bus pass")

    groceries_only = list_expenses(conn, category="groceries")

    assert len(groceries_only) == 1
    assert groceries_only[0].description == "Weekly shop"


def test_total_expenses_sums_amounts(conn):
    add_expense(conn, 42.50, "groceries")
    add_expense(conn, 15.00, "transport")

    assert total_expenses(conn) == 57.50


def test_total_expenses_zero_when_empty(conn):
    # SUM() over zero rows is NULL in SQL - this test guards against that
    # leaking through as None instead of the 0.0 callers expect.
    assert total_expenses(conn) == 0.0


def test_delete_expense_removes_row(conn):
    new_id = add_expense(conn, 42.50, "groceries")
    delete_expense(conn, new_id)
    assert list_expenses(conn) == []


def test_delete_nonexistent_expense_raises(conn):
    with pytest.raises(ExpenseNotFoundError):
        delete_expense(conn, 999)
