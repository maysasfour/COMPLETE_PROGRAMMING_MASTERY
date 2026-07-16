# 01 — Layered (N-tier) Architecture

[Back to module overview](../README.md)

## Beginner: What Layered Architecture Solves

Layered (N-tier) architecture separates a system into distinct layers — typically presentation, business/service, and data access — where each layer only communicates with the layer directly beneath it. The service layer is usually where business rules and validation live; the data access layer's job is just to persist and retrieve, with no opinion on whether the data is valid. This lesson demonstrates a real bug that occurs when a layer is skipped, letting invalid data reach storage unchecked.

## The Violation: A Real Data-Integrity Bug From Skipping a Layer

```java
static void presentationLayerViolation(OrderRepository repository) {
    repository.save(new Order("Widget", -5)); // no validation ever runs -- straight to storage!
}
```

The `OrderRepository` (data access layer) has no validation logic — that lives in `OrderService` (service layer). Calling the repository directly, bypassing the service layer entirely, skips that validation. Verified live:

```
Orders now in the repository: [-5x Widget]  <- BUG: a NEGATIVE quantity order was saved, because validation was bypassed!
```

A negative-quantity order — nonsensical for a real order — was saved successfully, because nothing in the call path ever checked it.

## The Fix: Enforce the Layer Boundary

```java
static void presentationLayerFixed(OrderService service, OrderRepository repository) {
    service.placeOrder("Widget", -5); // the ONLY path available goes through validation
}
```

Verified live — the same invalid order is now correctly rejected, and never reaches the repository at all:

```
Rejected: Quantity must be positive, got: -5
Orders now in the repository: []  <- correct: the invalid order was never saved
Orders now in the repository: [3x Widget]  <- the valid order WAS saved
```

The key architectural point: it's not that `OrderService`'s validation is "better" code — it's that the presentation layer has **no other path** to the repository once the layer boundary is actually enforced (in Java, this typically means keeping `OrderRepository` package-private or otherwise inaccessible outside the data access layer, so the compiler — not just convention — prevents the bypass).

## Detailed Example

See [Example.java](Example.java) — the real skipped-validation bug and the layered fix.

## Run It

```bash
cd 13-Software-Architecture/01-Layered-N-tier-Architecture
javac Example.java
java Example
```

## Expected Output

The violation section showing a negative-quantity order successfully (and wrongly) saved directly to the repository; the fixed section showing the same invalid order correctly rejected by the service layer, with only a genuinely valid order reaching storage.

## Common Mistakes

- Exposing the data access layer's classes/methods directly to the presentation layer "just this once, for convenience" — verified live to let a whole category of validation get silently bypassed.
- Putting validation logic in the presentation layer instead of the service layer — this technically avoids the specific bug shown here, but duplicates validation logic if there's ever a second presentation layer (a REST API alongside a UI, for example) calling the same service.
- Treating layering as purely a folder/package naming convention rather than an enforced boundary — real protection requires actually restricting access (via visibility modifiers or module boundaries), not just organizing files.

## Best Practices

- Keep validation and business rules in the service layer; keep the data access layer focused purely on persistence.
- Restrict data access layer classes' visibility so the presentation layer has no way to reach them directly, even if a developer tries to for convenience.
- Design each layer to be replaceable independently — a properly layered `OrderService` shouldn't need to change if the data access layer switches from an in-memory list to a real database.

## Real-World Usage

Layered architecture remains the default structure for most business applications — a web controller (presentation), a service class enforcing business rules (business layer), and a repository (data access layer), exactly mirroring [04-Backend-Development](../../04-Backend-Development/README.md)'s Spring Boot examples. The specific bug demonstrated here — a UI or API layer calling a repository directly and bypassing validation — is a genuine, recurring category of real production data-integrity bug, especially in codebases that grow organically without enforced layer boundaries.

## Summary

- Layered architecture separates presentation, business logic, and data access into distinct layers, each depending only on the one beneath it.
- Skipping the service layer and calling the data access layer directly was shown to let invalid data (a negative-quantity order) reach storage unchecked.
- Enforcing that the presentation layer can only reach the service layer made the same invalid data correctly rejected before it ever reached storage.

## Key Terms

- **Presentation layer** — the layer handling user/API-facing interaction (a UI or REST controller).
- **Business/service layer** — the layer enforcing business rules and validation.
- **Data access layer** — the layer responsible purely for persisting and retrieving data, with no business logic of its own.

## Interview Questions

1. **Why does skipping the service layer and calling the data access layer directly create a real risk, and how was this demonstrated concretely?**
   The service layer is typically where validation and business rules live; the data access layer's job is only to persist and retrieve data, with no opinion on whether that data is valid. Calling the data access layer directly bypasses whatever validation the service layer would have performed. This was demonstrated concretely: calling `OrderRepository.save()` directly with a negative quantity succeeded and stored the invalid order, verified by printing the repository's actual contents (`[-5x Widget]`), whereas routing the same call through `OrderService.placeOrder()` correctly rejected it before it ever reached the repository.

2. **What makes a layer boundary "enforced" rather than just a naming/organizational convention?**
   An enforced boundary means the layer that should be bypassed is not just conventionally avoided but is actually inaccessible — for example, restricting the data access layer's classes to package-private visibility so no code outside that layer's package can call them directly, forcing all access through the service layer. Without this enforcement, the layering is only a suggestion, and a developer under time pressure (or unaware of the convention) can call the repository directly, exactly as shown in this lesson's violation.

## Recommended Next Lesson

[02 — Clean and Hexagonal Architecture](../02-Clean-and-Hexagonal-Architecture/README.md)
