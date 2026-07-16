# Solution 01 — Predict Before You Run

[Back to lesson](../README.md) | [Exercise](../Exercises/exercise-01.md)

Runnable code for every part lives in `solution-01.py`. Verified output:

```
Part 1: [1, 2, 3]
Part 2: [1, 2]
Part 3: blocked as expected -> can only concatenate str (not "int") to str
Part 4: 6
Fix A (cast the string): 6
Fix B (cast the int instead, build a string): 51
```

## Explanations

**Part 1 — `[1, 2, 3]`.**
`y = x` binds `y` to the exact same list object `x` refers to. `x.append(3)` mutates that one shared object, so reading it through either name shows the change.

**Part 2 — `[1, 2]`.**
`make_list()` returns a **new** list literal each time it's called. `x` and `y` end up as two different list objects that merely started out looking equal. Mutating `x` has zero effect on `y`'s separate object.

**Part 3 — `TypeError`.**
Python is **strongly typed**: it never silently converts `"5"` (str) and `1` (int) into a common type to make `+` work, unlike a weakly typed language (JavaScript would produce `"51"`). The error is not "Python doesn't support `+`" — it's that `+` refuses to guess which type you meant.

**Part 4 — `6`.**
`int(count)` is an explicit cast that converts the string `"5"` to the integer `5` before addition, sidestepping the strong-typing restriction by making the conversion deliberate instead of implicit.

## Reflection Answers

1. Part 1 and Part 2 differ in whether `x` and `y` were bound to the *same* object or *two separate* objects. `y = x` (Part 1) is aliasing — one object, two names. `make_list()` called twice (Part 2) constructs two distinct list objects that happen to have equal contents at first.

2. **Strong typing.** (Not "dynamic typing" — Python would still refuse this even if types were checked at compile time; the refusal is about disallowing implicit cross-type conversion, which is the strong/weak axis, not the static/dynamic axis.)

3. Two valid fixes:
   ```python
   int(count) + 1        # cast the string to int, then add
   count + str(1)        # cast the int to string, then concatenate
   ```
   These produce different results (`6` vs `"51"`) because they express different intents — numeric addition vs. string concatenation. Neither is "more correct"; the right one depends on what you're actually trying to compute.

## Common Pitfalls

- Predicting Part 2 also mutates both lists — this is the most common mistake, conflating "looks the same" with "is the same object."
- Assuming Part 3's error is a syntax error — it's a `TypeError`, raised at runtime when the incompatible operation actually executes, which is consistent with Python being dynamically typed (the problem isn't caught until that line runs).
