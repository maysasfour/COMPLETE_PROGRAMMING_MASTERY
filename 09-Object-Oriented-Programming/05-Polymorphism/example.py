"""
Lesson 05 - Polymorphism
Demonstrates: polymorphism via method overriding, duck typing (no shared
base class required), dynamic dispatch (resolved by actual runtime type,
not the declared/annotated type), and operator overloading via dunder
methods (including the __eq__/__hash__ interaction).

Run with:
    python example.py

Expected output:
    --- Polymorphism via overriding ---
    Meow
    Woof

    --- Duck typing: no shared base class required ---
    Meow
    BEEP BOOP

    --- Dynamic dispatch resolves by actual runtime type ---
    make_it_speak(Dog()) -> Woof

    --- Operator overloading ---
    v1 + v2 = Vector(4, 6)
    v1 == Vector(1, 2): True
    Hashable after defining __hash__: True
"""


class Cat:
    def speak(self):
        return "Meow"


class Dog:
    def speak(self):
        return "Woof"


print("--- Polymorphism via overriding ---")
for animal in [Cat(), Dog()]:
    # The loop body is identical for both - each object's OWN speak()
    # runs, and the loop never needs to know which type it's holding.
    print(animal.speak())


class Robot:
    # Deliberately unrelated to Cat/Dog - no shared base class, no
    # shared ancestor at all beyond `object`.
    def speak(self):
        return "BEEP BOOP"


print("\n--- Duck typing: no shared base class required ---")
for thing in [Cat(), Robot()]:
    # Works purely because both objects HAVE a speak() method - Python
    # never checks what either one inherits from.
    print(thing.speak())


class Animal:
    def speak(self):
        return "..."


class DogAnimal(Animal):
    def speak(self):
        return "Woof"


def make_it_speak(animal: Animal):
    # The parameter is annotated Animal, but Python looks up speak() on
    # the OBJECT's real type at call time, not on the annotation.
    print(f"make_it_speak(Dog()) -> {animal.speak()}")


print("\n--- Dynamic dispatch resolves by actual runtime type ---")
make_it_speak(DogAnimal())


class Vector:
    def __init__(self, x: float, y: float):
        self.x, self.y = x, y

    def __add__(self, other: "Vector") -> "Vector":
        # + on two Vector objects is only meaningful because __add__
        # defines what "adding" even means for this type.
        return Vector(self.x + other.x, self.y + other.y)

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Vector):
            return NotImplemented
        return self.x == other.x and self.y == other.y

    def __hash__(self) -> int:
        # Defining __eq__ disables the default identity-based __hash__,
        # so it must be restored explicitly to keep Vector usable in
        # sets/dict keys - and it must be consistent with __eq__.
        return hash((self.x, self.y))

    def __repr__(self) -> str:
        return f"Vector({self.x}, {self.y})"


print("\n--- Operator overloading ---")
v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(f"v1 + v2 = {v1 + v2}")
print(f"v1 == Vector(1, 2): {v1 == Vector(1, 2)}")
print(f"Hashable after defining __hash__: {isinstance(hash(v1), int)}")
