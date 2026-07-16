# Solution 01 — Classes and Object Identity

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-01-classes-and-identity.md) | [Code](solution-01.py)

## Approach

`Point` needs one class attribute (`origin_label`, a true constant shared by every point — there's no reason each instance should carry its own copy of an unchanging label) and two instance attributes (`x`, `y`, which are obviously per-object data). `distance_from_origin` is a plain instance method using the Pythagorean formula.

The interesting part of this exercise isn't the class itself — it's the four printed comparisons, which exist to make the identity/equality distinction concrete rather than abstract:

- `p1 is p2` is `False` because `Point(3, 4)` was called twice, once per variable. Each call runs `__init__` and produces a distinct object at a distinct memory address, regardless of what values got stored inside.
- `p1 is p3` is `True` because `p3 = p1` doesn't construct anything — it just makes `p3` a second name for the *same* object `p1` already refers to. No `Point(...)` call happened.
- `p1 == p2` is `False` because `Point` never overrides `__eq__`. Python's default `__eq__` (inherited from `object`) falls back to identity comparison — the exact same check as `is` — so two distinct-but-equal-looking objects compare unequal until you explicitly tell Python what "equal" means for this type.

## Why This Design

Class attributes are the right tool specifically when a value is meant to be shared and read-only in practice (a label, a species name, a configuration constant). The moment a "shared" value needs to be *mutated per instance* (as in the reflection question about `history`), a class attribute becomes the wrong tool — mutating it through any one instance mutates it for all of them, because there was only ever one underlying object.

## Verified Output

```
False
True
False
5.0
```

Matches the exercise's expected behavior exactly.

## Reflection Answers

1. To make `p1 == p2` return `True` for matching coordinates, define `__eq__` explicitly:
   ```python
   def __eq__(self, other):
       return isinstance(other, Point) and (self.x, self.y) == (other.x, other.y)
   ```
   Without this, Python has no way to know that two `Point`s with equal coordinates should be considered "the same" for comparison purposes — value equality is something each class must opt into.

2. A mutable class attribute like `history = []` would be shared across every instance, exactly like the `Broken.items` example in Lesson 01: appending to it via one instance (`self.history.append(self)`) would make that same appended data visible through *every* `Point` instance's `.history`, because there's only ever one list object. The fix is to move it into `__init__` as `self.history = []`, giving each instance its own independent list.
