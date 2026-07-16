package com.example.orm;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    // Many books -> one author. This side owns the foreign key (author_id column).
    @ManyToOne
    @JoinColumn(name = "author_id")
    private Author author;

    // Many books <-> many tags: requires a join table (book_tags), which Hibernate
    // creates and manages automatically -- no manual join-table entity needed.
    @ManyToMany
    @JoinTable(
        name = "book_tags",
        joinColumns = @JoinColumn(name = "book_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private Set<Tag> tags = new HashSet<>();

    protected Book() {
    }

    public Book(String title) {
        this.title = title;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public Author getAuthor() { return author; }
    public void setAuthor(Author author) { this.author = author; }
    public Set<Tag> getTags() { return tags; }

    public void addTag(Tag tag) {
        tags.add(tag);
        tag.getBooks().add(this);
    }
}
