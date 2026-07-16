# 01 — Classes and Objects

[Back to module overview](../README.md)

## Beginner: What a Class and an Object Actually Are

A **class** is a blueprint — it describes what data an object will hold and what it can do, but it isn't itself a "thing" you can act on. An **object** (or **instance**) is a concrete thing built from that blueprint, living in memory, with its own data.

```python
class Dog:
    pass

my_dog = Dog()   # my_dog is an OBJECT (an instance) of the CLASS Dog
```

The class `Dog` describes "a dog" in the abstract. `my_dog` is one specific dog. You can create as many independent objects from one class as you want, and each one is distinct.

## Beginner: `__init__` and Instance Attributes

`__init__` is the **initializer** — it runs automatically when an object is created, and its job is to set up that object's starting state. `self` refers to the specific object being created; every attribute you assign to `self` becomes an **instance attribute**, meaning it belongs to that one object, not to the class itself or to any other instance.

```python
class Dog:
    def __init__(self, name: str, breed: str):
        self.name = name
        self.breed = breed

rex = Dog("Rex", "Labrador")
fido = Dog("Fido", "Poodle")
print(rex.name, fido.name)   # Rex Fido - independent data per object
```

`__init__` is not a constructor in the strict sense (Python actually constructs the object via `__new__` first, then calls `__init__` to initialize it), but for everyday purposes, treat `__init__` as "the setup code that runs when you create one of these."

## Intermediate: Instance Attributes vs. Class Attributes

An **instance attribute** lives on `self` and is unique per object. A **class attribute** is defined directly in the class body (not inside a method) and is shared by every instance unless a specific instance overrides it.

```python
class Dog:
    species = "Canis familiaris"   # CLASS attribute - shared by every Dog

    def __init__(self, name: str):
        self.name = name           # INSTANCE attribute - unique per Dog

rex = Dog("Rex")
fido = Dog("Fido")
print(rex.species, fido.species)   # both see the same shared value
```

This is genuinely useful for constants that describe the whole category (a species name, a default configuration, a running counter of how many instances exist) — but it is a classic trap with **mutable** class attributes:

```python
class Broken:
    items = []   # DANGER: one shared list for every instance

    def add(self, item):
        self.items.append(item)   # mutates the SHARED class-level list

a, b = Broken(), Broken()
a.add("x")
print(b.items)   # ['x'] - b sees a's data because there was only ever one list
```

The fix is to create the mutable value inside `__init__`, so each instance gets its own:

```python
class Fixed:
    def __init__(self):
        self.items = []   # a fresh list PER INSTANCE
```

## Advanced: Object Identity vs. Equality

Every object has an **identity** (where it lives in memory, exposed via `id()`), a **type**, and a **value**. Two variables can refer to the *same* object (identity) or to two *different* objects that merely compare as *equal* by value. Python distinguishes these with `is` (identity) and `==` (equality, which by default falls back to identity unless a class defines `__eq__`).

```python
a = Dog("Rex")
b = a               # b is bound to the SAME object as a
c = Dog("Rex")       # c is a DIFFERENT object with equal-looking data

print(a is b)   # True  - same object
print(a is c)   # False - two distinct objects
print(a == c)   # False by default - Dog hasn't defined __eq__, so == falls back to identity
```

This matters constantly in real code: `is None` is preferred over `== None` specifically because identity comparison for singletons like `None` is both faster and immune to a class redefining `__eq__` in a way that breaks `== None`.

## Real-World Usage

- Every ORM row (Django model instance, SQLAlchemy row) is an object: class = table schema, instance = one row's data.
- Class attributes are how you implement shared configuration or counters — e.g., a `Connection` class tracking `active_connections` as a class attribute incremented in `__init__` and decremented in a cleanup method.
- Identity vs. equality bugs are a classic source of production incidents: caching layers, deduplication logic, and `in` checks against lists of custom objects all depend on getting `__eq__`/`__hash__` right (Lesson 05 covers overriding `__eq__`).

## Summary

- A class is a blueprint; an object is a specific instance built from it, with independent data.
- `__init__` sets up an object's initial state; attributes assigned to `self` are instance attributes, unique per object.
- Class attributes (defined in the class body) are shared across instances — useful for true constants, dangerous for mutable defaults.
- `is` checks identity (same object in memory); `==` checks equality (same value), which defaults to identity unless overridden.

## Key Terms

- **Class** — a blueprint describing the attributes and methods of a category of objects.
- **Object / Instance** — a concrete, independent thing created from a class.
- **`__init__`** — the initializer method that sets up a new instance's starting state.
- **Instance attribute** — data stored on `self`, unique to one object.
- **Class attribute** — data stored on the class itself, shared by all instances unless overridden.
- **Identity** — whether two references point to the exact same object in memory (`is`).
- **Equality** — whether two objects are considered equal by value (`==`).

## Common Mistakes

- Using a mutable class attribute (list/dict) as a default that ends up shared across every instance.
- Forgetting `self` as the first parameter of an instance method — Python won't infer it for you.
- Using `==` when you actually mean `is` (or vice versa) — especially with `None`, where `is None` is idiomatic.
- Assuming every attribute must be set in `__init__`; forgetting you can also set attributes later (`obj.new_attr = value`), which technically works but usually signals a design that needs tightening.

## Interview Questions

1. **What's the difference between a class and an object?**
   A class is the blueprint/definition; an object is a specific instance created from that blueprint, with its own independent data in memory.

2. **What does `self` represent, and why must it be the first parameter of instance methods?**
   `self` is the specific object the method was called on. Python passes it automatically when you call `obj.method()`, which is sugar for `Class.method(obj)` — the method needs a reference to know which object's data to operate on.

3. **What's the danger of a mutable default value as a class attribute?**
   All instances share the *same* underlying object until an instance attribute of the same name shadows it. Mutating it through one instance (e.g., `self.items.append(...)`) is visible through every other instance, because there was only ever one list.

4. **What's the difference between `is` and `==`?**
   `is` compares object identity (same object in memory). `==` compares equality, which by default also checks identity unless the class overrides `__eq__` to define value-based equality.

5. **If two `Dog` objects have identical `name` and `breed`, does `dog1 == dog2` return `True`?**
   Not unless `Dog` defines `__eq__`. Without it, `==` falls back to identity comparison, so two separately-constructed objects with equal-looking data compare as unequal.

## Suggested Next Lesson

[02 — Encapsulation](../02-Encapsulation/README.md)
