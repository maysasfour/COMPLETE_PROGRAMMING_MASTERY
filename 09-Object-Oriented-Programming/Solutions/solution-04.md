# Solution 04 — Polymorphic Payment Methods

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-04-polymorphic-payments.md) | [Code](solution-04.py)

## Approach

`PaymentMethod` is an `abc.ABC` with a single abstract method, `pay(self, amount) -> str`. `CreditCard`, `PayPal`, and `GiftCard` each implement it differently: `CreditCard`/`PayPal` always succeed and return a description string, while `GiftCard.pay` validates `amount <= self.balance` first, raising `ValueError` and leaving `balance` untouched if the check fails, or deducting and returning a confirmation if it passes.

`Cart.checkout(payment_method)` sums `self.items` and calls `payment_method.pay(total)` — nothing in this method inspects what concrete type `payment_method` is. This is deliberate: the whole point of the exercise is that `checkout` works identically for any of the three payment types (or any future one) purely because they all honor the same `pay(amount) -> str` contract.

`CreditCard.__eq__` compares by `number` rather than by object identity, and `CreditCard.__hash__` hashes that same `number`. Both are required together: defining only `__eq__` would make Python remove the default identity-based `__hash__` inherited from `object` (since a hash consistent with the new equality is no longer guaranteed automatically), leaving `CreditCard` unhashable and unusable in a `set` or as a `dict` key until `__hash__` is supplied explicitly, consistent with the same field `__eq__` compares.

## Why This Design

An alternative to abstract `PaymentMethod` would be pure duck typing with no shared base class at all (any object with a `pay()` method works). The ABC is used here anyway because it documents the contract explicitly and gives a single place (`abc.abstractmethod`) that fails loudly and early if a new payment type forgets to implement `pay`, rather than failing later with a confusing `AttributeError` at call time.

## Verified Output

```
Paid $17.50 with credit card ending in 1111
Paid $17.50 via PayPal (user@example.com)
Rejected: $17.50 exceeds the $10.00 balance
True
1
```

Matches the exercise's expected behavior for all five printed lines, including the caught `ValueError` and the `set` collapsing two equal `CreditCard`s down to one element.

## Reflection Answers

1. Polymorphism (specifically Python's duck typing) makes the `isinstance` check unnecessary — `Cart.checkout` only ever calls `payment_method.pay(total)`, and Python resolves that method call dynamically against whatever object was actually passed in, regardless of its declared type. If an object were passed that had a matching `pay(amount)` method but did **not** inherit from `PaymentMethod` at all, `checkout` would work exactly the same way — Python doesn't consult the type hierarchy at the call site, only whether the object responds to `.pay(amount)`. This is precisely why `total_area`-style functions across this module never need `isinstance` branching.

2. Defining `__eq__` overrides the inherited default from `object`, which compares by identity and is always consistent with the default `__hash__` (also identity-based). Once `CreditCard.__eq__` says "two cards with the same number are equal" while the *inherited* `__hash__` still says "hash by identity," you'd get two objects that compare equal but hash differently — which breaks the fundamental invariant sets and dicts rely on (`a == b` must imply `hash(a) == hash(b)`). Python actually protects against this exact bug automatically: defining `__eq__` without `__hash__` makes the class unhashable outright (`TypeError: unhashable type`) rather than silently allowing the broken combination — so `__hash__` must be defined explicitly, using the same field(s) `__eq__` compares.
