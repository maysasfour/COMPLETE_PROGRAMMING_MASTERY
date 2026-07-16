# 06 — Composition vs. Inheritance

[Back to module overview](../README.md) | [Previous: Polymorphism](../05-Polymorphism/README.md)

## Beginner: "Favor Composition Over Inheritance"

This is one of the most repeated principles in OOP design, and it means: **prefer building objects out of other objects ("has-a") over building type hierarchies ("is-a"), unless "is-a" is genuinely and permanently true.** Composition means an object holds a reference to another object and delegates work to it, rather than inheriting that object's behavior.

```python
class Engine:
    def start(self): return "Engine starting"

class Car:
    def __init__(self):
        self.engine = Engine()   # Car HAS-A Engine (composition)

    def start(self):
        return self.engine.start()
```

vs. the inheritance version that models the same idea incorrectly:

```python
class Car(Engine):   # Car IS-A Engine?? No - this is backwards.
    pass
```

A car isn't a kind of engine; it *contains* one. Composition captures that correctly and — critically — lets you swap the engine (electric, hybrid, gas) without touching `Car`'s class hierarchy at all.

## Intermediate: Why Deep Inheritance Hierarchies Become Fragile

The problem compounds as a hierarchy grows. Below is a realistic "bad" design: notification types built through inheritance, where new requirements keep forcing awkward choices.

```python
class Notification:
    def send(self, message): raise NotImplementedError

class EmailNotification(Notification):
    def send(self, message): return f"Email: {message}"

class UrgentEmailNotification(EmailNotification):
    def send(self, message): return f"URGENT Email: {message}"

class SMSNotification(Notification):
    def send(self, message): return f"SMS: {message}"

class UrgentSMSNotification(SMSNotification):
    def send(self, message): return f"URGENT SMS: {message}"
```

Every new *combination* — urgent, retry-on-failure, logged, rate-limited — multiplied across every channel (email, SMS, push, Slack) requires a **new subclass for each combination**. Four channels × "urgent or not" already doubled the hierarchy; add "logged or not" and it doubles again. This is the classic **combinatorial explosion** that inheritance-only designs run into, and it's a direct symptom of the fragile base class problem from Lesson 04: a bug fix in `Notification.send` now has to be verified across every leaf in an exploding tree.

## Advanced: The Composition Refactor

Composition breaks the problem into independent, swappable pieces: **what channel to send through** and **how to modify the message/behavior**, composed together instead of multiplied into subclasses.

```python
from abc import ABC, abstractmethod

class Channel(ABC):
    @abstractmethod
    def deliver(self, message: str) -> str: ...

class EmailChannel(Channel):
    def deliver(self, message: str) -> str:
        return f"Email: {message}"

class SMSChannel(Channel):
    def deliver(self, message: str) -> str:
        return f"SMS: {message}"

class Notifier:
    def __init__(self, channel: Channel, urgent: bool = False):
        self.channel = channel   # COMPOSED, not inherited
        self.urgent = urgent

    def notify(self, message: str) -> str:
        if self.urgent:
            message = f"URGENT {message}"
        return self.channel.deliver(message)
```

Now "urgent SMS" is just `Notifier(SMSChannel(), urgent=True)` — a runtime combination of two independent pieces, not a compile-time subclass. Adding a `PushChannel` or a `logged: bool` flag doesn't multiply anything; it's one more independent piece that composes with everything already there. This is exactly the refactor demonstrated end-to-end in `example.py`, and the same shape (compose independent capabilities instead of subclassing every combination) is what the Mini-Project's `Library` uses to combine a catalog, a membership roster, and loan rules without those three concerns inheriting from one another.

## Real-World Usage

- Game engines almost universally use composition ("entity-component" systems) instead of deep inheritance — a `GameObject` *has* a `PositionComponent`, a `RenderComponent`, a `PhysicsComponent`, mixed and matched per object instead of subclassed per combination.
- Python's `logging` module composes handlers, formatters, and filters onto a `Logger` rather than requiring a different `Logger` subclass per output destination.
- Dependency injection (common in backend frameworks) is composition by another name: a service *receives* its dependencies (a database client, a cache client) rather than inheriting their behavior.

## When to Use Inheritance Instead

Inheritance is still the right tool when the "is-a" relationship is simple, stable, and the subclass genuinely wants the *entire* interface of the parent, not just a piece of it — exception hierarchies (Lesson 04) are the textbook case. Use inheritance for **is-a specialization of behavior**; use composition for **has-a assembly of capabilities**.

## Summary

- "Favor composition over inheritance" means preferring objects that hold and delegate to other objects, over building type hierarchies, unless "is-a" is genuinely permanent.
- Inheritance-only designs that need to represent multiple independent dimensions (channel × urgency × logging) suffer combinatorial explosion — a new subclass per combination.
- Composition decomposes those dimensions into independent, swappable pieces combined at runtime via constructor arguments.
- Inheritance still fits genuine, stable "is-a" relationships (exception hierarchies); composition fits "has-a" assembly of independent capabilities.

## Key Terms

- **Composition** — building an object by holding references to other objects and delegating work to them.
- **Combinatorial explosion** — the exponential growth of required subclasses when an inheritance hierarchy tries to represent multiple independent dimensions of variation.
- **Delegation** — an object forwarding a call to another object it holds, rather than implementing the behavior itself.
- **"Has-a" relationship** — one object contains or uses another, as opposed to "is-a" (inheritance).

## Common Mistakes

- Defaulting to inheritance for any kind of code reuse, without checking whether the relationship is really "has-a."
- Building a new subclass for every feature combination instead of recognizing the combination as two independent, composable pieces.
- Overcorrecting into "never use inheritance" — genuine is-a hierarchies (exceptions, UI widget trees) are still a good fit and composition would add needless indirection there.
- Forgetting that composition requires explicit delegation (`self.engine.start()`) — you don't get the composed object's methods "for free" the way inheritance gives you the parent's methods automatically.

## Interview Questions

1. **What does "favor composition over inheritance" mean, and why is it good default advice?**
   Prefer assembling objects out of other objects (has-a, via delegation) over building type hierarchies (is-a), because composition is more flexible — pieces can be swapped or recombined at runtime — and avoids the fragile base class problem and combinatorial explosion that inheritance-heavy designs run into.

2. **What is combinatorial explosion in the context of inheritance?**
   When a hierarchy tries to represent multiple independent dimensions of variation (e.g., channel type × urgency), the number of required subclasses grows multiplicatively — every new dimension multiplies the existing subclass count instead of adding to it.

3. **Give a concrete example where inheritance is still the right choice.**
   Exception hierarchies: `FileNotFoundError` is genuinely, permanently an `OSError` — there's one clear dimension of specialization, the relationship never becomes false, and catching the parent type is meant to catch every child.

4. **How would you refactor a class hierarchy suffering combinatorial explosion?**
   Identify the independent dimensions being multiplied together (e.g., channel and urgency), extract each into its own small class/interface, and compose them at runtime via constructor parameters instead of creating a subclass per combination.

5. **What's the tradeoff composition introduces that pure inheritance doesn't have?**
   You must delegate explicitly — composition doesn't give you the held object's methods automatically the way inheritance gives you a parent's methods, so you write forwarding methods (`self.engine.start()`) for whatever behavior should be exposed.

## Suggested Next Lesson

[07 — Interfaces and Abstract Classes](../07-Interfaces-and-Abstract-Classes/README.md)
