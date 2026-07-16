# 04 — Inheritance

[Back to module overview](../README.md) | [Previous: Abstraction](../03-Abstraction/README.md)

## Beginner: Single Inheritance

**Inheritance** lets a class (the **subclass**/**child**) reuse and extend the attributes and methods of another class (the **superclass**/**parent**). A subclass automatically gets everything the parent defines, and can add new behavior or override existing behavior.

```python
class Animal:
    def __init__(self, name: str):
        self.name = name

    def speak(self) -> str:
        return f"{self.name} makes a sound"

class Dog(Animal):          # Dog IS-A Animal
    def speak(self) -> str:  # overrides Animal.speak
        return f"{self.name} barks"

rex = Dog("Rex")
print(rex.speak())   # "Rex barks" - Dog's version runs, not Animal's
print(rex.name)      # "Rex" - inherited from Animal.__init__, never redefined in Dog
```

## Beginner: `super()`

`super()` gives a subclass access to its parent's methods, most commonly to extend `__init__` rather than replace it entirely — you usually want the parent's setup to still happen, plus your own additions.

```python
class Dog(Animal):
    def __init__(self, name: str, breed: str):
        super().__init__(name)   # let Animal set up self.name
        self.breed = breed       # then add Dog-specific setup

rex = Dog("Rex", "Labrador")
print(rex.name, rex.breed)   # Rex Labrador
```

Without `super().__init__(name)`, `Dog.__init__` would need to duplicate `self.name = name` itself — fine for one field, a maintenance hazard once the parent's setup grows or changes.

## Intermediate: Method Resolution Order (MRO)

When a class inherits from multiple classes (or a chain of classes), Python needs a deterministic rule for which method wins if more than one ancestor defines it. This rule is the **Method Resolution Order**, computed by an algorithm called **C3 linearization**. You can inspect it directly:

```python
class A:
    def greet(self): return "A"

class B(A):
    def greet(self): return "B"

class C(A):
    def greet(self): return "C"

class D(B, C):
    pass

print(D.__mro__)
# (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)
print(D().greet())   # "B" - Python searches D, then B (found here), stopping before C
```

C3 linearization guarantees two things that a naive "search parents left to right, depth-first" approach doesn't: a subclass always appears before its parents, and the order of parents you declare (`class D(B, C)`) is preserved — `B` is always checked before `C`. This is what makes `super()` chains in multiple inheritance actually work predictably: each `super().__init__()` call moves to the *next* class in the MRO, not necessarily "my direct parent."

## Advanced: When Inheritance Is the Wrong Tool

Inheritance models an **"is-a"** relationship that should remain true for the entire lifetime of the design. It's the wrong tool when:

- The relationship is really **"has-a"** — a `Car` is not an `Engine`; a `Car` *has* an `Engine`. Modeling this with inheritance (`class Car(Engine)`) exposes engine internals as if they were car behavior, and breaks if a `Car` ever needs to swap engines at runtime.
- You're inheriting **just to reuse a couple of methods**, dragging in the entire parent interface (including methods that don't make sense for the subclass) — a classic case is `Stack(list)`, which reuses `append`, but now also exposes `insert(index, item)`, breaking the stack's own invariant that items only enter at one end.
- The hierarchy would need to represent **combinations that don't cleanly nest** — e.g., modeling `FlyingFish` under both `Fish` and `Bird` fights the tree-shaped nature of single inheritance and even multiple inheritance gets tangled fast.
- A change deep in a base class could unpredictably break many unrelated subclasses (the **fragile base class problem**) — the more subclasses depend on a base's internal behavior (not just its documented interface), the more fragile the whole tree becomes.

Lesson 06 walks through a concrete before/after refactor from a fragile inheritance hierarchy to composition.

## Real-World Usage

- GUI toolkits (Qt, Java Swing) model widgets with deep inheritance trees (`Button` → `AbstractButton` → `Component`) because "is-a" genuinely holds — a button really is a kind of component.
- Django's class-based views use inheritance and `super()` extensively (`class MyView(ListView)`) to reuse framework behavior while overriding specific hooks.
- Exception hierarchies (`FileNotFoundError` → `OSError` → `Exception`) are inheritance used exactly right: catching `OSError` catches every specific I/O error beneath it, because each one genuinely "is an" `OSError`.

## Summary

- Inheritance lets a subclass reuse and override a parent's attributes/methods; `super()` calls into the parent explicitly rather than duplicating its logic.
- MRO (computed via C3 linearization) defines a deterministic method lookup order for multiple inheritance — accessible via `Class.__mro__`.
- Inheritance should model a genuine, stable "is-a" relationship — reaching for it purely to reuse a few methods, or to model "has-a," usually creates a fragile design.
- Deep hierarchies risk the fragile base class problem: changes to a shared ancestor ripple unpredictably through everything beneath it.

## Key Terms

- **Superclass / Parent / Base class** — the class being inherited from.
- **Subclass / Child / Derived class** — the class that inherits.
- **`super()`** — a proxy object used to call methods on the next class in the MRO, most often the parent's `__init__`.
- **Override** — a subclass redefining a method that a parent already defines.
- **MRO (Method Resolution Order)** — the deterministic order Python searches classes to resolve a method or attribute lookup.
- **Fragile base class problem** — a design risk where changes to a shared base class unexpectedly break subclasses that depended on its internal behavior.

## Common Mistakes

- Forgetting to call `super().__init__()` in a subclass, silently skipping the parent's setup and leaving expected attributes missing.
- Inheriting purely to reuse a couple of methods, unintentionally exposing the entire parent interface (including methods that violate the subclass's own invariants).
- Assuming multiple inheritance searches parents in a naive depth-first order rather than checking the actual computed `__mro__`.
- Building "is-a" relationships that are only true today but likely to stop being true as requirements evolve (e.g., `Employee(Person)` when a `Person` might need to become an `Employee` and a `Customer` simultaneously — composition handles that; single inheritance doesn't).

## Interview Questions

1. **What does `super()` do, and why prefer it over calling the parent class by name directly?**
   `super()` returns a proxy that resolves to the next class in the MRO, not necessarily the literal parent — this makes it work correctly with multiple inheritance/cooperative `__init__` chains, where hardcoding `ParentClass.__init__(self, ...)` would break that cooperation.

2. **What is MRO, and how does Python compute it?**
   Method Resolution Order is the sequence Python searches when looking up a method or attribute on an instance whose class has multiple ancestors. Python computes it using C3 linearization, which guarantees subclasses precede parents and preserves declared parent order.

3. **When is inheritance the wrong choice, even though it "would work"?**
   When the relationship is really "has-a" rather than "is-a," when you're only inheriting to reuse a couple of methods (dragging in an unwanted interface), or when the hierarchy would need to model combinations that don't nest cleanly in a tree.

4. **What's the fragile base class problem?**
   A design risk in deep inheritance hierarchies where a change to a base class — even one that looks safe in isolation — can break subclasses that depended on the base's internal (undocumented) behavior, not just its public contract.

5. **Give an example of "is-a" done right and "is-a" done wrong.**
   Right: `FileNotFoundError` is genuinely an `OSError` — the relationship never stops being true. Wrong: `Stack(list)` — a stack is not "a list with extra methods," and inheriting from `list` exposes operations (like `insert` at an arbitrary index) that violate the stack's own invariant.

## Suggested Next Lesson

[05 — Polymorphism](../05-Polymorphism/README.md)
