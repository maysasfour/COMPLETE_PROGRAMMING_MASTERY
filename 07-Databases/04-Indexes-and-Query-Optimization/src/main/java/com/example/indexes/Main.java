package com.example.indexes;

import java.sql.*;

/**
 * Demonstrates indexing with a REAL, measured before/after query time and a real
 * EXPLAIN plan change -- not just an assertion that "indexes make things faster."
 * Uses a large-enough row count (200,000) that a full table scan is actually
 * measurable in milliseconds, so the improvement isn't noise.
 */
public class Main {
    static final int ROW_COUNT = 200_000;

    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:indexdb")) {
            createAndPopulate(conn);

            System.out.println("=== EXPLAIN plan and timing BEFORE an index exists ===");
            explain(conn, "SELECT * FROM users WHERE email = 'user-100000@example.com'");
            long beforeMs = timeQuery(conn, "SELECT * FROM users WHERE email = 'user-100000@example.com'");
            System.out.println("Query time WITHOUT index: " + beforeMs + " ms (full table scan)");

            System.out.println("\n--- Creating an index on users.email ---");
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE INDEX idx_users_email ON users(email)");
            }

            System.out.println("\n=== EXPLAIN plan and timing AFTER the index exists ===");
            explain(conn, "SELECT * FROM users WHERE email = 'user-100000@example.com'");
            long afterMs = timeQuery(conn, "SELECT * FROM users WHERE email = 'user-100000@example.com'");
            System.out.println("Query time WITH index: " + afterMs + " ms (index lookup)");

            System.out.println("\nSpeedup: query with the index took " +
                    (beforeMs == 0 ? "an unmeasurably small" : String.format("%.1fx less", (double) beforeMs / Math.max(afterMs, 1))) +
                    " time than the full table scan (" + beforeMs + "ms -> " + afterMs + "ms).");
        }
    }

    static void createAndPopulate(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("""
                CREATE TABLE users (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    email VARCHAR(100),
                    name VARCHAR(100)
                )
            """);
        }
        System.out.println("Inserting " + ROW_COUNT + " rows (this takes a few seconds)...");
        conn.setAutoCommit(false);
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO users (email, name) VALUES (?, ?)")) {
            for (int i = 1; i <= ROW_COUNT; i++) {
                stmt.setString(1, "user-" + i + "@example.com");
                stmt.setString(2, "User " + i);
                stmt.addBatch();
                if (i % 5000 == 0) {
                    stmt.executeBatch();
                }
            }
            stmt.executeBatch();
        }
        conn.commit();
        conn.setAutoCommit(true);
        System.out.println("Done inserting " + ROW_COUNT + " rows.\n");
    }

    static void explain(Connection conn, String sql) throws SQLException {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("EXPLAIN " + sql)) {
            while (rs.next()) {
                System.out.println("  " + rs.getString(1));
            }
        }
    }

    static long timeQuery(Connection conn, String sql) throws SQLException {
        long start = System.nanoTime();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                rs.getString("name"); // force the row to actually be read
            }
        }
        return (System.nanoTime() - start) / 1_000_000;
    }
}
