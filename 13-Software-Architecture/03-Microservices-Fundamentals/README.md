# 03 — Microservices Fundamentals

[Back to module overview](../README.md) | [Previous: Clean and Hexagonal Architecture](../02-Clean-and-Hexagonal-Architecture/README.md)

## Beginner: What Actually Makes Something a Microservice

The defining property of a microservice isn't "it's a separate process" — it's that each service **owns its own state completely**, and the *only* way another service can affect that state is through a well-defined API (usually HTTP), which can enforce validation that direct access never could. This lesson demonstrates a real overselling bug caused by skipping that boundary entirely (a "distributed monolith" anti-pattern, modeled here as direct shared-state access), then fixes it with a **real HTTP server**, verified with actual network requests — not a simulation.

## The Violation: A Real Overselling Bug From No Service Boundary

```java
class InventoryModuleViolation {
    public int stock = 5; // exposed directly -- no boundary, no validation
}
class OrderModuleViolation {
    void placeOrder(InventoryModuleViolation inventory, int quantity) {
        inventory.stock -= quantity; // directly mutates ANOTHER module's internal state
    }
}
```

Verified live — ordering more than exists in stock succeeds silently, producing an impossible negative inventory count:

```
Starting stock: 5
Stock after ordering 10 (only 5 existed): -5  <- BUG: NEGATIVE stock, nothing enforced a real boundary!
```

This is exactly the risk of a "distributed monolith": even if `OrderModule` and `InventoryModule` are deployed as separate processes, if they still share a database table (or, as modeled here, memory) directly instead of going through a real, validating API, the same class of bug occurs.

## The Fix: A Real HTTP API Boundary, Verified With Real Requests

`InventoryService` is implemented as an actual HTTP server (`com.sun.net.httpserver.HttpServer`, the same JDK-built-in server used in [04-Backend-Development Lesson 01](../../04-Backend-Development/01-REST-API-Fundamentals/README.md)), and `OrderService`'s request goes over a **real network call** via `java.net.http.HttpClient` — there is no way for it to reach `InventoryService`'s internal state except through this one endpoint, which validates every request:

```java
if (qty > stock.get()) {
    statusCode = 409; // Conflict -- the boundary REJECTS an invalid request
} else {
    stock.addAndGet(-qty);
    statusCode = 200;
}
```

Verified live, with real HTTP requests and real responses:

```
OrderService requests 10 units (only 5 exist) via a real HTTP call:
  HTTP 409 {"error":"insufficient stock","available":5}  <- correct: the API boundary REJECTED the oversell attempt
OrderService requests 3 units (valid) via a real HTTP call:
  HTTP 200 {"reserved":3,"remaining":2}  <- correct: accepted and stock decremented
```

The oversell attempt was correctly rejected with a real `409 Conflict`, and a genuinely valid request correctly succeeded — because the *only* path to `InventoryService`'s stock count is through code that validates every request, something direct field access can never guarantee.

## Detailed Example

See [Example.java](Example.java) — the real overselling bug and the real HTTP-boundary fix, including starting and cleanly stopping an actual embedded HTTP server.

## Run It

```bash
cd 13-Software-Architecture/03-Microservices-Fundamentals
javac Example.java
java Example
```

## Expected Output

The violation section showing stock going negative (`-5`) after an oversell attempt; the fixed section showing a real HTTP server starting, correctly rejecting an oversell attempt with `409`, correctly accepting a valid request with `200`, and shutting down cleanly.

## Common Mistakes

- Splitting code into separate deployable services while still letting them share a database table (or, worse, in-memory state) directly — this is a "distributed monolith": you get the operational complexity of microservices with none of the data-integrity benefits, exactly the risk this lesson's violation models.
- Assuming any inter-process boundary is automatically safe — the boundary only helps if the code on the other side of it actually validates requests, as `InventoryService`'s `/reserve` endpoint does here.
- Splitting a system into microservices prematurely, before team/deployment/scaling needs actually justify the added operational complexity — a well-structured [layered monolith](../01-Layered-N-tier-Architecture/README.md) is often the right starting point.

## Best Practices

- Each service should own its data exclusively — no other service should ever read or write it except through that service's own API.
- Have the API boundary enforce the validation that matters (as `InventoryService` does with its stock check) — the boundary itself is the thing that makes microservices safer than shared-memory access, not just the fact that it's a separate process.
- Prefer starting with a well-layered monolith and extracting services only when a genuine, specific need (independent scaling, independent deployment, team boundaries) justifies it.

## Real-World Usage

The overselling bug demonstrated here — two parts of a system directly manipulating the same inventory count without a validating boundary — is a genuine, common category of real e-commerce bug, especially during high-traffic events (flash sales) where the assumption "surely no one will order more than we have" gets tested at scale. Real microservice architectures use exactly this pattern (an HTTP or gRPC API in front of a service's private data store) specifically to make this class of bug structurally harder to introduce.

## Summary

- Direct shared-state access between two "modules" was shown to allow a real overselling bug — stock going to `-5` after an invalid order.
- A real HTTP API boundary, verified with actual network requests using the JDK's built-in `HttpServer`/`HttpClient`, correctly rejected the same oversell attempt with a `409 Conflict` while still accepting a genuinely valid request.
- The safety comes specifically from the boundary enforcing validation on every request, not merely from services being deployed as separate processes.

## Key Terms

- **Service boundary** — the API through which a service's internal state can be affected; nothing outside the service should bypass it.
- **Distributed monolith** — an anti-pattern where services are deployed separately but still share data directly, gaining microservices' operational complexity without their data-integrity benefits.
- **409 Conflict** — an HTTP status code indicating the request conflicts with the current state of the resource (here, insufficient stock).

## Interview Questions

1. **What actually makes a system "microservices," beyond just running as separate processes, and how was this demonstrated in this lesson?**
   The defining property is that each service owns its state completely, and no other service can affect that state except through a well-defined, validating API. This was demonstrated by contrasting direct field access (`inventory.stock -= quantity`, which allowed stock to go to `-5`) against a real HTTP endpoint (`/reserve`) that validates every request before modifying `InventoryService`'s internal `stock` counter, verified by an oversell attempt receiving an actual `409 Conflict` response over a real network call rather than silently succeeding.

2. **What is a "distributed monolith," and how does this lesson's violation model that risk?**
   A distributed monolith is a system split into separately deployed services that still share data directly (a shared database table, or worse, shared memory) instead of going through each other's validating APIs — it has all the operational overhead of microservices (network calls, deployment coordination) with none of the data-integrity safety. This lesson's violation models the "sharing data directly" half of that risk: even without literally being separate processes, `OrderModuleViolation` and `InventoryModuleViolation` demonstrate exactly what goes wrong when one component can reach into another's state without validation — the fix demonstrates the actual solution: routing all access through a real, validating API boundary.

## Recommended Next Lesson

[04 — Event-Driven Architecture Basics](../04-Event-Driven-Architecture-Basics/README.md)
