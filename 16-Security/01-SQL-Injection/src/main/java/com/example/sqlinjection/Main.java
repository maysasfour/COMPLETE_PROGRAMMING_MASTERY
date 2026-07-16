package com.example.sqlinjection;

import java.sql.*;

/**
 * Demonstrates a REAL SQL injection attack succeeding against string-concatenated
 * SQL, and the SAME attack correctly failing against parameterized SQL --
 * OWASP's #1 historically-cited vulnerability, verified live against a real H2
 * database, not a hypothetical description.
 */
public class Main {
    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:securitydb")) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("""
                    CREATE TABLE users (
                        username VARCHAR(50) PRIMARY KEY,
                        password VARCHAR(100)
                    )
                """);
                stmt.execute("INSERT INTO users VALUES ('admin', 'correct-horse-battery-staple')");
                stmt.execute("INSERT INTO users VALUES ('alice', 'alice-real-password')");
            }

            System.out.println("=== Violation: string-concatenated SQL, exploited with a real injection payload ===");
            String attackerUsername = "' OR '1'='1' --";
            String attackerPassword = "anything, doesn't matter";
            System.out.println("Attacker submits username: " + attackerUsername + "  (password field ignored/irrelevant)");
            boolean loggedInViolation = loginVulnerable(conn, attackerUsername, attackerPassword);
            System.out.println("  Login result: " + loggedInViolation +
                    (loggedInViolation ? "  <- BUG: attacker is now logged in WITHOUT knowing any real password!" : ""));

            System.out.println("\n=== Fixed: the IDENTICAL attack against parameterized SQL ===");
            boolean loggedInFixed = loginSafe(conn, attackerUsername, attackerPassword);
            System.out.println("  Login result: " + loggedInFixed + "  <- correct: the injection payload is treated as LITERAL text, not SQL");

            System.out.println("\n=== Confirming the fixed version still works correctly for a REAL, valid login ===");
            boolean realLogin = loginSafe(conn, "alice", "alice-real-password");
            System.out.println("  Login result for alice with her real password: " + realLogin + "  <- correct");
        }
    }

    // VIOLATION: the username is concatenated DIRECTLY into the SQL string. An
    // attacker-controlled username can inject its own SQL logic.
    static boolean loginVulnerable(Connection conn, String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";
        System.out.println("  Actual SQL executed: " + sql);
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next(); // true if ANY row matched
        }
    }

    // FIX: parameterized SQL. The username/password are bound as PARAMETERS,
    // never interpreted as SQL syntax, no matter what characters they contain.
    static boolean loginSafe(Connection conn, String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}
