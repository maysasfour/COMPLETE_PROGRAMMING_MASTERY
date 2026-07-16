# Exercise 01 — Overloaded `describe` Methods

[Back to lesson](../README.md)

## Task

Write three overloads of a static method `describe`:

- `describe(int n)` returns `"int: " + n`.
- `describe(String s)` returns `"String: " + s`.
- `describe(int n, String unit)` returns `n + " " + unit`.

Call all three and print the results.

## Constraints

- Must use genuine overloading (same method name, different parameter lists) — no single method with an `Object` parameter and `instanceof` checks.

## Starter Code

```java
static String describe(int n) { /* ... */ }
static String describe(String s) { /* ... */ }
static String describe(int n, String unit) { /* ... */ }

System.out.println(describe(42));
System.out.println(describe("hello"));
System.out.println(describe(5, "km"));
```

## Expected Output

```
int: 42
String: hello
5 km
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/Solution01.java](../Solutions/Solution01.java).
