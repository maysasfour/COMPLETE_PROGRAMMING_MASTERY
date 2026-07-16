# Solution 01 — Shape Hierarchy with Validated Properties

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code lives in `solution-01.py`. Verified output:

```
Rectangle(width=4, height=3)
Square(side=5)
Circle(radius=2)
rectangle area -> 12
square area -> 25
circle area -> 12.56636
total_area -> 49.56636
invalid rectangle rejected: width must be positive, got -5
```

## Explanation

`Shape.area()` raises `NotImplementedError` rather than being left out entirely — that way, if a future subclass forgets to override it, calling `.area()` fails loudly and immediately with a clear message, instead of silently doing nothing or (worse) returning a wrong default like `0`.

`Rectangle` stores `width`/`height` behind `@property`/`@setter` pairs, and crucially its `__init__` assigns through `self.width = width` (the property) rather than `self._width = width` (the raw attribute) — that's what makes construction and later mutation share exactly one validation path:

```python
def __init__(self, width, height):
    super().__init__("rectangle")
    self.width = width    # goes through the width.setter, not a raw assignment
    self.height = height
```

`Square(Rectangle)` reuses that validation entirely for free:

```python
class Square(Rectangle):
    def __init__(self, side):
        super().__init__(side, side)
```

`Square` overrides only `__repr__`, since its display format genuinely differs from `Rectangle`'s — everything else (`area()`, the validated `width`/`height` properties) is inherited unchanged.

`total_area` sums `.area()` across a mixed list of shapes without ever branching on type:

```python
def total_area(shapes):
    return sum(shape.area() for shape in shapes)
```

## Reflection Answers

1. `Square` inheriting from `Rectangle` means it automatically gets `Rectangle`'s validated `width`/`height` properties and its `area()` implementation, just by passing `side` in for both dimensions via `super().__init__(side, side)`. If `Square` inherited from `Shape` directly, it would need its own `side` property with its own `<= 0` validation logic and its own `area()` method (`side ** 2`) — duplicating almost the exact same validation code that already exists on `Rectangle`, with all the maintenance risk that duplication implies (e.g., fixing a validation bug in one place but forgetting the other).

2. This is called **polymorphism** — calling the same method name (`.area()`) on objects of different types and having each one execute its own type-specific implementation, without the caller needing to know or check which concrete type it's dealing with. `NotImplementedError` (rather than returning `0`) is the right default because a shape with no defined area calculation is a programming error waiting to be caught during development — returning `0` would let that mistake silently corrupt any code that sums or compares areas, while raising surfaces the bug immediately and clearly.

3. Plain public attributes would let any calling code assign `rectangle.width = -5` or `circle.radius = 0` with no resistance, producing shapes with nonsensical negative or zero dimensions that would then silently produce wrong (or nonsensical, like negative) areas downstream. Wrapping them in validated properties means every assignment — whether during `__init__` or later mutation — is forced through the same `<= 0` check, so invalid states are rejected at the moment they'd be created rather than discovered much later when some unrelated calculation produces a strange result.

## Common Pitfalls

- Writing `Square.__init__` to duplicate `Rectangle`'s validation logic instead of calling `super().__init__(side, side)`, missing the entire point of inheriting from `Rectangle` rather than `Shape`.
- Assigning `self._width = width` directly in `__init__` instead of `self.width = width`, which bypasses the setter's validation entirely for the initial value (only later mutations would be checked).
- Forgetting to override `__repr__` in `Square`, leaving it displayed as `"Rectangle(width=5, height=5)"` instead of the more meaningful `"Square(side=5)"`.
- Having `total_area` check `isinstance()` for each shape type instead of trusting polymorphism — this defeats the purpose of designing a common `area()` interface in the first place.
