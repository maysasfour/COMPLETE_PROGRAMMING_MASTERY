# 01 — SQL Fundamentals

[Back to module overview](../README.md)

## Beginner: The Core Four — SELECT, INSERT, UPDATE, DELETE

Every relational database interaction reduces to four operations: `INSERT` (create), `SELECT` (read), `UPDATE` (modify), `DELETE` (remove) — the same CRUD concept covered throughout [04-Backend-Development](../../04-Backend-Development/README.md), but expressed directly as SQL here, via plain JDBC with **no ORM at all**, so the raw language is visible before an ORM (Lesson 05) abstracts it behind objects.

```sql
INSERT INTO authors (name) VALUES ('Ursula K. Le Guin');
SELECT id, title, author_id, pub_year FROM books ORDER BY id;
UPDATE books SET pub_year = 1952 WHERE title = 'Foundation';
DELETE FROM books WHERE title = 'The Dispossessed';
```

Verified live via JDBC (`java.sql.PreparedStatement`/`Statement`) against a real, embedded H2 database: inserting 2 authors and 3 books, then reading them back, then updating one book's year and deleting another, with a final `SELECT` confirming both changes took effect.

## Beginner: A Genuine, Verified Gotcha — Reserved Keywords as Column Names

While writing this lesson's schema, `CREATE TABLE books (..., year INT, ...)` failed to compile against H2 with a real, live syntax error:

```
Syntax error in SQL statement "... year INT, ..."; expected "identifier"
```

`YEAR` is a reserved SQL keyword (part of the standard's date/time vocabulary) and cannot be used as a bare, unquoted column name — verified live, not merely described. The fix applied here was renaming the column to `pub_year` entirely (the simplest, most portable fix); a database-specific alternative would be quoting it (`"year"` in most databases, `` `year` `` in MySQL), but avoiding reserved words as identifiers entirely is the more robust, cross-database-compatible habit.

## Intermediate: `JOIN` — Combining Rows from Related Tables

```sql
SELECT books.title, authors.name AS author_name, books.pub_year
FROM books
INNER JOIN authors ON books.author_id = authors.id
ORDER BY books.pub_year
```

Verified live: this query correctly combined each book with its author's actual name (not just the `author_id` foreign key), demonstrating `INNER JOIN`'s core purpose — matching rows across two tables based on a shared key (here, `books.author_id = authors.id`), producing one combined row per match.

## Advanced: Parameterized Queries — the Same Principle as Every Language Course

```java
PreparedStatement stmt = conn.prepareStatement("INSERT INTO authors (name) VALUES (?)");
stmt.setString(1, "Ursula K. Le Guin");
```

Every `INSERT`/`UPDATE`/`DELETE` in this lesson uses a `?`-parameterized `PreparedStatement`, never string-concatenated SQL — the exact same SQL-injection-prevention principle demonstrated in every one of this repository's `01-Languages` database-access lessons (Java's JDBC, PHP's PDO, Rust's `rusqlite`, and more), applied here at the level of raw SQL itself rather than through any particular language's wrapper.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/sqlfundamentals/Main.java) — a two-table schema (`authors`, `books`) with a foreign key, full CRUD, and a `JOIN`, all run against a real embedded H2 database.

## Run It

```bash
cd 07-Databases/01-SQL-Fundamentals
mvn compile exec:java
```

## Expected Output

Running the command above prints the schema-creation confirmation, both insert confirmations, all 3 books (via a plain `SELECT`), the `JOIN`ed author-and-title view (ordered by year: Foundation 1951, Left Hand of Darkness 1969, The Dispossessed 1974), the update/delete row-count confirmations, and a final `SELECT` showing only 2 remaining books with Foundation's year corrected to 1952 — all confirmed by actual execution.

## Common Mistakes

- Using a reserved SQL keyword (`year`, `order`, `group`, `select` itself) as a bare column/table name — verified live to produce a real syntax error; either quote the identifier or (more robustly) avoid reserved words as names entirely.
- Building SQL by string concatenation instead of parameterized placeholders — the exact SQL-injection vulnerability this lesson (and every database-access lesson throughout this repository) demonstrates a safe alternative to.
- Forgetting `ORDER BY` — SQL makes no guarantee about row order without it; relying on "whatever order rows happen to come back in" is a common, real source of flaky-seeming bugs.

## Best Practices

- Always use parameterized queries (`?` placeholders with `PreparedStatement`) for any dynamic value in SQL.
- Avoid reserved keywords as identifiers even where a database technically allows quoting them — it adds friction and portability risk for no real benefit.
- Use explicit `ORDER BY` whenever row order matters to the application, rather than relying on incidental database behavior.

## Real-World Usage

SQL's four core operations, plus `JOIN`, are the foundation underneath every ORM (Lesson 05), every reporting tool, and every data migration script in real-world relational-database-backed systems — understanding the raw SQL an ORM generates (as directly demonstrated here) is essential for diagnosing performance problems (Lesson 04) or debugging unexpected query results that an ORM's abstraction can otherwise obscure.

## Summary

- `INSERT`/`SELECT`/`UPDATE`/`DELETE` are the four core SQL operations; `JOIN` combines rows from related tables based on a shared key.
- Reserved keywords (like `year`) cannot be used as bare identifiers — verified live via a real syntax error.
- Parameterized queries prevent SQL injection — the same principle demonstrated throughout this repository's language courses, here at the raw-SQL level.

## Key Terms

- **`JOIN`** — combines rows from two or more tables based on a related column.
- **Foreign key** — a column referencing another table's primary key, establishing a relationship between rows.
- **Reserved keyword** — a word with special meaning in SQL's own grammar, unusable as a bare identifier.

## Interview Questions

1. **What does `INNER JOIN` do, and why was it needed in this lesson's `books`/`authors` example?**
   `INNER JOIN` combines rows from two tables based on a matching condition — here, `books.author_id = authors.id` — producing one output row per matching pair, and excluding any row from either table with no match on the other side. It was needed because `books` stores only `author_id` (a foreign key, an integer), not the author's actual name; without the `JOIN`, a query against `books` alone could show *which* author wrote a book only as an opaque numeric ID, not a human-readable name — verified live, the `JOIN`ed query correctly displayed each book alongside its author's actual name.

2. **Why did creating a `year` column fail, and what does this reveal about SQL identifiers generally?**
   `YEAR` is a reserved keyword in SQL's standard date/time vocabulary, and most databases (verified live against H2) don't allow reserved keywords to be used as bare, unquoted column/table names — the parser expects an identifier at that position and instead finds a keyword it interprets specially. This reveals a genuine, practical SQL portability concern: while most databases allow escaping/quoting a reserved word as an identifier (using database-specific quoting syntax), doing so adds friction and inconsistency across different database systems, which is why the more robust, portable habit is simply avoiding reserved words as identifiers in the first place — exactly the fix applied in this lesson (renaming to `pub_year`).

## Recommended Next Lesson

[02 — Database Design and Normalization](../02-Database-Design-and-Normalization/README.md)
