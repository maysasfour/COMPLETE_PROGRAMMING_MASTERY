# 05 — Using an ORM (JPA/Hibernate)

[Back to module overview](../README.md) | [Previous: Indexes and Query Optimization](../04-Indexes-and-Query-Optimization/README.md)

## Beginner: What an ORM Actually Does

An ORM (Object-Relational Mapper) lets you work with Java objects (`Author`, `Book`, `Tag`) instead of writing raw SQL for every operation — the ORM translates method calls like `em.persist(author)` into `INSERT` statements, and JPQL queries like `SELECT a FROM Author a` into real SQL, handling the mapping between object references and foreign-key columns.

This lesson uses **JPA (the standard API) with Hibernate (its most common implementation) directly**, without Spring — [04-Backend-Development's Lesson 03](../../04-Backend-Development/03-Data-Persistence-with-Spring-Data-JPA/README.md) already covers Spring Data JPA's repository abstraction; this lesson goes one level lower, showing what Spring Data JPA is built on top of: `EntityManager`, `persistence.xml`, and JPQL, plus real relationship mappings (one-to-many, many-to-many) that lesson didn't cover.

## Beginner: The Entities and Their Relationships

- **`Author` → `Book`**: one-to-many. One author has many books; each book has exactly one author.
- **`Book` ↔ `Tag`**: many-to-many. A book can have multiple tags, and a tag can apply to multiple books — requiring a join table (`book_tags`), which Hibernate creates and manages automatically.

```java
@Entity
public class Author {
    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Book> books = new ArrayList<>();
}

@Entity
public class Book {
    @ManyToOne
    @JoinColumn(name = "author_id")
    private Author author;

    @ManyToMany
    @JoinTable(name = "book_tags",
        joinColumns = @JoinColumn(name = "book_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<Tag> tags = new HashSet<>();
}
```

Verified live: Hibernate's `hbm2ddl.auto=update` generated `authors`, `books`, and `tags` tables plus the `book_tags` join table automatically, with real foreign-key constraints, from nothing but these annotations.

## Intermediate: Querying Relationships With JPQL

```java
Author asimov = em.createQuery(
        "SELECT a FROM Author a WHERE a.name = :name", Author.class)
    .setParameter("name", "Isaac Asimov")
    .getSingleResult();
```

Verified live output:

```
Isaac Asimov's books:
  - Foundation
  - I, Robot
```

The many-to-many side was queried from both directions — a book's tags, and (separately) a tag's books — confirmed live to return the correct, symmetric set each way.

## Advanced: The N+1 Problem, Reproduced and Fixed

This is the single most common real-world ORM performance bug, and this lesson reproduces it with actual SQL output (via `hibernate.show_sql=true`), not just a description.

**Naive approach** — query all authors, then access `.getBooks()` on each one:

```java
List<Author> authors = em.createQuery("SELECT a FROM Author a", Author.class).getResultList();
for (Author a : authors) {
    a.getBooks().size(); // triggers a lazy-load query PER author
}
```

Verified live: this produced **one query to fetch authors, plus one additional query per author** to lazily load that author's books — with only 1 author in this lesson's small dataset it's 2 queries total, but the pattern is what matters: with 1,000 authors, this becomes 1,001 queries.

**Fixed approach** — `JOIN FETCH` pulls the related entities in the *same* query:

```java
List<Author> authors = em.createQuery(
        "SELECT DISTINCT a FROM Author a JOIN FETCH a.books", Author.class)
    .getResultList();
```

Verified live: this produced **exactly one SQL query**, joining `authors` and `books` together — no matter how many authors exist, this stays at one query.

## Detailed Example

See [pom.xml](pom.xml), [persistence.xml](src/main/resources/META-INF/persistence.xml), and the entity/`Main.java` classes in [src/main/java/com/example/orm/](src/main/java/com/example/orm/) for the full runnable demonstration.

## Run It

```bash
cd 07-Databases/05-Using-an-ORM
mvn compile exec:java
```

`hibernate.show_sql=true` is enabled in `persistence.xml` specifically so the real SQL Hibernate generates is visible for every operation, including the N+1 demonstration.

## Expected Output

Schema creation SQL (tables + foreign keys), seed data inserts, the one-to-many query (an author's books), the many-to-many query (a book's tags, and a tag's books), then the N+1 demonstration showing 1+N queries for the naive approach followed by exactly 1 query for the `JOIN FETCH` version.

## Common Mistakes

- Accessing a lazy-loaded collection (like `author.getBooks()`) in a loop over many parent entities without `JOIN FETCH` — the N+1 problem, reproduced live in this lesson.
- Forgetting `cascade = CascadeType.ALL` on the owning side of a relationship when child entities should be persisted/deleted along with their parent — without it, `em.persist(author)` would not automatically persist its books.
- Not implementing both directions of a bidirectional relationship consistently (e.g., `addBook()` in this lesson updates both `Author.books` and `Book.author` together) — updating only one side leaves the in-memory object graph inconsistent with the database until the next fresh query.
- Confusing `mappedBy` (marks the non-owning side, purely for navigation) with the owning side (which actually has the foreign-key column) — get this backwards and Hibernate will create an unwanted extra join table or fail to persist the relationship at all.

## Best Practices

- Use `JOIN FETCH` (or an equivalent entity-graph mechanism) whenever you know you'll need a related collection for every row in a result set, to avoid N+1 queries.
- Enable `hibernate.show_sql` (or a proper SQL logging tool) during development to see the actual queries being generated — assumptions about ORM query behavior are frequently wrong until verified.
- Keep both directions of bidirectional relationships in sync via helper methods (like `addBook()`/`addTag()` in this lesson), rather than setting only one side.
- Use `hbm2ddl.auto=update` only for learning/prototyping (as in this lesson) — real projects should use versioned migration tools (like Flyway or Liquibase) for schema changes.

## Real-World Usage

Every Spring Data JPA repository call (as seen in [04-Backend-Development](../../04-Backend-Development/03-Data-Persistence-with-Spring-Data-JPA/README.md)) is built on exactly this `EntityManager`/JPQL machinery underneath — understanding this layer explains *why* Spring Data JPA behaves the way it does, and why the N+1 problem shows up just as easily in a Spring Data JPA repository as it does here.

## Summary

- JPA/Hibernate map Java objects to relational tables and relationships, generating both schema DDL and query SQL from annotations.
- One-to-many (`Author`→`Book`) and many-to-many (`Book`↔`Tag`, via an auto-generated join table) were both implemented and verified live.
- The N+1 query problem was reproduced with real SQL output (1+N queries), then fixed with `JOIN FETCH` (verified down to exactly 1 query).

## Key Terms

- **EntityManager** — JPA's core API for persisting, finding, and querying entities within a persistence context.
- **JPQL** — Java Persistence Query Language, an object-oriented query language that JPA translates into SQL.
- **N+1 problem** — a performance bug where fetching N parent rows triggers N additional queries for their related child rows, instead of one combined query.
- **JOIN FETCH** — a JPQL clause that eagerly loads a related collection in the same query as its parent, avoiding the N+1 problem.

## Interview Questions

1. **What is the N+1 problem, and how was it proven to actually occur in this lesson (rather than just described)?**
   The N+1 problem is when fetching N parent entities (like authors) and then accessing a lazy-loaded collection on each one (like their books) triggers 1 query for the parents plus N additional queries — one per parent — instead of a single combined query. This was proven, not just described, by enabling `hibernate.show_sql` and observing the real SQL Hibernate issued: exactly one `SELECT ... FROM authors` followed by one additional `SELECT ... FROM books WHERE author_id = ?` per author in the result set.

2. **How does `JOIN FETCH` fix the N+1 problem, and how was the fix verified?**
   `JOIN FETCH` tells JPA to load the related collection (`a.books`) in the *same* SQL query as the parent entity, via an actual SQL `JOIN`, rather than triggering a separate lazy-load query later. This was verified by rerunning the identical access pattern (`a.getBooks().size()` for each author) after switching the query to `SELECT DISTINCT a FROM Author a JOIN FETCH a.books`, and observing in the SQL log that exactly one query was issued total, regardless of how many authors existed in the result set.

## Recommended Next Lesson

[06 — NoSQL Databases](../06-NoSQL-Databases/README.md)
