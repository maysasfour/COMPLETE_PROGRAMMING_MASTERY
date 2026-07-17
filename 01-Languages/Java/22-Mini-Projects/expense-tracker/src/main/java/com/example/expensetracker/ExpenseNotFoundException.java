package com.example.expensetracker;

public class ExpenseNotFoundException extends Exception {
    public ExpenseNotFoundException(int id) {
        super("No expense found with id " + id);
    }
}
