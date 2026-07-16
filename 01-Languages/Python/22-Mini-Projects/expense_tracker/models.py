"""
models.py - the Expense value object.

A plain class (rather than a dict) so every place that handles an expense
gets attribute access, type hints, and a readable repr for free instead of
passing around loosely-shaped dictionaries.
"""

from dataclasses import dataclass


@dataclass
class Expense:
    """A single tracked expense. Immutable-by-convention: we don't mutate
    an Expense after creation - updates go through db.py as new rows."""

    id: int
    amount: float
    category: str
    description: str

    def __str__(self) -> str:
        # Fixed-width formatting keeps the CLI's `list` output readable
        # as a simple aligned table without needing a table library.
        return f"#{self.id}  ${self.amount:.2f}   {self.category}   {self.description}"
