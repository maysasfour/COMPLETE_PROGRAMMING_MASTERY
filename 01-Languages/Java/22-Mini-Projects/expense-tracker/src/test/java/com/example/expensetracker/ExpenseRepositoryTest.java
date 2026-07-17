package com.example.expensetracker;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Uses an IN-MEMORY SQLite database (never the real expenses.db file), so
 * running this suite never touches or resets real tracked data. */
class ExpenseRepositoryTest {

    private Connection connection;
    private ExpenseRepository repo;

    @BeforeEach
    void setUp() throws SQLException {
        connection = DriverManager.getConnection("jdbc:sqlite::memory:");
        repo = new ExpenseRepository(connection);
        repo.initSchema();
    }

    @AfterEach
    void tearDown() throws SQLException {
        connection.close();
    }

    @Test
    void initSchemaCreatesTable() throws SQLException {
        // A second call must not throw (IF NOT EXISTS), and the table must be usable.
        repo.initSchema();
        assertEquals(0.0, repo.totalExpenses());
    }

    @Test
    void addExpenseReturnsGeneratedId() throws SQLException {
        int id = repo.addExpense(42.50, "groceries", "Weekly shop");
        assertTrue(id > 0);
    }

    @Test
    void addExpenseRejectsNonPositiveAmount() {
        assertThrows(IllegalArgumentException.class, () -> repo.addExpense(0, "groceries", "x"));
        assertThrows(IllegalArgumentException.class, () -> repo.addExpense(-5, "groceries", "x"));
    }

    @Test
    void listExpensesReturnsAll() throws SQLException {
        repo.addExpense(10, "food", "a");
        repo.addExpense(20, "transport", "b");
        List<Expense> all = repo.listExpenses(null);
        assertEquals(2, all.size());
    }

    @Test
    void listExpensesFiltersByCategory() throws SQLException {
        repo.addExpense(10, "food", "a");
        repo.addExpense(20, "transport", "b");
        repo.addExpense(30, "food", "c");
        List<Expense> foodOnly = repo.listExpenses("food");
        assertEquals(2, foodOnly.size());
        assertTrue(foodOnly.stream().allMatch(e -> e.category().equals("food")));
    }

    @Test
    void totalExpensesSumsAmounts() throws SQLException {
        repo.addExpense(10.50, "food", "a");
        repo.addExpense(20.25, "transport", "b");
        assertEquals(30.75, repo.totalExpenses(), 0.001);
    }

    @Test
    void totalExpensesZeroWhenEmpty() throws SQLException {
        assertEquals(0.0, repo.totalExpenses());
    }

    @Test
    void deleteExpenseRemovesRow() throws Exception {
        int id = repo.addExpense(10, "food", "a");
        repo.deleteExpense(id);
        assertEquals(0, repo.listExpenses(null).size());
    }

    @Test
    void deleteNonexistentExpenseThrows() {
        assertThrows(ExpenseNotFoundException.class, () -> repo.deleteExpense(999));
    }
}
