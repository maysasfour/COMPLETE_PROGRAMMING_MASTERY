package com.example.library;

import com.example.library.model.*;
import com.example.library.repo.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    private final AuthorRepository authorRepository;
    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(AuthorRepository authorRepository, BookRepository bookRepository,
                       MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
        this.authorRepository = authorRepository;
        this.bookRepository = bookRepository;
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        Author orwell = authorRepository.save(new Author("George Orwell"));
        Author tolkien = authorRepository.save(new Author("J.R.R. Tolkien"));

        bookRepository.save(new Book("1984", "978-0451524935", orwell, 2));
        bookRepository.save(new Book("Animal Farm", "978-0451526342", orwell, 0));
        bookRepository.save(new Book("The Hobbit", "978-0345339683", tolkien, 3));

        memberRepository.save(new Member("alice", passwordEncoder.encode("alice123"), Role.MEMBER));
        memberRepository.save(new Member("libby", passwordEncoder.encode("libby123"), Role.LIBRARIAN));
    }
}
