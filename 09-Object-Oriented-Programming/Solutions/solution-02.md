# Solution 02 — Validated Properties

[Back to Solutions](README.md) | [Exercise](../Exercises/exercise-02-validated-properties.md) | [Code](solution-02.py)

## Approach

The core requirement is that `_celsius` can never hold a physically impossible value, and that this guarantee holds no matter *how* a caller tries to set it — at construction time or later via assignment. That means the validation must live in exactly one place: the `celsius` property's setter.

The constructor doesn't do `self._celsius = celsius` directly. Instead it does `self.celsius = celsius`, which — because `celsius` is a property — routes through the exact same setter that validates every later assignment. This is the single most important design decision in the solution: it eliminates the possibility of the validation logic drifting out of sync between "construction-time" and "assignment-time" checks, because there's only one check.

`fahrenheit` is a read-only computed property: it has a getter (`@property`) but no corresponding `@fahrenheit.setter`. This isn't a workaround — it's exactly what "read-only" means in Python's property system. Attempting `t.fahrenheit = 100` raises `AttributeError` automatically, with no code written to detect or reject the assignment; the absence of a setter *is* the enforcement.

## Why This Design

An alternative would be to validate separately in `__init__` and in the setter, but that duplicates the `-273.15` check and the two copies can silently diverge if one is edited later. Routing everything through the property is the standard idiom precisely because it collapses "validate at construction" and "validate at assignment" into the same code path.

## Verified Output

```
25
77.0
Rejected: -300°C is below absolute zero (-273.15°C)
Rejected: property 'fahrenheit' of 'Temperature' object has no setter
```

Matches the exercise's expected behavior: valid construction and read succeed, an out-of-range `celsius` assignment raises `ValueError`, and assigning `fahrenheit` raises `AttributeError`.

## Reflection Answers

1. Routing the constructor through the `celsius` property setter means the validation rule is written once. If `__init__` instead assigned `self._celsius = celsius` directly, the -273.15 check would need to be duplicated in `__init__`, and any future change to the validation logic (e.g., adding a maximum plausible temperature) would require remembering to update both places — a classic source of bugs where one code path gets fixed and the other doesn't.

2. A plain public `celsius` attribute would let any caller assign `t.celsius = -1000` with no error raised anywhere. That's not just cosmetically wrong — it would silently corrupt any downstream calculation relying on the value being physically meaningful (e.g., the `fahrenheit` conversion would return a nonsensical number, or a physics simulation using this `Temperature` would produce garbage results without ever signaling that something went wrong).
