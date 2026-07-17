# Solution 01 — Secure Repository Query

[Back to Solutions overview](../README.md) | [Exercise](../../24-Exercises/01-Secure-Repository-Query.md)

## Approach

`findByUsernameVulnerable` builds SQL via string concatenation; `findByUsernameFixed` uses `PreparedStatement` with a bound parameter instead.

## Verified Live

```
=== Step 1: demonstrate the vulnerability ===
findByUsernameVulnerable("' OR '1'='1' --") returned 2 row(s): [alice, bob]
  BUG: should return 0 rows (no user is actually named that), but returned ALL rows!

=== Step 2 & 3: fixed version, identical payload ===
findByUsernameFixed("' OR '1'='1' --") returned 0 row(s): []
  Correct: 0 rows -- the payload is treated as a literal username, not SQL

=== Confirming a real, legitimate lookup still works ===
findByUsernameFixed("alice") returned 1 row(s): [alice]
```

## Why This Works Structurally

`PreparedStatement` sends the query's structure (`WHERE username = ?`) and the parameter value to the database *separately* — the database never re-parses the bound value as SQL syntax, no matter what characters it contains. This is the same finding verified in [16-Security/01-SQL-Injection](../../16-Security/01-SQL-Injection/README.md).

## Run It

```bash
cd 25-Solutions/01-Secure-Repository-Query
mvn compile exec:java
```

See [Main.java](src/main/java/com/example/solution01/Main.java) for the full, runnable solution.
