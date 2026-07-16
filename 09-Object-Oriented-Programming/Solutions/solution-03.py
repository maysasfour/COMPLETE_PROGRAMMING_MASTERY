"""Solution to Exercise 03 -- Shape Hierarchy with an ABC."""

from abc import ABC, abstractmethod


class Shape(ABC):
    @abstractmethod
    def area(self) -> float: ...

    @abstractmethod
    def perimeter(self) -> float: ...

    def describe(self) -> str:
        # Concrete and NOT overridden by subclasses: it only depends on area()/perimeter(),
        # which are polymorphic, so this single implementation works for every subclass.
        return f"{type(self).__name__}: area={self.area():.2f}, perimeter={self.perimeter():.2f}"


class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14159265358979 * self.radius ** 2

    def perimeter(self) -> float:
        return 2 * 3.14159265358979 * self.radius


class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def area(self) -> float:
        return self.width * self.height

    def perimeter(self) -> float:
        return 2 * (self.width + self.height)


class Square(Rectangle):
    def __init__(self, side: float):
        # A square IS a rectangle with equal sides, so reuse Rectangle's area/perimeter
        # entirely via super().__init__() instead of reimplementing the formulas.
        super().__init__(side, side)


def total_area(shapes: list[Shape]) -> float:
    # No isinstance checks needed: every Shape guarantees an area() method via the ABC
    # contract, so this works uniformly across circles, rectangles, squares, or any future
    # Shape subclass without modification.
    return sum(s.area() for s in shapes)


shapes = [Circle(5), Rectangle(3, 4), Square(2)]
for s in shapes:
    print(s.describe())

print(total_area(shapes))  # 94.54

try:
    Shape()
except TypeError as e:
    print(f"Cannot instantiate Shape directly: {e}")


# Reflection 1: Shape() raises TypeError ("Can't instantiate abstract class Shape without an
# implementation for abstract methods 'area', 'perimeter'") because abc.ABC enforces that
# every abstract method must be overridden before a class can be instantiated.
#
# Reflection 2: Square(Rectangle) is the classic example of an "is-a" relationship that looks
# fine geometrically but breaks under mutation. If Rectangle grows a `stretch_width(amount)`
# method, calling it on a Square instance would change only the width, leaving the object with
# unequal width/height -- no longer a valid square, violating the invariant a "Square" type is
# supposed to guarantee (a violation of the Liskov Substitution Principle). It works here only
# because both classes are read-only after construction; a mutable stretch_width would expose
# the flaw immediately.
