# 22 — Projects

[Back to repository root](../README.md)

## What Projects Covers

Three complete, runnable, progressively larger applications, each combining skills from multiple modules already built elsewhere in this repository rather than drilling one topic in isolation — the same cross-cutting philosophy as [24-Exercises](../24-Exercises/README.md)/[25-Solutions](../25-Solutions/README.md), but at project scale instead of exercise scale.

## Table of Contents

| Level | Project | Stack | Combines |
|-------|---------|-------|----------|
| Beginner | [Task-Management-CRUD](Beginner/Task-Management-CRUD/README.md) | Vanilla HTML/CSS/JS, `localStorage` | [03-Frontend-Development](../03-Frontend-Development/README.md) |
| Intermediate | [Library-Management-System](Intermediate/Library-Management-System/README.md) | Spring Boot 4.1.0, JPA, H2, Spring Security, JWT | [04-Backend-Development](../04-Backend-Development/README.md) + [07-Databases](../07-Databases/README.md) + [16-Security](../16-Security/README.md) |
| Advanced | [Distributed-Order-Processing-System](Advanced/Distributed-Order-Processing-System/README.md) | Two independent Spring Boot services over real HTTP | [13-Software-Architecture](../13-Software-Architecture/README.md) + [07-Databases](../07-Databases/README.md) + [16-Security](../16-Security/README.md) |

## Progression

Each project deliberately raises the stakes of the one before it:

- **Beginner** has no backend at all — a single client, single data store (`localStorage`), zero network calls. It establishes clean CRUD logic separated from rendering.
- **Intermediate** introduces a real backend, a real relational database, and real authentication/authorization — but everything still lives in one deployable process.
- **Advanced** splits that single process into two genuinely independent services with no shared database, forcing an explicit answer to the question every real microservice architecture has to answer: what do you do when the other service is unreachable? See [Distributed-Order-Processing-System's CP-over-AP design decision](Advanced/Distributed-Order-Processing-System/README.md#the-core-design-decision-cp-over-ap) for the answer this repository chose, and why.

## Verification Discipline

Every project here was actually run, not just compiled: the Beginner project was tested by hand in a real browser; the Intermediate and Advanced projects had every endpoint and business rule exercised with real `curl` requests against actually-running servers, including the Advanced project's core scenario — killing one service's real OS process mid-demo to prove the partition-handling behavior, then restarting it to prove recovery. See each project's own README for the exact commands and captured output.

**Previous module:** [21-Interview-Preparation](../21-Interview-Preparation/README.md)
**Next module:** [23-Cheat-Sheets](../23-Cheat-Sheets/README.md)
