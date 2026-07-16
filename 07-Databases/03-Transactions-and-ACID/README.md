# 03 — Transactions and ACID

[Back to module overview](../README.md) | [Previous: Database Design and Normalization](../02-Database-Design-and-Normalization/README.md)

## Beginner: What a Transaction Actually Is

A transaction groups multiple SQL statements into a single all-or-nothing unit: either every statement in it takes effect, or none of them do. The classic motivating example — used directly in this lesson — is a bank transfer: debiting one account and crediting another are two separate `UPDATE` statements, but they must succeed or fail *together*. If the debit succeeds and the credit fails, money vanishes; that is exactly the class of bug transactions exist to make impossible.

ACID names the four guarantees a transactional database provides:

- **Atomicity** — all statements in a transaction succeed, or none do.
- **Consistency** — the database moves from one valid state to another; constraints (like "balance can't go negative") are never violated, even mid-transaction.
- **Isolation** — one transaction's in-progress changes are invisible to other connections until committed.
- **Durability** — once committed, a change survives even if the connection (or application) is closed immediately after.

## Beginner: Atomicity and Consistency, Verified Together

This lesson uses a `CHECK (balance >= 0)` constraint on the `accounts` table — a real, enforced Consistency rule — and then attempts an invalid transfer: $200 from Ada, who only has $100.

```sql
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    balance DECIMAL(10,2) CHECK (balance >= 0)
)
```

The debit statement itself violates the `CHECK` constraint, throwing a `SQLException`. Verified live output:

```
--- Attempting to transfer $200 from Ada (who only has $100) ---
caught: Check constraint violation: "CONSTRAINT_AF: "; SQL statement:
UPDATE accounts SET balance = balance - ? WHERE id = ? [23513-232]
Transaction rolled back -- Ada's debit was UNDONE too, not left half-applied.
Balances after the FAILED transfer (should be UNCHANGED):
  Ada: $100.00
  Grace: $50.00
```

The critical point: the debit statement itself never committed, because `conn.setAutoCommit(false)` had already opened a transaction before it ran. Calling `conn.rollback()` in the `catch` block undoes it — Ada's balance is back to $100.00, not partially debited. A subsequent *valid* $30 transfer commits cleanly:

```
--- A VALID transfer of $30 from Ada to Grace ---
Transaction committed successfully.
Balances after the SUCCESSFUL transfer:
  Ada: $70.00
  Grace: $80.00
```

## Intermediate: Isolation, Verified With Two Real Connections

Isolation is demonstrated with two separate JDBC `Connection` objects (`connA`, `connB`) against the same in-memory database (`DB_CLOSE_DELAY=-1` keeps the in-memory DB alive across multiple connections). `connA` opens a transaction and updates a value, but does not yet commit; `connB` queries the same row:

```
=== ISOLATION: an uncommitted change is invisible to another connection ===
connB sees value = 100 (still 100 -- connA's uncommitted change is correctly invisible to it)
connB sees value = 999 (NOW 999 -- visible only AFTER connA committed)
```

`connB` only sees `999` after `connA.commit()` is called — this is Isolation at work: an in-progress, uncommitted transaction is invisible to other connections.

## Intermediate: Durability, Verified by Closing the Connection Entirely

Durability is only meaningfully demonstrated with a **file-based** database — the `jdbc:h2:mem:...` databases used elsewhere in this lesson are deliberately non-durable (they vanish when the JVM exits), which is fine for a quick demo but does not prove durability. This section instead uses `jdbc:h2:<file path>`, inserts a row, fully closes the connection, then opens a **brand new connection** to the same file and confirms the data is still there:

```
=== DURABILITY: a committed change survives closing the connection entirely ===
Reopened the database in a NEW connection and found: "this should survive a full disconnect"
```

## Advanced: Reserved Keyword Gotcha (`VALUE`)

While writing the isolation demo, `CREATE TABLE counter (value INT)` failed with a real H2 error:

```
Syntax error in SQL statement "CREATE TABLE counter ([*]value INT)"; expected "identifier"
```

