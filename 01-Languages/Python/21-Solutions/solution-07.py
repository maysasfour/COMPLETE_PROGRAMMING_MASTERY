"""
Solution 07 - Mini Inventory System with SQLite
See: ../20-Exercises/README.md#exercise-07--mini-inventory-system-with-sqlite-advanced

Run with:
    python solution-07.py

Expected output:
    Items after adding three:
      {'id': 1, 'name': 'Widget', 'quantity': 10}
      {'id': 2, 'name': 'Gadget', 'quantity': 5}
      {'id': 3, 'name': 'Gizmo', 'quantity': 0}
    Updated Gadget quantity to 20
    Items after update:
      {'id': 1, 'name': 'Widget', 'quantity': 10}
      {'id': 2, 'name': 'Gadget', 'quantity': 20}
      {'id': 3, 'name': 'Gizmo', 'quantity': 0}
    Expected error caught: No item named 'Sprocket' exists
"""

import sqlite3


class ItemNotFoundError(Exception):
    pass


def init_db(conn: sqlite3.Connection) -> None:
    conn.execute(
        """
        CREATE TABLE items (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 0
        )
        """
    )
    conn.commit()


def add_item(conn: sqlite3.Connection, name: str, quantity: int) -> None:
    # Using "?" placeholders (parameterized queries) instead of an f-string
    # means the driver treats name/quantity strictly as DATA, never as SQL
    # syntax - this is what prevents SQL injection, not just convenience.
    conn.execute(
        "INSERT INTO items (name, quantity) VALUES (?, ?)", (name, quantity)
    )
    conn.commit()


def update_quantity(conn: sqlite3.Connection, name: str, new_quantity: int) -> None:
    cursor = conn.execute(
        "UPDATE items SET quantity = ? WHERE name = ?", (new_quantity, name)
    )
    conn.commit()
    # cursor.rowcount tells us how many rows the UPDATE actually touched -
    # zero means the WHERE clause matched nothing, i.e. the name doesn't exist.
    if cursor.rowcount == 0:
        raise ItemNotFoundError(f"No item named '{name}' exists")


def list_items(conn: sqlite3.Connection) -> list[dict]:
    cursor = conn.execute("SELECT id, name, quantity FROM items ORDER BY id")
    # Column names come from cursor.description so this stays correct even
    # if the SELECT's column list changes later.
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


if __name__ == "__main__":
    connection = sqlite3.connect(":memory:")
    init_db(connection)

    add_item(connection, "Widget", 10)
    add_item(connection, "Gadget", 5)
    add_item(connection, "Gizmo", 0)

    print("Items after adding three:")
    for item in list_items(connection):
        print(f"  {item}")

    update_quantity(connection, "Gadget", 20)
    print("Updated Gadget quantity to 20")

    print("Items after update:")
    for item in list_items(connection):
        print(f"  {item}")

    try:
        update_quantity(connection, "Sprocket", 1)
    except ItemNotFoundError as e:
        print(f"Expected error caught: {e}")

    connection.close()
