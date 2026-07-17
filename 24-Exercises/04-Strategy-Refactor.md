# Exercise 04 — Strategy Pattern Refactor

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/04-Strategy-Refactor/README.md)

**Combines:** [12-Design-Patterns](../12-Design-Patterns/README.md) (Strategy) + [11-Design-Principles](../11-Design-Principles/README.md) (Open/Closed Principle)

## Problem

You're given a `ShippingCostCalculator` that computes shipping cost via an `if`/`else if` chain based on a `String method`:

```java
double calculate(String method, double weightKg) {
    if (method.equals("standard")) return weightKg * 2.0;
    else if (method.equals("express")) return weightKg * 5.0;
    else if (method.equals("overnight")) return weightKg * 10.0;
    throw new IllegalArgumentException("Unknown method");
}
```

A new requirement arrives: add an "international" shipping method priced at `weightKg * 15.0 + 20.0` (a flat international handling fee).

1. First, demonstrate the Open/Closed violation concretely: show that adding "international" to the existing code requires **editing** the existing `calculate` method (not just adding new code alongside it).
2. Refactor to the Strategy pattern: a `ShippingStrategy` interface, one implementation class per method, and a lookup (e.g., a `Map<String, ShippingStrategy>`) replacing the `if`/`else if` chain.
3. Add the "international" strategy as a **new class**, verifying it requires **zero changes** to any existing class.
4. Verify all four shipping methods (including the newly-added one) compute the correct cost.

## Constraints

- Keep the public API (`calculate(String method, double weightKg)`) the same before and after the refactor, so the change is purely internal.

## Success Criteria

- The refactored version is shown to compute identical, correct results to the original for all pre-existing methods.
- Adding "international" is demonstrated to require creating one new class and one new map entry — no edits to `ShippingCostCalculator` itself or any other existing strategy class.
