"""Solution to Exercise 04 -- Polymorphic Payment Methods."""

from abc import ABC, abstractmethod


class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount: float) -> str: ...


class CreditCard(PaymentMethod):
    def __init__(self, number: str):
        self.number = number

    def pay(self, amount: float) -> str:
        return f"Paid ${amount:.2f} with credit card ending in {self.number[-4:]}"

    def __eq__(self, other):
        # Two cards are the "same card" if the number matches, regardless of object identity.
        if not isinstance(other, CreditCard):
            return NotImplemented
        return self.number == other.number

    def __hash__(self):
        # Required alongside __eq__: Python's set/dict machinery hashes an object first and
        # only falls back to __eq__ within the matching bucket. Without a matching __hash__,
        # two "equal" cards could land in different buckets and never be recognized as
        # duplicates in a set/dict -- and Python disables the default hash entirely once
        # __eq__ is defined, so omitting __hash__ makes CreditCard unhashable (TypeError).
        return hash(self.number)


class PayPal(PaymentMethod):
    def __init__(self, email: str):
        self.email = email

    def pay(self, amount: float) -> str:
        return f"Paid ${amount:.2f} via PayPal ({self.email})"


class GiftCard(PaymentMethod):
    def __init__(self, balance: float):
        self.balance = balance

    def pay(self, amount: float) -> str:
        if amount > self.balance:
            raise ValueError(
                f"${amount:.2f} exceeds the ${self.balance:.2f} balance"
            )
        self.balance -= amount
        return f"Paid ${amount:.2f} with gift card (${self.balance:.2f} remaining)"


class Cart:
    def __init__(self, items: list[tuple[str, float]]):
        self.items = items

    def checkout(self, payment_method: PaymentMethod) -> None:
        # No isinstance check on payment_method's concrete type: any object exposing a
        # compatible pay() method works here, whether it inherits from PaymentMethod or not.
        total = sum(price for _, price in self.items)
        print(payment_method.pay(total))


cart = Cart([("Book", 15.0), ("Pen", 2.5)])
cart.checkout(CreditCard("4111111111111111"))
cart.checkout(PayPal("user@example.com"))

gift_card = GiftCard(10.0)
try:
    cart.checkout(gift_card)
except ValueError as e:
    print(f"Rejected: {e}")

c1 = CreditCard("4111111111111111")
c2 = CreditCard("4111111111111111")
print(c1 == c2)          # True
print(len({c1, c2}))     # 1


# Reflection 1: Polymorphism (specifically duck typing / structural compatibility) makes the
# isinstance check unnecessary -- Cart.checkout only ever calls payment_method.pay(total), and
# Python resolves that call dynamically at runtime against whatever object was passed. If an
# object wasn't a PaymentMethod subclass at all but happened to define a matching pay(amount)
# method, checkout() would work identically -- Python doesn't care about the type's ancestry,
# only whether the method exists and behaves as expected.
#
# Reflection 2: Defining __eq__ makes Python remove the default identity-based __hash__ (since
# equal objects must hash identically for sets/dicts to work correctly, and the default hash
# is based on id() which two "equal-by-number" cards won't share). Without a custom __hash__,
# CreditCard instances become unhashable, raising TypeError the moment you try to put one in a
# set. Defining __hash__ to match __eq__'s notion of equality (hash the same field being
# compared) keeps the type usable in sets/dicts.
