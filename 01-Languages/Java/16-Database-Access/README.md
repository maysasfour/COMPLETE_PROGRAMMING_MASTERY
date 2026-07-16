# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using JDBC (`java.sql`), the JDK's built-in database access API.
- Use `PreparedStatement` with `?` placeholders to prevent SQL injection.
- Understand the JDBC driver JAR is a required external dependency — the JDK provides the API, not any specific database's driver.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

**JDBC** (`java.sql`) is the JDK's built-in, database-agnostic database access API — `Connection`, `Statement`, `PreparedStatement`, `ResultSet` are all part of the standard library. What the JDK does *not* provide is a driver for any specific database — that's a separate JAR (here, `sqlite-jdbc`) each database vendor publishes, loaded onto the classpath. This is a genuine difference from C#'s `Microsoft.Data.Sqlite` (also a separate package, but installed via NuGet automatically) or Node's `node:sqlite` (fully built-in) — Java's driver must be manually placed on the classpath for this lesson's single-file style, since there's no NuGet/npm-equivalent automatic restore without Maven/Gradle (Lesson 15).

## Getting the Driver JAR

```bash
curl -L -o sqlite-jdbc.jar "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.47.1.0/sqlite-jdbc-3.47.1.0.jar"
```

(A real Maven/Gradle project would instead declare this as a normal dependency, per Lesson 15, and the build tool would handle downloading and classpath management automatically — the manual `curl` step here is specific to keeping this one lesson runnable as a single file.)

## `PreparedStatement` and Parameterized Queries

```java
try (PreparedStatement insert = conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)")) {
    insert.setString(1, title); // 1-indexed parameter position
    insert.executeUpdate();
}
```

`?` placeholders (1-indexed, not 0-indexed) with `.setString`/`.setInt`/etc. are JDBC's parameterized-query mechanism — the same underlying principle as `@param`/named parameters in the C# course and `?`/named placeholders in the Python/JavaScript courses, all preventing SQL injection the same way: the value is bound as data, never re-parsed as SQL syntax.

## Detailed Example

See [Example.java](Example.java) — full CRUD against an in-memory SQLite database via JDBC, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Java/16-Database-Access
curl -L -o sqlite-jdbc.jar "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.47.1.0/sqlite-jdbc-3.47.1.0.jar"
java -cp sqlite-jdbc.jar Example.java
```

(`sqlite-jdbc.jar` is deliberately not committed to this repository — like any binary dependency, it's downloaded on demand, exactly as `node_modules`/NuGet packages/PyPI wheels are for the other language courses, and is covered by `.gitignore`.)

## Expected Output

Running the command above prints inserted rows (read back via `ResultSet`), an update reflected in a follow-up query, a delete reflected in the remaining row count, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, with the table surviving intact. A benign JVM warning about native access (the SQLite driver loading its native library) is expected and unrelated to the actual database logic.

## Common Mistakes

- Building SQL by string concatenation instead of using `?` placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting JDBC parameter indices are **1-indexed**, not 0-indexed (a common off-by-one mistake coming from most other 0-indexed APIs).
- Forgetting `try`-with-resources for `Connection`/`Statement`/`ResultSet` (all `AutoCloseable`), leaking database resources.

## Best Practices

- Always use `PreparedStatement` with `?` placeholders for any dynamic value — never string-interpolate/concatenate into SQL.
- Use try-with-resources for every JDBC resource, nesting as needed (as shown in the example) to ensure each closes even if an earlier statement in the same block throws.
- In a real project, manage the JDBC driver dependency via Maven/Gradle (Lesson 15), not a manual classpath JAR.

## Real-World Usage

Production Java applications typically use an ORM (Hibernate/JPA, or Spring Data JPA) rather than raw JDBC directly, but every ORM's actual database communication happens through exactly this JDBC layer underneath — understanding raw JDBC explains what an ORM is doing when it logs a generated SQL statement.

## Summary

- JDBC (`java.sql`) is the JDK's built-in, database-agnostic access API; a database-specific driver JAR (like `sqlite-jdbc`) is a separate, required dependency.
- `PreparedStatement` with 1-indexed `?` placeholders is JDBC's parameterized-query mechanism, preventing SQL injection.
- Real projects manage the driver dependency via Maven/Gradle; this lesson's manual JAR download is specific to keeping it runnable as a single file.

## Key Terms

- **JDBC (Java Database Connectivity)** — the JDK's built-in, database-agnostic database access API.
- **JDBC driver** — a database-specific JAR implementing JDBC's interfaces for a particular database engine.

## Interview Questions

1. **Does the JDK include a database driver for any specific database?**
   No — the JDK provides JDBC (`java.sql`), a database-agnostic API (`Connection`, `Statement`, `ResultSet`), but each specific database (SQLite, PostgreSQL, MySQL, etc.) requires its own separate driver JAR implementing those interfaces, added as a project dependency (typically via Maven/Gradle in a real project).

2. **How does `PreparedStatement` prevent SQL injection?**
   `?` placeholders in the SQL text are bound to actual values separately via `.setString`/`.setInt`/etc. — the JDBC driver sends the parameter values to the database as pure data, never re-parsing them as part of the SQL statement's syntax, regardless of what characters the value contains. This is the same principle as parameterized queries in every other language course in this repository.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
