package com.example.expensetracker;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

public class Cli {

    public static void main(String[] args) throws SQLException {
        if (args.length == 0) {
            printUsage();
            return;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:expenses.db")) {
            ExpenseRepository repo = new ExpenseRepository(conn);
            repo.initSchema();

            String command = args[0];
            switch (command) {
                case "add" -> {
                    double amount = Double.parseDouble(args[1]);
                    String category = args[2];
                    String description = args.length > 3 ? args[3] : "";
                    int id = repo.addExpense(amount, category, description);
                    System.out.printf("Added expense #%d: $%.2f [%s] %s%n", id, amount, category, description);
                }
                case "list" -> {
                    String categoryFilter = null;
                    for (int i = 1; i < args.length - 1; i++) {
                        if (args[i].equals("--category")) {
                            categoryFilter = args[i + 1];
                        }
                    }
                    List<Expense> expenses = repo.listExpenses(categoryFilter);
                    for (Expense e : expenses) {
                        System.out.printf("#%-3d $%-8.2f %-12s %s%n", e.id(), e.amount(), e.category(), e.description());
                    }
                }
                case "total" -> System.out.printf("Total spent: $%.2f%n", repo.totalExpenses());
                case "delete" -> {
                    int id = Integer.parseInt(args[1]);
                    try {
                        repo.deleteExpense(id);
                        System.out.println("Deleted expense #" + id);
                    } catch (ExpenseNotFoundException e) {
                        System.out.println("Error: " + e.getMessage());
                    }
                }
                default -> printUsage();
            }
        }
    }

    private static void printUsage() {
        System.out.println("""
            Usage:
              add <amount> <category> [description]
              list [--category <category>]
              total
              delete <id>
            """);
    }
}