`VALUE` is a reserved SQL keyword in H2 (like `YEAR`, hit in Lesson 01) and cannot be used as a bare column name. Fixed by renaming the column to `counter_value`. This is a recurring, genuine category of bug: always check whether a "natural" column name collides with a reserved word before assuming a schema is broken in some more complex way.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/transactions/Main.java) for the full, runnable demonstration of all four ACID properties.

## Run It

```bash
cd 07-Databases/03-Transactions-and-ACID
mvn compile exec:java
```

## Expected Output

Running the command above prints, in order: the Atomicity/Consistency demo (a rejected over-limit transfer, correctly rolled back, followed by a valid transfer that commits), the Isolation demo (an uncommitted value invisible to a second connection until commit), and the Durability demo (a value surviving a full connection close and reopen against a file-based database).

## Common Mistakes

- Leaving `autoCommit` at its JDBC default of `true` when multiple related statements need to succeed or fail together — each statement commits independently, so a failure partway through leaves earlier statements permanently applied. Always call `setAutoCommit(false)` before a multi-statement operation that needs atomicity, and always `commit()`/`rollback()` explicitly.
- Assuming an in-memory (`jdbc:h2:mem:...`) database demonstrates Durability — it does not; durability is only meaningful against a database that persists after the process exits.
- Forgetting to reset `setAutoCommit(true)` after a manual transaction, which silently leaves every subsequent statement needing an explicit commit.
- Using a reserved SQL keyword (`YEAR`, `VALUE`, etc.) as a column name — both encountered live in this module — producing a syntax error that is easy to misdiagnose as something more complex.

## Best Practices

- Keep transactions as short as practical — they hold locks and delay other connections' visibility of committed data.
- Enforce invariants (like "balance can't go negative") as real database constraints (`CHECK`, `NOT NULL`, foreign keys) rather than only in application code, so Consistency holds even if application logic has a bug.
- Always pair `rollback()` in a `catch` block with `commit()` in the success path, and restore `autoCommit` state in a `finally` block.

## Real-World Usage

Every financial transaction, inventory deduction paired with an order confirmation, or any operation touching multiple related tables that must not be left half-applied relies on exactly this pattern. Distributed systems extend these same ideas (with much more complexity) via two-phase commit and saga patterns when a single database transaction can't span multiple services.

## Summary

- Atomicity and Consistency were verified together: an invalid transfer (violating a real `CHECK` constraint) was fully rolled back, leaving both accounts' balances unchanged.
- Isolation was verified with two real, separate JDBC connections: an uncommitted change was invisible to the second connection until the first committed.
- Durability was verified against a file-based H2 database: data survived a full connection close and a brand-new connection reopening the same file.
- A reserved-keyword gotcha (`VALUE`) was hit and fixed live, the same category of issue as `YEAR` in Lesson 01.

## Key Terms

- **ACID** — Atomicity, Consistency, Isolation, Durability: the four guarantees a transactional database provides.
- **Rollback** — undoing every statement executed since a transaction began.
- **Auto-commit** — the JDBC default where each statement commits immediately on its own; must be disabled (`setAutoCommit(false)`) to group statements into one transaction.

## Interview Questions

1. **What does Atomicity guarantee, and how was it verified in this lesson rather than just asserted?**
   Atomicity guarantees that every statement in a transaction succeeds, or none of them take effect at all. This was verified by attempting a $200 transfer from an account with only $100: the debit statement itself violated a `CHECK (balance >= 0)` constraint, triggering a `rollback()`, and the subsequent balance query confirmed Ada's balance was still exactly $100.00 — not partially debited — proving the failed statement left no trace.

2. **Why doesn't an in-memory H2 database (`jdbc:h2:mem:...`) demonstrate Durability, and what did this lesson use instead?**
   Durability means a committed change survives beyond the transaction — including a full application/connection shutdown. An in-memory database's data is lost the moment its last connection closes (or the JVM exits), so surviving *within the same connection* proves nothing about durability. This lesson instead used a file-based H2 URL (`jdbc:h2:<path>`), inserted and let a connection close completely, then opened a **new** connection to the same file and confirmed the row was still there — genuinely proving the write persisted independent of any connection's lifetime.

## Recommended Next Lesson

[04 — Indexes and Query Optimization](../04-Indexes-and-Query-Optimization/README.md)
