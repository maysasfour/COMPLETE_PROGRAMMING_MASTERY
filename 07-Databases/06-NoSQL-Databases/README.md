# 06 — NoSQL Databases

[Back to module overview](../README.md) | [Previous: Using an ORM](../05-Using-an-ORM/README.md)

## Beginner: What "NoSQL" Actually Means Here

"NoSQL" covers several very different database models (document, key-value, column-family, graph); this lesson focuses on the **document model**, using real MongoDB — specifically a genuine `mongod` binary, auto-downloaded and managed by the `de.flapdoodle.embed.mongo` Java library, so every operation here is a real MongoDB query/response, not a simulation.

The core difference from everything in Lessons 01-05: instead of rows in fixed-column tables, MongoDB stores **documents** (JSON-like objects) in **collections**, and documents in the same collection are not required to share the same fields.

## Beginner: Schema Flexibility, Verified Live

```java
books.insertOne(new Document("title", "Foundation").append("author", "Isaac Asimov")
        .append("year", 1951).append("series", "Foundation"));
books.insertOne(new Document("title", "Dune").append("author", "Frank Herbert").append("year", 1965));
books.insertOne(new Document("title", "Neuromancer").append("author", "William Gibson")
        .append("year", 1984).append("tags", Arrays.asList("cyberpunk", "sci-fi")));
```

Verified live — three documents in the *same* `books` collection, each with a different shape (`series` only on one, `tags` only on another):

```
{"title": "Foundation", "author": "Isaac Asimov", "year": 1951, "series": "Foundation"}
{"title": "Dune", "author": "Frank Herbert", "year": 1965}
{"title": "Neuromancer", "author": "William Gibson", "year": 1984, "tags": ["cyberpunk", "sci-fi"]}
```

A relational table (Lessons 01-02) would need every row to have the same columns — adding `series` to one book and `tags` to another would require nullable columns for both on *every* row, or a schema migration. Here, no schema declaration was needed at all.

## Intermediate: Embedding vs. Joins

Lesson 02 modeled one-to-many relationships (a customer and their orders) with **separate tables joined by a foreign key**, specifically to avoid duplicating data. Document databases offer a different, equally valid option for some relationships: **embedding** related data directly inside the parent document.

```java
Document dune = new Document("title", "Dune's Sequel Reference")
        .append("reviews", Arrays.asList(
                new Document("reviewer", "Ada").append("rating", 5),
                new Document("reviewer", "Grace").append("rating", 4)));
```

Verified live — a single query returned the book *and* its reviews together, with no join:

```
{"title": "Dune's Sequel Reference", "author": "Frank Herbert", "year": 1965,
 "reviews": [{"reviewer": "Ada", "rating": 5}, {"reviewer": "Grace", "rating": 4}]}
```

This is a genuine tradeoff, not a strictly "better" approach: embedding avoids a join and reads fast, but duplicates data if the same sub-document needs to be shared/queried independently across parents — exactly the kind of redundancy Lesson 02's normalization was designed to eliminate in the relational model. Document databases favor embedding when related data is always read together and rarely needs independent updates; they favor references (like a foreign key) otherwise.

## Advanced: Querying, Updating, Deleting

```java
books.find(new Document("year", new Document("$gt", 1960)));       // filter: year > 1960
books.updateOne(new Document("title", "Neuromancer"),
        new Document("$set", new Document("rating", 5)));          // partial update
books.deleteOne(new Document("title", "Foundation"));               // delete
```

Verified live: the `$gt` filter correctly returned only `Dune` and `Neuromancer`; `$set` added a new `rating` field to just the `Neuromancer` document without touching any other field; `deleteOne` removed exactly one document, confirmed by `countDocuments()` dropping from 4 to 3.

## Detailed Example

See [pom.xml](pom.xml) and [Main.java](src/main/java/com/example/nosql/Main.java) — starts a real embedded `mongod`, demonstrates schema flexibility, embedding, and CRUD/filter operations, then shuts the instance down cleanly.

## Run It

```bash
cd 07-Databases/06-NoSQL-Databases
mvn compile exec:java
```

