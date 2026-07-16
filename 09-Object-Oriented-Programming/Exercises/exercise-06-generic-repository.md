# Exercise 06 — Generic Repository

[Back to Exercises](README.md) | Covers: [Lesson 07 — Interfaces and Abstract Classes](../07-Interfaces-and-Abstract-Classes/README.md), [Lesson 08 — Generics and Static Members](../08-Generics-and-Static-Members/README.md)

**Difficulty: Advanced**

## Task

Build a generic, type-safe in-memory "repository" pattern (a common data-access abstraction):

1. Define a `Protocol` named `HasId` requiring an `id: int` attribute — anything stored in the repository must satisfy this structurally (no inheritance required).
2. Define a generic `Repository(Generic[T])` class (where `T` is bound to `HasId`) with:
   - `add(self, item: T) -> None`
   - `get(self, id: int) -> T | None`
   - `remove(self, id: int) -> None`
   - `all(self) -> list[T]`
   - A `@classmethod` `empty(cls) -> "Repository[T]"` as an alternative constructor (just returns `cls()`, but demonstrates the pattern).
   - A `@staticmethod` `count_by_predicate(items: list[T], predicate) -> int` that counts how many items in a list satisfy a given predicate function — this doesn't need `self` or `cls` at all.
3. Create two unrelated classes, `User` (with `id`, `name`) and `Product` (with `id`, `name`, `price`), neither inheriting from anything special — just satisfying `HasId` structurally.
4. Demonstrate `Repository[User]` and `Repository[Product]` both working from the same class definition.

## Expected Behavior

```python
users = Repository[User]()
users.add(User(1, "Alice"))
users.add(User(2, "Bob"))
print(users.get(1).name)          # Alice
print(len(users.all()))            # 2
users.remove(1)
print(users.get(1))                # None

products = Repository[Product]()
products.add(Product(1, "Widget", 9.99))
print(Repository.count_by_predicate(products.all(), lambda p: p.price < 10))   # 1
```

## Reflection Questions

1. Why use `Protocol` (`HasId`) here instead of requiring every stored type to inherit from a common `abc.ABC` base class?
2. `count_by_predicate` is a `@staticmethod` — could it instead have been a plain module-level function? What (if anything) is gained by attaching it to `Repository`?

## Deliverable

A runnable `.py` file producing the behavior shown above, plus written answers to both reflection questions.
