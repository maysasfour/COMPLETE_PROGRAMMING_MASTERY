package com.example.library.model;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "loans")
public class Loan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "book_id")
    private Book book;

    @ManyToOne(optional = false)
    @JoinColumn(name = "member_id")
    private Member member;

    private Instant borrowedAt;
    private Instant returnedAt;

    protected Loan() {}

    public Loan(Book book, Member member, Instant borrowedAt) {
        this.book = book;
        this.member = member;
        this.borrowedAt = borrowedAt;
    }

    public Long getId() { return id; }
    public Book getBook() { return book; }
    public Member getMember() { return member; }
    public Instant getBorrowedAt() { return borrowedAt; }
    public Instant getReturnedAt() { return returnedAt; }

    public void markReturned(Instant when) { this.returnedAt = when; }
    public boolean isReturned() { return returnedAt != null; }
}
