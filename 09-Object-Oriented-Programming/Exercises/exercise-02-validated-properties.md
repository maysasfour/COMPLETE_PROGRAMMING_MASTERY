# Exercise 02 — Validated Properties

[Back to Exercises](README.md) | Covers: [Lesson 02 — Encapsulation](../02-Encapsulation/README.md)

**Difficulty: Beginner**

## Task

Write a `Temperature` class that stores a temperature in Celsius, using encapsulation to enforce a physical constraint: temperature cannot go below absolute zero (-273.15°C).

Requirements:

- Store the actual value in a protected attribute `_celsius`.
- Expose it through a `celsius` property with a getter and a setter.
- The setter must raise `ValueError` if the assigned value is less than `-273.15`.
- Add a read-only computed property `fahrenheit` that returns `celsius * 9/5 + 32` (no setter).
- The constructor must accept an initial value and route it through the same validation (don't duplicate the check).

## Expected Behavior

```python
t = Temperature(25)
print(t.celsius)      # 25
print(t.fahrenheit)    # 77.0

t.celsius = -300       # should raise ValueError
```

```python
t.fahrenheit = 100     # should raise AttributeError (no setter)
```

## Reflection Questions

1. Why route the constructor's initial value through the `celsius` property setter instead of assigning `self._celsius = celsius` directly in `__init__`?
2. What real-world bug does the -273.15 validation prevent that a plain public attribute would allow?

## Deliverable

A runnable `.py` file demonstrating both the valid case and both rejected cases (via `try`/`except`), plus written answers to the reflection questions.
