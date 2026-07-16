# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Beginner: Classes and `__init__`

A class is a blueprint for creating objects that bundle data (attributes) and behavior (methods) together.

```python
class Dog:
    def __init__(self, name, breed):
        self.name = name    # instance attribute - unique to each object
        self.breed = breed

    def bark(self):
        return f"{self.name} says Woof!"

rex = Dog("Rex", "Labrador")
print(rex.bark())    # Rex says Woof!
```

`__init__` is the **initializer**, automatically called when you create a new instance (`Dog("Rex", "Labrador")`). `self` is the instance itself, explicitly passed as the first parameter to every instance method — Python doesn't hide this the way some languages do; you always see `self` in the method signature and use it to access the instance's own attributes.

## Beginner: Instance vs. Class Attributes

```python
class Dog:
    species = "Canis familiaris"   # class attribute - shared by ALL instances

    def __init__(self, name):
        self.name = name            # instance attribute - unique per instance

rex = Dog("Rex")
fido = Dog("Fido")
print(rex.species, fido.species)    # both see the same class attribute
Dog.species = "Canis lupus familiaris"
print(rex.species)                  # changing it on the class affects all instances

rex.name = "Rex Jr."                # this only affects rex, not fido
print(rex.name, fido.name)
```

A class attribute is defined directly in the class body (not inside `__init__`) and is shared across every instance unless a specific instance shadows it by assigning its own instance attribute of the same name. This is a common trap with **mutable** class attributes (like a list) — mutating them affects every instance, since they all share the exact same object (analogous to the mutable default argument bug from Lesson 06).

## Intermediate: Inheritance

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError("subclasses must implement speak()")

class Cat(Animal):
    def speak(self):
        return f"{self.name} says Meow!"

class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name)   # calls Animal's __init__ to set self.name
        self.breed = breed

    def speak(self):
        return f"{self.name} says Woof!"

for animal in [Cat("Whiskers"), Dog("Rex", "Labrador")]:
    print(animal.speak())
```

`class Dog(Animal):` makes `Dog` a subclass of `Animal`, inheriting its methods and attributes. `super().__init__(name)` calls the parent class's `__init__` instead of duplicating its logic — essential once a subclass needs to extend, not replace, the parent's setup. Overriding `speak()` in each subclass while defining it (as a placeholder that raises) on the base class is a common way to say "every subclass must provide its own version."

## Intermediate: Dunder Methods

"Dunder" (double underscore) methods let your objects work with Python's built-in syntax and functions instead of requiring custom method calls.

```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Point({self.x}, {self.y})"     # unambiguous, dev-facing representation

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

p1 = Point(1, 2)
p2 = Point(3, 4)
print(p1 + p2)          # Point(4, 6) - uses __add__
print(p1 == Point(1, 2))  # True - uses __eq__
print(p1)               # Point(1, 2) - uses __repr__
```

Without `__repr__`, printing an object shows an unhelpful default like `<__main__.Point object at 0x...>`. Without `__eq__`, `==` falls back to identity comparison (same as `is`), so two different `Point` objects with identical coordinates would compare as unequal. `__str__` (used by `print()` and `str()`) falls back to `__repr__` if not separately defined — define `__repr__` first; add `__str__` only if you want a different, more human-friendly display than the developer-facing `__repr__`.

## Advanced: Properties

`@property` lets a method be accessed like a plain attribute, enabling validation or computed values without changing the calling code's syntax.

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius   # leading underscore signals "internal, don't touch directly"

    @property
    def radius(self):
        return self._radius

    @radius.setter
    def radius(self, value):
        if value <= 0:
            raise ValueError("radius must be positive")
        self._radius = value

    @property
    def area(self):             # read-only computed property - no setter defined
        return 3.14159 * self._radius ** 2

c = Circle(5)
print(c.radius)      # 5 - looks like plain attribute access, but calls the getter
print(c.area)        # 78.53975 - computed on every access, not stored
c.radius = 10        # calls the setter, which validates
# c.radius = -1      # raises ValueError - the setter rejects it
# c.area = 100       # raises AttributeError - no setter defined for area
```

Properties let you start with plain public attributes and add validation/computation later **without breaking any code that already does `obj.radius`** — that calling code doesn't need to change to `obj.get_radius()`, which is why Python favors properties over getter/setter method pairs common in other languages.

## Real-World Usage

