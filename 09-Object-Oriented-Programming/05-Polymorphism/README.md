# 05 — Polymorphism

[Back to module overview](../README.md) | [Previous: Inheritance](../04-Inheritance/README.md)

## Beginner: What Polymorphism Means

**Polymorphism** ("many forms") means code can treat objects of different types uniformly, and each type supplies its own specific behavior for the same call. You've already seen it in earlier lessons without the name: `shape.area()` in Lesson 03 works whether `shape` is a `Circle` or a `Square`, because each type provides its own `area()`.

```python
class Cat:
    def speak(self): return "Meow"

class Dog:
    def speak(self): return "Woof"

for animal in [Cat(), Dog()]:
    print(animal.speak())   # each object runs ITS OWN speak() - the loop doesn't know or care which
```

## Beginner: Duck Typing

Python doesn't require a common base class or interface for polymorphism to work — **"if it walks like a duck and quacks like a duck, treat it like a duck."** Any object with a matching method can be used anywhere that method is called, regardless of its type or ancestry.

```python
class Cat:
    def speak(self): return "Meow"

class Robot:
    def speak(self): return "BEEP BOOP"   # unrelated to Cat entirely

for thing in [Cat(), Robot()]:
    print(thing.speak())   # works for both - no shared base class required
```

This is why Lesson 03's `Protocol` exists: it lets you *describe* the duck-typed shape statically without forcing inheritance.

## Intermediate: Method Overriding and Dynamic Dispatch

**Overriding** (introduced in Lesson 04) is one mechanism for polymorphism — a subclass redefines a method its parent already has. **Dynamic dispatch** is the runtime mechanism that decides *which* version actually runs: Python looks up the method on the object's actual type, not on the type of the variable pointing at it.

```python
class Animal:
    def speak(self): return "..."

class Dog(Animal):
    def speak(self): return "Woof"

def make_it_speak(animal: Animal):
    print(animal.speak())   # dispatches based on animal's ACTUAL type at runtime

make_it_speak(Dog())   # "Woof" - even though the parameter is typed as Animal
```

This is what makes polymorphic code useful: `make_it_speak` was written once, against the `Animal` type hint, but correctly calls `Dog`'s override without any `isinstance` branching.

## Advanced: Operator Overloading

Python lets a class define how built-in operators behave on its instances by implementing **dunder (double-underscore) methods**. This is polymorphism applied to operators themselves — `+` means something different for `int`, `str`, and your own class, and Python dispatches to the right implementation based on the operand's type.

```python
class Vector:
    def __init__(self, x: float, y: float):
        self.x, self.y = x, y

    def __add__(self, other: "Vector") -> "Vector":
        return Vector(self.x + other.x, self.y + other.y)

    def __repr__(self) -> str:
        return f"Vector({self.x}, {self.y})"

v1 = Vector(1, 2)
v2 = Vector(3, 4)
print(v1 + v2)   # Vector(4, 6) - __add__ is invoked by the + operator
```

Common dunder methods to override: `__add__`/`__sub__`/`__mul__` (arithmetic), `__eq__` (equality — recall Lesson 01, where `==` defaulted to identity), `__lt__`/`__gt__` (ordering, needed for `sorted()`), `__str__`/`__repr__` (string representation), `__len__` (so `len(obj)` works). If you override `__eq__`, you almost always need `__hash__` too — Python sets `__hash__` to `None` automatically when you define `__eq__` without `__hash__`, making instances unhashable (unusable in sets/dict keys) unless you explicitly restore it.

## Real-World Usage

- ORMs overload `__eq__`, comparison operators, and `__repr__` on model classes so `if user1 == user2` and debug-printing work intuitively.
- Duck typing underlies Python's iterator protocol (`__iter__`/`__next__`) and context manager protocol (`__enter__`/`__exit__`) — any object implementing them works in a `for` loop or `with` statement, no base class required.
- Numeric/scientific libraries (NumPy) overload nearly every operator so array math reads like ordinary arithmetic (`a + b`, `a * 2`) instead of verbose function calls.

## Summary

- Polymorphism lets different types respond to the same call in their own way; calling code doesn't need to branch on type.
- Duck typing means Python cares whether an object *has* the right method, not what it inherits from.
- Dynamic dispatch resolves which method implementation runs based on the object's actual runtime type.
- Operator overloading (via dunder methods like `__add__`, `__eq__`) extends polymorphism to Python's built-in operators; overriding `__eq__` without `__hash__` makes instances unhashable.

## Key Terms

- **Polymorphism** — the ability of different types to respond to the same interface/call with type-specific behavior.
- **Duck typing** — treating an object as usable based on the methods/attributes it has, not its declared type or ancestry.
- **Dynamic dispatch** — resolving which method implementation runs based on an object's actual runtime type.
- **Operator overloading** — defining dunder methods (`__add__`, `__eq__`, etc.) so built-in operators work on custom objects.
- **Dunder method** — a "double underscore" method (`__init__`, `__add__`, `__str__`) that hooks into Python's built-in syntax and protocols.

## Common Mistakes

- Writing `if isinstance(x, TypeA): ... elif isinstance(x, TypeB): ...` chains instead of letting polymorphism (a shared method each type implements) do the dispatching — a strong signal a method belongs on the classes themselves.
- Overriding `__eq__` and being surprised the object can no longer go in a `set` or be used as a dict key — Python disables the default `__hash__` the moment you define `__eq__`.
- Confusing duck typing (a Python/dynamic-language technique) with polymorphism (the general OOP concept) — duck typing is *one way* to achieve polymorphism, not a synonym for it.
- Forgetting `__repr__` entirely, leaving debug output as `<Vector object at 0x...>` instead of something inspectable.

## Interview Questions

1. **What is polymorphism, and give a real code example.**
   The ability of different types to respond to the same call with their own behavior. Example: `shape.area()` works identically in calling code whether `shape` is a `Circle` or `Square`, because each class supplies its own `area()`.

2. **What's duck typing, and how does it differ from polymorphism achieved via inheritance?**
   Duck typing treats an object as usable purely based on whether it has the right methods, without requiring a shared base class. Inheritance-based polymorphism requires the types to share an ancestor that defines the overridden method. Both achieve the same runtime effect through different mechanisms.

3. **What is dynamic dispatch?**
   The runtime process of choosing which method implementation to call based on the object's actual type, not the declared/static type of the variable referencing it.

4. **Why does defining `__eq__` without `__hash__` make instances unhashable?**
   Python assumes that if you customize equality, the default identity-based hash (which assumes equal objects are the same object) is no longer valid, so it sets `__hash__` to `None` automatically unless you explicitly define a compatible one.

5. **How does operator overloading relate to polymorphism?**
   It's polymorphism applied to syntax: `+` dispatches to `__add__` based on the operand's actual type, so the same operator means different things (integer addition, string concatenation, vector addition) depending on what it's used on.

## Suggested Next Lesson

[06 — Composition vs. Inheritance](../06-Composition-vs-Inheritance/README.md)
