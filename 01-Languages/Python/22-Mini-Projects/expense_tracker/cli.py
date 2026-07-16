"""
cli.py - command-line entry point for the expense tracker.

Uses argparse (stdlib) rather than a third-party CLI framework, keeping
this mini-project runnable with zero extra dependencies beyond pytest
(which is only needed to run the test suite, not the app itself).

Run with:
    python cli.py add 42.50 groceries "Weekly shop"
    python cli.py list
    python cli.py list --category groceries
    python cli.py total
    python cli.py delete 1
"""

import argparse
import sqlite3
import sys

from db import ExpenseNotFoundError, add_expense, delete_expense, init_db, list_expenses, total_expenses

DB_FILENAME = "expenses.db"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Track personal expenses in a local SQLite database.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    add_parser = subparsers.add_parser("add", help="Add a new expense")
    add_parser.add_argument("amount", type=float, help="Expense amount, e.g. 42.50")
    add_parser.add_argument("category", type=str, help="Category, e.g. groceries")
    add_parser.add_argument("description", type=str, nargs="?", default="", help="Optional description")

    list_parser = subparsers.add_parser("list", help="List expenses")
    list_parser.add_argument("--category", type=str, default=None, help="Filter by category")

    subparsers.add_parser("total", help="Show the total of all expenses")

    delete_parser = subparsers.add_parser("delete", help="Delete an expense by id")
    delete_parser.add_argument("id", type=int, help="Expense id to delete")

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    # One connection per invocation is fine for a small CLI tool run
    # repeatedly from a shell - a long-running server would instead keep
    # a connection pool, which would be overkill here.
    conn = sqlite3.connect(DB_FILENAME)
    init_db(conn)

    try:
        if args.command == "add":
            new_id = add_expense(conn, args.amount, args.category, args.description)
            print(f"Added expense #{new_id}: ${args.amount:.2f} [{args.category}] {args.description}")

        elif args.command == "list":
            expenses = list_expenses(conn, category=args.category)
            if not expenses:
                print("No expenses found.")
            for expense in expenses:
                print(expense)

        elif args.command == "total":
            print(f"Total spent: ${total_expenses(conn):.2f}")

        elif args.command == "delete":
            delete_expense(conn, args.id)
            print(f"Deleted expense #{args.id}")

    except ValueError as e:
        print(f"Invalid input: {e}", file=sys.stderr)
        return 1
    except ExpenseNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    finally:
        conn.close()

    return 0


if __name__ == "__main__":
    sys.exit(main())
