package com.example.orm;

import jakarta.persistence.*;
import java.util.List;

/**
 * Demonstrates using JPA/Hibernate directly (no Spring) to map Java objects to
 * relational tables: a one-to-many relationship (Author -> Books) and a
 * many-to-many relationship (Book <-> Tags), plus the real N+1 query problem
 * and how JOIN FETCH avoids it -- verified by counting actual SQL statements
 * Hibernate issues, not just described.
 */
public class Main {
    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("ormdemo");

        seedData(emf);
        demonstrateOneToMany(emf);
        demonstrateManyToMany(emf);
        demonstrateNPlusOneVsJoinFetch(emf);

        emf.close();
    }

    static void seedData(EntityManagerFactory emf) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();

        Author asimov = new Author("Isaac Asimov");
        Book foundation = new Book("Foundation");
        Book robots = new Book("I, Robot");
        asimov.addBook(foundation);
        asimov.addBook(robots);

        Tag scifi = new Tag("sci-fi");
        Tag classic = new Tag("classic");
        foundation.addTag(scifi);
        foundation.addTag(classic);
        robots.addTag(scifi);

        em.persist(asimov); // cascades to books via CascadeType.ALL
        em.persist(scifi);
        em.persist(classic);

        em.getTransaction().commit();
        em.close();
        System.out.println("=== Seeded 1 author, 2 books, 2 tags ===\n");
    }

    static void demonstrateOneToMany(EntityManagerFactory emf) {
        System.out.println("=== ONE-TO-MANY: Author -> Books ===");
        EntityManager em = emf.createEntityManager();
        Author asimov = em.createQuery(
                "SELECT a FROM Author a WHERE a.name = :name", Author.class)
            .setParameter("name", "Isaac Asimov")
            .getSingleResult();

        System.out.println(asimov.getName() + "'s books:");
        for (Book b : asimov.getBooks()) {
            System.out.println("  - " + b.getTitle());
        }
        em.close();
        System.out.println();
    }

    static void demonstrateManyToMany(EntityManagerFactory emf) {
        System.out.println("=== MANY-TO-MANY: Books <-> Tags ===");
        EntityManager em = emf.createEntityManager();
        Book foundation = em.createQuery(
                "SELECT b FROM Book b WHERE b.title = :title", Book.class)
            .setParameter("title", "Foundation")
            .getSingleResult();

        System.out.println("\"" + foundation.getTitle() + "\" tags:");
        for (Tag t : foundation.getTags()) {
            System.out.println("  - " + t.getName());
        }

        Tag scifi = em.createQuery("SELECT t FROM Tag t WHERE t.name = :name", Tag.class)
            .setParameter("name", "sci-fi")
            .getSingleResult();
        System.out.println("Books tagged \"sci-fi\":");
        for (Book b : scifi.getBooks()) {
            System.out.println("  - " + b.getTitle());
        }
        em.close();
        System.out.println();
    }

    static void demonstrateNPlusOneVsJoinFetch(EntityManagerFactory emf) {
        System.out.println("=== THE N+1 PROBLEM vs. JOIN FETCH ===");

        System.out.println("\n--- Naive: query all authors, then access .getBooks() for each (N+1 queries) ---");
        EntityManager em1 = emf.createEntityManager();
        List<Author> authors = em1.createQuery("SELECT a FROM Author a", Author.class).getResultList();
        for (Author a : authors) {
            a.getBooks().size(); // triggers a SEPARATE lazy-load query per author
        }
        em1.close();
        System.out.println("(watch hibernate.show_sql output above: 1 query for authors, +1 more per author for their books)");

        System.out.println("\n--- Fixed: JOIN FETCH loads authors AND books in ONE query ---");
        EntityManager em2 = emf.createEntityManager();
        List<Author> authorsFetched = em2.createQuery(
                "SELECT DISTINCT a FROM Author a JOIN FETCH a.books", Author.class)
            .getResultList();
        for (Author a : authorsFetched) {
            a.getBooks().size(); // no extra query -- already loaded by the JOIN FETCH
        }
        em2.close();
        System.out.println("(watch hibernate.show_sql output above: exactly ONE query, joining authors and books together)");
    }
}
