# Solution 05 — Layered Validation

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/05-Layered-Validation.md)

## Approach

`ProductRepository` is made **package-private** (no `public` modifier) inside `com.example.solution05.core`, alongside the public `ProductService` that validates before delegating to it. `Main` lives in a different package — it can use `ProductService`, but referencing `ProductRepository` directly would be a genuine **compile error**, not just a convention.

## Verified Live

```
=== Violation: repository called directly, no validation ===
Rows in products:
  Broken Widget ($-5.0)  <- BUG: a negative price was saved!

=== Fixed: application code can ONLY reach ProductService ===
Rejected: Product price must be positive, got: -5.0
Products in the database after the rejected attempt:
Products in the database after a VALID product:
  Real Widget ($9.99)
```

The invalid product was correctly rejected before ever reaching the database, and a real, valid product still saved correctly — the same layered-architecture discipline verified in [13-Software-Architecture/01-Layered-N-tier-Architecture](../../13-Software-Architecture/01-Layered-N-tier-Architecture/README.md).

## Run It

```bash
cd 25-Solutions/05-Layered-Validation
mvn compile exec:java
```

See [Product.java](src/main/java/com/example/solution05/core/Product.java), [ProductRepository.java](src/main/java/com/example/solution05/core/ProductRepository.java), [ProductService.java](src/main/java/com/example/solution05/core/ProductService.java), and [Main.java](src/main/java/com/example/solution05/Main.java) for the full, runnable solution.
