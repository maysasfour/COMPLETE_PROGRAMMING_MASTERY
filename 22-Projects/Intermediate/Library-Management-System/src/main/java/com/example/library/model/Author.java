package com.example.library.model;

import jakarta.persistence.*;

@Entity
@Table(name = "authors")
public class Author {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    protected Author() {}
    public Author(String name) { this.name = name; }

    public Long getId() { return id; }
    public String getName() { return name; }
}
