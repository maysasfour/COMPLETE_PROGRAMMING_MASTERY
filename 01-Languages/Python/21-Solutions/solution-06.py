"""
Solution 06 - Generic Stack with Type Hints
See: ../20-Exercises/README.md#exercise-06--generic-stack-with-type-hints-advanced

Run with:
    python solution-06.py

Expected output:
    int stack after pushes: length 3
    Popped: 3
    Peeked (unchanged): 2
    int stack after pop: length 2
    str stack: ['a', 'b']
    Popped from empty stack raised: Stack is empty
"""

from typing import Generic, TypeVar

T = TypeVar("T")


class EmptyStackError(Exception):
    pass


class Stack(Generic[T]):
    """A LIFO stack generic over a single type T (see Lesson 13 for TypeVar/Generic)."""

    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        if self.is_empty():
            raise EmptyStackError("Stack is empty")
        return self._items.pop()

    def peek(self) -> T:
        if self.is_empty():
            raise EmptyStackError("Stack is empty")
        return self._items[-1]

    def is_empty(self) -> bool:
        return len(self._items) == 0

    def __len__(self) -> int:
        return len(self._items)


if __name__ == "__main__":
    # Stack[int] - the [int] is a hint for readers/type-checkers only;
    # the SAME Stack class handles any type at runtime (Lesson 13 explains why).
    int_stack: Stack[int] = Stack()
    int_stack.push(1)
    int_stack.push(2)
    int_stack.push(3)
    print(f"int stack after pushes: length {len(int_stack)}")
    print(f"Popped: {int_stack.pop()}")
    print(f"Peeked (unchanged): {int_stack.peek()}")
    print(f"int stack after pop: length {len(int_stack)}")

    str_stack: Stack[str] = Stack()
    str_stack.push("a")
    str_stack.push("b")
    print(f"str stack: {list(str_stack._items)}")

    empty_stack: Stack[int] = Stack()
    try:
        empty_stack.pop()
    except EmptyStackError as e:
        print(f"Popped from empty stack raised: {e}")
