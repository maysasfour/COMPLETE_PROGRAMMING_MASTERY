package com.example.library.dto;

import com.example.library.model.Loan;

public record LoanResponse(Long id, Long bookId, String bookTitle, Long memberId, String borrowedAt, String returnedAt) {
    public static LoanResponse from(Loan loan) {
        return new LoanResponse(
                loan.getId(),
                loan.getBook().getId(),
                loan.getBook().getTitle(),
                loan.getMember().getId(),
                loan.getBorrowedAt().toString(),
                loan.getReturnedAt() == null ? null : loan.getReturnedAt().toString()
        );
    }
}
