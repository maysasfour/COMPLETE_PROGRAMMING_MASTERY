# 02 — Database Design and Normalization

[Back to module overview](../README.md) | [Previous: SQL Fundamentals](../01-SQL-Fundamentals/README.md)

## Beginner: What Normalization Actually Solves

Normalization means organizing a database's tables so each fact is stored in exactly one place — eliminating the possibility of the *same* fact (like a customer's email) existing in multiple, potentially-conflicting copies. This isn't an abstract academic exercise: this lesson reproduces a genuine **update anomaly** live, then shows that normalizing the schema makes it structurally impossible, not just less likely.

## Beginner: The Unnormalized Schema and Its Real Update Anomaly

```sql
CREATE TABLE orders_flat (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    product_name VARCHAR(100),
    product_price DECIMAL(10,2),
    quantity INT
)
```

With this design, Ada Lovelace's name, email, and every product she orders are duplicated across every one of her order rows. Verified live: after deliberately updating Ada's email on only *one* of her two order rows (simulating a real, easy-to-make mistake — an incomplete `UPDATE`), the query result showed **two different emails for the same customer**:

```
order_id=1, customer=Ada Lovelace, email=ada.lovelace@newdomain.com, ...
order_id=2, customer=Ada Lovelace, email=ada@example.com, ...              <- STILL THE OLD EMAIL
```

Nothing in this schema prevented this inconsistency — the database happily stored two conflicting "facts" about the same customer, because that customer's data was never stored in just one place to begin with.

## Intermediate: The Normalized Schema

```sql
CREATE TABLE customers (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), email VARCHAR(100));
CREATE TABLE products  (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100), price DECIMAL(10,2));
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL REFERENCES customers(id),
    product_id INT NOT NULL REFERENCES products(id),
    quantity INT
);
```

Each customer's email now lives in exactly one row of `customers`; `orders` merely *references* that customer via `customer_id`, never duplicating their email at all. Verified live: updating Ada's email with a single `UPDATE customers SET email = ? WHERE id = ?` immediately made *every* one of her orders reflect the new email correctly — because there was only ever one row holding that fact, referenced (not copied) everywhere it's needed.

```
order_id=1, customer=Ada Lovelace, email=ada.lovelace@newdomain.com, ...
order_id=2, customer=Ada Lovelace, email=ada.lovelace@newdomain.com, ...   <- BOTH updated correctly, automatically
```

## Advanced: 1NF, 2NF, 3NF in Plain Terms

- **1NF (First Normal Form)**: every column holds a single, atomic value (no comma-separated lists crammed into one field); every row is uniquely identifiable.
- **2NF**: every non-key column depends on the *entire* primary key, not just part of it (relevant for tables with composite keys — not directly demonstrated here, since none of this lesson's tables use one).
- **3NF (Third Normal Form)**: every non-key column depends *only* on the primary key, not on another non-key column. `orders_flat`'s `customer_email` depended on `customer_name`, not directly on `order_id` — a genuine 3NF violation, fixed by moving customer data into its own table.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/normalization/Main.java) — the unnormalized schema with its live-reproduced update anomaly, followed by the normalized schema demonstrating the same update now propagating correctly and automatically.

## Run It

```bash
cd 07-Databases/02-Database-Design-and-Normalization
mvn compile exec:java
```

## Expected Output

Running the command above prints the unnormalized table's initial 3 rows, then the deliberately-incomplete email update producing two conflicting emails for Ada (verified live), followed by the normalized schema's equivalent data, an email update via `customers` alone, and a final query confirming *all* of Ada's orders now correctly and consistently show the updated email.

## Common Mistakes

- Duplicating "descriptive" data (a customer's name/email, a product's price) across every row that references it, rather than storing it once and referencing it by key — verified live to allow the same customer to end up with inconsistent data after an incomplete update.
- Over-normalizing to the point of needing many `JOIN`s for even simple, common queries — real schema design balances normalization's consistency benefits against query complexity/performance (Lesson 04 covers indexing, which mitigates much of this cost).
- Confusing normalization with "more tables is always better" — normalization is about eliminating redundancy that could become inconsistent, not table count for its own sake.

## Best Practices

- Store each fact (a customer's email, a product's price) in exactly one place, referenced by foreign key wherever else it's needed.
- Use foreign keys (`REFERENCES`) to enforce that a reference actually points to a real row, not just a convention.
- Reach for denormalization deliberately and selectively (e.g., for read-heavy reporting tables) only after confirming normalization's query complexity is a genuine, measured performance problem — not as a default starting design.

## Real-World Usage

The update anomaly demonstrated in this lesson is a real, common category of production data-integrity bug — inconsistent customer records, mismatched product pricing across order history, and similar "which copy is the truth?" problems are a direct, practical consequence of insufficiently normalized schemas, and are exactly why normalization remains a foundational database design skill despite the rise of ORMs (Lesson 05) that can obscure the underlying schema.

## Summary

- Normalization stores each fact in exactly one place, eliminating a category of update anomaly — verified live: an unnormalized schema allowed the same customer to end up with two conflicting emails after an incomplete update; a normalized schema made this structurally impossible.
- 1NF/2NF/3NF each address a progressively more specific kind of redundancy; 3NF (no non-key column depending on another non-key column) is the practical target for most everyday schema design.
- Foreign keys formalize the reference relationship normalization depends on.

## Key Terms

- **Update anomaly** — an inconsistency that can arise when the same fact is duplicated across multiple rows and only some copies are updated.
- **Normal form (1NF/2NF/3NF)** — a progressively stricter set of rules for eliminating redundancy in a relational schema.
- **Foreign key** — a column referencing another table's primary key, formalizing a relationship between rows.

## Interview Questions

1. **What is an update anomaly, and how was one reproduced live in this lesson?**
   An update anomaly occurs when duplicated data (the same fact stored in multiple rows) is updated inconsistently — some copies get the new value, others don't, leaving the database in a contradictory state. This was reproduced directly: in the unnormalized `orders_flat` table, Ada Lovelace's email appeared in two separate rows (one per order); updating only one of those rows left the *same customer* with two different emails on file simultaneously, with nothing in the schema preventing or even flagging this inconsistency.

2. **Why does normalizing a schema make an update anomaly structurally impossible, rather than just less likely?**
   By moving each fact (like a customer's email) into its own dedicated table with one row per customer, and having every other table *reference* that customer by a foreign key rather than duplicating their data, there is only ever one place that fact can be stored — there's no second copy that could fall out of sync in the first place. This was verified live: after normalizing, updating a customer's email required (and only required) a single `UPDATE` against the `customers` table, and every order referencing that customer immediately and correctly reflected the change, since they were never storing a separate copy of the email to begin with.

## Recommended Next Lesson

[03 — Transactions and ACID](../03-Transactions-and-ACID/README.md)
