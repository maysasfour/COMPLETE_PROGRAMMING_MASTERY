# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using JDBC (`java.sql`) — Kotlin has no database access of its own, using Java's JDBC directly, the same driver-based API covered in this repository's Java course.
- Use `?`-parameterized `PreparedStatement`s to prevent SQL injection.
- Use Kotlin's `.use { }` extension function for automatic resource closing — Kotlin's equivalent of Java's try-with-resources.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Kotlin has no database access API of its own — since it runs on the JVM, it uses `java.sql`'s JDBC directly, exactly as this repository's Java course does, requiring the same `org.xerial:sqlite-jdbc` driver JAR (downloaded here, not committed, matching the Java course's dependency-handling pattern).

## JDBC CRUD with `?`-Parameterized Statements

```kotlin
Class.forName("org.sqlite.JDBC")
val conn = DriverManager.getConnection("jdbc:sqlite::memory:")

conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)").use { stmt ->
    stmt.setString(1, title) // ?-placeholder, 1-indexed, like Java's JDBC and Go's database/sql
    stmt.executeUpdate()
}
```

## `.use { }`: Kotlin's Try-With-Resources Equivalent

```kotlin
conn.createStatement().use { stmt ->
    val rs = stmt.executeQuery("SELECT ...")
    // ...
} // stmt.close() called automatically here, even if an exception is thrown inside the block
```

`.use { }` is a Kotlin standard library extension function on any `Closeable`/`AutoCloseable` (which `Statement`, `Connection`, `ResultSet`, and every JDBC resource implement) — it guarantees the resource's `close()` is called when the block exits, whether normally or via an exception, exactly like Java's try-with-resources (`try (var stmt = ...) { }`), but expressed as an ordinary higher-order function call rather than special syntax.

## Detailed Example

See [Example.kt](Example.kt) — full CRUD against an in-memory SQLite database via JDBC, using `.use { }` throughout for automatic resource cleanup, plus the same SQL-injection-safety demonstration used throughout this repository's other language courses.

## Run It

```bash
cd 01-Languages/Kotlin/16-Database-Access
# Requires sqlite-jdbc.jar on the classpath (downloaded separately, not committed):
kotlinc -cp sqlite-jdbc.jar Example.kt -include-runtime -d Example.jar
java -cp "Example.jar;sqlite-jdbc.jar" ExampleKt
```

## Expected Output

Running the compiled JAR prints confirmation of 3 inserted rows, all 3 rows read back, row 1's `done` status flipping to `1` after an update, a remaining row count of `2` after a delete, confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, and confirmation the table survives intact with all rows present (3, including the malicious-string test row). A JDK 25 native-access warning about the SQLite driver's native binding is benign and expected — it doesn't affect correctness.

## Common Mistakes

- Building SQL by string concatenation instead of `?`-placeholders with `PreparedStatement` — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Manually calling `.close()` on JDBC resources in a `finally` block instead of using `.use { }` — more verbose and easier to get wrong (e.g., forgetting to close a `ResultSet` while correctly closing its parent `Statement`) than Kotlin's automatic-closing extension function.
- Forgetting JDBC's `?` placeholders are 1-indexed (`setString(1, ...)`, not `setString(0, ...)`), matching Java's JDBC and Go's `database/sql` conventions covered elsewhere in this repository.

## Best Practices

- Always use `?`-parameterized `PreparedStatement`s for any dynamic value in SQL.
- Use `.use { }` for every JDBC resource (`Connection`, `Statement`, `PreparedStatement`, `ResultSet`) to guarantee cleanup without manual `try`/`finally` boilerplate.
- Consider a higher-level Kotlin database library (Exposed, a JetBrains-maintained Kotlin SQL framework, or Ktorm) for real projects wanting a more idiomatic, type-safe query API than raw JDBC.

## Real-World Usage

Raw JDBC (as shown here) remains foundational to virtually every JVM database library, but real Kotlin projects commonly use a higher-level abstraction on top of it — Exposed (JetBrains' own Kotlin SQL framework, offering both a DSL and a lightweight ORM) is a popular, idiomatic choice specifically designed to feel natural in Kotlin, unlike using raw `java.sql` JDBC calls directly as this lesson does for consistency with the rest of this course's dependency-minimal style.

## Summary

- Kotlin has no database access of its own; it uses Java's JDBC directly, exactly as this repository's Java course does.
- `?`-parameterized `PreparedStatement`s (1-indexed) prevent SQL injection — the same principle as every other language course in this repository.
- `.use { }` is Kotlin's concise, functional equivalent of Java's try-with-resources, guaranteeing resource cleanup.

## Key Terms

- **JDBC** — Java's standard database connectivity API, used directly by Kotlin since it runs on the JVM.
- **`.use { }`** — a Kotlin standard library extension function guaranteeing a `Closeable` resource's `close()` is called when the block exits.

## Interview Questions

1. **Why does Kotlin use `java.sql`/JDBC directly instead of having its own database access API?**
   Because Kotlin compiles to and runs on the JVM, it can call any Java library directly — and rather than reinventing database connectivity, Kotlin simply uses Java's existing, mature JDBC API as-is, exactly as demonstrated in this lesson (`Class.forName`, `DriverManager.getConnection`, `PreparedStatement`, all directly from `java.sql`). This mirrors this repository's Java course's approach precisely, since there's no meaningful difference at the JDBC level between Kotlin and Java code — Kotlin's value-add here is purely syntactic conciseness (like `.use { }`) layered on top of the same underlying Java API, not a replacement for it.

2. **What does Kotlin's `.use { }` function provide, and how does it compare to Java's try-with-resources?**
   `.use { }` is an extension function available on any type implementing `Closeable`/`AutoCloseable` — calling it with a lambda guarantees the receiver's `close()` method runs when the lambda block finishes, whether it completes normally or throws an exception, exactly matching the guarantee Java's try-with-resources (`try (var stmt = ...) { }`) syntax provides. The difference is purely syntactic: Kotlin achieves this through an ordinary higher-order function (usable on any `Closeable`, chainable, and composable like any other function call) rather than a dedicated language construct, while Java requires its special `try (...)` resource-declaration syntax specifically for this purpose.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
