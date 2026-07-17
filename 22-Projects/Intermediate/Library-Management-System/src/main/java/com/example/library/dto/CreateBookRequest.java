package com.example.library.dto;

public record CreateBookRequest(String title, String isbn, Long authorId, int copiesTotal) {
}
