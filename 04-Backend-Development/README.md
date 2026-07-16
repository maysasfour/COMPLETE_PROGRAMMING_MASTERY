# 04 — Backend Development

[Back to repository root](../README.md)

## What Backend Development Covers

Backend development is everything that happens on the server side of a web application: receiving HTTP requests, running business logic, persisting and retrieving data, enforcing who's allowed to do what, and returning responses — all without a user interface of its own. This module builds a single, evolving example (a task-management REST API) across five lessons, each adding one real capability: raw HTTP mechanics, a framework, persistence, security, and testing.

## Why Java and Spring Boot as This Module's Reference Stack

This repository's concept modules each pick one reference language/stack rather than duplicating every lesson across every language in `01-Languages` (see [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md)'s Python choice and [10-Functional-Programming](../10-Functional-Programming/README.md)'s, for the same reasoning). This module uses **Java with Spring Boot**, the most widely deployed stack for production Java backends, and the natural choice given this repository's existing, complete Java language course. The ideas — REST conventions, ORM-based persistence, token-based auth, the unit/integration test split — transfer directly to Node.js/Express, Django, ASP.NET Core, or any other backend framework covered by this repository's other language courses; only the syntax and specific library APIs change. (Node.js/Express specifically is not covered as a separate lesson here — this repository's JavaScript/TypeScript courses in `01-Languages` already cover async HTTP handling in depth, and a full second backend framework tutorial would duplicate rather than add new concepts.)

## Why It Matters / Where It's Used

- **Every non-trivial web/mobile app needs a backend** — for data that must be shared, validated, or kept secure beyond what a client alone can guarantee.
- **REST APIs are the default integration format** — nearly every public API (Stripe, GitHub, Twilio) and most internal microservice architectures communicate this way.
- **Interviews**: "design a REST API for X," "how would you secure this endpoint," and "how do you test a service layer" are extremely common backend interview questions, directly mirroring this module's five lessons.

## Advantages of This Stack

- Spring Boot's annotation-driven approach (`@RestController`, `@Entity`, `@PreAuthorize`) lets a working REST API, persistence layer, and security layer be built with a small amount of code, verified live across all five lessons in this module.
- Spring Data JPA eliminates hand-written SQL for common CRUD operations entirely — verified live via derived query methods (Lesson 03) generating real SQL from a method name alone.
- The Spring ecosystem's test support (`@WebMvcTest`, `@SpringBootTest`) makes both fast unit tests and full integration tests straightforward to write (Lesson 05).

## Disadvantages / Trade-offs

- Spring Boot's "magic" (auto-configuration, annotation-driven wiring) can obscure what's actually happening under the hood for newcomers — Lesson 01 deliberately starts with zero framework at all, using only the JDK's built-in HTTP server, specifically to make the underlying REST mechanics visible before Spring abstracts them away.
- A full Spring Boot application has a real startup cost (several seconds, verified across every lesson's live runs in this module) compared to a minimal HTTP server — a genuine trade-off against the developer-ergonomics gains.
- Major version upgrades can introduce real breaking changes requiring investigation, not just documentation-reading — Lesson 05 hit and worked through several genuine Spring Boot 4.x test-support API changes live, discovered by inspecting actual resolved dependencies rather than assuming prior knowledge still applied.

## How to Run the Examples

Each lesson folder has its own `pom.xml` and is a self-contained Maven project.

```bash
cd 04-Backend-Development/02-Building-a-REST-API-with-Spring-Boot
mvn spring-boot:run
```

Requires a JDK (this module was built and verified against JDK 25) and Apache Maven (this module was verified against Maven 3.9.16). No IDE is required — every lesson was verified purely via `mvn compile`/`mvn spring-boot:run`/`mvn test` from the command line. Each lesson runs on a distinct port (8082, 8090, 8091, 8092, 8093) so multiple lessons' servers never conflict if accidentally left running simultaneously.

## Common Beginner Mistakes

- **Confusing authentication with authorization** — verified live in Lesson 04: a correctly-authenticated user (a valid JWT) was still correctly denied a specific action (`DELETE`) because they lacked the required role — being logged in is not the same as being allowed to do everything.
- **Returning `200 OK` for every outcome** — real REST APIs use the status code itself to communicate success/failure category (Lesson 01); a `404` and a `400` mean genuinely different things to a well-behaved client.
- **Assuming an unauthenticated request always returns `401`** — verified live in Lesson 04 that Spring Security's actual default (with no custom entry point configured) is `403` in this setup.
- **Writing only unit tests or only integration tests** — Lesson 05 demonstrates why both matter: a mocked-repository unit test can never catch a genuinely wrong database query, while integration-tests-only makes for a slow, impractical feedback loop during development.
- **Not investigating framework upgrade breakage directly** — Lesson 05's real Spring Boot 4.x test-API changes were found by inspecting actual resolved JAR contents after a real compile failure, not by assuming outdated tutorials still applied.

## Best Practices

- Use `ResponseEntity<T>` (or your framework's equivalent) to express the exact, intended status code for every outcome, not just the happy path.
- Keep request/response DTOs separate from internal domain/persistence models — Lesson 02's `NewTaskRequest` deliberately excludes fields a client shouldn't control directly.
- Never store or compare plaintext passwords — Lesson 04 uses BCrypt hashing even in its deliberately-simplified demo user store.
- Maintain both fast unit tests (mocked dependencies) and slower integration tests (real database, real HTTP) — Lesson 05's 7-unit/3-integration split reflects a realistic, healthy ratio.

## Interview Questions

1. What's the difference between `200`, `201`, `204`, `400`, and `404`, and when should each be used?
2. What does REST's "statelessness" constraint mean, and why does it matter for scalability?
3. What's the difference between authentication and authorization? Can a valid, authenticated request still be denied?
4. What does `@Entity`/`JpaRepository` provide, and how does a derived query method (`findByDoneFalse`) actually work with no query written?
5. Why is a JWT considered "stateless" compared to traditional session-cookie authentication?
6. What's the difference between a unit test (`@WebMvcTest`) and an integration test (`@SpringBootTest`) for a REST API, and why do you need both?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [REST API Fundamentals](01-REST-API-Fundamentals/README.md) | Resources, HTTP methods, status codes, statelessness — built with zero framework |
| 02 | [Building a REST API with Spring Boot](02-Building-a-REST-API-with-Spring-Boot/README.md) | `@RestController`, `ResponseEntity`, records as DTOs |
| 03 | [Data Persistence with Spring Data JPA](03-Data-Persistence-with-Spring-Data-JPA/README.md) | `@Entity`, `JpaRepository`, derived queries, embedded H2 |
| 04 | [Authentication and Authorization](04-Authentication-and-Authorization/README.md) | Spring Security, JWT, `@PreAuthorize`, role-based access |
| 05 | [Testing a REST API](05-Testing-a-REST-API/README.md) | `@WebMvcTest`/`@MockitoBean` unit tests, `@SpringBootTest` integration tests |

## Suggested Path

Work through 01 → 05 in order — each lesson builds directly on the previous one's code (Lesson 02 reimplements Lesson 01's API with a framework; Lesson 03 swaps Lesson 02's in-memory storage for a real database; Lesson 04 secures Lesson 03's API; Lesson 05 tests an API following the same shape). See also [07-Databases](../07-Databases/README.md) for SQL/database-design fundamentals underlying Lesson 03, and [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) for API design/documentation topics beyond what this module covers.

**Previous module:** [10-Functional-Programming](../10-Functional-Programming/README.md)
