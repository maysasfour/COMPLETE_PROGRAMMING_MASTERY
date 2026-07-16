# 04 — Adapter and Decorator

[Back to module overview](../README.md) | [Previous: Builder](../03-Builder/README.md)

## Beginner: Two Structural Patterns

**Adapter** makes an incompatible interface usable through the interface your code actually expects — converting between them in exactly one place. **Decorator** adds behavior to an object dynamically, by wrapping it, instead of creating a new subclass for every possible combination of behaviors. Both are demonstrated here with real, verified bugs caused by *not* using the pattern.

## Adapter: A Real Unit-Conversion Bug

A legacy payment gateway expects an integer number of **cents**; the rest of the codebase works in **dollars**. The violation leaves the conversion up to every individual call site:

```java
static void checkoutCorrectViolation(LegacyPaymentGateway gateway, double amountDollars) {
    gateway.makeTransaction((int) Math.round(amountDollars * 100)); // correct
}
static void checkoutBuggyViolation(LegacyPaymentGateway gateway, double amountDollars) {
    gateway.makeTransaction((int) amountDollars); // BUG: forgot the *100 conversion!
}
```

Verified live — a real $19.99 charge, processed through the "buggy" call site, actually charges 19 cents instead of 1999 cents:

```
Correct call site ($19.99):   Legacy gateway charged 1999 cents
Buggy call site ($19.99):     Legacy gateway charged 19 cents
^ BUG: charged only 19 cents instead of 1999 cents -- the *100 conversion was forgotten!
```

The fix wraps the legacy gateway in an `Adapter` implementing the `PaymentProcessor` interface the rest of the codebase expects, performing the conversion in exactly one place:

```
Fixed: every caller goes through the SAME Adapter -- conversion cannot be forgotten:
  Legacy gateway charged 1999 cents
```

No caller can forget the conversion, because no caller ever sees the legacy, cents-based API directly anymore.

## Decorator: A Real Subclass-Explosion Pricing Bug

The violation creates a new subclass for every add-on combination, each **reimplementing** the pricing formula:

```java
class SugarCoffeeViolation extends SimpleCoffee {
    public double cost() { return super.cost() + 0.25; }
}
class MilkSugarCoffeeViolation extends SimpleCoffee {
    public double cost() { return super.cost() + 0.50 + 0.20; } // BUG: sugar priced at 0.20, drifted from 0.25!
}
```

Verified live — sugar's price silently drifted between the two subclasses:

```
Coffee, Sugar: $2.25
Coffee, Milk, Sugar: $2.70  <- BUG: sugar's price drifted (0.20 here vs 0.25 in SugarCoffeeViolation)!
```

The fix defines each add-on as a small `CoffeeDecorator` wrapper, with its price defined in exactly **one** place, and builds combinations by composing decorators rather than writing a new subclass per combination:

```java
class Sugar extends CoffeeDecorator {
    public double cost() { return wrapped.cost() + 0.25; } // the ONE place sugar's price is defined
}
```

Verified live — the same $0.25 sugar price is now used consistently, regardless of what other add-ons are composed with it:

```
Coffee, Sugar: $2.25
Coffee, Milk, Sugar: $2.75  <- consistent: same $0.25 sugar price, no drift possible
```

## Detailed Example

See [Example.java](Example.java) — both a real Adapter bug and a real Decorator bug, each with a verified fix.

## Run It

```bash
cd 12-Design-Patterns/04-Adapter-and-Decorator
javac Example.java
java Example
```

## Expected Output

An Adapter section showing a real under-charge (19 cents instead of 1999) in the violation, then a correctly-converted charge in the fix; a Decorator section showing a drifted sugar price ($2.70 instead of the correct $2.75) in the violation, then a consistent price in the fix.

## Common Mistakes

