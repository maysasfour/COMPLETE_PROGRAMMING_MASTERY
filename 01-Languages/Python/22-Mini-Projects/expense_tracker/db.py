"""
db.py - all sqlite3 access for the expense tracker.

Kept separate from cli.py so the persistence logic can be tested directly
(see tests/test_db.py) against an in-memory database, without needing to
invoke the command-line interface at all.
"""

import sqlite3

from models import Expense


class ExpenseNotFoundError(Exception):
    """Raised when an operation targets an expense id that doesn't exist."""


def init_db(conn: sqlite3.Connection) -> None:
    """Create the expenses table if it doesn't already exist.

    IF NOT EXISTS makes this safe to call every time the CLI starts up,
    rather than requiring a separate one-time "setup" step the user could
    forget to run.
    """
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            description TEXT NOT NULL DEFAULT ''
        )
        """
    )
    conn.commit()


def add_expense(conn: sqlite3.Connection, amount: float, category: str, description: str = "") -> int:
    """Insert a new expense and return its generated id.

    Validation happens here (not just in the CLI layer) so any other
    caller of this function - tests, a future web API - gets the same
    guarantees without re-implementing them.
    """
    if amount <= 0:
        raise ValueError("amount must be positive")
    if not category.strip():
        raise ValueError("category must not be empty")

    cursor = conn.execute(
        "INSERT INTO expenses (amount, category, description) VALUES (?, ?, ?)",
        (amount, category, description),
    )
    conn.commit()
    # lastrowid gives us the AUTOINCREMENT id without a second round-trip query.
    return cursor.lastrowid


def list_expenses(conn: sqlite3.Connection, category: str | None = None) -> list[Expense]:
    """Return all expenses, optionally filtered to a single category.

    Building the query conditionally (rather than always filtering in
    Python after fetching everything) lets SQLite do the filtering work,
    which matters once the table is larger than trivially small.
    """
    if category is not None:
        rows = conn.execute(
            "SELECT id, amount, category, description FROM expenses WHERE category = ? ORDER BY id",
            (category,),
        ).fetchall()
    else:
        rows = conn.execute(
            "SELECT id, amount, category, description FROM expenses ORDER BY id"
        ).fetchall()

    return [Expense(id=row[0], amount=row[1], category=row[2], description=row[3]) for row in rows]


def total_expenses(conn: sqlite3.Connection) -> float:
    """Return the sum of all expense amounts, or 0.0 if there are none.

    SUM() in SQL returns NULL (not 0) over zero rows, so we coalesce that
    to 0.0 in Python rather than surprising callers with a None total.
    """
    row = conn.execute("SELECT SUM(amount) FROM expenses").fetchone()
    return row[0] if row[0] is not None else 0.0


def delete_expense(conn: sqlite3.Connection, expense_id: int) -> None:
    """Delete an expense by id, raising ExpenseNotFoundError if it doesn't exist.

    Checking cursor.rowcount after the DELETE (rather than a SELECT first)
    avoids a redundant query - one statement tells us both whether the
    delete happened and how many rows it affected.
    """
    cursor = conn.execute("DELETE FROM expenses WHERE id = ?", (expense_id,))
    conn.commit()
    if cursor.rowcount == 0:
        raise ExpenseNotFoundError(f"No expense with id {expense_id}")
