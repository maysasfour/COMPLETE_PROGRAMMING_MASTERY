"""Solution to Exercise 06 -- Generic Repository."""

from typing import Generic, Protocol, TypeVar, Callable


class HasId(Protocol):
    id: int


T = TypeVar("T", bound=HasId)


class Repository(Generic[T]):
    def __init__(self):
        self._items: dict[int, T] = {}

    def add(self, item: T) -> None:
        self._items[item.id] = item

    def get(self, id: int) -> T | None:
        return self._items.get(id)

    def remove(self, id: int) -> None:
        self._items.pop(id, None)

    def all(self) -> list[T]:
        return list(self._items.values())

    @classmethod
    def empty(cls) -> "Repository[T]":
        # Alternative constructor: reads better than `Repository()` at some call sites, and
        # gives a single place to add future setup (e.g. pre-sizing) without touching __init__.
        return cls()

    @staticmethod
    def count_by_predicate(items: list[T], predicate: Callable[[T], bool]) -> int:
        # Doesn't touch self or cls -- it's a pure utility over a list, attached to Repository
        # purely for discoverability/namespacing (Repository.count_by_predicate(...)).
        return sum(1 for item in items if predicate(item))


class User:
    def __init__(self, id: int, name: str):
        self.id = id
        self.name = name


class Product:
    def __init__(self, id: int, name: str, price: float):
        self.id = id
        self.name = name
        self.price = price


users: Repository[User] = Repository.empty()
users.add(User(1, "Alice"))
users.add(User(2, "Bob"))
print(users.get(1).name)   # Alice
print(len(users.all()))     # 2
users.remove(1)
print(users.get(1))         # None

products: Repository[Product] = Repository.empty()
products.add(Product(1, "Widget", 9.99))
print(Repository.count_by_predicate(products.all(), lambda p: p.price < 10))  # 1


# Reflection 1: Protocol (HasId) is used instead of a common abc.ABC base class because User
# and Product are otherwise unrelated types with no natural "is-a" relationship to each other
# or to some shared base -- forcing them to inherit from a common ABC purely to satisfy the
# repository would be an artificial coupling. Protocol gives structural typing: any class with
# an `id: int` attribute satisfies HasId automatically, with no inheritance, no import
# dependency on the repository module, and no risk of MRO conflicts if User/Product need to
# inherit from something else entirely.
#
# Reflection 2: count_by_predicate could absolutely be a plain module-level function -- it uses
# neither self nor cls, so nothing about it is intrinsically tied to Repository instances.
# Attaching it as a @staticmethod buys namespacing/discoverability (Repository.count_by_predicate
# reads as "a repository-related operation" and appears via autocomplete on the class) and
# groups related functionality together, at the minor cost of implying a tighter coupling to
# Repository than technically exists.
