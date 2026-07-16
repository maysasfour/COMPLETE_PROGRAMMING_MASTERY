# 02 — Clean and Hexagonal Architecture

[Back to module overview](../README.md) | [Previous: Layered (N-tier) Architecture](../01-Layered-N-tier-Architecture/README.md)

## Beginner: The Dependency Rule

Clean Architecture and Hexagonal Architecture ("Ports and Adapters") share the same core idea: the **domain** (business logic) should depend only on abstractions it defines itself — **ports** — never on concrete **infrastructure** (databases, external APIs, frameworks). Infrastructure implements those ports via **adapters**. This is [Dependency Inversion](../../11-Design-Principles/01-SOLID-Principles/README.md#d--dependency-inversion-principle) from Design Principles, applied at the scale of an entire system's architecture rather than a single class.

## The Violation: A Real, Verified Limitation From Depending on Concrete Infrastructure

```java
class MySQLDatabaseViolation {
    double fetchDiscountRate() { return 0.10; } // a real, concrete infrastructure class
}
class DiscountServiceViolation {
    private final MySQLDatabaseViolation db = new MySQLDatabaseViolation(); // hard-wired!
    double applyDiscount(double amount) { return amount - (amount * db.fetchDiscountRate()); }
}
```

`DiscountServiceViolation` — the business logic — has a compiled-in, hard dependency on one specific concrete infrastructure class. Verified live:

```
$100 order with the standard rate: $90.00
LIMITATION: to test/exercise a promotional 20% rate scenario, you would have to
actually MODIFY MySQLDatabaseViolation itself -- there is no other way in, because
DiscountServiceViolation has a hard, compiled-in dependency on that ONE concrete class.
```

This is a genuine, demonstrable limitation: there is no way to exercise `DiscountServiceViolation`'s discount logic under a different rate scenario (a promotion, a test double, a different region's database) without editing the concrete infrastructure class the domain logic happens to be welded to.

## The Fix: A Port, Defined by the Domain

```java
interface DiscountRatePort { double fetchDiscountRate(); } // the PORT -- owned by the domain
class MySQLDiscountRateAdapter implements DiscountRatePort { public double fetchDiscountRate() { return 0.10; } }
class PromotionalDiscountRateAdapter implements DiscountRatePort { public double fetchDiscountRate() { return 0.20; } }

class DiscountService {
    private final DiscountRatePort ratePort; // depends ONLY on the abstraction
    DiscountService(DiscountRatePort ratePort) { this.ratePort = ratePort; }
}
```

Verified live — the exact same `DiscountService` class correctly produces a different, valid result purely by swapping which adapter it's given, with **zero changes** to `DiscountService` or the real `MySQLDiscountRateAdapter`:

```
$100 order with the standard rate:     $90.00
$100 order with the promotional rate:  $80.00  <- exercised with ZERO changes to DiscountService or MySQLDiscountRateAdapter
```

## Detailed Example

See [Example.java](Example.java) — the real limitation caused by depending directly on infrastructure, and the port-based fix.

## Run It

```bash
cd 13-Software-Architecture/02-Clean-and-Hexagonal-Architecture
javac Example.java
java Example
```

## Expected Output

The violation section showing the standard discount correctly applied, but explicitly noting the real limitation of not being able to exercise a different rate scenario without editing the infrastructure class itself; the fixed section showing both the standard and a promotional rate correctly applied, purely by injecting a different adapter.

## Common Mistakes

- Having a business-logic class directly instantiate (`new ConcreteInfraClass()`) the infrastructure it needs, rather than depending on an interface — verified live to make that business logic impossible to exercise under a different infrastructure scenario without editing the infrastructure class itself.
- Defining the "port" interface in the infrastructure layer instead of the domain layer — Clean/Hexagonal architecture specifically wants the **domain** to own the interface, expressing exactly what it needs, with infrastructure conforming to it, not the reverse.
- Over-applying ports-and-adapters to trivial applications with no realistic need to swap infrastructure — the same YAGNI caution raised in [11-Design-Principles](../../11-Design-Principles/02-DRY-KISS-YAGNI/README.md#yagni--you-arent-gonna-need-it) applies to introducing architectural abstraction layers too.

## Best Practices

- Define interfaces (ports) in the domain/business-logic layer, expressing exactly what the domain needs from the outside world.
- Implement those interfaces in the infrastructure layer (adapters) — the infrastructure layer depends on the domain's interfaces, never the other way around.
- Inject adapters into domain classes via their constructors (as `DiscountService` does here), so different adapters (real, promotional, test doubles) can be swapped without touching the domain class itself.

## Real-World Usage

This dependency rule is what makes business logic genuinely unit-testable without a real database, and what allows swapping infrastructure (a different database, a different payment provider, a different message queue) without rewriting business logic — exactly the practical benefit demonstrated in this lesson's promotional-rate scenario. It's also the architectural foundation that makes [04-Backend-Development](../../04-Backend-Development/README.md)'s Spring Data JPA repositories (interfaces implemented by the framework) and this repository's own [07-Databases](../../07-Databases/README.md) Lesson 05 JPA examples testable in isolation.

## Summary

- A domain class hard-wired to a concrete infrastructure class was shown to have a real, verified limitation: it cannot be exercised under a different scenario without editing that infrastructure class.
- Introducing a port (an interface owned by the domain) and adapters (infrastructure implementations of that port) fixed this, verified live by exercising the exact same domain logic under two different rate scenarios with zero changes to the domain class.
- This is Dependency Inversion from [11-Design-Principles](../../11-Design-Principles/01-SOLID-Principles/README.md#d--dependency-inversion-principle), applied at the scale of a whole system's architecture.

## Key Terms

- **Domain** — the business logic layer, containing the rules that define what a system actually does.
- **Port** — an interface, defined by the domain, expressing what it needs from the outside world.
- **Adapter** — an infrastructure-layer implementation of a port, connecting the domain to a real external system (database, API, queue).

## Interview Questions

1. **What real limitation does a domain class depending directly on a concrete infrastructure class create, and how was it demonstrated in this lesson?**
   It makes the domain logic impossible to exercise under any scenario other than whatever the concrete infrastructure class happens to provide, since there's no substitutable abstraction between them. This was demonstrated concretely: `DiscountServiceViolation` could only ever apply the 10% rate hard-coded into `MySQLDatabaseViolation`, because it directly instantiated and depended on that one concrete class — verified by the explicit limitation that testing a 20% promotional scenario would require editing `MySQLDatabaseViolation` itself, which is not a realistic option for a class meant to represent a real, external database.

2. **Where should the "port" interface be defined in Hexagonal Architecture, and why does that placement matter?**
   The port should be defined by and for the domain layer — expressing exactly what the domain needs — with infrastructure-layer adapters implementing it, not the other way around. This was demonstrated by `DiscountRatePort`, which `DiscountService` (the domain) depends on directly, while `MySQLDiscountRateAdapter` and `PromotionalDiscountRateAdapter` (both infrastructure) implement it. This placement matters because it keeps the dependency direction pointing from infrastructure toward the domain, never the reverse — which is exactly what allowed `DiscountService` to be exercised under two different rate scenarios, verified live, with zero changes to the domain class itself.

## Recommended Next Lesson

[03 — Microservices Fundamentals](../03-Microservices-Fundamentals/README.md)
