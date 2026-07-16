# Solution 01 — Shape Hierarchy with Polymorphic Area

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `Shape`'s `#name` is a true private field, accessible externally only through the `get name()` getter — neither `Rectangle` nor `Circle` needs its own name storage, they just pass the right string to `super(...)`.
- `totalArea` calls `shape.area()` on each element with no `instanceof` check anywhere — each subclass provides its own correct `area()`, so the polymorphic dispatch (JavaScript calling the right overridden method automatically based on the object's actual class) does all the work.
- The base `Shape.area()` deliberately throws, turning "someone instantiated a bare `Shape` and called `.area()` on it" into a loud, immediate error instead of a silent wrong answer (e.g., returning `0` or `undefined`).

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
Rectangle area: 20
Circle area: 28.274333882308138
totalArea([rect, circle]): 48.27433388230814
Base Shape.area() correctly throws: area() must be overridden by a subclass
```

`48.274...` matches the exercise's expected "approximately 48.27" exactly, and the base class's guard was confirmed to actually throw rather than silently returning something.