- Letting every call site convert between two incompatible interfaces/units itself — verified live to allow a real, 100x-too-small charge when one call site's conversion is simply forgotten.
- Modeling every combination of optional behaviors as its own subclass, each reimplementing shared logic — verified live to let that shared logic (a sugar add-on's price) drift apart between subclasses.
- Using Decorator for behavior that isn't actually meant to be optionally composed — if there's only ever one fixed combination, plain composition or a simple field is simpler and sufficient (the same YAGNI caution as [11-Design-Principles](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#yagni--you-arent-gonna-need-it)).

## Best Practices

- Wrap incompatible third-party/legacy APIs in a single Adapter implementing the interface your code actually depends on — never scatter the conversion logic across call sites.
- Use Decorator when behaviors need to be combined in varying combinations at runtime — it avoids the combinatorial subclass explosion (and the drift risk that comes with duplicating logic across those subclasses).
- Keep each decorator focused on exactly one added behavior, with its own state/logic defined in exactly one place.

## Real-World Usage

Adapter is the standard fix whenever integrating a third-party library or legacy system whose API doesn't match your codebase's expected interface — exactly the kind of unit-mismatch bug demonstrated here is a common, real category of integration bug. Decorator underlies Java's own I/O library (`BufferedReader` wrapping a `Reader`, `InputStreamReader` wrapping an `InputStream`) and is the standard solution for adding cross-cutting behaviors (logging, caching, compression) to an object without a subclass explosion.

## Summary

- Adapter converts an incompatible interface in exactly one place — verified live to prevent a real, silent under-charge caused by a forgotten unit conversion at one of several call sites.
- Decorator composes optional behaviors instead of subclassing every combination — verified live to prevent a real, drifted price caused by the same logic being duplicated across subclasses.
- Both patterns solve a duplication/drift problem, the same underlying concern as [DRY](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#dry--dont-repeat-yourself) from Design Principles, applied to interface conversion and behavior composition respectively.

## Key Terms

- **Adapter** — a class that converts one interface into another that client code expects, isolating the conversion logic in one place.
- **Decorator** — a class that wraps another object implementing the same interface, adding behavior before/after delegating to the wrapped object.
- **Subclass explosion** — the combinatorial growth of subclasses needed to represent every combination of optional behaviors, avoided by Decorator's composition-based approach.

## Interview Questions

1. **How does Adapter prevent the kind of unit-conversion bug demonstrated in this lesson?**
   Without an Adapter, every call site integrating with an incompatible API (like a cents-based legacy payment gateway, when the rest of the code works in dollars) must perform the conversion itself — and any call site that gets it wrong or forgets it entirely produces a silent, wrong result. This was demonstrated concretely: one call site correctly converted `$19.99` to `1999` cents, while another simply cast the dollar amount directly, charging only `19` cents. Wrapping the legacy gateway in a single `LegacyPaymentGatewayAdapter` implementing the `PaymentProcessor` interface moved the conversion into exactly one place, so no caller can forget or get it wrong — verified by every subsequent call producing the correct `1999`-cent charge.

2. **Why did the subclass-based coffee add-on approach in this lesson lead to a real pricing bug, and how does Decorator fix it?**
   The subclass-based approach reimplemented the sugar add-on's price formula separately in `SugarCoffeeViolation` and again in `MilkSugarCoffeeViolation`, and the two copies drifted apart (`0.25` vs. `0.20`) — verified live by the actual computed prices ($2.25 in one, $2.70 instead of the correct $2.75 in the other). Decorator fixes this by defining each add-on's behavior in exactly one small wrapper class (`Sugar`, with its `+0.25` defined once) and building combinations by composing decorators (`new Sugar(new Milk(new SimpleCoffee()))`) rather than writing a new subclass with its own copy of the formula — verified live to produce a consistent $2.75 for the milk-and-sugar combination, using the same $0.25 sugar price as the sugar-only case.

## Recommended Next Lesson

[05 — Observer](../05-Observer/README.md)
