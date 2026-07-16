# 02 — Factory Method and Abstract Factory

[Back to module overview](../README.md) | [Previous: Singleton](../01-Singleton/README.md)

## Beginner: Two Related Creational Patterns

**Factory Method** centralizes the logic for creating *one* kind of object, so every caller asks a single place for what it needs instead of duplicating `new X()`/`new Y()` decision logic everywhere. **Abstract Factory** goes one step further: it centralizes creation of a whole **family** of related objects, guaranteeing they're always created consistently together. Both are demonstrated here as real bugs caused by scattered/independent creation, then fixed.

## Factory Method: A Real Copy-Paste Drift Bug

The violation duplicates the "which notification type to create" decision in two separate methods. When SMS support was added, the branch was updated in `confirmOrder()` but the same edit was forgotten in `cancelOrder()`:

```java
class OrderServiceViolation {
    void confirmOrder(String method) {
        Notification n = method.equals("email") ? new EmailNotification() : new SmsNotification();
        n.send("Order confirmed");
    }
    void cancelOrder(String method) {
        Notification n = method.equals("email") ? new EmailNotification() : new EmailNotification(); // never updated!
        n.send("Order cancelled");
    }
}
```

Verified live — calling `cancelOrder("sms")` sends an **Email**, not an SMS:

```
Violation: cancelOrder("sms") should send an SMS, but the branch was never updated:
  [Email] Order cancelled
  ^ BUG: that was actually sent as an Email, not SMS!
```

This is exactly the same underlying failure mode as a [DRY](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#dry--dont-repeat-yourself) violation — duplicated logic drifting apart — but specifically about object *creation* logic, which is what Factory Method addresses. The fix moves creation into one `NotificationFactory.create(method)` method that every caller uses:

```
Fixed: both confirmOrder and cancelOrder use the SAME NotificationFactory:
  [SMS] Order confirmed
  [SMS] Order cancelled
```

## Abstract Factory: A Real Mismatched-Family Bug

The violation picks a UI theme's `Button` and `Checkbox` from two **independent** flags — nothing enforces they represent the same theme:

```java
class ScreenViolation {
    ScreenViolation(boolean darkButton, boolean darkCheckbox) {
        this.button = darkButton ? new DarkButton() : new LightButton();
        this.checkbox = darkCheckbox ? new DarkCheckbox() : new LightCheckbox();
    }
}
```

Verified live — a real configuration mistake (`darkButton=true, darkCheckbox=false`, meant to be both `true`) produces a visually inconsistent, mismatched screen:

```
[Dark Button] + [Light Checkbox]  <- BUG: mismatched theme, should have been both Dark or both Light!
```

The fix introduces a `UIFactory` interface (`LightUIFactory`, `DarkUIFactory`) that produces an entire *matched* family from one object — there is no longer any way to independently pick a button theme and a checkbox theme, because both come from the same factory instance:

```
[Dark Button] + [Dark Checkbox]  <- consistent
[Light Button] + [Light Checkbox]  <- consistent
```

## Detailed Example

See [Example.java](Example.java) — both a real Factory Method bug and a real Abstract Factory bug, each with a verified fix.

## Run It

```bash
cd 12-Design-Patterns/02-Factory-Method-and-Abstract-Factory
javac Example.java
java Example
```

## Expected Output

A Factory Method section showing an SMS request incorrectly sent as an Email in the violation, then correctly sent as SMS in the fix; an Abstract Factory section showing a mismatched Dark-Button/Light-Checkbox screen in the violation, then two correctly consistent (all-Dark, all-Light) screens in the fix.

## Common Mistakes

- Scattering `new ConcreteClass()` decision logic across multiple call sites — verified live to drift out of sync exactly like a DRY violation, since it *is* one, specifically about object creation.
- Choosing components of a "family" (like a UI theme's button and checkbox) via independent flags/conditions rather than one shared source of truth — verified live to allow a real, visually mismatched configuration.
- Reaching for Abstract Factory when there's only ever one family in practice — the added indirection only pays for itself when multiple, genuinely swappable families actually exist (the same YAGNI caution from [11-Design-Principles](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#yagni--you-arent-gonna-need-it)).

## Best Practices

- Centralize object-creation decision logic in one factory method/class so every caller shares the same, single source of truth.
- Use Abstract Factory specifically when a set of related objects must always be created together, consistently, as a matched set.
- Keep factories focused on creation only — a factory method deciding *what* to create is fine; a factory method also containing unrelated business logic is a [Single Responsibility](../../11-Design-Principles/01-SOLID-Principles/README.md#s--single-responsibility-principle) violation.

## Real-World Usage

Factory Method appears throughout standard libraries (`Calendar.getInstance()`, JDBC's `DriverManager.getConnection()`) specifically because the exact concrete class to instantiate can depend on runtime configuration the caller shouldn't need to know about. Abstract Factory is the standard solution for cross-platform UI toolkits and theme systems — ensuring, for example, that every widget rendered belongs to the same look-and-feel family, exactly as demonstrated in this lesson's Light/Dark UI example.

## Summary

- Factory Method centralizes creation logic for one kind of object — verified live to prevent the exact copy-paste drift bug that let an SMS request silently get sent as an Email.
- Abstract Factory centralizes creation of a whole family of related objects — verified live to prevent a real, visually mismatched Dark-Button/Light-Checkbox configuration.
- Both patterns are really the [DRY principle](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#dry--dont-repeat-yourself) applied specifically to object creation.

## Key Terms

- **Factory Method** — a method that centralizes the logic for creating one kind of object, so callers don't duplicate creation decisions.
- **Abstract Factory** — an interface for creating a whole family of related objects consistently, without callers choosing family members independently.
- **Family** — a set of related objects (like a UI theme's button and checkbox) that must be used together consistently.

## Interview Questions

1. **How does a Factory Method bug relate to a DRY violation, and how was one demonstrated concretely in this lesson?**
   A Factory Method violation is a DRY violation specifically about object-creation logic: if the decision of which concrete class to instantiate is duplicated across multiple call sites, those copies can drift out of sync exactly like any other duplicated logic. This was demonstrated concretely: `OrderServiceViolation` duplicated its email/SMS creation decision in both `confirmOrder()` and `cancelOrder()`; when SMS support was added, only `confirmOrder()`'s copy was updated, so calling `cancelOrder("sms")` incorrectly sent an Email — verified by the actual printed output showing `[Email] Order cancelled` instead of the expected `[SMS] Order cancelled`.

2. **What specific problem does Abstract Factory solve that a plain Factory Method does not, and how was it verified in this lesson?**
   Abstract Factory solves the problem of keeping a *family* of related objects consistent with each other — a plain Factory Method only guarantees one object type is created correctly, but says nothing about whether multiple, independently-created related objects match. This was verified concretely: choosing a `Button` and a `Checkbox` via two independent boolean flags allowed a real configuration mistake to produce a mismatched `[Dark Button] + [Light Checkbox]` screen. Introducing a `UIFactory` interface that produces both components from one factory instance made this mismatch structurally impossible — verified by both `DarkUIFactory` and `LightUIFactory` producing fully consistent pairs.

## Recommended Next Lesson

[03 — Builder](../03-Builder/README.md)
