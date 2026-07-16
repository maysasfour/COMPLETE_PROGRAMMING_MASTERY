"""
Lesson 01 - Classes and Objects
Demonstrates: class vs. instance, __init__, instance attributes vs.
class attributes (including the shared-mutable-default trap), and
object identity (`is`) vs. equality (`==`).

Run with:
    python example.py

Expected output:
    --- Class vs. object ---
    rex.name = Rex, fido.name = Fido

    --- Class attribute shared across instances ---
    rex.species = Canis familiaris, fido.species = Canis familiaris

    --- The mutable class-attribute trap ---
    a.items after a.add('x'): ['x']
    b.items (SAME list, unintended!): ['x']

    --- Fixed version: instance attribute per object ---
    a.items: ['x']
    b.items (independent now): []

    --- Identity vs. equality ---
    a is b (same object): True
    a is c (different object): False
    a == c (no __eq__ defined, falls back to identity): False
"""


class Dog:
    # Class attribute: ONE copy shared by every Dog instance, because it's
    # data that genuinely describes the whole species, not a single animal.
    species = "Canis familiaris"

    def __init__(self, name: str, breed: str):
        # Assigning to self.<name> creates data that belongs to THIS
        # object only - two Dog instances never share these values.
        self.name = name
        self.breed = breed


print("--- Class vs. object ---")
# Dog is the blueprint; rex and fido are two independent objects built
# from it, each carrying its own name/breed.
rex = Dog("Rex", "Labrador")
fido = Dog("Fido", "Poodle")
print(f"rex.name = {rex.name}, fido.name = {fido.name}")

print("\n--- Class attribute shared across instances ---")
# Neither instance defines its own `species`, so both look it up on the
# class and see the exact same value.
print(f"rex.species = {rex.species}, fido.species = {fido.species}")


class Broken:
    # DANGER: this list is created ONCE, when the class body executes,
    # not once per instance - every Broken() shares this same object.
    items = []

    def add(self, item):
        self.items.append(item)


print("\n--- The mutable class-attribute trap ---")
a = Broken()
b = Broken()
a.add("x")
# b never called add(), yet it sees "x" - because a.items and b.items
# both resolve to the one shared class-level list.
print(f"a.items after a.add('x'): {a.items}")
print(f"b.items (SAME list, unintended!): {b.items}")


class Fixed:
    def __init__(self):
        # Creating the list INSIDE __init__ means every instance gets
        # its own fresh list object at construction time.
        self.items = []

    def add(self, item):
        self.items.append(item)


print("\n--- Fixed version: instance attribute per object ---")
a = Fixed()
b = Fixed()
a.add("x")
print(f"a.items: {a.items}")
print(f"b.items (independent now): {b.items}")

print("\n--- Identity vs. equality ---")
a = Dog("Rex", "Labrador")
b = a                          # b is bound to the SAME Dog object as a
c = Dog("Rex", "Labrador")      # c is a DIFFERENT object with equal-looking data

# `is` asks "are these the same object in memory"; it's true for a/b
# because no new object was created for b - it's just another name for a.
print(f"a is b (same object): {a is b}")
print(f"a is c (different object): {a is c}")

# Dog never defines __eq__, so == inherits object's default behavior,
# which is identity comparison - equal-looking data is NOT enough.
print(f"a == c (no __eq__ defined, falls back to identity): {a == c}")
