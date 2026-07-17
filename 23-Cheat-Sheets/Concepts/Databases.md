# Databases Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../07-Databases/README.md)

## SQL Quick Reference
```sql
SELECT name, price FROM products WHERE price > 100 ORDER BY price DESC;
INSERT INTO products (name, price) VALUES ('Widget', 9.99);
UPDATE products SET price = 12.99 WHERE name = 'Widget';
DELETE FROM products WHERE id = 5;

SELECT o.id, c.name FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
);
CREATE INDEX idx_products_name ON products(name);
```
See [07-Databases/01-SQL-Fundamentals](../../07-Databases/01-SQL-Fundamentals/README.md) — includes a real reserved-keyword gotcha (`YEAR` failed; use a different name).

## Normalization (1NF/2NF/3NF)
Store each fact in exactly one place, referenced by foreign key elsewhere. Verified live in [07-Databases/02](../../07-Databases/02-Database-Design-and-Normalization/README.md): an unnormalized schema let the same customer end up with two conflicting emails after an incomplete update; normalizing made this structurally impossible.

## ACID
| Property | Verified via |
|---|---|
| Atomicity | A rejected over-limit transfer left both balances unchanged |
| Consistency | A `CHECK (balance >= 0)` constraint blocked an invalid state |
| Isolation | An uncommitted change was invisible to a second connection until commit |
| Durability | Data survived a full connection close/reopen against a file-based DB |

See [07-Databases/03-Transactions-and-ACID](../../07-Databases/03-Transactions-and-ACID/README.md).

## Indexing
An index trades write speed/storage for read speed. Measured live: 73ms (table scan) → 1ms (index lookup) on 200,000 rows. See [07-Databases/04](../../07-Databases/04-Indexes-and-Query-Optimization/README.md).

## JDBC Quick Reference (Java)
```java
try (Connection conn = DriverManager.getConnection(url);
     PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?")) {
    stmt.setInt(1, userId);
    try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) { rs.getString("name"); }
    }
}
```
**Always use `PreparedStatement`** — string concatenation enables SQL injection (verified live in [16-Security/01](../../16-Security/01-SQL-Injection/README.md): `' OR '1'='1' --` achieved a complete authentication bypass).

## ORM (JPA/Hibernate) Quick Reference
```java
@Entity class Author {
    @OneToMany(mappedBy = "author") List<Book> books;
}
// N+1 fix: JOIN FETCH
em.createQuery("SELECT a FROM Author a JOIN FETCH a.books", Author.class);
```
See [07-Databases/05-Using-an-ORM](../../07-Databases/05-Using-an-ORM/README.md) — the N+1 problem reproduced with real SQL logs.

## NoSQL (MongoDB) Quick Reference
```java
collection.insertOne(new Document("name", "Widget").append("tags", List.of("new")));
collection.find(new Document("price", new Document("$gt", 100)));
collection.updateOne(new Document("name", "Widget"), new Document("$set", new Document("price", 12)));
```
See [07-Databases/06-NoSQL-Databases](../../07-Databases/06-NoSQL-Databases/README.md) — real schema flexibility and embedding vs. joins tradeoffs, verified live.

See the [full Databases module](../../07-Databases/README.md) for verified, runnable code for everything above.
