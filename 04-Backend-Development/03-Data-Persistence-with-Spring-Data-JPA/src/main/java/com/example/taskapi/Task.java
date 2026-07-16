package com.example.taskapi;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

/**
 * @Entity marks this class as a genuine, PERSISTED database table -- unlike Lesson 02's
 * plain record held in an in-memory Map, JPA maps this class's fields directly to
 * columns in a real "task" table, and Hibernate (the JPA implementation Spring Boot
 * uses by default) generates the actual SQL for every operation.
 *
 * Deliberately a class, not a record: JPA entities need a no-args constructor and
 * mutable fields for Hibernate to populate via reflection when loading rows from the
 * database -- records' all-args-only canonical constructor and immutable fields don't
 * fit this requirement.
 */
@Entity
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // the DATABASE assigns the id (auto-increment)
    private Long id;

    private String title;

    private boolean done;

    protected Task() {
        // required no-args constructor for JPA/Hibernate -- never called directly by our own code
    }

    public Task(String title, boolean done) {
        this.title = title;
        this.done = done;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public boolean isDone() { return done; }
    public void setTitle(String title) { this.title = title; }
    public void setDone(boolean done) { this.done = done; }
}
