# 04 — Indexes and Query Optimization

[Back to module overview](../README.md) | [Previous: Transactions and ACID](../03-Transactions-and-ACID/README.md)

## Beginner: What an Index Actually Does

An index is a separate, ordered data structure the database maintains alongside a table, letting it find matching rows without scanning every row (a "table scan"). Without an index, `WHERE email = '...'` on a 200,000-row table must check every single row; with an index on `email`, the database can jump almost directly to the matching row.

This lesson doesn't just assert that — it measures it, on 200,000 real rows in a real H2 database, using `EXPLAIN` to see the actual query plan the database chose, and wall-clock timing to see the real difference.

## Beginner: The Setup

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100),
    name VARCHAR(100)
)
```

200,000 rows are batch-inserted (`addBatch()`/`executeBatch()` in chunks of 5,000, inside a single transaction) — batching like this is itself a real performance practice: inserting 200,000 rows one at a time, each auto-committed, would be dramatically slower than batching them into one transaction.

## Intermediate: EXPLAIN Before and After

**Before** any index exists on `email`, `EXPLAIN` shows a real table scan:

```
FROM "PUBLIC"."USERS"
    /* PUBLIC.USERS.tableScan */
WHERE "EMAIL" = 'user-100000@example.com'
```

After creating the index:

```sql
CREATE INDEX idx_users_email ON users(email)
```

`EXPLAIN` on the exact same query now shows H2 choosing the new index instead of a table scan:

```
FROM "PUBLIC"."USERS"
    /* PUBLIC.IDX_USERS_EMAIL: EMAIL = 'user-100000@example.com' */
WHERE "EMAIL" = 'user-100000@example.com'
```

## Intermediate: The Measured Speedup

Verified live, on this machine, against 200,000 rows:

```
Query time WITHOUT index: 73 ms (full table scan)
Query time WITH index: 1 ms (index lookup)
Speedup: query with the index took 73.0x less time than the full table scan (73ms -> 1ms).
```

The exact numbers will vary run to run and machine to machine, but the *shape* of the result — a full scan costing time proportional to table size, versus an index lookup costing close to constant time — is the real, generalizable lesson.

## Advanced: Why Not Index Everything?

Indexes aren't free:

- Every index must be updated on every `INSERT`/`UPDATE`/`DELETE` affecting the indexed column(s), slowing writes down in exchange for faster reads.
- Every index consumes additional disk space.
- An index only helps queries that filter, join, or sort on the indexed column(s) — an index on `email` does nothing for a query filtering on `name`.

The right default is: index columns that are frequently used in `WHERE`, `JOIN`, or `ORDER BY` clauses on tables large enough (and read-heavy enough) for it to matter — not every column reflexively.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/indexes/Main.java) — populates 200,000 rows, runs `EXPLAIN` and a timed query before and after creating an index, and reports the measured speedup.

## Run It

```bash
cd 07-Databases/04-Indexes-and-Query-Optimization
mvn compile exec:java
```

(Takes a few seconds due to the 200,000-row batch insert.)

## Expected Output

Row insertion progress, followed by an `EXPLAIN` plan and timing showing a table scan before the index exists, then the same `EXPLAIN` plan and timing showing an index lookup after `CREATE INDEX`, followed by the measured speedup ratio.

## Common Mistakes

- Assuming an index automatically helps every query on that table — it only helps queries that actually filter/join/sort on the indexed column(s).
- Adding indexes to every column "just in case," which slows down every write without necessarily speeding up any read that matters.
- Inserting large volumes of data one row at a time with auto-commit enabled, rather than batching — a real, measurable performance difference distinct from (but related to) indexing.
- Not checking `EXPLAIN` before assuming a slow query is or isn't using an index — the actual query plan, not intuition, is the source of truth.

## Best Practices

- Index columns used in `WHERE`, `JOIN ON`, and `ORDER BY` clauses of frequently-run, performance-sensitive queries.
- Use `EXPLAIN` (or your database's equivalent) to confirm a query plan actually uses the index you expect, rather than assuming.
- Batch bulk inserts/updates inside explicit transactions instead of relying on per-statement auto-commit.
- Measure before optimizing — the 73ms→1ms result in this lesson was verified live, not assumed.

## Real-World Usage

Slow, unindexed lookups on growing tables are one of the most common real production performance issues — a query that's fine on a 1,000-row development database and unusably slow on a 10-million-row production table is very often missing exactly the kind of index demonstrated here. Database administrators and backend engineers routinely use `EXPLAIN` (or `EXPLAIN ANALYZE` in PostgreSQL, or similar tools in other databases) as the first diagnostic step for a slow query.

## Summary

- An index lets the database avoid scanning every row, at the cost of extra space and slower writes.
- `EXPLAIN` reveals the actual query plan the database chose — verified live, showing a real `tableScan` before an index and a real index-based plan after.
- The improvement was measured, not assumed: 73ms (table scan) down to 1ms (index lookup) on 200,000 rows.
- Indexes should be added deliberately, based on actual query patterns, not reflexively on every column.

## Key Terms

- **Index** — a separate data structure maintained by the database to speed up lookups on specific column(s), at the cost of extra write overhead and storage.
- **Table scan** — checking every row in a table to find matches, when no usable index exists.
- **EXPLAIN** — a SQL command that shows the query plan the database will use (or used), without necessarily running the full query's side effects.

## Interview Questions

1. **What tradeoff does adding an index introduce, and why shouldn't every column be indexed?**
   An index speeds up reads that filter/join/sort on the indexed column, but every write to that column (insert, update, delete) must also update the index, and the index itself consumes storage. Indexing every column would slow down all writes across the table for the benefit of only some reads — the right approach is indexing columns actually used in frequent, performance-sensitive queries, confirmed via `EXPLAIN`.

2. **How was the claim "the index made this query faster" actually verified in this lesson, rather than just asserted?**
   Two ways: first, `EXPLAIN` was run before and after creating the index, showing the query plan literally change from a `tableScan` comment to a reference to the new index (`IDX_USERS_EMAIL`) — proof the database's plan actually changed, not just an assumption. Second, the same query was timed with real wall-clock measurements before and after, on a real 200,000-row table, showing a measured drop from 73ms to 1ms — a concrete, reproducible number rather than a general claim.

## Recommended Next Lesson

[05 — Using an ORM](../05-Using-an-ORM/README.md)
