# Solution 04 — Strategy Pattern Refactor

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/04-Strategy-Refactor.md)

## Approach

Replaced the `if`/`else if` chain with a `ShippingStrategy` interface, one implementation per method, and a `Map<String, ShippingStrategy>` lookup. The new "international" requirement is added as a brand-new class plus one map entry — zero edits to any existing class.

## Verified Live

```
=== Violation: original if/else chain (no 'international' support without editing it) ===
  standard, 2kg: $4.00
  express, 2kg:  $10.00
  international, 2kg: Unknown method  <- would require editing the existing method

=== Fixed: Strategy pattern -- all methods, including the NEW one, work correctly ===
  standard, 2kg:      $4.00 (matches original)
  express, 2kg:       $10.00 (matches original)
  overnight, 2kg:     $20.00 (matches original)
  international, 2kg: $50.00  <- NEW, added via a new class + one map entry, zero edits elsewhere
```

All pre-existing methods compute identical results before and after the refactor, and the new method computes correctly — directly matching the Open/Closed Principle demonstrated in [11-Design-Principles/01-SOLID-Principles](../../11-Design-Principles/01-SOLID-Principles/README.md) and the Strategy pattern in [12-Design-Patterns/06-Strategy-and-Command](../../12-Design-Patterns/06-Strategy-and-Command/README.md).

## Run It

```bash
cd 25-Solutions/04-Strategy-Refactor
javac Example.java
java Example
```

See [Example.java](Example.java) for the full, runnable solution.
