"""
Solution 01 - OOP: Shape Hierarchy with Validated Properties
Runnable implementation of Shape/Rectangle/Square/Circle with inheritance,
super()-based reuse, validated properties, and a polymorphic total_area().

Run with:
    python solution-01.py

Expected output:
    Rectangle(width=4, height=3)
    Square(side=5)
    Circle(radius=2)
    rectangle area -> 12
    square area -> 25
    circle area -> 12.56636
    total_area -> 49.56636
    invalid rectangle rejected: width must be positive, got -5
"""


class Shape:
    def __init__(self, name):
        self.name = name

    def area(self):
        # Forces every subclass to provide its own area() - calling this
        # directly signals a subclass forgot to override it, rather than
        # silently returning a meaningless 0.
        raise NotImplementedError("subclasses must implement area()")

    def __repr__(self):
        return f"Shape(name={self.name})"


class Rectangle(Shape):
    def __init__(self, width, height):
        super().__init__("rectangle")
        # Assigning through the properties below (not to a private attribute
        # directly) means construction goes through the same validation as
        # any later mutation.
        self.width = width
        self.height = height

    @property
    def width(self):
        return self._width

    @width.setter
    def width(self, value):
        if value <= 0:
            raise ValueError(f"width must be positive, got {value}")
        self._width = value

    @property
    def height(self):
        return self._height

    @height.setter
    def height(self, value):
        if value <= 0:
            raise ValueError(f"height must be positive, got {value}")
        self._height = value

    def area(self):
        return self.width * self.height

    def __repr__(self):
        return f"Rectangle(width={self.width}, height={self.height})"


class Square(Rectangle):
    def __init__(self, side):
        # Reusing Rectangle's __init__ (and therefore its width/height
        # validation) instead of re-implementing the same >0 check here.
        super().__init__(side, side)

    def __repr__(self):
        # Square has only one meaningful dimension, so it gets its own
        # repr instead of the inherited "Rectangle(width=W, height=H)" form.
        return f"Square(side={self.width})"


class Circle(Shape):
    def __init__(self, radius):
        super().__init__("circle")
        self.radius = radius

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value <= 0:
            raise ValueError(f"radius must be positive, got {value}")
        self._radius = value

    def area(self):
        return 3.14159 * self.radius ** 2

    def __repr__(self):
        return f"Circle(radius={self.radius})"


def total_area(shapes):
    # Each shape's own area() is called polymorphically - this function
    # never checks "if isinstance(shape, Rectangle)" or similar.
    return sum(shape.area() for shape in shapes)


rectangle = Rectangle(4, 3)
square = Square(5)
circle = Circle(2)

print(rectangle)
print(square)
print(circle)

print("rectangle area ->", rectangle.area())
print("square area ->", square.area())
print("circle area ->", circle.area())

print("total_area ->", total_area([rectangle, square, circle]))

try:
    Rectangle(width=-5, height=2)
except ValueError as e:
    print("invalid rectangle rejected:", e)
