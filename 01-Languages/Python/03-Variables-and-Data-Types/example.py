"""
Lesson 03 - Variables and Data Types
Demonstrates: built-in types, type()/isinstance(), None vs falsy values,
dynamic typing, unenforced type hints, and truthiness.

Run with:
    python example.py

Expected output:
    --- Built-in types ---
    age = 25 (int)
    price = 19.99 (float)
    name = Ada (str)
    is_admin = False (bool)
    result = None (NoneType)

    --- isinstance respects inheritance, type() == does not ---
    isinstance(True, int) -> True (bool is a subclass of int)
    isinstance(dog, Animal) -> True
    type(dog) == Animal -> False (this is why isinstance is preferred)

    --- None vs falsy-but-not-None ---
    None == 0: False
    None == '': False
    None == False: False
    bool(None): False
    Correct None check uses 'is None': True

    --- Dynamic typing: same name, different types ---
    value = 42 (<class 'int'>)
    value = now text (<class 'str'>)
    value = [1, 2, 3] (<class 'list'>)

    --- Type hints are not enforced at runtime ---
    greet(123) still ran and returned: Hello, 123

    --- Truthiness ---
    bool(0) = False
    bool('') = False
    bool([]) = False
    bool('0') = True (non-empty string, even though it looks like zero)
    bool([0]) = True (non-empty list, even though its only element is falsy)
"""

print("--- Built-in types ---")
age = 25
price = 19.99
name = "Ada"
is_admin = False
result = None
for label, val in [("age", age), ("price", price), ("name", name),
                    ("is_admin", is_admin), ("result", result)]:
    print(f"{label} = {val} ({type(val).__name__})")

print("\n--- isinstance respects inheritance, type() == does not ---")
# bool is implemented as a SUBCLASS of int, so isinstance correctly reports
# True here - this is intentional Python design, not an edge-case bug.
print(f"isinstance(True, int) -> {isinstance(True, int)} (bool is a subclass of int)")

class Animal:
    pass

class Dog(Animal):
    pass

dog = Dog()
# isinstance() walks the class hierarchy, so a Dog correctly counts as an Animal.
print(f"isinstance(dog, Animal) -> {isinstance(dog, Animal)}")
# type() == only matches the EXACT class, so this incorrectly says "no" -
# this is exactly why isinstance() is the recommended check in real code.
print(f"type(dog) == Animal -> {type(dog) == Animal} (this is why isinstance is preferred)")

print("\n--- None vs falsy-but-not-None ---")
# None is its own distinct type/value - it is not automatically equal to
# any of these other "empty-ish" values, even though it IS falsy like them.
print(f"None == 0: {None == 0}")
print(f"None == '': {None == ''}")
print(f"None == False: {None == False}")
print(f"bool(None): {bool(None)}")
maybe_value = None
print(f"Correct None check uses 'is None': {maybe_value is None}")

print("\n--- Dynamic typing: same name, different types ---")
value = 42
print(f"value = {value} ({type(value)})")
value = "now text"
print(f"value = {value} ({type(value)})")
value = [1, 2, 3]
print(f"value = {value} ({type(value)})")

print("\n--- Type hints are not enforced at runtime ---")
def greet(name: str) -> str:
    return f"Hello, {name}"

# Passing an int where the hint says str does NOT raise an error - hints
# are advisory for humans/tools, not a runtime contract the interpreter checks.
outcome = greet(123)
print(f"greet(123) still ran and returned: {outcome}")

print("\n--- Truthiness ---")
print(f"bool(0) = {bool(0)}")
print(f"bool('') = {bool('')}")
print(f"bool([]) = {bool([])}")
# A non-empty string is truthy regardless of its CONTENT - "0" is not the
# number zero, it's a one-character string, and non-empty strings are truthy.
print(f"bool('0') = {bool('0')} (non-empty string, even though it looks like zero)")
# Same idea for a list: truthiness of a container is about emptiness,
# not about the truthiness of what's inside it.
print(f"bool([0]) = {bool([0])} (non-empty list, even though its only element is falsy)")
