# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Connect to a real SQLite database using plain JDBC (`java.sql`) — Scala has no database library of its own, exactly like its file-I/O and JSON gaps covered in Lesson 10.
- Use `PreparedStatement` for safe, parameterized queries.
- Demonstrate, with a genuinely attempted attack string, why parameter binding prevents SQL injection.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Scala has no database-access library in its standard library — real Scala projects reach directly into Java's JDBC API (`java.sql.DriverManager`, `Connection`, `PreparedStatement`) or wrap it in a higher-level library (Slick, Doobie). This lesson uses raw JDBC directly against a real SQLite database file via the `sqlite-jdbc` driver, fetched as a JAR through Coursier (introduced conceptually in Lesson 15) rather than a project-wide sbt dependency, keeping this course dependency-minimal.

## Installing the Driver (via Coursier)

```bash
cs fetch org.xerial:sqlite-jdbc:3.45.1.0
# resolves and caches the JAR (plus its slf4j-api dependency) under the Coursier cache,
# printing the full local path(s) to use on the classpath
```

## Connecting and Running Queries

```scala
import java.sql.{Connection, DriverManager, PreparedStatement}

Class.forName("org.sqlite.JDBC")               // register the driver with DriverManager
val conn: Connection = DriverManager.getConnection("jdbc:sqlite:demo.db")

val ps = conn.prepareStatement("INSERT INTO users (name, email) VALUES (?, ?)")
ps.setString(1, "Ada Lovelace")
ps.setString(2, "ada@example.com")
ps.executeUpdate()
```

## SQL-Injection Safety, Verified With a Real Attack String

```scala
val maliciousInput = "x'; DROP TABLE users; --"
val safePs = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM users WHERE name = ?")
safePs.setString(1, maliciousInput)   // bound as a LITERAL STRING VALUE, never interpreted as SQL
```

Because `PreparedStatement` binds `maliciousInput` as data (not text spliced into the SQL string), the attempted `DROP TABLE` never executes — verified directly by checking the table's row count is unchanged immediately afterward.

## Detailed Example

See [DatabaseAccess.scala](DatabaseAccess.scala) — creates a real SQLite database file, creates a table, inserts rows via `PreparedStatement`, queries them back, attempts a real SQL-injection payload as a bound parameter (proving the table survives intact), and shows what the equivalent *unsafe*, string-concatenated query would have looked like for contrast.

## Run It

```bash
cd 01-Languages/Scala/16-Database-Access

# 1. Fetch the driver (once) via Coursier:
cs fetch org.xerial:sqlite-jdbc:3.45.1.0
# note the two JAR paths it prints (sqlite-jdbc and its slf4j-api dependency)

# 2. Compile against the driver's classpath:
scalac -classpath "<sqlite-jdbc-jar>;<slf4j-api-jar>" DatabaseAccess.scala

# 3. Run with java directly (java -cp), including the Scala runtime library JAR
#    alongside the driver JARs -- `scala run --classpath` does not reliably forward
#    an external classpath to the launched JVM in this toolchain, so `java -cp` is used instead:
java -cp ".;<sqlite-jdbc-jar>;<slf4j-api-jar>;<scala3-library_3-jar>;<scala-library-2.13-jar>" databaseAccessDemo
```

## Expected Output

```
--- inserting rows via a PreparedStatement (safe parameter binding) ---
inserted 2 rows

--- querying all rows ---
  id=1 name=Ada Lovelace email=ada@example.com
  id=2 name=Alan Turing email=alan@example.com

--- SQL-injection safety: PreparedStatement binds values, never concatenates ---
query with malicious-looking input as a bound parameter: cnt=0 (table intact, no injection)
users table row count after attempted injection: 2

--- UNSAFE comparison: what string concatenation WOULD do (demonstrated, not executed for real damage) ---
a naively concatenated query would look like: SELECT COUNT(*) AS cnt FROM users WHERE name = 'x'; DROP TABLE users; --'
(this is exactly the shape of a SQL-injection vector -- PreparedStatement above avoids it entirely)
```

(SLF4J prints a harmless "no-operation logger" warning to stderr on first run since no logging backend is configured — safe to ignore for this demo.)

## Common Mistakes

- Building SQL by string concatenation/interpolation (`s"... WHERE name = '$input'"`) instead of `PreparedStatement` binding — this is the exact SQL-injection vector shown (but not executed) for contrast in this lesson.
- Forgetting `Class.forName("org.sqlite.JDBC")` — some JDBC driver versions self-register via `META-INF/services`, but explicitly loading the driver class remains the most portable, explicit approach.
- Not closing `Connection`/`Statement`/`ResultSet` objects — each holds real OS resources; always close in a `finally` block (as this lesson does) or use `scala.util.Using` (Lesson 10) for automatic closing.

## Best Practices

- Always use `PreparedStatement` with bound parameters for any query containing external/user-supplied data — never string-concatenate values into SQL.
- Close JDBC resources deterministically (`finally`, or `scala.util.Using`), since they hold native/OS-level handles the garbage collector won't promptly reclaim.
- For any real (non-teaching) Scala project, prefer a higher-level library like Doobie (functional, type-safe) or Slick (a query DSL) over raw JDBC — both are still built on top of the same JDBC foundation shown here.

## Real-World Usage

Every JVM-based data-access library (Slick, Doobie, even Java's Hibernate) ultimately issues its actual queries through the same JDBC `Connection`/`PreparedStatement` APIs demonstrated directly in this lesson — understanding raw JDBC is what makes the abstractions those libraries provide over it comprehensible.

## Summary

- Scala has no database-access library of its own; real projects use JDBC (`java.sql`) directly or a wrapping library like Doobie/Slick.
- `PreparedStatement` binds parameters as data, not SQL text — verified with a real attempted `DROP TABLE` injection payload that left the table fully intact.
- The `sqlite-jdbc` driver was fetched via Coursier and used directly on the classpath, without needing a full sbt project.

## Key Terms

- **JDBC** — Java's standard database-connectivity API (`java.sql`), usable directly from Scala with no adaptation needed.
- **`PreparedStatement`** — a precompiled SQL statement with `?` placeholders bound to actual values as data, preventing SQL injection.
- **SQL injection** — an attack where untrusted input is interpreted as executable SQL rather than data, typically via unsafe string concatenation.

## Interview Questions

1. **Why does `PreparedStatement` prevent SQL injection where string concatenation doesn't, and how was this actually proven rather than just asserted?** — `PreparedStatement` sends the SQL statement's *shape* (with `?` placeholders) to the database separately from the *parameter values*; the database driver binds each value as literal data for its placeholder, never re-parsing it as SQL syntax, so a value containing `'; DROP TABLE users; --` is treated as a literal (and in this case simply non-matching) string to compare against, not executable SQL. This was proven directly, not just asserted: the malicious string was bound via `setString`, the query executed without error, and the `users` table's row count was checked immediately after and found unchanged (still 2 rows) — the injection attempt had zero effect.
2. **Given Scala has no database library in its standard library, what are the options for real projects, and what did this lesson use?** — Real Scala projects either use raw JDBC directly (as this lesson does, via `java.sql.DriverManager`/`Connection`/`PreparedStatement`) or a higher-level wrapping library — Doobie (a purely functional JDBC wrapper built on Cats Effect) or Slick (a type-safe query DSL that compiles to SQL) are the two most common. This lesson used raw JDBC directly against a real SQLite database (via the `sqlite-jdbc` driver, fetched with Coursier) to keep the underlying mechanism visible and dependency-minimal, exactly as Lesson 10 did for file I/O.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
