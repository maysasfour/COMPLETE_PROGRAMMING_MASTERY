# Solution 06 — Generic Repository

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-06-generic-repository.md) | [Code](solution-06.py)

## Approach

`HasId` is a `typing.Protocol` declaring only `id: int`. Because it's a `Protocol` rather than an `abc.ABC`, nothing needs to inherit from it — any class that happens to define an `id: int` attribute satisfies it structurally, which is exactly why `User` and `Product` (two otherwise-unrelated classes) can both be stored in a `Repository` without either one importing or subclassing anything from the repository module.

`Repository(Generic[T])` is parameterized over `T = TypeVar("T", bound=HasId)`, meaning `T` can be *any* type as long as it satisfies `HasId`. Internally it stores items in a `dict[int, T]` keyed by `.id`, which makes `get`/`remove`/`add` all O(1) rather than scanning a list. `all()` returns `list(self._items.values())`.

`empty()` is a `@classmethod` alternative constructor — here it's trivial (`return cls()`), but the pattern matters more than this specific implementation: using `cls()` rather than hardcoding `Repository()` means a subclass calling `SubRepository.empty()` would correctly construct a `SubRepository`, not a `Repository`.

`count_by_predicate` is a `@staticmethod` because it uses neither `self` nor `cls` — it's a pure function over a `list[T]` and a predicate callable, attached to the class purely for namespacing/discoverability rather than because it needs instance or class state.

## Why This Design

The alternative to `Protocol` here would be an `abc.ABC` base class that `User` and `Product` both inherit from (e.g. `class Identifiable(ABC): id: int`). That would work, but it forces every stored type to accept a coupling to the repository module's class hierarchy even if that type already has (or needs) an unrelated inheritance chain of its own. `Protocol` achieves the same type-safety guarantee (a type checker like `mypy` will flag a class missing `id: int` used as `T`) without that coupling — structural typing over nominal typing is the right call whenever the constraint is "has this shape" rather than "is fundamentally a kind of this thing."

## Verified Output

```
Alice
2
None
1
```

Matches the exercise's expected behavior line for line: `users.get(1).name` returns `"Alice"`, `len(users.all())` is `2` before removal, `users.get(1)` is `None` after removal, and `count_by_predicate` correctly counts the one `Product` under $10.

## Reflection Answers

1. `Protocol` is used instead of a common `abc.ABC` base class because `User` and `Product` have no natural "is-a" relationship to each other or to some shared repository-domain concept — they're unrelated types that merely happen to both have an `id`. Requiring inheritance from a shared ABC would impose an artificial coupling (every storable type must import and subclass something from the repository module) and would conflict the moment either type needed to inherit from something else instead (Python supports multiple inheritance, but it adds MRO complexity that a structural `Protocol` sidesteps entirely). `Protocol` gives the same static-type-checking guarantee — a type checker still verifies `T` has `id: int` wherever `Repository[T]` is used — purely by shape, with zero runtime coupling.

2. `count_by_predicate` could absolutely be a plain module-level function (`def count_by_predicate(items, predicate): ...`) — it doesn't reference `self` or `cls` anywhere, so nothing about its logic depends on being part of `Repository`. What's gained by attaching it as a `@staticmethod` is purely organizational: it's discoverable via `Repository.count_by_predicate(...)` (autocomplete/documentation surfaces it alongside the class it conceptually relates to), and it signals to readers "this utility is meant to operate on repository-style collections," even though the language enforces no such restriction. The cost is a slightly misleading impression of tighter coupling to `Repository` than actually exists.
