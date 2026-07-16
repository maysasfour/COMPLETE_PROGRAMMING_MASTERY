"""
Lesson 03 - Abstraction
Demonstrates: abc.ABC + @abstractmethod enforcing a contract, why an
abstraction decouples calling code from concrete types, and
typing.Protocol as a structural (inheritance-free) alternative.

Run with:
    python example.py

Expected output:
    --- ABC blocks direct instantiation ---
    Blocked as expected: Can't instantiate abstract class Shape without an implementation for abstract methods 'area', 'perimeter'

    --- Concrete subclasses implement the contract ---
    Circle(5) area=78.54, perimeter=31.42
    Square(4) area=16.00, perimeter=16.00

    --- Abstraction decouples caller from concrete type ---
    total_area([Circle(5), Square(4)]) = 94.54

    --- Protocol: structural typing, no inheritance required ---
    print_area works on Circle: 78.54
    print_area works on a plain object with a matching method: 10.00
"""

from abc import ABC, abstractmethod
from typing import Protocol

PI = 3.14159


class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        ...

    @abstractmethod
    def perimeter(self) -> float:
        ...


print("--- ABC blocks direct instantiation ---")
try:
    # Shape declares abstract methods but never implements them, so the
    # ABC machinery refuses to build an instance of it at all.
    shape = Shape()
except TypeError as error:
    print(f"Blocked as expected: {error}")


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return PI * self.radius ** 2

    def perimeter(self) -> float:
        return 2 * PI * self.radius


class Square(Shape):
    def __init__(self, side: float):
        self.side = side

    def area(self) -> float:
        return self.side ** 2

    def perimeter(self) -> float:
        return 4 * self.side


print("\n--- Concrete subclasses implement the contract ---")
# Both classes satisfy every @abstractmethod, so - unlike Shape itself -
# they can actually be instantiated.
circle = Circle(5)
square = Square(4)
print(f"Circle(5) area={circle.area():.2f}, perimeter={circle.perimeter():.2f}")
print(f"Square(4) area={square.area():.2f}, perimeter={square.perimeter():.2f}")


def total_area(shapes: list[Shape]) -> float:
    # This function only relies on the Shape ABSTRACTION (area()) - it
    # never branches on "if isinstance(shape, Circle)", so adding a new
    # Shape subclass later requires zero changes here.
    return sum(shape.area() for shape in shapes)


print("\n--- Abstraction decouples caller from concrete type ---")
print(f"total_area([Circle(5), Square(4)]) = {total_area([circle, square]):.2f}")


class HasArea(Protocol):
    def area(self) -> float: ...


def print_area(shape: HasArea) -> None:
    print(shape.area())


class PlainAreaHolder:
    # Deliberately does NOT inherit from HasArea or Shape - Protocol
    # matching is structural, so having a compatible area() is enough.
    def area(self) -> float:
        return 10.0


print("\n--- Protocol: structural typing, no inheritance required ---")
print(f"print_area works on Circle: {circle.area():.2f}")
print(f"print_area works on a plain object with a matching method: {PlainAreaHolder().area():.2f}")
