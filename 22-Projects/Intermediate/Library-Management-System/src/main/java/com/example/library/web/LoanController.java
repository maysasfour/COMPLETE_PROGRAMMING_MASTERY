package com.example.library.web;

import com.example.library.dto.BorrowRequest;
import com.example.library.dto.LoanResponse;
import com.example.library.model.Book;
import com.example.library.model.Loan;
import com.example.library.model.Member;
import com.example.library.repo.BookRepository;
import com.example.library.repo.LoanRepository;
import com.example.library.repo.MemberRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@RestController
public class LoanController {

    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    private final LoanRepository loanRepository;

    public LoanController(BookRepository bookRepository, MemberRepository memberRepository, LoanRepository loanRepository) {
        this.bookRepository = bookRepository;
        this.memberRepository = memberRepository;
        this.loanRepository = loanRepository;
    }

    @PostMapping("/loans")
    @Transactional
    public ResponseEntity<?> borrow(@RequestBody BorrowRequest request, Authentication authentication) {
        Member member = memberRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalStateException("Authenticated member not found"));
        Book book = bookRepository.findById(request.bookId())
                .orElseThrow(() -> new IllegalArgumentException("Unknown bookId: " + request.bookId()));

        if (!book.borrowCopy()) {
            return ResponseEntity.status(409).body(Map.of("error", "No copies available for this book"));
        }
        bookRepository.save(book);

        Loan loan = new Loan(book, member, Instant.now());
        loanRepository.save(loan);
        return ResponseEntity.status(201).body(LoanResponse.from(loan));
    }

    @PostMapping("/loans/{id}/return")
    @Transactional
    public ResponseEntity<?> returnLoan(@PathVariable Long id) {
        Loan loan = loanRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Unknown loanId: " + id));
        if (loan.isReturned()) {
            return ResponseEntity.status(409).body(Map.of("error", "Loan already returned"));
        }
        loan.markReturned(Instant.now());
        loanRepository.save(loan);

        Book book = loan.getBook();
        book.returnCopy();
        bookRepository.save(book);

        return ResponseEntity.ok(LoanResponse.from(loan));
    }

    @GetMapping("/members/{id}/loans")
    public List<LoanResponse> loansForMember(@PathVariable Long id) {
        return loanRepository.findByMemberId(id).stream().map(LoanResponse::from).toList();
    }
}
