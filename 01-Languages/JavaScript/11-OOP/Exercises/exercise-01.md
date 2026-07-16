# Exercise 01 — Shape Hierarchy with Polymorphic Area

[Back to lesson](../README.md)

## Task

Build a small shape hierarchy:

- A base class `Shape` with a private field `#name` (set via the constructor), a getter `name`, and a method `area()` that throws an `Error` saying it must be overridden (this base class is never meant to be instantiated directly for area purposes).
- `Rectangle extends Shape`, storing `width`/`height`, overriding `area()` correctly.
- `Circle extends Shape`, storing `radius`, overriding `area()` correctly (`Math.PI * radius ** 2`).
- A function `totalArea(shapes)` that takes an array of `Shape` instances and returns the sum of all their areas, using `.reduce()`.

## Constraints

- `Shape`'s constructor must accept and store the shape's `name` as a true private field (`#name`), exposed only via a getter.
- `totalArea` must work on a mixed array of `Rectangle` and `Circle` instances without any `instanceof` checks — pure polymorphism, each shape computing its own area.

## Starter Code

```js
class Shape {
  #name;
  constructor(name) { this.#name = name; }
  get name() { return this.#name; }
  area() { throw new Error("area() must be overridden"); }
}

class Rectangle extends Shape { /* ... */ }
class Circle extends Shape { /* ... */ }

function totalArea(shapes) {
  return shapes.reduce((sum, shape) => sum + shape.area(), 0);
}
```

## Expected Output

For a `Rectangle(4, 5)` (area 20) and a `Circle(3)` (area ≈28.274), `totalArea([rect, circle])` should be approximately `48.27`.

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
