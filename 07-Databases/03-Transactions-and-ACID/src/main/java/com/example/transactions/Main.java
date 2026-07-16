package com.example.transactions;

import java.sql.*;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Demonstrates each ACID property with a REAL, observable effect -- not just defined
 * in prose. A bank-transfer scenario (debit one account, credit another) is the classic,
 * clearest way to show why transactions matter: half a transfer completing is exactly
 * the kind of bug ACID guarantees are designed to make impossible.
 */
public class Main {
    public static void main(String[] args) throws Exception {
        demonstrateAtomicityAndConsistency();
        demonstrateIsolation();
        demonstrateDurability();
    }

    static void demonstrateAtomicityAndConsistency() throws SQLException {
        System.out.println("=== ATOMICITY: a failed transfer must leave NEITHER account changed ===");
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:accountsdb")) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("""
                    CREATE TABLE accounts (
                        id INT PRIMARY KEY,
                        name VARCHAR(50),
                        balance DECIMAL(10,2) CHECK (balance >= 0)
                    )
                """); // CHECK (balance >= 0): a CONSISTENCY rule enforced by the database ITSELF
                stmt.execute("INSERT INTO accounts VALUES (1, 'Ada', 100.00), (2, 'Grace', 50.00)");
            }

            printBalances(conn, "Starting balances");

            System.out.println("\n--- Attempting to transfer $200 from Ada (who only has $100) ---");
            conn.setAutoCommit(false); // start a transaction: nothing commits until we say so
            try {
                debit(conn, 1, 200.00); // this ITSELF violates the CHECK (balance >= 0) constraint
                credit(conn, 2, 200.00);
                conn.commit();
                System.out.println("(transfer committed -- should NOT reach here)");
            } catch (SQLException e) {
                conn.rollback(); // ATOMICITY: undo EVERYTHING done since the transaction began
                System.out.println("caught: " + e.getMessage());
                System.out.println("Transaction rolled back -- Ada's debit was UNDONE too, not left half-applied.");
            } finally {
                conn.setAutoCommit(true);
            }

            printBalances(conn, "Balances after the FAILED transfer (should be UNCHANGED)");

            System.out.println("\n--- A VALID transfer of $30 from Ada to Grace ---");
            conn.setAutoCommit(false);
            try {
                debit(conn, 1, 30.00);
                credit(conn, 2, 30.00);
                conn.commit();
                System.out.println("Transaction committed successfully.");
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
            printBalances(conn, "Balances after the SUCCESSFUL transfer");
        }
    }

    static void debit(Connection conn, int accountId, double amount) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE accounts SET balance = balance - ? WHERE id = ?")) {
            stmt.setDouble(1, amount);
            stmt.setInt(2, accountId);
            stmt.executeUpdate(); // the CHECK constraint fires HERE if this would go negative
        }
    }

    static void credit(Connection conn, int accountId, double amount) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE accounts SET balance = balance + ? WHERE id = ?")) {
            stmt.setDouble(1, amount);
            stmt.setInt(2, accountId);
            stmt.executeUpdate();
        }
    }

    static void printBalances(Connection conn, String label) throws SQLException {
        System.out.println(label + ":");
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT name, balance FROM accounts ORDER BY id")) {
            while (rs.next()) {
                System.out.printf("  %s: $%s%n", rs.getString("name"), rs.getBigDecimal("balance"));
            }
        }
    }

    static void demonstrateIsolation() throws SQLException {
        System.out.println("\n=== ISOLATION: an uncommitted change is invisible to another connection ===");
        try (Connection connA = DriverManager.getConnection("jdbc:h2:mem:isolationdb;DB_CLOSE_DELAY=-1");
             Connection connB = DriverManager.getConnection("jdbc:h2:mem:isolationdb;DB_CLOSE_DELAY=-1")) {

            try (Statement stmt = connA.createStatement()) {
                stmt.execute("CREATE TABLE counter (counter_value INT)");
                stmt.execute("INSERT INTO counter VALUES (100)");
            }

            connA.setAutoCommit(false);
            try (PreparedStatement stmt = connA.prepareStatement("UPDATE counter SET counter_value = 999")) {
                stmt.executeUpdate(); // connA has changed the value, but NOT yet committed
            }

            // connB, a COMPLETELY SEPARATE connection, queries the SAME table right now
            try (Statement stmt = connB.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT counter_value FROM counter")) {
                rs.next();
                System.out.println("connB sees value = " + rs.getInt("counter_value") +
                        " (still 100 -- connA's uncommitted change is correctly invisible to it)");
            }

            connA.commit();
            connA.setAutoCommit(true);

            try (Statement stmt = connB.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT counter_value FROM counter")) {
                rs.next();
                System.out.println("connB sees value = " + rs.getInt("counter_value") +
                        " (NOW 999 -- visible only AFTER connA committed)");
            }
        }
    }

    static void demonstrateDurability() throws Exception {
        System.out.println("\n=== DURABILITY: a committed change survives closing the connection entirely ===");
        Path dbFile = Files.createTempFile("durabilitydemo", "");
        Files.deleteIfExists(dbFile); // H2 will create its own file(s) at this path
        String url = "jdbc:h2:" + dbFile.toAbsolutePath();

        try (Connection conn = DriverManager.getConnection(url)) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE TABLE durable_data (id INT, note VARCHAR(100))");
                stmt.execute("INSERT INTO durable_data VALUES (1, 'this should survive a full disconnect')");
            }
            // no explicit commit needed -- H2 defaults to auto-commit, and this is a real,
            // FILE-BACKED database (unlike the :mem: databases used elsewhere in this lesson,
            // which are deliberately non-durable, existing only for the JVM's lifetime).
        } // connection fully closed here

        try (Connection conn2 = DriverManager.getConnection(url)) {
            try (Statement stmt = conn2.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT note FROM durable_data WHERE id = 1")) {
                rs.next();
                System.out.println("Reopened the database in a NEW connection and found: \"" +
                        rs.getString("note") + "\"");
            }
        }

        // clean up the on-disk file this demo created
        Files.deleteIfExists(Path.of(dbFile.toAbsolutePath() + ".mv.db"));
    }
}
