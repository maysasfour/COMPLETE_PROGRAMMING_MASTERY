# Software Architecture Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../13-Software-Architecture/README.md)

## Layered (N-tier) Architecture
Presentation → Business/Service → Data Access, each layer depending only on the one beneath it. Verified live in [13-Software-Architecture/01](../../13-Software-Architecture/01-Layered-N-tier-Architecture/README.md): skipping the service layer let a negative-quantity order reach storage unchecked.

## Clean / Hexagonal Architecture (Ports and Adapters)
```java
interface DiscountRatePort { double fetchDiscountRate(); }        // owned by the DOMAIN
class MySQLDiscountRateAdapter implements DiscountRatePort { ... } // infrastructure implements it
class DiscountService {
    DiscountService(DiscountRatePort port) { ... }  // domain depends only on the abstraction
}
```
Verified live in [13-Software-Architecture/02](../../13-Software-Architecture/02-Clean-and-Hexagonal-Architecture/README.md): a domain class hard-wired to a concrete infrastructure class couldn't be exercised under a different scenario without editing that infrastructure class.

## Microservices Fundamentals
A genuine microservice owns its state completely, exposed only through a validating API. Verified live in [13-Software-Architecture/03](../../13-Software-Architecture/03-Microservices-Fundamentals/README.md): direct shared-state access allowed a real overselling bug; a real HTTP endpoint correctly rejected the identical oversell attempt with `409 Conflict`.

## Event-Driven Architecture
```java
class EventBus {
    void publish(String data) {
        for (var listener : listeners) {
            try { listener.onEvent(data); }
            catch (Exception e) { /* isolate -- one failure can't block others */ }
        }
    }
}
```
Verified live in [13-Software-Architecture/04](../../13-Software-Architecture/04-Event-Driven-Architecture-Basics/README.md): a synchronous analytics failure blocked an order's success message; isolating subscriber exceptions fixed it.

## CAP Theorem
A distributed system chooses at most two of Consistency, Availability, Partition tolerance during an actual partition. Verified live with a real stopped server in [20-Computer-Science-Fundamentals/04](../../20-Computer-Science-Fundamentals/04-CAP-Theorem-and-Distributed-Systems/README.md): CP mode rejected a write with `503`; AP mode accepted it, producing real, measured data divergence once the partition healed.

See the [full Software Architecture module](../../13-Software-Architecture/README.md) for verified, runnable code for everything above.
