# SQL and Database Interview Questions

[Back to module overview](README.md)

## 1. What is an update anomaly, and how does normalization prevent it?

An update anomaly occurs when the same fact is duplicated across multiple rows, and updating it in only some of those rows leaves the database in a contradictory state. This was reproduced live in [07-Databases/02-Database-Design-and-Normalization](../07-Databases/02-Database-Design-and-Normalization/README.md): an unnormalized `orders_flat` table let the same customer end up with two different emails on file after an incomplete update. Normalizing into separate `customers`/`orders` tables, referenced by foreign key, made this structurally impossible — there's only one row where that email can live.

## 2. What are the ACID properties?

Atomicity (all statements in a transaction succeed or none do), Consistency (the database moves from one valid state to another, never violating constraints), Isolation (one transaction's in-progress changes are invisible to others until committed), and Durability (a committed change survives even a full application/connection shutdown). All four were demonstrated with real, verified examples in [07-Databases/03-Transactions-and-ACID](../07-Databases/03-Transactions-and-ACID/README.md), including a durability proof against a file-based (not in-memory) database.

## 3. Why does `PreparedStatement` (or a parameterized query) prevent SQL injection?

A parameterized query sends the query's structure and its parameter values to the database *separately* — the database never re-parses a bound value as SQL syntax, no matter what characters it contains. This was demonstrated with a real, working exploit in [16-Security/01-SQL-Injection](../16-Security/01-SQL-Injection/README.md): the classic `' OR '1'='1' --` payload achieved a complete authentication bypass against string-concatenated SQL, but was correctly treated as inert literal text against the identical query written with `PreparedStatement`.

## 4. What's the difference between an INNER JOIN and a LEFT JOIN?

An INNER JOIN returns only rows where a match exists in both tables. A LEFT JOIN returns all rows from the left table, with `NULL`s filled in for columns from the right table where no match exists. See [07-Databases/01-SQL-Fundamentals](../07-Databases/01-SQL-Fundamentals/README.md) for a real, verified INNER JOIN example.

## 5. What does a database index do, and why not index every column?

An index is a separate data structure that lets the database avoid scanning every row to find matches for a query, at the cost of extra storage and slower writes (every insert/update/delete must also update the index). This was measured live in [07-Databases/04-Indexes-and-Query-Optimization](../07-Databases/04-Indexes-and-Query-Optimization/README.md): a query against 200,000 rows dropped from 73ms (full table scan) to 1ms (index lookup) — but indexing every column would slow down every write for benefits only some reads would ever see.

## 6. What's the difference between SQL and NoSQL databases, and when would you choose each?

SQL (relational) databases enforce a fixed schema and support joins/referential integrity, well-suited to structured data with many relationships (verified throughout [07-Databases](../07-Databases/README.md)'s Lessons 01-05). NoSQL document databases (like MongoDB) allow flexible, per-document schemas and favor embedding related data for fast reads, at the cost of the same redundancy risk normalization eliminates in the relational model — verified live in [07-Databases/06-NoSQL-Databases](../07-Databases/06-NoSQL-Databases/README.md), where three documents in the same collection had genuinely different fields with no schema declaration.

## 7. Why is a fast hash function like MD5 a bad choice for password storage?

Because it's fast — which is exactly the wrong property for password hashing: the same speed that makes it convenient for checksums makes brute-forcing a stolen password database cheap for an attacker. This was measured live in [16-Security/02-Secure-Password-Storage](../16-Security/02-Secure-Password-Storage/README.md): 100,000 MD5 hashes computed in 211ms, versus just 20 PBKDF2 hashes (at a real 120,000-iteration cost) taking 3,642ms — a genuine, measured ~86,000x cost difference. MD5 is also unsalted by default, so identical passwords produce identical hashes, verified live to leak that two accounts share a password.

## 8. What is the N+1 query problem?

Fetching N parent records and then separately querying each one's related child records (instead of a single combined query) results in 1+N total queries rather than 1. This was reproduced with real SQL logs in [07-Databases/05-Using-an-ORM](../07-Databases/05-Using-an-ORM/README.md) and fixed with `JOIN FETCH`, confirmed down to exactly 1 query.

## 9. What's the difference between a primary key and a foreign key?

A primary key uniquely identifies each row in its own table. A foreign key is a column in one table that references a primary key in another table, enforcing (when properly constrained) that the referenced row actually exists — the mechanism normalization relies on to reference data instead of duplicating it.

## 10. Why should you always use try-with-resources (or explicit closing) for JDBC connections/statements?

Not closing a resource like a `FileWriter` or database connection can leave its internal buffer unflushed (silent data loss) and its underlying handle unreleased (a resource leak). This was demonstrated with a real, reproduced bug in [15-Testing-and-Debugging/02-Integration-Testing](../15-Testing-and-Debugging/02-Integration-Testing/README.md): an unflushed, unclosed `FileWriter` caused a genuine data-loss bug (`expected: <Buy milk> but was: <>`) and a real Windows file-lock error, both fixed by switching to try-with-resources.

## 11. What's a transaction isolation level, and why does it matter?

Isolation levels (Read Uncommitted, Read Committed, Repeatable Read, Serializable) control how much one transaction can see of another transaction's in-progress, uncommitted changes — trading off consistency guarantees against concurrency/performance. Stricter isolation prevents more anomalies (dirty reads, non-repeatable reads, phantom reads) at the cost of more locking and reduced throughput.

## Recommended Next File

[05 — Web Development Questions](05-Web-Development-Questions.md)
