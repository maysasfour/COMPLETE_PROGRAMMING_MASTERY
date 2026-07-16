# Exercise 03 — Shape Hierarchy with an ABC

[Back to Exercises](README.md) | Covers: [Lesson 03 — Abstraction](../03-Abstraction/README.md), [Lesson 04 — Inheritance](../04-Inheritance/README.md)

**Difficulty: Intermediate**

## Task

Design a small shape hierarchy using `abc.ABC`:

1. An abstract `Shape` class with abstract methods `area()` and `perimeter()`, plus a **concrete** method `describe()` that returns a string like `"Circle: area=78.54, perimeter=31.42"` (the class name is available via `type(self).__name__`) — this method should NOT be overridden by subclasses, only inherited.
2. Concrete subclasses `Circle(radius)`, `Rectangle(width, height)`, and `Square(side)`.
3. `Square` should reuse `Rectangle`'s logic rather than reimplementing `area`/`perimeter` from scratch (hint: what's the relationship between a square and a rectangle, and does `super().__init__()` help here?).
4. A function `total_area(shapes: list[Shape]) -> float` that sums the area of a mixed list of shapes without any `isinstance` checks.

## Expected Behavior

```python
shapes = [Circle(5), Rectangle(3, 4), Square(2)]
for s in shapes:
    print(s.describe())
# Circle: area=78.54, perimeter=31.42
# Rectangle: area=12.00, perimeter=14.00
# Square: area=4.00, perimeter=8.00

print(total_area(shapes))   # 94.54
```

## Reflection Questions

1. Why can't you instantiate `Shape` directly, and what specific error does Python raise if you try?
2. Is `Square(Rectangle)` a legitimate "is-a" relationship (per Lesson 04's guidance on when inheritance fits)? Why or why not — would this design cause problems if `Rectangle` later grew a `stretch_width(amount)` method?

## Deliverable

A runnable `.py` file producing the exact output shown above, plus written answers to both reflection questions.
