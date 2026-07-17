# Exercise 05 — Layered Validation

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/05-Layered-Validation/README.md)

**Combines:** [13-Software-Architecture](../13-Software-Architecture/README.md) (Layered Architecture) + [07-Databases](../07-Databases/README.md) (JDBC persistence)

## Problem

You're given a `ProductRepository` (data access layer) with no validation of its own, and no service layer sitting in front of it — application code calls the repository directly:

```java
repository.save(new Product("Widget", -5.00)); // a negative price, saved without complaint
```

1. Demonstrate, with a real H2 database, that calling the repository directly allows a negative-priced product to be saved.
2. Introduce a `ProductService` layer that validates (price must be `> 0`, name must not be blank) before delegating to the repository.
3. Restructure the code so the repository is not directly reachable from application code — application code can only go through `ProductService`.
4. Verify live: the same invalid product is now rejected with a clear error, and never reaches the database; a genuinely valid product still saves correctly.

## Constraints

- Use a real H2 database — the validation must be proven to actually prevent a real row from being inserted, not just checked in isolation.
- The fix must make the repository genuinely unreachable from outside the service layer (e.g., via package-private visibility), not merely "usually called through the service by convention."

## Success Criteria

- The violation is shown, with a real query against the database afterward, to contain the invalid row.
- The fix is shown, with a real query against the database afterward, to contain zero invalid rows and exactly the valid ones submitted.
