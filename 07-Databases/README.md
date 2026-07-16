# 07 — Databases

[Back to repository root](../README.md)

## What Databases Covers

Databases persist data beyond a single program's runtime and let multiple processes read and write it safely, concurrently, and reliably. This module covers both major models — relational (SQL) and document (NoSQL) — building up from raw SQL through schema design, transactional guarantees, performance, and ORM-based access, ending with a direct, hands-on contrast against a document database.

## Why Java as This Module's Reference Language

This repository's concept modules each pick one reference language/stack rather than duplicating every lesson across every language in `01-Languages` (see [09-Object-Oriented-Programming](../09-Object-Oriented-Programming/README.md) and [04-Backend-Development](../04-Backend-Development/README.md) for the same reasoning). This module uses **Java with plain JDBC** for Lessons 01-04 (deliberately not an ORM, so the raw SQL and its real behavior stays visible), then **Hibernate/JPA** for Lesson 05, and the **MongoDB Java driver** (via a real, embedded `mongod`) for Lesson 06. Every SQL statement, transaction, index, and query in this module was executed against a real H2 database engine — not mocked or simulated — and every result shown in each lesson's README was copied from an actual verified run.

## Why It Matters / Where It's Used

- **Nearly every application needs to persist data** — user accounts, orders, content, logs — and the choice of database model and schema design has lasting consequences for correctness and performance.
- **Data integrity bugs are some of the most damaging in production** — the update anomaly reproduced live in Lesson 02, and the atomicity failure modes explored in Lesson 03, are genuine categories of real-world data corruption bugs.
- **Interviews**: normalization, ACID properties, indexing tradeoffs, the N+1 query problem, and SQL-vs-NoSQL tradeoffs are extremely common database interview topics, each directly covered (and verified live) by this module's six lessons.

## Advantages of This Approach

- Starting with raw JDBC (Lessons 01-04) before introducing an ORM (Lesson 05) makes the underlying SQL and transaction behavior visible first, rather than hidden behind an abstraction from the start — directly parallel to [04-Backend-Development](../04-Backend-Development/README.md)'s Lesson 01 choice to start with zero framework.
- Every claim in this module is backed by a live, reproducible result: a real reserved-keyword syntax error (Lessons 01 and 03), a real reproduced update anomaly (Lesson 02), a real rollback (Lesson 03), a real measured 73x query speedup (Lesson 04), real N+1 SQL logs (Lesson 05), and a real embedded MongoDB instance (Lesson 06).
- Covering both relational and document models in one module, using the same running examples where possible, makes the tradeoffs between them concrete rather than abstract.

## Disadvantages / Trade-offs

