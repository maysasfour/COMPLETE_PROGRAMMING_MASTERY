# 03 — Coupling and Cohesion

[Back to module overview](../README.md) | [Previous: DRY, KISS, and YAGNI](../02-DRY-KISS-YAGNI/README.md)

## Beginner: Two Different Axes of Design Quality

**Coupling** measures how much one class depends on another's internals. **Cohesion** measures how strongly the responsibilities *within* a single class actually belong together. The goal is **loose coupling** (classes depend on each other as little as possible, and only through clean abstractions) and **high cohesion** (each class does one focused thing, using its own state for that one thing). Both are demonstrated here as real, verified bugs, not just abstract advice.

## Coupling: A Real Bug From Depending on Internal Representation

The violation lets `DisplayViolation` read `ThermometerViolation`'s internal field directly, wrongly assuming it's already in Celsius:

```java
class ThermometerViolation {
    public double tempFahrenheit; // internal representation exposed directly
}
class DisplayViolation {
    String show(ThermometerViolation t) {
        return "Temp: " + t.tempFahrenheit + "C"; // no conversion -- just labeled wrong
    }
}
```

Verified live, with an actual body temperature of 98.6°F:

```
Temp: 98.6C  <- WRONG: this is 98.6, mislabeled as Celsius!
```

The fix hides `Thermometer`'s internal representation entirely behind a `getCelsius()` accessor that performs the actual conversion; `Display` is now decoupled from *how* the temperature happens to be stored internally:

```
Temp: 37.0C  <- correct: 98.6F really is 37.0C
```

`Display` never needed to know or care that the internal representation was Fahrenheit — that's the entire point of loose coupling: it can't misuse a representation it never has direct access to.

## Cohesion: A Real Bug From Unrelated Responsibilities Sharing State

The violation crams two unrelated responsibilities — header formatting, and discount calculation — into one class, and they end up sharing the same mutable field:

```java
class ReportGeneratorViolation {
    private String cache; // used for TWO unrelated purposes
    String formatHeader(String title) { cache = title.toUpperCase(); return "=== " + cache + " ==="; }
    double applyDiscount(double amount, double rate) { cache = "discount-op"; return amount - (amount * rate); }
}
```

Verified live: formatting a header, then calling the *completely unrelated* `applyDiscount`, silently corrupts the remembered header:

```
getLastHeaderCache() = "discount-op"  <- BUG: should still be "SALES REPORT", but the unrelated discount call clobbered it!
```

The fix splits the two responsibilities into `HeaderFormatter` and `DiscountCalculator`, each with its own private state — verified live, the header is now correctly preserved, since there is no shared state left for an unrelated operation to clobber:

```
getLastHeader() = "SALES REPORT"  <- correct, untouched by the unrelated discount call
```

## Detailed Example

See [Example.java](Example.java) — both a real coupling bug and a real cohesion bug, each with a verified fix.

## Run It

```bash
cd 11-Design-Principles/03-Coupling-and-Cohesion
javac Example.java
java Example
```

## Expected Output

A coupling section showing a mislabeled temperature (98.6 shown as Celsius, when it's actually Fahrenheit) followed by the correct conversion; a cohesion section showing a clobbered header value followed by the correctly-preserved one after splitting responsibilities.

## Common Mistakes

- Exposing a class's internal fields directly (`public` fields, or getters that return raw internal representation without conversion/validation) — verified live to let a caller misuse that representation with a real, silent bug.
- Sharing mutable state between a class's unrelated responsibilities — verified live to let one operation silently corrupt state meant for a completely different, unrelated operation.
- Assuming "coupling" only means "classes that call each other" — some coupling is unavoidable and fine (calling a well-designed public method); the problem is specifically coupling to *internal representation/implementation details* that could change.

## Best Practices

- Keep fields private and expose behavior (methods that perform real logic/conversion), not raw internal state, so callers can't misuse a representation they never directly see.
- Give each class a single, focused responsibility with its own private state — if two methods on a class don't share any meaningful state, they likely belong in two different classes (directly related to [Single Responsibility](../01-SOLID-Principles/README.md#s--single-responsibility-principle)).
- When reviewing code, ask "if I changed this class's internal representation, what else would break?" — the more that breaks, the tighter (and more dangerous) the coupling.

## Real-World Usage

Tight coupling to internal representation is a common source of real production bugs whenever a class's internal storage format changes (units, encoding, a switch from one data structure to another) and some caller elsewhere was silently depending on the old representation. Low cohesion — "god classes" or "utility bags" accumulating unrelated responsibilities and shared mutable state — is one of the most common findings in real code review, and directly motivates refactoring efforts to split such classes apart.

## Summary

- Coupling: `Display` reading `Thermometer`'s raw internal field directly caused a real unit-mislabeling bug (98.6°F shown as "98.6C"); hiding the representation behind a proper accessor fixed it.
- Cohesion: cramming header formatting and discount calculation into one class caused them to share state and silently corrupt each other; splitting them into two focused classes fixed it.
- Both principles push toward the same outcome from different angles: classes that depend on each other minimally, and internally do one clearly-scoped thing.

## Key Terms

- **Coupling** — the degree to which one class depends on another's internal details rather than a stable, well-defined interface.
- **Cohesion** — the degree to which the responsibilities and state within a single class genuinely belong together.
- **Encapsulation** — hiding a class's internal representation behind methods, so callers depend only on behavior, not implementation.

## Interview Questions

1. **What's the difference between coupling and cohesion, and how did this lesson demonstrate a real bug caused by each?**
   Coupling is about dependencies *between* classes (how much one depends on another's internals); cohesion is about whether the responsibilities *within* one class actually belong together. A coupling bug was demonstrated by `Display` reading `Thermometer`'s raw internal Fahrenheit field and mislabeling it as Celsius, producing a wrong displayed temperature (98.6 shown as "98.6C" instead of the correct 37.0C). A cohesion bug was demonstrated by a single class handling both header formatting and discount calculation, sharing one mutable field between them — calling the unrelated discount method silently corrupted the previously-formatted header.

2. **Why does hiding internal representation (encapsulation) directly prevent the kind of coupling bug shown in this lesson?**
   The bug occurred because `DisplayViolation` had direct access to `ThermometerViolation`'s raw Fahrenheit field and assumed, incorrectly, that it was already in Celsius. Once `Thermometer`'s field was made `private` and only a `getCelsius()` method (which performs the actual, correct conversion) was exposed, `Display` had no way to access the raw, unconverted value at all — it could only ever get a correctly-converted Celsius value, making the specific mislabeling bug structurally impossible, not just less likely.

## Recommended Next Lesson

[04 — Composition over Inheritance](../04-Composition-over-Inheritance/README.md)