- Web frameworks (Django models, FastAPI/Pydantic models) are class-based, using `__init__`-like patterns (or dataclasses) to represent database rows or request/response bodies.
- Custom exception hierarchies (Lesson 09) are built entirely on inheritance — `class InsufficientFundsError(Exception):`.
- `__eq__`/`__lt__`/`__hash__` and friends let custom objects work naturally with `sorted()`, `in`, sets, and dict keys.
- Properties are common for validated model fields (e.g., an `age` property that rejects negative numbers) and for computed values that shouldn't be manually kept in sync (like `area` derived from `radius`).

## Summary

- `__init__` initializes a new instance; `self` refers to that instance and is always the first parameter of instance methods.
- Instance attributes (set via `self.x = ...`) are unique per object; class attributes (defined in the class body) are shared across all instances unless shadowed.
- `class Child(Parent):` creates inheritance; `super().__init__(...)` calls the parent's initializer instead of duplicating its logic.
- Dunder methods (`__repr__`, `__eq__`, `__add__`, etc.) let custom objects integrate with built-in syntax and functions.
- `@property` (plus `@x.setter`) exposes a method as attribute-like access, enabling validation or computed values while keeping the calling syntax unchanged.

## Key Terms

- **Instance** — a specific object created from a class, with its own instance attributes.
- **`self`** — the instance itself, explicitly passed as the first parameter of instance methods.
- **Inheritance** — a class (subclass) deriving attributes/methods from another (base/parent class), via `class Child(Parent):`.
- **`super()`** — a reference to the parent class, most commonly used to call its `__init__` from a subclass's own `__init__`.
- **Dunder method** — a "double underscore" method (`__init__`, `__repr__`, `__eq__`, etc.) that hooks a class into Python's built-in syntax/behavior.
- **Property** — a method exposed via attribute-access syntax using `@property` (and optionally `@x.setter`), for validation or computed values.

## Common Mistakes

- Forgetting `self` as the first parameter of an instance method, causing a `TypeError` about missing/extra arguments when the method is called.
- Using a mutable class attribute (like `tags = []`) expecting each instance to get its own independent list — they all share the exact same list object.
- Overriding `__init__` in a subclass and forgetting to call `super().__init__(...)`, so the parent's setup logic never runs.
- Defining `__eq__` without also defining `__hash__` — by default, defining `__eq__` makes instances unhashable (can't be dict keys/set members) unless `__hash__` is explicitly provided too.
- Adding a `@property` setter that doesn't validate anything, missing the entire point of using a property over a plain public attribute.

## Best Practices

- Prefix "internal use only" attributes with a single leading underscore (`self._radius`) as a convention signaling "don't access this directly from outside the class" (Python has no true private attributes).
- Always call `super().__init__(...)` in a subclass's `__init__` unless you deliberately want to skip the parent's setup.
- Define `__repr__` on any class whose instances might end up printed or shown in a debugger/REPL — the default representation is rarely useful.
- Use `@property` when a method has no side effects and semantically represents "a value the object has," not "an action the object performs."
- Keep class hierarchies shallow; prefer composition (one object holding another) over deep inheritance chains when the relationship isn't a clean "is-a."

## Interview Questions

1. **What's the difference between an instance attribute and a class attribute?**
   An instance attribute is set via `self.x = ...` (typically in `__init__`) and belongs to one specific object. A class attribute is defined directly in the class body and is shared by every instance of the class unless a particular instance shadows it with its own instance attribute of the same name.

2. **What does `super().__init__(...)` do, and why would you call it in a subclass?**
   It calls the parent class's `__init__` method, letting the subclass reuse the parent's setup logic (e.g., setting common attributes) instead of duplicating that code. It's typically called at the start of the subclass's own `__init__`, before adding any subclass-specific setup.

3. **Why would you define `__eq__` on a custom class?**
   Without it, `==` between two instances falls back to identity comparison (equivalent to `is`), so two objects with identical data would compare as unequal. Defining `__eq__` lets you specify value-based equality — e.g., two `Point` objects with the same `x`/`y` should be considered equal.

4. **What's the point of `@property` instead of a plain public attribute?**
   It lets you add validation logic or computed behavior behind attribute-access syntax (`obj.radius` instead of `obj.get_radius()`), so callers don't need to change their code if you later need to validate assignments or compute a value on the fly rather than store it directly.

5. **Python doesn't have true private attributes like some languages — how is "privacy" signaled instead?**
   By convention: a single leading underscore (`_radius`) signals "internal use, don't touch from outside," and a double leading underscore (`__radius`) triggers name mangling (renamed internally to `_ClassName__radius`), making accidental access or subclass name collisions less likely — but neither is enforced by the language; it's a convention, not access control.

## Suggested Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
