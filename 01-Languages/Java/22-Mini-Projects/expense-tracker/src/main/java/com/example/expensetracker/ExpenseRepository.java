package com.example.expensetracker;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/** The JDBC CRUD layer -- every query uses a PreparedStatement, never
 * string-concatenated SQL, the same SQL-injection-safe pattern verified in
 * 16-Database-Access and reused in 21-Solutions/Solution07. */
public class ExpenseRepository {
    private final Connection connection;

    public ExpenseRepository(Connection connection) {
        this.connection = connection;
    }

    public void initSchema() throws SQLException {
        try (Statement stmt = connection.createStatement()) {
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS expenses (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    amount REAL NOT NULL,
                    category TEXT NOT NULL,
                    description TEXT NOT NULL DEFAULT ''
                )
                """);
        }
    }

    public int addExpense(double amount, String category, String description) throws SQLException {
        if (amount <= 0) {
            throw new IllegalArgumentException("Expense amount must be positive, got " + amount);
        }
        try (PreparedStatement stmt = connection.prepareStatement(
                "INSERT INTO expenses (amount, category, description) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
            stmt.setDouble(1, amount);
            stmt.setString(2, category);
            stmt.setString(3, description);
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    public List<Expense> listExpenses(String categoryFilter) throws SQLException {
        String sql = "SELECT id, amount, category, description FROM expenses"
                + (categoryFilter != null ? " WHERE category = ?" : "")
                + " ORDER BY id";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (categoryFilter != null) {
                stmt.setString(1, categoryFilter);
            }
            List<Expense> results = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    results.add(new Expense(
                            rs.getInt("id"), rs.getDouble("amount"),
                            rs.getString("category"), rs.getString("description")));
                }
            }
            return results;
        }
    }

    public double totalExpenses() throws SQLException {
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COALESCE(SUM(amount), 0) AS total FROM expenses")) {
            rs.next();
            return rs.getDouble("total");
        }
    }

    public void deleteExpense(int id) throws SQLException, ExpenseNotFoundException {
        try (PreparedStatement stmt = connection.prepareStatement("DELETE FROM expenses WHERE id = ?")) {
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new ExpenseNotFoundException(id);
            }
        }
    }
}
