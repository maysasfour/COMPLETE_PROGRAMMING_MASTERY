# 02 — Encapsulation

[Back to module overview](../README.md) | [Previous: Classes and Objects](../01-Classes-and-Objects/README.md)

## Beginner: What Encapsulation Means

**Encapsulation** is bundling data together with the methods that operate on it, and restricting direct outside access to that data so it can only be changed in valid ways. Instead of exposing raw fields that any code can set to anything, an object controls its own state through its methods.

```python
class BankAccount:
    def __init__(self, owner: str, balance: float):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount: float):
        self.balance += amount
```

Without encapsulation, nothing stops `account.balance = -500` from anywhere in the codebase. With it, `balance` can be protected so the only path to changing it is through methods that enforce the rules (no negative deposits, no overdrafts past a limit, etc.).

## Beginner: Python's Naming Conventions

Python has no `private` keyword. Instead, it uses **naming conventions** that programmers and tools agree to respect:

| Prefix | Convention | Enforcement |
|---|---|---|
| `name` | Public — part of the intended external interface | None needed |
| `_name` | Protected — internal detail, "you can touch this but you're on your own" | None — pure convention |
| `__name` | Private — strongly discourage external/subclass access | Name mangling (see below) |

```python
class Account:
    def __init__(self):
        self.owner = "Alice"       # public
        self._audit_log = []       # protected: internal bookkeeping
        self.__pin = "1234"        # private: name-mangled
```

## Intermediate: Why Python Has No *True* Private

`__pin` isn't actually hidden — Python performs **name mangling**: internally, `self.__pin` becomes `self._Account__pin`. This is intentional; it prevents accidental collisions with attributes of the same name in subclasses, but it is trivially bypassable by anyone who knows the mangled name.

```python
account = Account()
print(account._Account__pin)   # '1234' - "private" is a speed bump, not a lock
```

This reflects Python's broader philosophy ("we're all consenting adults here") — the language trusts you not to reach into internals rather than mechanically forbidding it. Contrast with Java/C++, where `private` is enforced by the compiler.

## Advanced: `@property` for Validated and Computed Attributes

Public raw fields are fine until you need validation, computed values, or a migration path. `@property` lets an object expose something that *looks* like a plain attribute from the outside (`account.balance`, no parentheses) while actually running code underneath.

```python
class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self._balance = 0
        self.balance = balance   # goes through the setter below, validating the initial value too

    @property
    def balance(self) -> float:
        return self._balance

    @balance.setter
    def balance(self, value: float):
        if value < 0:
            raise ValueError("balance cannot be negative")
        self._balance = value
```

```python
acc = BankAccount("Alice", 100)
acc.balance = 50        # runs the setter - valid, allowed
acc.balance = -10       # raises ValueError - the setter rejected it
print(acc.balance)      # runs the getter - reads _balance
```

This is the key advantage of starting with a plain public attribute and only introducing `@property` when validation becomes necessary: **callers never need to change their code**. `account.balance = 50` looks identical before and after you add the property — you're changing the implementation, not the interface.

A **read-only** computed property (no setter) is also common:

```python
class Rectangle:
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    @property
    def area(self) -> float:
        return self.width * self.height   # no setter - area is derived, not stored
```

## Real-World Usage

- Django/SQLAlchemy models use properties heavily to validate or derive fields (e.g., a `full_name` property computed from `first_name` + `last_name`).
- API client libraries use `_` prefixes to mark internal helper methods that aren't part of the public contract, so they're free to change without breaking users.
- Financial and inventory systems rely on encapsulated setters to enforce invariants (no negative stock, no balance below an overdraft limit) at the single point where the value can change.

## Summary

- Encapsulation bundles data with the logic that keeps it valid, and limits direct outside mutation.
- Python signals visibility by convention: `name` public, `_name` protected, `__name` private (name-mangled, not truly hidden).
- `@property`/`@x.setter` let you add validation or computation to an attribute without changing the calling code's syntax.
- Prefer starting with plain public attributes; add `@property` only once you need validation, computation, or a controlled migration.

## Key Terms

- **Encapsulation** — bundling data with the methods that operate on it and controlling access to that data.
- **Protected (`_x`)** — conventionally internal; accessible but signals "implementation detail."
- **Private (`__x`)** — name-mangled to `_ClassName__x`, strongly discourages access but doesn't prevent it.
- **Name mangling** — Python's mechanism of rewriting `__x` to `_ClassName__x` to avoid subclass collisions.
- **`@property`** — decorator that makes a method callable using attribute syntax (no parentheses).
- **Getter/Setter** — methods that read/write a property's underlying value, optionally validating it.

## Common Mistakes

- Believing `__x` provides real security — it's discoverable and bypassable, not a security boundary.
- Adding `@property` to every single attribute preemptively ("just in case") — adds ceremony with no payoff until validation is actually needed.
- Forgetting that a property with only a getter is read-only — assigning to it raises `AttributeError`, which is often exactly the intended behavior for computed values.
- Validating in `__init__` but forgetting to route the initial value through the property setter too, so the very first assignment skips validation.

## Interview Questions

1. **Does Python have true private members? What does `__x` actually do?**
   No. `__x` triggers name mangling to `_ClassName__x`, which discourages accidental access and subclass collisions but does not prevent deliberate access — Python has no compiler-enforced privacy.

2. **What's the practical difference between `_x` and `__x`?**
   `_x` is pure convention with no language behavior attached. `__x` additionally triggers name mangling, which mainly protects against a subclass accidentally overriding a base class's "private" attribute of the same name.

3. **Why use `@property` instead of a plain public attribute?**
   It lets you add validation, computed logic, or side effects later without changing the calling syntax — `obj.attr` and `obj.attr = value` still work, so existing callers don't need to be rewritten.

4. **How would you make a read-only computed attribute?**
   Define a `@property` with only a getter and no corresponding `@x.setter`; assigning to it then raises `AttributeError`.

5. **Why might starting with public attributes and adding properties later be better than adding properties from day one?**
   YAGNI — most attributes never need validation. Since properties are interface-compatible with plain attributes in Python, you can defer the decision until you actually need it, avoiding premature ceremony.

## Suggested Next Lesson

[03 — Abstraction](../03-Abstraction/README.md)