- H2 (used throughout Lessons 01-05) is not identical to production databases like PostgreSQL or MySQL — its `EXPLAIN` output format, reserved keyword list, and some SQL dialect details differ; the concepts transfer, but exact syntax should always be verified against your actual production database.
- Embedded MongoDB (Lesson 06) downloads a real binary on first run and adds real startup latency — appropriate for learning and testing, not a substitute for a properly configured, persistent MongoDB deployment in production.
- This module's reference stack is Java-only; the SQL and transaction concepts transfer directly to any language's database driver, but exact ORM APIs (Lesson 05's JPA/Hibernate specifics) differ across ecosystems.

## How to Run the Examples

Each lesson folder has its own `pom.xml` and is a self-contained Maven project.

```bash
cd 07-Databases/01-SQL-Fundamentals
mvn compile exec:java
```

Requires a JDK (this module was built and verified against JDK 25) and Apache Maven (verified against Maven 3.9.16). Lesson 06 additionally downloads a real MongoDB binary on its first run (cached afterward) via `de.flapdoodle.embed.mongo`, verified working in this environment with no separate MongoDB installation required.

## Common Beginner Mistakes

- **Duplicating the same fact (a customer's email) across multiple rows** — verified live in Lesson 02 to allow the same customer to end up with two conflicting emails after an incomplete update; fixed by normalizing into separate, referenced tables.
- **Leaving `autoCommit` at its JDBC default of `true`** for a multi-statement operation that needs to succeed or fail together — Lesson 03 shows why: without an explicit transaction, a failure partway through a "transfer" leaves earlier statements permanently applied.
- **Assuming an index automatically speeds up every query on that table** — an index only helps queries that filter/join/sort on the indexed column(s); Lesson 04 measures a real 73ms → 1ms improvement specifically for a query that does.
- **Accessing a lazy-loaded collection in a loop over many parent entities** — the N+1 query problem, reproduced with real SQL logs in Lesson 05 and fixed with `JOIN FETCH`.
- **Using a SQL reserved keyword as a column name** (`YEAR` in Lesson 01, `VALUE` in Lesson 03) — both hit live, producing a real syntax error each time, not a hypothetical warning.
- **Assuming NoSQL's schema flexibility means "no structure at all"** — Lesson 06 shows real schema variation between documents, while noting application code still needs to handle whatever fields may or may not be present.

## Best Practices

- Store each fact in exactly one place, referenced by foreign key wherever else it's needed (Lesson 02).
- Wrap multi-statement operations that must succeed or fail together in an explicit transaction, and always pair `commit()` with a `rollback()` in a `catch` block (Lesson 03).
- Use `EXPLAIN` (or your database's equivalent) to confirm a query plan actually uses the index you expect, rather than assuming (Lesson 04).
- Use `JOIN FETCH` (or an equivalent eager-fetch mechanism) whenever a related collection will be needed for every row in a result set (Lesson 05).
- Choose embedding vs. referencing in a document database based on whether the related data is always read together with, and owned exclusively by, one parent (Lesson 06) — not by default habit either way.

## Interview Questions

1. What is an update anomaly, and how does normalization make it structurally impossible rather than just less likely?
2. What do the four ACID properties guarantee, and how would you demonstrate each one concretely?
3. Why doesn't adding an index to every column improve overall performance?
4. What is the N+1 query problem, and how does `JOIN FETCH` (or eager fetching) fix it?
5. What's the core tradeoff between embedding and referencing related data in a document database?
6. When would you choose a document database over a relational one, and vice versa?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [SQL Fundamentals](01-SQL-Fundamentals/README.md) | Schema creation, CRUD, `JOIN`, `PreparedStatement`, a real reserved-keyword gotcha |
| 02 | [Database Design and Normalization](02-Database-Design-and-Normalization/README.md) | A live-reproduced update anomaly, 1NF/2NF/3NF, normalized schema design |
| 03 | [Transactions and ACID](03-Transactions-and-ACID/README.md) | Atomicity/Consistency via a rejected transfer + rollback, Isolation across two connections, Durability via a file-based database |
| 04 | [Indexes and Query Optimization](04-Indexes-and-Query-Optimization/README.md) | `EXPLAIN` plans, a measured 73x query speedup on 200,000 rows |
| 05 | [Using an ORM](05-Using-an-ORM/README.md) | JPA/Hibernate, one-to-many and many-to-many mappings, the N+1 problem and its fix |
| 06 | [NoSQL Databases](06-NoSQL-Databases/README.md) | Document model via real embedded MongoDB, schema flexibility, embedding vs. joins |

## Suggested Path

Work through 01 → 06 in order — each lesson builds conceptually on the previous one (Lesson 02's normalized schema is queried again in Lesson 05's ORM mapping; Lesson 04's indexing concepts apply to any of the schemas from Lessons 01-03; Lesson 06 is deliberately placed last so its document-model tradeoffs can be directly contrasted against the relational lessons that precede it). See also [04-Backend-Development](../04-Backend-Development/README.md) Lesson 03 for Spring Data JPA's higher-level repository abstraction, built on the same JPA/Hibernate foundation as this module's Lesson 05.

**Previous module:** [04-Backend-Development](../04-Backend-Development/README.md)
