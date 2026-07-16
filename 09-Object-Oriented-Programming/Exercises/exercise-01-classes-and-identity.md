# Exercise 01 — Classes and Object Identity

[Back to Exercises](README.md) | Covers: [Lesson 01 — Classes and Objects](../01-Classes-and-Objects/README.md)

**Difficulty: Beginner**

## Task

Write a `Point` class with:

- `__init__(self, x, y)` storing `x` and `y` as instance attributes.
- A class attribute `origin_label = "Point"` shared by all instances.
- A method `distance_from_origin(self)` returning `(x**2 + y**2) ** 0.5`.

Then, in a script:

1. Create `p1 = Point(3, 4)` and `p2 = Point(3, 4)`.
2. Print `p1 is p2` and explain in a comment why it's `False` even though the coordinates match.
3. Set `p3 = p1` and print `p1 is p3` — explain why this one is `True`.
4. Print `p1 == p2` and explain why it's also `False` by default.
5. Print `p1.distance_from_origin()` — should be `5.0` for `(3, 4)`.

## Reflection Questions

1. What would you need to add to `Point` to make `p1 == p2` return `True` when their coordinates match?
2. If you added a mutable class attribute like `history = []` intended to track all created points, what bug would you introduce, and how would you fix it?

## Deliverable

A runnable `.py` file producing the five printed results, plus written answers to both reflection questions.