The first run downloads a real MongoDB binary (cached afterward) — expect several seconds of `mongod` startup log output before the demo's own output appears.

## Expected Output

`mongod` startup logs, followed by the schema-flexibility demo (3 differently-shaped documents), the embedding demo (one document containing an embedded reviews array), and the querying demo (a `$gt` filter, a `$set` update, and a delete with a confirmed remaining count), followed by a clean shutdown message.

## Common Mistakes

- Assuming "schema-less" means "no structure at all" — in practice, most documents in a collection still follow a consistent shape by convention; MongoDB just doesn't *enforce* it at the database level the way a relational `CREATE TABLE` does.
- Over-embedding data that's actually shared across many parent documents (e.g., embedding full author details into every one of that author's books) — this reintroduces exactly the update-anomaly risk Lesson 02 demonstrated, since the same fact now exists in multiple places.
- Treating document databases as a strict upgrade over relational databases — they trade referential integrity and join support (present in Lessons 01-05) for flexible schemas and fast reads of self-contained documents; the right choice depends on the data's actual access patterns.

## Best Practices

- Embed data that is always read together with its parent and rarely needs independent querying or updates; reference (store an ID, query separately) data that's shared across many parents or updated independently.
- Even without enforced schemas, keep documents in the same collection reasonably consistent in shape — application code still needs to handle whatever fields may or may not be present.
- Use MongoDB's query operators (`$gt`, `$set`, `$in`, etc.) rather than pulling all documents into application code to filter/update manually.

## Real-World Usage

Document databases are commonly used for content that's naturally self-contained and varies in shape (product catalogs with different attributes per category, user-generated content, event/activity logs) where the relational model's rigid, uniform-column tables would require excessive nullable columns or awkward workarounds. They are less suited to data with many small, frequently-changing relationships that benefit from referential integrity and joins — exactly where the relational model (Lessons 01-05) remains the stronger choice.

## Summary

- MongoDB documents in the same collection can have different fields — verified live with three differently-shaped book documents.
- Embedding related data directly in a document avoids joins for data that's always read together, verified live with a book and its embedded reviews — but reintroduces the redundancy risk normalization (Lesson 02) exists to prevent, if overused.
- Filtering (`$gt`), partial updates (`$set`), and deletes were all verified live against a real embedded `mongod` instance.

## Key Terms

- **Document** — a JSON-like record (BSON in MongoDB) stored in a collection; the NoSQL analogue of a relational row, but without a fixed set of required columns.
- **Collection** — a group of documents, the NoSQL analogue of a relational table.
- **Embedding** — storing related data directly inside a parent document instead of in a separate, joined table/collection.

## Interview Questions

1. **How does MongoDB's schema flexibility differ from a relational table, and what was verified live to demonstrate it?**
   A relational table requires every row to have the same fixed set of columns; adding a new attribute to just one row still requires that column to exist (typically as nullable) for every other row. MongoDB documents in the same collection can each have entirely different fields. This was verified live by inserting three book documents into the same `books` collection where only one had a `series` field and only one had a `tags` field, with no schema declaration or migration required for either.

2. **What is "embedding" in a document database, and what tradeoff does it introduce compared to the normalized, foreign-key approach from Lesson 02?**
   Embedding stores related data (like a book's reviews) directly inside the parent document as a nested sub-document/array, rather than in a separate table joined by a foreign key. This was verified live: a single query returned a book and its embedded reviews together, with no join needed. The tradeoff is that embedded data is duplicated wherever it's embedded — if the same sub-document needed to be shared and independently updated across multiple parents, embedding would reintroduce exactly the kind of update anomaly that normalization (Lesson 02) is designed to eliminate; embedding is best suited to data that's always read together with, and owned exclusively by, one parent document.

## Recommended Next Lesson

This is the final lesson in the Databases module. Return to the [module overview](../README.md) or continue to another module, such as [12-Design-Patterns](../../12-Design-Patterns/README.md) or [13-Software-Architecture](../../13-Software-Architecture/README.md) if built.
