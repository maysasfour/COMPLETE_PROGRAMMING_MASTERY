"""
Lesson 11 - OOP
Demonstrates: classes and __init__, instance vs. class attributes,
inheritance with super(), dunder methods (__repr__/__eq__/__add__), and
properties with validation and computed values.

Run with:
    python example.py

Expected output:
    --- classes and __init__ ---
    Rex says Woof!

    --- instance vs. class attributes ---
    Rex species -> Canis familiaris
    Fido species -> Canis familiaris
    after changing Dog.species: Canis lupus familiaris
    Rex name -> Rex Jr., Fido name -> Fido

    --- inheritance ---
    Whiskers says Meow!
    Rex says Woof! (breed: Labrador)

    --- dunder methods ---
    p1 + p2 -> Point(4, 6)
    p1 == Point(1, 2) -> True
    p1 -> Point(1, 2)

    --- properties ---
    circle radius -> 5
    circle area -> 78.53975
    radius after setter update -> 10
    invalid radius rejected: radius must be positive
"""

print("--- classes and __init__ ---")


class Dog:
    species = "Canis familiaris"  # class attribute - shared by every Dog instance

    def __init__(self, name, breed=None):
        self.name = name   # instance attribute - unique to this object
        self.breed = breed

    def bark(self):
        return f"{self.name} says Woof!"


rex = Dog("Rex", "Labrador")
print(rex.bark())

print("\n--- instance vs. class attributes ---")
fido = Dog("Fido")
print("Rex species ->", rex.species)
print("Fido species ->", fido.species)

# Changing the CLASS attribute affects every instance that hasn't shadowed it.
Dog.species = "Canis lupus familiaris"
print("after changing Dog.species:", rex.species)

# Assigning to rex.name only creates/updates an INSTANCE attribute on rex -
# it has no effect on fido, since instance attributes are per-object.
rex.name = "Rex Jr."
print(f"Rex name -> {rex.name}, Fido name -> {fido.name}")

print("\n--- inheritance ---")


class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError("subclasses must implement speak()")


class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"


class DogAnimal(Animal):
    def __init__(self, name, breed):
        super().__init__(name)  # reuses Animal's __init__ instead of repeating self.name = name
        self.breed = breed

    def speak(self):
        return f"{self.name} says Woof! (breed: {self.breed})"


for animal in [Cat("Whiskers"), DogAnimal("Rex", "Labrador")]:
    print(animal.speak())

print("\n--- dunder methods ---")


class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        # Called by print()/repr() - without this, printing shows an
        # unhelpful <__main__.Point object at 0x...> instead.
        return f"Point({self.x}, {self.y})"

    def __eq__(self, other):
        # Without this, == would fall back to identity comparison (like `is`),
        # so two Points with the same coordinates would compare unequal.
        return self.x == other.x and self.y == other.y

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)


p1 = Point(1, 2)
p2 = Point(3, 4)
print("p1 + p2 ->", p1 + p2)
print("p1 == Point(1, 2) ->", p1 == Point(1, 2))
print("p1 ->", p1)

print("\n--- properties ---")


class Circle:
    def __init__(self, radius):
        self._radius = radius  # leading underscore: internal, accessed via the property below

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value <= 0:
            raise ValueError("radius must be positive")
        self._radius = value

    @property
    def area(self):
        # Computed fresh every access, never stored - always reflects the
        # current radius, so it can never silently go stale.
        return 3.14159 * self._radius ** 2


circle = Circle(5)
print("circle radius ->", circle.radius)
print("circle area ->", circle.area)

circle.radius = 10  # goes through the setter, which validates the new value
print("radius after setter update ->", circle.radius)

try:
    circle.radius = -1
except ValueError as e:
    print("invalid radius rejected:", e)
