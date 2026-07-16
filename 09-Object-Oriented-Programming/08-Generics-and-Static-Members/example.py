"""
Lesson 08 - Generics and Static Members
Demonstrates: instance methods vs. @classmethod (alternative
constructors that respect subclassing via `cls`) vs. @staticmethod
(plain namespaced functions), and a generic Stack[T] built with
TypeVar/Generic, including the fact that Python does not enforce the
type parameter at runtime.

Run with:
    python example.py

Expected output:
    --- Instance method, classmethod, staticmethod ---
    temp.describe() = 25degC
    Temperature.from_fahrenheit(98.6).degrees = 37.0
    Temperature.is_freezing(-5) = True
    Temperature.is_freezing(20) = False

    --- classmethod respects subclassing via cls ---
    type(Temperature.from_fahrenheit(32)).__name__ = Temperature
    type(FancyTemperature.from_fahrenheit(32)).__name__ = FancyTemperature

    --- Generic Stack[T] ---
    int_stack after push(1), push(2): [1, 2]
    int_stack.pop() -> 2
    str_stack after push('a'), push('b'): ['a', 'b']
    Python does NOT enforce T at runtime: mixed_stack items = [1, 'oops']
"""

from typing import Generic, TypeVar


class Temperature:
    unit_name = "Celsius"

    def __init__(self, degrees: float):
        self.degrees = degrees

    def describe(self) -> str:
        # Needs self.degrees - this is inherently instance-specific data.
        # (Plain "deg" instead of the ° symbol keeps output portable across
        # default Windows console code pages without needing PYTHONIOENCODING.)
        return f"{self.degrees}deg{self.unit_name[0]}"

    @classmethod
    def from_fahrenheit(cls, f: float) -> "Temperature":
        # cls(...) - NOT Temperature(...) - so subclasses build an
        # instance of THEMSELVES, not hardcoded back to Temperature.
        return cls((f - 32) * 5 / 9)

    @staticmethod
    def is_freezing(celsius: float) -> bool:
        # Touches neither self nor cls - it's a pure utility that just
        # happens to be conceptually about temperatures.
        return celsius <= 0


print("--- Instance method, classmethod, staticmethod ---")
temp = Temperature(25)
print(f"temp.describe() = {temp.describe()}")
print(f"Temperature.from_fahrenheit(98.6).degrees = {Temperature.from_fahrenheit(98.6).degrees:.1f}")
print(f"Temperature.is_freezing(-5) = {Temperature.is_freezing(-5)}")
print(f"Temperature.is_freezing(20) = {Temperature.is_freezing(20)}")


class FancyTemperature(Temperature):
    unit_name = "FancyCelsius"


print("\n--- classmethod respects subclassing via cls ---")
# Both calls invoke the SAME from_fahrenheit code, but cls is bound
# differently each time, so each builds the RIGHT type.
print(f"type(Temperature.from_fahrenheit(32)).__name__ = {type(Temperature.from_fahrenheit(32)).__name__}")
print(f"type(FancyTemperature.from_fahrenheit(32)).__name__ = {type(FancyTemperature.from_fahrenheit(32)).__name__}")


T = TypeVar("T")


class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    @property
    def items(self) -> list[T]:
        return list(self._items)


print("\n--- Generic Stack[T] ---")
int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)
print(f"int_stack after push(1), push(2): {int_stack.items}")
print(f"int_stack.pop() -> {int_stack.pop()}")

str_stack: Stack[str] = Stack()
str_stack.push("a")
str_stack.push("b")
print(f"str_stack after push('a'), push('b'): {str_stack.items}")

# A type checker (mypy/pyright) would flag this line as an error because
# mixed_stack was committed to int - but the INTERPRETER enforces nothing,
# so this runs without error, proving generics are a static-analysis tool here.
mixed_stack: Stack[int] = Stack()
mixed_stack.push(1)
mixed_stack.push("oops")  # type: ignore
print(f"Python does NOT enforce T at runtime: mixed_stack items = {mixed_stack.items}")
