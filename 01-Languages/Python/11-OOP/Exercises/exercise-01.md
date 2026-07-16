# Exercise 01 — Shape Hierarchy with Validated Properties

[Back to lesson](../README.md)

## Task

Build a small class hierarchy for 2D shapes, using inheritance, a dunder method, and a validated `@property`:

1. A base class `Shape` with:
   - `__init__(self, name)` storing `self.name`
   - a method `area(self)` that raises `NotImplementedError("subclasses must implement area()")`
   - `__repr__` returning something like `"Shape(name=generic)"` (subclasses will override this or reuse it via `super()` — your choice, but be consistent)

2. A subclass `Rectangle(Shape)` with:
   - `__init__(self, width, height)` calling `super().__init__("rectangle")` and storing `width`/`height` as **validated properties**: a `@property`/`@setter` pair for each that raises `ValueError` if set to a value `<= 0`
   - `area(self)` returning `width * height`
   - `__repr__` returning `"Rectangle(width=W, height=H)"`

3. A subclass `Square(Rectangle)` with:
   - `__init__(self, side)` — reuse `Rectangle`'s `__init__` via `super()` by passing `side` as both width and height (don't duplicate the validation logic)
   - override `__repr__` to return `"Square(side=S)"` instead of the Rectangle-style repr

4. A subclass `Circle(Shape)` with:
   - `__init__(self, radius)` calling `super().__init__("circle")`, storing radius as a validated property (same `<= 0` rule)
   - `area(self)` returning `3.14159 * radius ** 2`
   - `__repr__` returning `"Circle(radius=R)"`

Then write a function `total_area(shapes)` that takes a list of `Shape` instances and returns the sum of calling `.area()` on each — this should work polymorphically regardless of which subclass each shape actually is.

Demonstrate: create one of each shape, print each one (using its `__repr__`), print each one's area, print the `total_area` of all three together, and show that constructing a `Rectangle(width=-5, height=2)` raises `ValueError`.

## Reflection Questions

1. Why does `Square` inheriting from `Rectangle` (rather than directly from `Shape`) let you avoid rewriting the width/height validation logic? What would you have lost if `Square` inherited from `Shape` directly instead?
2. `total_area` calls `.area()` on each shape without checking what specific subclass it is. What is this behavior called, and why does the base class's `area()` raising `NotImplementedError` (rather than, say, returning `0`) make sense as a design choice?
3. Why are `width`/`height`/`radius` implemented as properties with validation, instead of plain public attributes that any code could set directly to any value, including negative numbers?

## Deliverable

A working script implementing the full hierarchy and `total_area`, demonstrating all the required behavior including the validation error, plus answers to the three reflection questions. Do not peek at `Solutions/solution-01.py` until you've attempted your own version.
