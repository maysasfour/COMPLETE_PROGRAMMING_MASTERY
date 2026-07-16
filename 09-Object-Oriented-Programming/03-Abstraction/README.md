# 03 — Abstraction

[Back to module overview](../README.md) | [Previous: Encapsulation](../02-Encapsulation/README.md)

## Beginner: What Abstraction Means

**Abstraction** means exposing only what a caller needs to know to use something, while hiding the details of how it works internally. When you call `len(my_list)`, you don't need to know how CPython counts elements internally — you just need the contract: "give me a container, I'll tell you how many items it has."

In class design, abstraction usually means defining a **common interface** that multiple concrete classes implement, so calling code can work against the interface without caring which concrete class it received.

```python
def print_area(shape):
    print(shape.area())   # works for ANY object with an area() method
```

## Beginner: Abstract Base Classes with `abc`

Python's `abc` module lets you define a class that **cannot be instantiated directly** and that forces subclasses to implement specific methods. This is how you make "you must implement `area()`" an enforced contract rather than a hopeful comment.

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        ...

    @abstractmethod
    def perimeter(self) -> float:
        ...
```

```python
shape = Shape()   # TypeError: Can't instantiate abstract class Shape with abstract methods area, perimeter
```

A concrete subclass must implement every `@abstractmethod` before it can be instantiated at all:

```python
class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14159 * self.radius ** 2

    def perimeter(self) -> float:
        return 2 * 3.14159 * self.radius
```

If `Circle` forgot to implement `perimeter`, instantiating `Circle(5)` would raise the same `TypeError` — the ABC mechanism checks at instantiation time, not just by convention.

## Intermediate: Why Abstraction, Not Just "Write Fewer Methods"

Abstraction isn't about hiding complexity for its own sake — it's about **decoupling callers from implementation details that are likely to change**. If `print_area()` only worked with `Circle`, adding a `Square` would require touching every function that currently hardcodes `Circle`. Coding against the `Shape` abstraction means new shapes just plug in.

```python
def total_area(shapes: list[Shape]) -> float:
    return sum(shape.area() for shape in shapes)   # doesn't care what kind of Shape
```

## Advanced: Interfaces-as-Protocols (Structural Typing)

`abc.ABC` requires **explicit inheritance** — a class must subclass `Shape` to count as a `Shape`. `typing.Protocol` instead defines a shape *structurally*: any object with matching methods counts, with no inheritance required. This is **duck typing made statically checkable**.

```python
from typing import Protocol

class Sized(Protocol):
    def area(self) -> float: ...

class Circle:  # note: does NOT inherit from Sized
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14159 * self.radius ** 2

def print_area(shape: Sized) -> None:
    print(shape.area())

print_area(Circle(5))   # type-checks and runs fine - Circle "quacks" like a Sized
```

`Protocol` is checked by static type checkers (mypy, pyright) at analysis time and via `isinstance()` at runtime *only* if decorated with `@runtime_checkable` — by default `Protocol` is a typing-only construct with no runtime enforcement at all. Lesson 07 compares `ABC` and `Protocol` in depth.

## Real-World Usage

- Payment processing systems define a `PaymentProcessor` abstraction; concrete `StripeProcessor`, `PayPalProcessor` implement it, and checkout code never branches on which provider is active.
- Storage backends (local disk, S3, GCS) are abstracted behind a common interface so application code calls `storage.save(file)` without knowing or caring where bytes actually land.
- Python's own standard library uses this pattern extensively: anything implementing `__iter__`/`__next__` is "iterable" — no explicit `Iterable` base class subclassing is required to work in a `for` loop.

## Summary

- Abstraction hides implementation detail behind a simple, stable interface that callers code against.
- `abc.ABC` + `@abstractmethod` enforces a contract via inheritance — subclasses that skip a required method cannot be instantiated.
- `typing.Protocol` defines an interface structurally — no inheritance needed, matching is based on having the right methods/signatures.
- Abstraction's payoff is decoupling: code written against an abstraction doesn't need to change when new implementations are added.

## Key Terms

- **Abstraction** — exposing a simple interface while hiding implementation detail.
- **Abstract Base Class (ABC)** — a class that cannot be instantiated directly and defines methods subclasses must implement.
- **`@abstractmethod`** — marks a method as required; a subclass missing it also cannot be instantiated.
- **`Protocol`** — a structural (duck-typed) interface definition checked by type checkers, not requiring inheritance.
- **Structural typing** — "if it has the right shape (methods/attributes), it satisfies the type" — as opposed to nominal typing, which requires explicit inheritance.

## Common Mistakes

- Trying to instantiate an `ABC` directly and being surprised by the `TypeError` — that's the entire point of marking it abstract.
- Forgetting that a subclass must implement **every** `@abstractmethod`, not just some — a partially-implemented subclass is still abstract and still can't be instantiated.
- Assuming `Protocol` gives you runtime `isinstance()` checks by default — it doesn't unless you add `@runtime_checkable`, and even then only method/attribute *presence* is checked, not signatures.
- Reaching for `ABC` when duck typing (no formal interface at all) would be simpler — Python doesn't require a common base class for polymorphism to work (see Lesson 05).

## Interview Questions

1. **What's the point of an abstract base class if Python already supports duck typing?**
   An ABC makes the contract explicit and enforced — instantiation fails immediately if a required method is missing, rather than failing later at the call site with a confusing `AttributeError`. It also documents intent clearly for readers and tooling.

2. **Can you instantiate a class that inherits from `ABC` but doesn't implement all its `@abstractmethod`s?**
   No — Python raises `TypeError` at instantiation time listing the missing abstract methods.

3. **What's the difference between `ABC` and `Protocol`?**
   `ABC` requires explicit inheritance (nominal typing); `Protocol` matches structurally based on having the right methods (structural typing), with no inheritance required, and is primarily enforced by static type checkers rather than the runtime.

4. **Does `Protocol` give you runtime type checking?**
   Only if you decorate it with `@runtime_checkable`, and even then `isinstance()` only checks that the right method/attribute names exist — not that their signatures match.

5. **Give a real-world example of abstraction reducing coupling.**
   A `PaymentProcessor` abstraction lets checkout code call `processor.charge(amount)` without knowing whether it's talking to Stripe or PayPal — adding a new provider means writing a new class that implements the interface, not touching every call site.

## Suggested Next Lesson

[04 — Inheritance](../04-Inheritance/README.md)
