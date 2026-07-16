# Solution 01 — Overloaded `describe` Methods

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

Three distinct `describe` overloads share a name but differ in parameter count/type, letting the compiler pick the correct one at each call site based purely on the arguments' compile-time types — `describe(42)` resolves to the `int` overload, `describe("hello")` to the `String` overload, and `describe(5, "km")` to the two-parameter overload, entirely at compile time with no runtime type-checking needed.

## Verification

Ran with `java Solutions/Solution01.java`; actual output:

```
int: 42
String: hello
5 km
```

Matches the exercise's expected output exactly.
