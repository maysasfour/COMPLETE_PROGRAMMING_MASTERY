"""
Lesson 02 - Encapsulation
Demonstrates: public/protected/private naming conventions, name mangling
(and why it isn't real privacy), and @property for validated + computed
attributes.

Run with:
    python example.py

Expected output:
    --- Public / protected / private ---
    owner (public): Alice
    _audit_log (protected, touchable): []
    Name-mangled access still works: 1234

    --- @property validates on assignment ---
    Initial balance: 100
    After acc.balance = 50: 50
    Rejected as expected: balance cannot be negative
    Balance unchanged after rejection: 50

    --- Read-only computed property ---
    Rectangle 3x4 area: 12
    Rejected as expected: property 'area' of 'Rectangle' object has no setter
"""


class Account:
    def __init__(self, owner: str):
        self.owner = owner          # public: part of the intended interface
        self._audit_log = []        # protected: internal bookkeeping, "look but don't touch"
        self.__pin = "1234"         # private: name-mangled, discourages external access


print("--- Public / protected / private ---")
account = Account("Alice")
print(f"owner (public): {account.owner}")
print(f"_audit_log (protected, touchable): {account._audit_log}")
# Nothing actually stops this access - it just requires knowing the mangled
# name, which proves privacy here is a convention, not an enforced boundary.
print(f"Name-mangled access still works: {account._Account__pin}")


class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self._balance = 0
        # Routing the INITIAL value through the property setter too, so
        # construction can't bypass the same validation later calls get.
        self.balance = balance

    @property
    def balance(self) -> float:
        return self._balance

    @balance.setter
    def balance(self, value: float):
        # This is the ONE place balance can change, so it's the one place
        # the "never negative" invariant needs to be enforced.
        if value < 0:
            raise ValueError("balance cannot be negative")
        self._balance = value


print("\n--- @property validates on assignment ---")
acc = BankAccount("Alice", 100)
print(f"Initial balance: {acc.balance}")
acc.balance = 50   # looks like plain attribute assignment, but runs the setter
print(f"After acc.balance = 50: {acc.balance}")

try:
    acc.balance = -10   # setter rejects this before _balance is ever touched
except ValueError as error:
    print(f"Rejected as expected: {error}")
print(f"Balance unchanged after rejection: {acc.balance}")


class Rectangle:
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    @property
    def area(self) -> float:
        # No setter defined below - area is DERIVED from width/height,
        # so it should never be assignable directly, only recomputed.
        return self.width * self.height


print("\n--- Read-only computed property ---")
rect = Rectangle(3, 4)
print(f"Rectangle 3x4 area: {rect.area}")
try:
    rect.area = 100   # no setter exists, so this must fail
except AttributeError as error:
    print(f"Rejected as expected: {error}")
