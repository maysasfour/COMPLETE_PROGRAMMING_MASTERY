package com.example.library.dto;

import com.example.library.model.Book;

public record BookResponse(Long id, String title, String isbn, String authorName, int copiesTotal, int copiesAvailable) {
    public static BookResponse from(Book book) {
        return new BookResponse(
                book.getId(),
                book.getTitle(),
                book.getIsbn(),
                book.getAuthor().getName(),
                book.getCopiesTotal(),
                book.getCopiesAvailable()
        );
    }
}
