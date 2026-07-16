# 13 — Software Architecture

[Back to repository root](../README.md)

## What Software Architecture Covers

Software architecture is how the object-level principles and patterns from [11-Design-Principles](../11-Design-Principles/README.md) and [12-Design-Patterns](../12-Design-Patterns/README.md) scale up to whole-system design: how layers, services, and components are organized and communicate. This module covers four foundational architectural styles — layered/N-tier, clean/hexagonal, microservices, and event-driven — each demonstrated as a real, verified bug caused by *not* following the architecture's core discipline, followed by a fix.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language rather than duplicating every lesson across every language in `01-Languages` (see [11-Design-Principles](../11-Design-Principles/README.md) and [12-Design-Patterns](../12-Design-Patterns/README.md) for the same reasoning). Lessons 01, 02, and 04 are single, self-contained `Example.java` files needing no build tool. Lesson 03 uses the JDK's built-in `com.sun.net.httpserver.HttpServer` and `java.net.http.HttpClient` — the same zero-framework HTTP approach as [04-Backend-Development Lesson 01](../04-Backend-Development/01-REST-API-Fundamentals/README.md) — to demonstrate a genuinely real HTTP API boundary between two services, verified with actual network requests rather than simulated in-process calls.

## Why It Matters / Where It's Used

- **Architecture decisions have long-lasting consequences** — the cost of a wrong architectural boundary (or a missing one) compounds over a system's lifetime far more than a single class's design.
- **Every pattern in this module addresses a real, recurring failure mode**: a skipped validation layer letting bad data through, business logic welded to infrastructure and untestable in isolation, a shared-state overselling bug, and a non-critical failure cascading into a critical one — all reproduced live, not just described.
- **Interviews**: "walk me through how you'd structure a new service," "what's the difference between a layered monolith and microservices," and "how would you make this business logic testable without a database" are extremely common system-design interview topics, directly covered by this module's four lessons.

## Advantages of This Approach

- Every architectural concept in this module is backed by a **real, compiled, and run bug**: a negative-quantity order silently saved (Lesson 01), a domain class provably unable to be exercised under a different scenario without editing infrastructure (Lesson 02), a real overselling bug fixed with an actual HTTP server rejecting a real request with a real `409 Conflict` (Lesson 03), and a non-critical failure genuinely blocking an operation's completion message (Lesson 04).
- Lesson 03 goes further than the other lessons in this repository's design-focused modules by spinning up **real, separate HTTP endpoints** and making **real network calls** between them — directly extending the safe server-verification discipline established in [04-Backend-Development](../04-Backend-Development/README.md).
- Each lesson is directly cross-referenced with the object-level principles/patterns it scales up: Lesson 02 is Dependency Inversion at architecture scale; Lesson 04 is a distinct, reliability-focused counterpart to Observer.

## Disadvantages / Trade-offs

- These architectural styles are not mutually exclusive or strictly ordered in sophistication — a well-layered monolith (Lesson 01) is often the right choice, and prematurely adopting microservices (Lesson 03) or event-driven architecture (Lesson 04) before a genuine need exists adds real operational complexity without benefit.
- This module's examples are deliberately simplified to fit in single, runnable files — real systems following these architectures involve far more operational concerns (service discovery, distributed tracing, message durability) beyond what's demonstrated here.

## How to Run the Examples

Lessons 01, 02, and 04 are single, self-contained Java files — no build tool or dependencies required.

```bash
cd 13-Software-Architecture/01-Layered-N-tier-Architecture
javac Example.java
java Example
```

Lesson 03 additionally starts and cleanly stops a real embedded HTTP server on `localhost:8099` as part of its own execution — no separate setup is required; running `java Example` handles the full start/verify/stop lifecycle automatically. Requires only a JDK (this module was built and verified against JDK 25). `.class` files are not committed — recompile locally after cloning.

## Common Beginner Mistakes

- **Letting a presentation/UI layer call the data access layer directly** — verified live in Lesson 01 to let invalid data bypass validation and reach storage.
- **Having business logic directly instantiate concrete infrastructure classes** — verified live in Lesson 02 to make that logic impossible to exercise under a different scenario without editing the infrastructure itself.
- **Sharing mutable state directly between "services" instead of enforcing a real API boundary** — verified live in Lesson 03 to allow a real overselling bug (negative inventory).
- **Calling non-critical side effects synchronously and unguarded alongside critical operations** — verified live in Lesson 04 to let a non-critical failure block an otherwise fully successful operation.

## Best Practices

- Keep validation and business rules in a service layer that the presentation layer cannot bypass.
- Define ports (interfaces) in the domain layer and implement them with infrastructure-layer adapters, never the reverse.
- Ensure every service owns its state exclusively, exposed only through a validating API boundary.
- Isolate non-critical side effects from critical operations, so a non-critical failure can never cascade into blocking a critical one.

## Interview Questions

1. What's the difference between a layered architecture and a microservices architecture?
2. What does the "Dependency Rule" in Clean/Hexagonal architecture actually require, and why?
3. What makes something a genuine microservice, beyond just being a separate deployable process?
4. What's the difference between Observer (from Design Patterns) and event-driven architecture's reliability-isolation benefit?
5. What is a "distributed monolith," and how does it happen?
6. How would you make business logic testable without a real database?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Layered (N-tier) Architecture](01-Layered-N-tier-Architecture/README.md) | A real bug from skipping the service layer's validation |
| 02 | [Clean and Hexagonal Architecture](02-Clean-and-Hexagonal-Architecture/README.md) | Ports and adapters; Dependency Inversion at architecture scale |
| 03 | [Microservices Fundamentals](03-Microservices-Fundamentals/README.md) | A real overselling bug fixed with a genuine, verified HTTP API boundary |
| 04 | [Event-Driven Architecture Basics](04-Event-Driven-Architecture-Basics/README.md) | Reliability isolation: a non-critical failure that cannot cascade |

## Suggested Path

Work through 01 → 04 in order — each lesson builds on progressively larger architectural scope (a single application's layers, then a single service's internal dependency direction, then multiple services' boundaries, then how those services communicate reliably). See also [11-Design-Principles](../11-Design-Principles/README.md) and [12-Design-Patterns](../12-Design-Patterns/README.md) for the object-level foundations this module scales up, and [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) (if built) for a deeper treatment of the HTTP API design touched on in Lesson 03.

**Previous module:** [12-Design-Patterns](../12-Design-Patterns/README.md)
