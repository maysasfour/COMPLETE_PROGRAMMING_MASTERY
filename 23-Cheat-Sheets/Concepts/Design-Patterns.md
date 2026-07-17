# Design Patterns Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../12-Design-Patterns/README.md)

## Creational
| Pattern | Solves | Verified finding |
|---|---|---|
| [Singleton](../../12-Design-Patterns/01-Singleton/README.md) | Exactly one instance, globally accessible | A naive lazy singleton created 6-9 instances out of 10 racing threads; fixed with the holder idiom |
| [Factory Method](../../12-Design-Patterns/02-Factory-Method-and-Abstract-Factory/README.md) | Centralize object creation | Scattered creation logic drifted, sending an SMS request as an Email |
| [Abstract Factory](../../12-Design-Patterns/02-Factory-Method-and-Abstract-Factory/README.md) | Create a matched family of related objects | Independent flags produced a mismatched Dark-Button/Light-Checkbox UI |
| [Builder](../../12-Design-Patterns/03-Builder/README.md) | Avoid ambiguous positional constructor args | Two swapped `int` args silently produced a "12x 2-inch pizza" instead of "2x 12-inch" |

## Structural
| Pattern | Solves | Verified finding |
|---|---|---|
| [Adapter](../../12-Design-Patterns/04-Adapter-and-Decorator/README.md) | Make an incompatible interface usable | A forgotten dollars-to-cents conversion caused a real 100x under-charge |
| [Decorator](../../12-Design-Patterns/04-Adapter-and-Decorator/README.md) | Add behavior without subclass explosion | A duplicated pricing formula across subclasses drifted ($2.70 instead of $2.75) |

## Behavioral
| Pattern | Solves | Verified finding |
|---|---|---|
| [Observer](../../12-Design-Patterns/05-Observer/README.md) | Notify dependents without hard-coding who they are | A hard-coded notification list left a display silently stale |
| [Strategy](../../12-Design-Patterns/06-Strategy-and-Command/README.md) | Swap an algorithm without fragile branching | An `if/else` chain shadowed one country's tax rate with another's |
| [Command](../../12-Design-Patterns/06-Strategy-and-Command/README.md) | Encapsulate an action so it can be undone correctly | A naive "undo" restored a hardcoded default instead of the real previous value |

## Quick Syntax Reference (Java)
```java
// Singleton (initialization-on-demand holder idiom -- thread-safe, no locking)
class Singleton {
    private Singleton() {}
    private static class Holder { static final Singleton INSTANCE = new Singleton(); }
    static Singleton getInstance() { return Holder.INSTANCE; }
}

// Strategy
interface DiscountStrategy { double apply(double price); }
class PercentOff implements DiscountStrategy {
    public double apply(double price) { return price * 0.9; }
}

// Observer
interface Listener { void onEvent(String data); }
class EventBus {
    List<Listener> listeners = new ArrayList<>();
    void publish(String data) { listeners.forEach(l -> l.onEvent(data)); }
}
```

See the [full Design Patterns module](../../12-Design-Patterns/README.md) for verified, runnable code for every pattern above.
