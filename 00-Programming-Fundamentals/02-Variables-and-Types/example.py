"""
Lesson 02 - Variables and Types
Demonstrates: value vs reference semantics on assignment, dynamic typing,
strong typing (no silent cross-type coercion), and explicit casting.

Run with:
    python example.py

Expected output:
    --- Value type: int is copied on assignment ---
    a = 25, b = 25
    After b = 26: a = 25, b = 26  (unchanged - independent values)

    --- Reference type: list is shared on assignment ---
    original = [1, 2, 3], alias = [1, 2, 3]
    After alias.append(4): original = [1, 2, 3, 4]  (changed via alias!)
    Explicit copy stays independent: original = [1, 2, 3, 4], safe_copy = [1, 2, 3, 4, 99]

    --- Dynamic typing: same name, different types over time ---
    value is now: 42 (type <class 'int'>)
    value is now: hello (type <class 'str'>)

    --- Strong typing: Python refuses silent int+str ---
    Blocked as expected: can only concatenate str (not "int") to str

    --- Explicit casting ---
    '25' cast to int -> 25
    '25.5' cannot go straight to int, so cast to float first -> 25.5, then int -> 25
"""

print("--- Value type: int is copied on assignment ---")
# Ints are immutable, so assignment behaves like an independent copy:
# there is no way for a second name to "see" a change to the first.
a = 25
b = a
print(f"a = {a}, b = {b}")
b = 26
print(f"After b = 26: a = {a}, b = {b}  (unchanged - independent values)")

print("\n--- Reference type: list is shared on assignment ---")
# Lists are mutable reference types: `alias = original` binds a SECOND
# name to the SAME list object, so mutating through alias is visible
# through original too - this is the aliasing behavior beginners trip on.
original = [1, 2, 3]
alias = original
print(f"original = {original}, alias = {alias}")
alias.append(4)
print(f"After alias.append(4): original = {original}  (changed via alias!)")

# To avoid aliasing, make an EXPLICIT independent copy.
safe_copy = original.copy()
safe_copy.append(99)
print(f"Explicit copy stays independent: original = {original}, safe_copy = {safe_copy}")

print("\n--- Dynamic typing: same name, different types over time ---")
# Python only checks that an operation is valid for a value's type at the
# moment the operation runs - the NAME `value` itself carries no fixed type.
value = 42
print(f"value is now: {value} (type {type(value)})")
value = "hello"
print(f"value is now: {value} (type {type(value)})")

print("\n--- Strong typing: Python refuses silent int+str ---")
# Strong typing means Python will NOT silently convert "3" to 3 or 3 to "3"
# to make this work, unlike a weakly typed language (e.g. JavaScript).
try:
    broken = "3" + 3
except TypeError as error:
    print(f"Blocked as expected: {error}")

print("\n--- Explicit casting ---")
# int() parses whole-number strings directly...
age_text = "25"
age_number = int(age_text)
print(f"'25' cast to int -> {age_number}")

# ...but raises ValueError on a decimal string, so a value with a
# fractional part needs an intermediate float() step before int().
decimal_text = "25.5"
as_float = float(decimal_text)
as_int = int(as_float)  # deliberately discards the fractional part
print(f"'25.5' cannot go straight to int, so cast to float first -> {as_float}, then int -> {as_int}")
