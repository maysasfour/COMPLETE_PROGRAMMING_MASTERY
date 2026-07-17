package com.example.library.web;

import com.example.library.dto.BookResponse;
import com.example.library.dto.CreateBookRequest;
import com.example.library.model.Author;
import com.example.library.model.Book;
import com.example.library.repo.AuthorRepository;
import com.example.library.repo.BookRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/books")
public class BookController {

    private final BookRepository bookRepository;
    private final AuthorRepository authorRepository;

    public BookController(BookRepository bookRepository, AuthorRepository authorRepository) {
        this.bookRepository = bookRepository;
        this.authorRepository = authorRepository;
    }

    @GetMapping
    public List<BookResponse> listBooks() {
        return bookRepository.findAll().stream().map(BookResponse::from).toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<BookResponse> getBook(@PathVariable Long id) {
        return bookRepository.findById(id)
                .map(book -> ResponseEntity.ok(BookResponse.from(book)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasRole('LIBRARIAN')")
    public ResponseEntity<BookResponse> createBook(@RequestBody CreateBookRequest request) {
        Author author = authorRepository.findById(request.authorId())
                .orElseThrow(() -> new IllegalArgumentException("Unknown authorId: " + request.authorId()));
        Book book = new Book(request.title(), request.isbn(), author, request.copiesTotal());
        bookRepository.save(book);
        return ResponseEntity.status(201).body(BookResponse.from(book));
    }
}
