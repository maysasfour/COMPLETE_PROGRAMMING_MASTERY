# 25 — Solutions

[Back to repository root](../README.md)

## What Solutions Covers

Fully verified, runnable solutions to every exercise in [24-Exercises](../24-Exercises/README.md), kept in a separate folder deliberately — per this repository's own conventions, so working through the exercises isn't undermined by the solutions being immediately visible alongside them.

## Verification Discipline

Every solution here was actually compiled and run, with its real output captured in that solution's own README — including, where the exercise calls for it, a genuine reproduced bug (a real SQL injection bypass, a real race condition allowing more requests than a rate limiter's stated maximum, a real negative-priced product reaching a database) followed by the verified fix. Nothing here is asserted without having actually been executed.

## Table of Contents

| # | Solution | Exercise |
|---|----------|----------|
| 01 | [Secure Repository Query](01-Secure-Repository-Query/README.md) | [24-Exercises/01](../24-Exercises/01-Secure-Repository-Query.md) |
| 02 | [Idempotent Endpoint](02-Idempotent-Endpoint/README.md) | [24-Exercises/02](../24-Exercises/02-Idempotent-Endpoint.md) |
| 03 | [Thread-Safe Rate Limiter](03-Thread-Safe-Rate-Limiter/README.md) | [24-Exercises/03](../24-Exercises/03-Thread-Safe-Rate-Limiter.md) |
| 04 | [Strategy Pattern Refactor](04-Strategy-Refactor/README.md) | [24-Exercises/04](../24-Exercises/04-Strategy-Refactor.md) |
| 05 | [Layered Validation](05-Layered-Validation/README.md) | [24-Exercises/05](../24-Exercises/05-Layered-Validation.md) |
| 06 | [Secure Password Reset Flow](06-Password-Reset-Flow/README.md) | [24-Exercises/06](../24-Exercises/06-Password-Reset-Flow.md) |

## How to Run Any Solution

Solutions using only the JDK (02, 03, 04, 06) need no build tool:
```bash
cd 25-Solutions/02-Idempotent-Endpoint
javac Example.java && java Example
```

Solutions using H2 (01, 05) are self-contained Maven projects:
```bash
cd 25-Solutions/01-Secure-Repository-Query
mvn compile exec:java
```

**Previous module:** [24-Exercises](../24-Exercises/README.md)
