"""
Lesson 03 - Control Flow
Demonstrates: if/elif/else, for vs while, expressions vs statements
(ternary, comprehension, walrus operator), and guard clauses replacing
nested conditionals.

Run with:
    python example.py

Expected output:
    --- Conditions ---
    Age 8 -> child
    Age 16 -> teenager
    Age 30 -> adult

    --- for vs while ---
    for loop items: a b c
    while loop attempts until success: 3

    --- Expressions vs statements ---
    Ternary expression result: adult
    Comprehension result: [0, 1, 4, 9, 16]
    Walrus operator captured length: 5

    --- Guard clauses vs nested conditionals ---
    Nested version   - valid order:   Shipped
    Nested version   - empty order:   None
    Guard-clause version - valid order:   Shipped
    Guard-clause version - empty order:   None
"""

print("--- Conditions ---")
# elif stops checking at the FIRST matching branch, unlike stacking
# independent `if` statements which would evaluate every condition.
for age in (8, 16, 30):
    if age < 13:
        category = "child"
    elif age < 20:
        category = "teenager"
    else:
        category = "adult"
    print(f"Age {age} -> {category}")

print("\n--- for vs while ---")
# for: the sequence and its length are already known - we're processing
# "each item," not repeating until some condition becomes true.
letters = []
for item in ["a", "b", "c"]:
    letters.append(item)
print("for loop items:", " ".join(letters))

# while: we don't know in advance how many attempts a real retry loop
# would need - the loop condition, not a fixed count, decides when to stop.
attempts = 0
success = False
while not success and attempts < 3:
    attempts += 1
    success = attempts == 3  # simulate "succeeds on the 3rd try"
print("while loop attempts until success:", attempts)

print("\n--- Expressions vs statements ---")
# Ternary: an EXPRESSION, so its result can be assigned directly -
# no separate if/else statement block needed to produce a value.
age = 30
label = "adult" if age >= 18 else "minor"
print("Ternary expression result:", label)

# Comprehension: also an expression - it produces a list value in one
# line rather than requiring a `for` statement plus manual .append() calls.
squares = [n * n for n in range(5)]
print("Comprehension result:", squares)

# Walrus operator: lets an assignment happen INSIDE the condition
# expression itself, so the computed value doesn't need a separate
# line before the `if` just to be checked once.
text = "hello"
if (length := len(text)) > 3:
    print("Walrus operator captured length:", length)

print("\n--- Guard clauses vs nested conditionals ---")


class Order:
    def __init__(self, items, total):
        self.items = items
        self.total = total


def ship(order):
    return "Shipped"


# Nested version: each new rule adds another indent level, and the
# "real" work (ship(order)) is buried three levels deep.
def process_order_nested(order):
    if order is not None:
        if order.items:
            if order.total > 0:
                return ship(order)
            else:
                return None
        else:
            return None
    else:
        return None


# Guard-clause version: each invalid case exits immediately at the same
# indent level, so the final line is always the "happy path," unindented.
def process_order_guarded(order):
    if order is None:
        return None
    if not order.items:
        return None
    if order.total <= 0:
        return None
    return ship(order)


valid_order = Order(items=["book"], total=15.0)
empty_order = Order(items=[], total=0)

print("Nested version   - valid order:  ", process_order_nested(valid_order))
print("Nested version   - empty order:  ", process_order_nested(empty_order))
print("Guard-clause version - valid order:  ", process_order_guarded(valid_order))
print("Guard-clause version - empty order:  ", process_order_guarded(empty_order))
