package com.example.nosql;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import de.flapdoodle.embed.mongo.transitions.Mongod;
import de.flapdoodle.embed.mongo.transitions.RunningMongodProcess;
import de.flapdoodle.reverse.TransitionWalker;
import org.bson.Document;

import java.util.Arrays;

/**
 * Demonstrates a document (NoSQL) database, contrasted directly with the relational
 * model covered in Lessons 01-05. Uses a REAL mongod binary, auto-downloaded and
 * managed by de.flapdoodle.embed.mongo -- not a mock or an in-memory fake -- so every
 * operation here is a genuine MongoDB query/response, verified live.
 */
public class Main {
    public static void main(String[] args) {
        System.out.println("Starting a real embedded MongoDB instance (downloads the binary on first run)...");
        try (TransitionWalker.ReachedState<RunningMongodProcess> running =
                     Mongod.instance().start(de.flapdoodle.embed.mongo.distribution.Version.Main.V7_0)) {

            String connectionString = "mongodb://" + running.current().getServerAddress();
            try (MongoClient client = MongoClients.create(connectionString)) {
                MongoDatabase db = client.getDatabase("bookstore");
                MongoCollection<Document> books = db.getCollection("books");

                demonstrateSchemaFlexibility(books);
                demonstrateEmbeddingVsJoins(books);
                demonstrateQuerying(books);
            }
        }
        System.out.println("\nEmbedded MongoDB instance shut down cleanly.");
    }

    static void demonstrateSchemaFlexibility(MongoCollection<Document> books) {
        System.out.println("\n=== SCHEMA FLEXIBILITY: documents in the same collection can differ in shape ===");
        // Unlike a relational table (fixed columns for every row), each document here
        // has a DIFFERENT set of fields -- no ALTER TABLE needed to add "series" later.
        books.insertOne(new Document("title", "Foundation")
                .append("author", "Isaac Asimov")
                .append("year", 1951)
                .append("series", "Foundation"));
        books.insertOne(new Document("title", "Dune")
                .append("author", "Frank Herbert")
                .append("year", 1965));
        books.insertOne(new Document("title", "Neuromancer")
                .append("author", "William Gibson")
                .append("year", 1984)
                .append("tags", Arrays.asList("cyberpunk", "sci-fi")));

        System.out.println("Inserted 3 documents with DIFFERENT fields (series/tags present on some, absent on others):");
        for (Document d : books.find()) {
            System.out.println("  " + d.toJson());
        }
    }

    static void demonstrateEmbeddingVsJoins(MongoCollection<Document> books) {
        System.out.println("\n=== EMBEDDING vs. JOINS: related data lives INSIDE the document ===");
        // In the relational model (Lesson 02), a book and its reviews would need
        // separate tables joined by a foreign key. Here, reviews are EMBEDDED directly
        // as a sub-document array -- one query returns the book AND its reviews together,
        // no JOIN required.
        Document dune = new Document("title", "Dune's Sequel Reference")
                .append("author", "Frank Herbert")
                .append("year", 1965)
                .append("reviews", Arrays.asList(
                        new Document("reviewer", "Ada").append("rating", 5),
                        new Document("reviewer", "Grace").append("rating", 4)
                ));
        books.insertOne(dune);

        Document found = books.find(new Document("title", "Dune's Sequel Reference")).first();
        System.out.println("One query returned the book AND its embedded reviews together:");
        System.out.println("  " + found.toJson());
    }

    static void demonstrateQuerying(MongoCollection<Document> books) {
        System.out.println("\n=== QUERYING: filter, update, and delete ===");

        System.out.println("Books published after 1960:");
        for (Document d : books.find(new Document("year", new Document("$gt", 1960)))) {
            System.out.println("  " + d.getString("title") + " (" + d.getInteger("year") + ")");
        }

        System.out.println("\nUpdating Neuromancer to add a 'rating' field...");
        books.updateOne(new Document("title", "Neuromancer"),
                new Document("$set", new Document("rating", 5)));
        Document updated = books.find(new Document("title", "Neuromancer")).first();
        System.out.println("  " + updated.toJson());

        System.out.println("\nDeleting Foundation...");
        long deletedCount = books.deleteOne(new Document("title", "Foundation")).getDeletedCount();
        System.out.println("Deleted " + deletedCount + " document(s). Remaining count: " + books.countDocuments());
    }
}
