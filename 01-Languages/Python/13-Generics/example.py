"""
Lesson 13 - Generics
Demonstrates: type hint fundamentals, Optional/Union (and the modern
list[int] / X | None syntax), and TypeVar + Generic for a generic
Stack[T] class. Type hints are NOT enforced at runtime - this script
proves that by deliberately "violating" a hint and showing it still runs.

Run with:
    python example.py

Expected output:
    --- Type hint fundamentals (not enforced at runtime) ---
    greet(name='Ana') = Hello, Ana!
    add(2, 3) = 5
    add("2", "3") = 23 (ran fine even though hints say int - hints are not checked at runtime)

    --- Optional / Union (and modern X | None, A | B syntax) ---
    find_user(1) = None
    find_user(2) = alice
    parse(5) = 5
    parse('7') = 7

    --- Generic Box[T] ---
    int_box.get() = 42
    str_box.get() = hello

    --- Generic Stack[T] ---
    stack (int) after pushes: [1, 2, 3]
    stack.pop() = 3
    stack.pop() = 2
    stack.is_empty() = False
    stack.pop() = 1
    stack.is_empty() = True
"""

from typing import Generic, TypeVar


print("--- Type hint fundamentals (not enforced at runtime) ---")


def greet(name: str) -> str:
    return f"Hello, {name}!"


def add(a: int, b: int) -> int:
    return a + b


print(f"greet(name='Ana') = {greet('Ana')}")
print(f"add(2, 3) = {add(2, 3)}")
# This "violates" the int hints by passing strings, but Python never checks
# hints at runtime - it just runs `"2" + "3"`, which is string concatenation.
result = add("2", "3")
print(f'add("2", "3") = {result} (ran fine even though hints say int - hints are not checked at runtime)')

print("\n--- Optional / Union (and modern X | None, A | B syntax) ---")

# str | None (3.10+ syntax) is equivalent to Optional[str] - both just mean
# "this function may return a string, or may return nothing at all."
_users = {2: "alice"}


def find_user(user_id: int) -> str | None:
    """Returns the username, or None if not found."""
    return _users.get(user_id)


# int | str (3.10+ syntax) is equivalent to Union[int, str] - "accepts either."
def parse(value: int | str) -> int:
    return int(value)


print(f"find_user(1) = {find_user(1)}")
print(f"find_user(2) = {find_user(2)}")
print(f"parse(5) = {parse(5)}")
print(f"parse('7') = {parse('7')}")

print("\n--- Generic Box[T] ---")

T = TypeVar("T")


class Box(Generic[T]):
    """A container that holds exactly one value of some type T."""

    def __init__(self, item: T) -> None:
        self._item = item

    def get(self) -> T:
        return self._item

    def set(self, item: T) -> None:
        self._item = item


# Box[int] and Box[str] are the SAME class at runtime - the [int]/[str] part
# only helps a static type checker (mypy/pyright), it has no runtime effect.
int_box: Box[int] = Box(42)
str_box: Box[str] = Box("hello")
print(f"int_box.get() = {int_box.get()}")
print(f"str_box.get() = {str_box.get()}")

print("\n--- Generic Stack[T] ---")


class Stack(Generic[T]):
    """A last-in-first-out stack holding items of a single type T."""

    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def __repr__(self) -> str:
        return repr(self._items)


stack: Stack[int] = Stack()
stack.push(1)
stack.push(2)
stack.push(3)
print(f"stack (int) after pushes: {stack}")
print(f"stack.pop() = {stack.pop()}")
print(f"stack.pop() = {stack.pop()}")
print(f"stack.is_empty() = {stack.is_empty()}")
print(f"stack.pop() = {stack.pop()}")
print(f"stack.is_empty() = {stack.is_empty()}")
