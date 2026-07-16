"""
Lesson 04 - Inheritance
Demonstrates: single inheritance and overriding, super() extending
(not replacing) parent setup, method resolution order (MRO) with
multiple inheritance, and why inheriting purely for reuse can leak an
unwanted interface (the "wrong tool" case).

Run with:
    python example.py

Expected output:
    --- Single inheritance and overriding ---
    rex.speak() = Rex barks
    rex.name (inherited, never redefined in Dog) = Rex

    --- super() extends parent __init__ instead of duplicating it ---
    rex.name = Rex, rex.breed = Labrador

    --- Method Resolution Order (MRO) ---
    D.__mro__ = D -> B -> C -> A -> object
    D().greet() = B (found before C, per declared parent order)

    --- Inheritance misused for reuse alone ---
    Stack after push(1), push(2): [1, 2]
    pop() -> 2
    Leaked list interface breaks the stack invariant: [1, 99, 2]
"""


class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        return f"{self.name} makes a sound"


class Dog(Animal):
    def speak(self) -> str:
        # Overriding replaces Animal.speak entirely for Dog instances -
        # Python looks up speak() on Dog first and stops there.
        return f"{self.name} barks"


print("--- Single inheritance and overriding ---")
rex = Dog("Rex")
print(f"rex.speak() = {rex.speak()}")
print(f"rex.name (inherited, never redefined in Dog) = {rex.name}")


class DogWithBreed(Animal):
    def __init__(self, name: str, breed: str):
        # super().__init__ lets Animal's setup logic run exactly once,
        # from one place - if Animal's __init__ later grows more fields,
        # this line doesn't need to change to pick them up.
        super().__init__(name)
        self.breed = breed


print("\n--- super() extends parent __init__ instead of duplicating it ---")
rex2 = DogWithBreed("Rex", "Labrador")
print(f"rex.name = {rex2.name}, rex.breed = {rex2.breed}")


class A:
    def greet(self):
        return "A"


class B(A):
    def greet(self):
        return "B"


class C(A):
    def greet(self):
        return "C"


class D(B, C):
    pass


print("\n--- Method Resolution Order (MRO) ---")
mro_names = " -> ".join(cls.__name__ for cls in D.__mro__)
print(f"D.__mro__ = {mro_names}")
# D declares (B, C) in that order, so C3 linearization checks B before C -
# both inherit greet() from A, but B's own override is found first.
print(f"D().greet() = {D().greet()} (found before C, per declared parent order)")


class Stack(list):
    # Inheriting from list to "get append/pop for free" looks convenient,
    # but it also exposes EVERY list method - including ones that break
    # the stack's own rule that items only enter/leave at one end.
    def push(self, item):
        self.append(item)


print("\n--- Inheritance misused for reuse alone ---")
stack = Stack()
stack.push(1)
stack.push(2)
print(f"Stack after push(1), push(2): {list(stack)}")
print(f"pop() -> {stack.pop()}")
stack.push(2)
# insert() was never intended to be part of a Stack's contract, but
# because Stack IS a list, nothing stops arbitrary-position insertion.
stack.insert(1, 99)
print(f"Leaked list interface breaks the stack invariant: {list(stack)}")
