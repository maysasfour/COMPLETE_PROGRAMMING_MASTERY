# Exercise 04 — Polymorphic Payment Methods

[Back to Exercises](README.md) | Covers: [Lesson 05 — Polymorphism](../05-Polymorphism/README.md)

**Difficulty: Intermediate**

## Task

Model a checkout system with polymorphic payment processing:

1. An abstract `PaymentMethod` (using `abc.ABC`) with an abstract method `pay(self, amount: float) -> str`.
2. Concrete `CreditCard(number)`, `PayPal(email)`, and `GiftCard(balance)` implementations. `GiftCard.pay` should raise a `ValueError` if `amount` exceeds its remaining balance, and otherwise deduct the amount from `balance`.
3. A `Cart` class holding a list of `(item_name, price)` tuples and a `checkout(self, payment_method: PaymentMethod)` method that sums the prices and calls `payment_method.pay(total)`, printing the result.
4. Implement `__eq__` and `__hash__` on `CreditCard` so two `CreditCard` objects with the same `number` are considered equal and hashable.

## Expected Behavior

```python
cart = Cart([("Book", 15.0), ("Pen", 2.5)])
cart.checkout(CreditCard("4111111111111111"))   # Paid $17.50 with credit card ending in 1111
cart.checkout(PayPal("user@example.com"))        # Paid $17.50 via PayPal (user@example.com)

gift_card = GiftCard(10.0)
cart.checkout(gift_card)   # should raise ValueError - $17.50 exceeds the $10.00 balance
```

```python
c1 = CreditCard("4111111111111111")
c2 = CreditCard("4111111111111111")
print(c1 == c2)                # True
print(len({c1, c2}))            # 1 - both hash/compare equal, so the set collapses them
```

## Reflection Questions

1. `Cart.checkout` never checks `isinstance(payment_method, CreditCard)` anywhere — what OOP concept makes that unnecessary, and what would happen if you passed an object that wasn't a `PaymentMethod` at all but happened to have a matching `pay()` method?
2. Why does defining `__eq__` on `CreditCard` require also defining `__hash__` if you want `CreditCard` instances to work correctly in a `set`?

## Deliverable

A runnable `.py` file producing the behavior shown above (including the raised `ValueError` handled via `try`/`except`), plus written answers to both reflection questions.
