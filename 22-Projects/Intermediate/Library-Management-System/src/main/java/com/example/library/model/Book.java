package com.example.library.model;

import jakarta.persistence.*;

@Entity
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String isbn;

    @ManyToOne(optional = false)
    @JoinColumn(name = "author_id")
    private Author author;

    private int copiesTotal;
    private int copiesAvailable;

    protected Book() {}

    public Book(String title, String isbn, Author author, int copiesTotal) {
        this.title = title;
        this.isbn = isbn;
        this.author = author;
        this.copiesTotal = copiesTotal;
        this.copiesAvailable = copiesTotal;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getIsbn() { return isbn; }
    public Author getAuthor() { return author; }
    public int getCopiesTotal() { return copiesTotal; }
    public int getCopiesAvailable() { return copiesAvailable; }

    public void setCopiesAvailable(int copiesAvailable) { this.copiesAvailable = copiesAvailable; }

    public boolean borrowCopy() {
        if (copiesAvailable <= 0) return false;
        copiesAvailable--;
        return true;
    }

    public void returnCopy() {
        if (copiesAvailable < copiesTotal) copiesAvailable++;
    }
}
