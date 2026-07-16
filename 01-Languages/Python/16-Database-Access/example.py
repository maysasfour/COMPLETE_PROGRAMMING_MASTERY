"""
Lesson 16 - Database Access
Demonstrates: connecting to SQLite with sqlite3, creating a table, full CRUD
(INSERT/SELECT/UPDATE/DELETE), parameterized queries with `?` placeholders,
using `with` for automatic commit/rollback, and fetchone/fetchall/cursor
iteration.

Run with:
    python example.py

Expected output:
    --- Creating table ---
    Table 'contacts' created.

    --- INSERT ---
    Inserted contact with id 1
    Inserted contact with id 2
    Inserted contact with id 3

    --- SELECT all (iterating the cursor directly) ---
    (1, 'Amina', 'amina@example.com')
    (2, 'Bilal', 'bilal@example.com')
    (3, 'Chen', 'chen@example.com')

    --- SELECT one (fetchone) ---
    Contact 2: (2, 'Bilal', 'bilal@example.com')

    --- SELECT all (fetchall) ---
    [(1, 'Amina', 'amina@example.com'), (2, 'Bilal', 'bilal@example.com'), (3, 'Chen', 'chen@example.com')]

    --- UPDATE ---
    Rows updated: 1
    Bilal's new email: bilal.new@example.com

    --- DELETE ---
    Rows deleted: 1
    Remaining contacts: [(1, 'Amina', 'amina@example.com'), (3, 'Chen', 'chen@example.com')]

    --- Parameterized query prevents SQL injection ---
    Safely searched for name containing: O'Brien -> 0 match(es)

    Connection closed.
"""

import sqlite3

# ":memory:" creates a temporary database that lives only for the duration
# of this process - ideal for a demo/example since it leaves no file behind.
# In real applications you'd pass a filename, e.g. sqlite3.connect("app.db").
connection = sqlite3.connect(":memory:")

# The `with connection:` context manager wraps statements in a transaction:
# it commits automatically when the block exits cleanly, or rolls back if
# an exception is raised. It does NOT close the connection - that's separate.
print("--- Creating table ---")
with connection:
    connection.execute(
        """
        CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL
        )
        """
    )
print("Table 'contacts' created.")

print("\n--- INSERT ---")
# The `?` placeholders let sqlite3 bind values safely, keeping user data out
# of the SQL text itself. Never build SQL with f-strings/concatenation -
# see the "Common Mistakes" section in the README for why that's dangerous.
contacts_to_add = [
    ("Amina", "amina@example.com"),
    ("Bilal", "bilal@example.com"),
    ("Chen", "chen@example.com"),
]
with connection:
    for name, email in contacts_to_add:
        cursor = connection.execute(
            "INSERT INTO contacts (name, email) VALUES (?, ?)", (name, email)
        )
        # lastrowid gives us the auto-generated primary key of the row just inserted.
        print(f"Inserted contact with id {cursor.lastrowid}")

print("\n--- SELECT all (iterating the cursor directly) ---")
# A cursor is itself iterable - looping over it row by row avoids loading
# the entire result set into memory at once, which matters for big tables.
cursor = connection.execute("SELECT * FROM contacts")
for row in cursor:
    print(row)

print("\n--- SELECT one (fetchone) ---")
# fetchone() pulls a single row from the cursor's remaining results, or
# None if there are no more rows - useful when you expect at most one match.
cursor = connection.execute("SELECT * FROM contacts WHERE id = ?", (2,))
row = cursor.fetchone()
print(f"Contact 2: {row}")

print("\n--- SELECT all (fetchall) ---")
# fetchall() collects every remaining row into a list. Fine for small result
# sets; for huge tables prefer iterating the cursor (above) to save memory.
cursor = connection.execute("SELECT * FROM contacts")
all_rows = cursor.fetchall()
print(all_rows)

print("\n--- UPDATE ---")
with connection:
    cursor = connection.execute(
        "UPDATE contacts SET email = ? WHERE name = ?",
        ("bilal.new@example.com", "Bilal"),
    )
    # rowcount tells us how many rows the last statement actually touched -
    # handy for confirming a query matched what you expected (e.g. exactly 1).
    print(f"Rows updated: {cursor.rowcount}")
updated = connection.execute(
    "SELECT email FROM contacts WHERE name = ?", ("Bilal",)
).fetchone()
print(f"Bilal's new email: {updated[0]}")

print("\n--- DELETE ---")
with connection:
    cursor = connection.execute("DELETE FROM contacts WHERE name = ?", ("Bilal",))
    print(f"Rows deleted: {cursor.rowcount}")
remaining = connection.execute("SELECT * FROM contacts").fetchall()
print(f"Remaining contacts: {remaining}")

print("\n--- Parameterized query prevents SQL injection ---")
# Even a value that LOOKS like it could break out of a string (an embedded
# quote) is handled safely because it's bound as data, never parsed as SQL.
# Contrast with the unsafe pattern (DO NOT DO THIS):
#     query = f"SELECT * FROM contacts WHERE name = '{user_input}'"
# If user_input were `' OR '1'='1`, that string concatenation would change
# the query's logic entirely and could leak or destroy data. The `?`
# placeholder form below never lets the value be interpreted as SQL syntax.
malicious_looking_input = "O'Brien"
cursor = connection.execute(
    "SELECT * FROM contacts WHERE name = ?", (malicious_looking_input,)
)
matches = cursor.fetchall()
print(f"Safely searched for name containing: {malicious_looking_input} -> {len(matches)} match(es)")

# Always close the connection when you're done with it to release the
# underlying file handle / resources, even for an in-memory database.
connection.close()
print("\nConnection closed.")
