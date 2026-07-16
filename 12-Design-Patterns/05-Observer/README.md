# 05 — Observer

[Back to module overview](../README.md) | [Previous: Adapter and Decorator](../04-Adapter-and-Decorator/README.md)

## Beginner: What Observer Solves

Observer lets a "subject" (like a stock price) notify any number of interested "observers" (like displays) whenever it changes, without the subject needing to know exactly who's listening or hard-code calls to each one individually. This lesson demonstrates a real "stale data" bug caused by hard-coded notification calls, then fixes it.

## The Violation: A Real, Silent Stale-Data Bug

```java
class StockPriceViolation {
    private final EmailDisplayViolation emailDisplay = new EmailDisplayViolation();
    private final MobileAppDisplayViolation mobileDisplay = new MobileAppDisplayViolation(); // added later...

    void setPrice(String symbol, double price) {
        this.price = price;
        emailDisplay.update(symbol, price);
        // BUG: mobileDisplay was added as a field, but the call to notify it here was forgotten.
    }
}
```

This is a realistic scenario: `mobileDisplay` was added to the class as a field (perhaps as a first step, planning to wire it in), but the actual call to `mobileDisplay.update(...)` inside `setPrice()` was never added. Verified live:

```
[Email] ACME is now $101.5
MobileApp's last known price: -1.0  <- BUG: -1 means it was NEVER actually notified, despite existing as a field!
```

The email display updates correctly; the mobile display silently never receives the new price at all, despite existing as a field on the class — a real, easy-to-miss stale-data bug.

## The Fix: Observer — Notify a List Uniformly

```java
interface StockObserver { void update(String symbol, double price); }

class StockPrice {
    private final List<StockObserver> observers = new ArrayList<>();
    void addObserver(StockObserver observer) { observers.add(observer); }
    void setPrice(String symbol, double price) {
        for (StockObserver observer : observers) {
            observer.update(symbol, price); // EVERY registered observer, uniformly
        }
    }
}
```

Verified live — both displays now correctly receive the update:

```
[Email] ACME is now $101.5
[MobileApp] ACME is now $101.5
MobileApp's last known price: 101.5  <- correct, actually received the update
```

Because notification happens in a loop over a list of registered observers, there's no per-observer call to forget — registering an observer via `addObserver()` is the only thing needed to receive updates.

## Advanced: Adding a Third Observer With Zero Changes to `StockPrice`

Verified live, adding an `SmsDisplay` required only implementing `StockObserver` and calling `addObserver()` — **zero changes to `StockPrice` itself**, directly echoing [Open/Closed](../../11-Design-Principles/01-SOLID-Principles/README.md#o--openclosed-principle):

```
[Email] ACME is now $102.75
[MobileApp] ACME is now $102.75
[SMS] ACME is now $102.75
```

## Detailed Example

See [Example.java](Example.java) — the real stale-data bug and the Observer-based fix.

## Run It

```bash
cd 12-Design-Patterns/05-Observer
javac Example.java
java Example
```

## Expected Output

The violation section showing a mobile display that never received an update (`-1.0`); the fixed section showing both displays correctly updated; a third observer added afterward with no changes to `StockPrice`.

## Common Mistakes

- Hard-coding notification calls to specific, named dependent objects — verified live to let a genuinely added dependent silently never receive updates when its notification call is forgotten.
- Forgetting to remove an observer that's no longer needed (a memory leak risk in long-lived subjects) — a complete Observer implementation typically needs a `removeObserver()` alongside `addObserver()`.
- Making observers depend on the *order* they're notified in — well-designed observers should be independent of one another and of notification order.

## Best Practices

- Notify observers through a uniform loop over a registered list, never through individually hard-coded calls.
- Keep the `StockObserver`/`update()` contract minimal and focused, so implementing a new observer is simple.
- Provide a way to unregister observers, to avoid indefinitely retaining references to observers that should have been discarded.

## Real-World Usage

Observer is the foundation of GUI event listeners (`addActionListener`), reactive/event-driven architectures, and pub/sub messaging systems — anywhere a component needs to react to changes in another component without that component needing to know about it directly. The stale-data bug demonstrated here — a listener silently never wired into a hard-coded notification path — is a common, real bug category in codebases that grow this way instead of using Observer from the start.

## Summary

- Hard-coding notification calls to specific dependents makes it easy for a genuinely added dependent to be silently forgotten — verified live with a mobile display that never received an update despite existing as a field.
- Observer notifies a uniform list of registered observers, verified live to correctly deliver updates to all of them, and to allow a third observer to be added with zero changes to the subject.

## Key Terms

- **Subject** — the object being observed, which notifies its observers of changes (`StockPrice` here).
- **Observer** — an object that reacts to a subject's changes, registered with the subject in advance.
- **Pub/sub (publish-subscribe)** — a broader architectural pattern generalizing Observer, often across process/network boundaries.

## Interview Questions

1. **How did hard-coded notification calls cause a real, silent bug in this lesson, and how does Observer prevent it?**
   `StockPriceViolation` called `emailDisplay.update(...)` directly inside `setPrice()`, but the equivalent call for a later-added `mobileDisplay` field was never written — the mobile display existed as a field but was never actually notified of price changes, verified live by its "last known price" remaining `-1.0` (its untouched initial value) even after `setPrice()` was called. Observer prevents this by having the subject iterate over a list of registered observers and notify all of them uniformly — there's no separate, hard-coded call per observer to forget, since adding an observer via `addObserver()` is sufficient to guarantee it receives every future update.

2. **How does adding a new observer in this lesson relate to the Open/Closed Principle from Design Principles?**
   Open/Closed states that code should be open for extension but closed for modification. Observer directly supports this: adding a third observer (`SmsDisplay`) required only writing a new class implementing `StockObserver` and calling `stock.addObserver(new SmsDisplay())` — verified live, with zero changes to the `StockPrice` class's own source code, exactly the same benefit demonstrated with the `Triangle` shape in [SOLID Principles Lesson 01](../../11-Design-Principles/01-SOLID-Principles/README.md#o--openclosed-principle).

## Recommended Next Lesson

[06 — Strategy and Command](../06-Strategy-and-Command/README.md)
