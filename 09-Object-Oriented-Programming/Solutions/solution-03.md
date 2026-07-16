# Solution 03 — Shape Hierarchy with an ABC

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-03-shape-abc.md) | [Code](solution-03.py)

## Approach

`Shape` extends `abc.ABC` and declares `area()` and `perimeter()` as `@abstractmethod` — this is what makes `Shape()` itself uninstantiable, and forces every concrete subclass to supply both methods before Python will allow an instance to be created.

`describe()` is deliberately **not** abstract and **not** overridden anywhere. It's written once, on `Shape`, using `type(self).__name__` (rather than a hardcoded class name) and calling `self.area()` / `self.perimeter()` — both of which resolve polymorphically to whichever subclass's implementation is appropriate for the actual object. This is the abstraction payoff: one method definition serves every current and future subclass, because it depends only on the abstract *contract*, not on any subclass's *implementation details*.

`Square` inherits from `Rectangle`, not from `Shape` directly, and its `__init__` simply calls `super().__init__(side, side)`. This reuses `Rectangle.area()` and `Rectangle.perimeter()` verbatim — a square's area/perimeter formulas are exactly a rectangle's formulas with `width == height`, so there's no reason to reimplement them.

`total_area()` sums `s.area()` over a mixed list with no `isinstance` branching at all — this only works *because* every element is guaranteed (by the ABC) to have a working `area()` method, which is the entire point of programming against an abstraction instead of a family of concrete types.

## Why This Design

The alternative — giving `Square` its own independent `area`/`perimeter` implementation, or making it inherit from `Shape` directly and duplicate `Rectangle`'s formulas — would work but violates DRY for no benefit. Reusing `Rectangle` via inheritance is appropriate here specifically because both classes are effectively immutable value objects with no methods that would break the "a square's width always equals its height" invariant (see Reflection 2 for the caveat).

## Verified Output

```
Circle: area=78.54, perimeter=31.42
Rectangle: area=12.00, perimeter=14.00
Square: area=4.00, perimeter=8.00
94.53981633974475
Cannot instantiate Shape directly: Can't instantiate abstract class Shape without an implementation for abstract methods 'area', 'perimeter'
```

The `total_area` result prints with full float precision (`94.53981633974475`) rather than the exercise's rounded `94.54` — the underlying value matches (`94.54` when formatted to 2 decimal places), the difference is purely display formatting, which the exercise's `describe()` output already handles correctly with `:.2f`.

## Reflection Answers

1. `Shape()` raises `TypeError: Can't instantiate abstract class Shape without an implementation for abstract methods 'area', 'perimeter'`. This happens because `abc.ABCMeta` (the metaclass behind `ABC`) checks, at instantiation time, whether every method marked `@abstractmethod` in the class or its bases has been overridden by a concrete implementation; if not, object creation is refused outright.

2. `Square(Rectangle)` is a legitimate "is-a" relationship *only as long as both types stay immutable after construction* — which they do here, since neither class exposes any mutating methods. It would become illegitimate the moment `Rectangle` grew a method like `stretch_width(amount)`: calling `square_instance.stretch_width(5)` would change only the width, leaving the object with `width != height` — no longer a valid square, even though its type is still `Square`. This is a textbook violation of the Liskov Substitution Principle (a `Square` should be usable anywhere a `Rectangle` is expected without surprising behavior, but `stretch_width` breaks that). In a codebase where `Rectangle` might realistically grow such a method, favoring composition (a `Square` that *has a* private `Rectangle` rather than *is a* `Rectangle`) would be the safer long-term design — see Lesson 06.
