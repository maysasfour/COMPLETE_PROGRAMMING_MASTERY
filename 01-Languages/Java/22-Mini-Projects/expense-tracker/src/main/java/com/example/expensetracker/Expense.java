package com.example.expensetracker;

public record Expense(int id, double amount, String category, String description) {
}
