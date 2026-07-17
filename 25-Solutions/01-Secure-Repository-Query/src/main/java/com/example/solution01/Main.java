package com.example.solution01;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:exercise01")) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE TABLE users (username VARCHAR(50), password VARCHAR(100))");
                stmt.execute("INSERT INTO users VALUES ('alice', 'alicepass'), ('bob', 'bobpass')");
            }

            String payload = "' OR '1'='1' --";

            System.out.println("=== Step 1: demonstrate the vulnerability ===");
            List<String> vulnerableResult = findByUsernameVulnerable(conn, payload);
            System.out.println("findByUsernameVulnerable(\"" + payload + "\") returned " + vulnerableResult.size() + " row(s): " + vulnerableResult);
            System.out.println("  BUG: should return 0 rows (no user is actually named that), but returned ALL rows!");

            System.out.println("\n=== Step 2 & 3: fixed version, identical payload ===");
            List<String> fixedResult = findByUsernameFixed(conn, payload);
            System.out.println("findByUsernameFixed(\"" + payload + "\") returned " + fixedResult.size() + " row(s): " + fixedResult);
            System.out.println("  Correct: 0 rows -- the payload is treated as a literal username, not SQL");

            System.out.println("\n=== Confirming a real, legitimate lookup still works ===");
            List<String> realLookup = findByUsernameFixed(conn, "alice");
            System.out.println("findByUsernameFixed(\"alice\") returned " + realLookup.size() + " row(s): " + realLookup);
        }
    }

    // VIOLATION
    static List<String> findByUsernameVulnerable(Connection conn, String username) throws SQLException {
        String sql = "SELECT username FROM users WHERE username = '" + username + "'";
        List<String> results = new ArrayList<>();
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) results.add(rs.getString("username"));
        }
        return results;
    }

    // FIX
    static List<String> findByUsernameFixed(Connection conn, String username) throws SQLException {
        String sql = "SELECT username FROM users WHERE username = ?";
        List<String> results = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) results.add(rs.getString("username"));
            }
        }
        return results;
    }
}
