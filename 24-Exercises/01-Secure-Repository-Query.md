# Exercise 01 — Secure Repository Query

[Back to Exercises overview](README.md) | [Solution](../25-Solutions/01-Secure-Repository-Query/README.md)

**Combines:** [07-Databases](../07-Databases/README.md) (JDBC) + [16-Security](../16-Security/README.md) (SQL injection prevention) + [15-Testing-and-Debugging](../15-Testing-and-Debugging/README.md) (verifying a fix with a real exploit attempt)

## Problem

You're given a `UserRepository` with a `findByUsername(String username)` method that builds its SQL query by string concatenation:

```java
String sql = "SELECT * FROM users WHERE username = '" + username + "'";
```

1. Demonstrate — with a real, running H2 database — that this method is vulnerable to SQL injection. Specifically, show that calling `findByUsername("' OR '1'='1' --")` returns **every** row in the table, not zero rows.
2. Fix `findByUsername` to use a parameterized query (`PreparedStatement`).
3. Verify the identical malicious input now correctly returns **no** rows (assuming no user is actually named that).
4. Write a note explaining why this fix works structurally, not just for this one payload.

## Constraints

- Use a real H2 in-memory database (`jdbc:h2:mem:...`), not a mock.
- Seed the table with at least 2 real users before testing.
- Print the actual SQL executed and the actual row count returned at each step.

## Success Criteria

- The vulnerable version genuinely returns all rows for the injection payload (verified by row count, not assumed).
- The fixed version genuinely returns zero rows for the identical payload.
- A legitimate lookup (a real, existing username) still succeeds correctly after the fix.
