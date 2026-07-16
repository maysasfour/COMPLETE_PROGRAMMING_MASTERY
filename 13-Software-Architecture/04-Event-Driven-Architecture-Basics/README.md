# 04 — Event-Driven Architecture Basics

[Back to module overview](../README.md) | [Previous: Microservices Fundamentals](../03-Microservices-Fundamentals/README.md)

## Beginner: What Event-Driven Architecture Solves

In event-driven architecture, a component publishes an event and moves on; interested subscribers react independently. This lesson focuses specifically on a benefit distinct from [Observer](../../12-Design-Patterns/05-Observer/README.md) (which focused on avoiding stale, hard-coded notification bugs): **reliability isolation** — a failing, non-critical subscriber should never be able to block the operation that published the event, or any other subscriber.

## The Violation: A Real Reliability Bug From Tight Synchronous Coupling

```java
class OrderServiceViolation {
    void placeOrder(String orderId) {
        System.out.println("Order " + orderId + " placed.");
        inventory.decrement(orderId);
        email.send(orderId);
        analytics.log(orderId); // throws! everything below never runs
        System.out.println("Order " + orderId + " fully processed."); // never reached!
    }
}
```

`analytics.log()` is a non-critical, "nice to have" side effect — but because it's called synchronously and unguarded, its failure propagates up and prevents the order from ever being marked complete. Verified live:

```
Order ORD-1 placed.
  [Inventory] stock decremented for ORD-1
  [Email] confirmation sent for ORD-1
  Caught: Analytics service is down!
  BUG: "Order fully processed" was NEVER printed -- a failing ANALYTICS call
  blocked the entire order, even though inventory and email had already succeeded!
```

Inventory was already decremented and the confirmation email already sent — genuinely successful, important side effects — yet the overall operation still failed because an unrelated, non-critical dependency (analytics) happened to be down.

## The Fix: Publish an Event; Isolate Subscriber Failures

```java
class EventBus {
    void publish(String orderId) {
        for (OrderEventListener listener : listeners) {
            try {
                listener.onOrderPlaced(orderId);
            } catch (Exception e) {
                System.out.println("a listener failed, but did NOT block anything else: " + e.getMessage());
            }
        }
    }
}
```

Verified live — the exact same analytics failure occurs, but the order still completes successfully:

```
Order ORD-2 placed.
  [Inventory] stock decremented for ORD-2
  [Email] confirmation sent for ORD-2
  [EventBus] a listener failed, but did NOT block anything else: Analytics service is down!
Order ORD-2 fully processed.
  ^ correct: "fully processed" WAS printed, even though the analytics listener failed exactly as before
```

The key mechanism: `EventBus.publish()` catches each subscriber's exception individually, inside the loop, so one subscriber's failure cannot propagate to the publisher (`OrderService`) or to any other subscriber.

## Detailed Example

See [Example.java](Example.java) — the real reliability bug and the event-driven fix.

## Run It

```bash
cd 13-Software-Architecture/04-Event-Driven-Architecture-Basics
javac Example.java
java Example
```

## Expected Output

The violation section showing an order's completion message never printed because a non-critical analytics call threw an exception; the fixed section showing the exact same analytics failure occurring, but correctly isolated, with the order still completing successfully.

## Common Mistakes

- Calling non-critical side effects (analytics, logging, notifications) synchronously and unguarded in the same call path as critical operations — verified live to let a non-critical failure block an otherwise fully successful operation.
- Assuming "event-driven" only matters for decoupling who calls whom (the concern [Observer](../../12-Design-Patterns/05-Observer/README.md) addresses) — reliability isolation (this lesson's focus) is an equally important, distinct benefit.
- Swallowing exceptions silently with no logging at all — the fix here still surfaces that the analytics listener failed (via a printed message), it just doesn't let that failure block anything else; production systems would typically also alert or retry.

## Best Practices

- Separate critical operations (that must succeed for the overall operation to be considered successful) from non-critical side effects (that should never be able to block it).
- Have an event bus/dispatcher catch and isolate each subscriber's exceptions individually, so one failing subscriber can never affect another or the publisher.
- Still log or alert on subscriber failures — isolating a failure from blocking the main operation is not the same as ignoring that the failure happened.

## Real-World Usage

Real message queues and event buses (Kafka, RabbitMQ, AWS SNS/SQS) provide exactly this isolation at a much larger, distributed scale — a failing consumer of an event does not prevent the event from being published or from reaching other consumers. This lesson's `try`/`catch` inside `EventBus.publish()`'s loop is a simplified, in-process illustration of the same underlying reliability principle those systems are built around.

## Summary

- Calling a non-critical dependency synchronously and unguarded was shown to let its failure block an otherwise fully successful operation — verified live with an order's completion message never printed.
- Publishing an event and isolating each subscriber's failure individually fixed this — verified live with the exact same analytics failure occurring, but the order still completing successfully.
- This is a distinct benefit from Observer's decoupling focus: event-driven architecture's reliability isolation specifically protects critical operations from non-critical failures.

## Key Terms

- **Event-driven architecture** — a design where components communicate by publishing and reacting to events, rather than calling each other directly and synchronously.
- **Reliability isolation** — ensuring one component's failure cannot cascade and affect unrelated components or operations.
- **Publisher/subscriber** — the publisher emits events without knowing who (if anyone) is listening; subscribers react independently.

## Interview Questions

1. **How did tight synchronous coupling cause a real reliability bug in this lesson, and how does event-driven architecture fix it?**
   `OrderServiceViolation` called `analytics.log()` synchronously and unguarded, in the same call path as the critical inventory-decrement and email-send steps. When the analytics call threw an exception, it propagated up through `placeOrder()`, preventing the final "fully processed" confirmation from ever printing — verified live, even though the inventory and email steps had already completed successfully. The event-driven fix has `OrderService` simply publish an event and move on; `EventBus.publish()` catches each subscriber's exception individually inside its loop, so the identical analytics failure was verified live to no longer block the order's completion message.

2. **Why is reliability isolation considered a distinct benefit from the decoupling Observer provides, even though both patterns look structurally similar?**
   Observer (as covered in [12-Design-Patterns Lesson 05](../../12-Design-Patterns/05-Observer/README.md)) primarily solves the problem of a subject not needing to know exactly which dependents exist, avoiding hard-coded, easily-forgotten notification calls. This lesson's event-driven example uses a structurally similar publish/subscribe mechanism, but the specific property demonstrated is different: even with all the "right" subscribers correctly registered, one of them failing should not be allowed to block the publisher or other subscribers. This was verified concretely by reproducing the identical analytics failure in both the violation and the fix — the difference wasn't which subscribers existed, but whether one subscriber's failure could cascade.

## Recommended Next Lesson

This is the final lesson in the Software Architecture module. Continue to [14-APIs-and-Integrations](../../14-APIs-and-Integrations/README.md) if built, or return to the [module overview](../README.md).
