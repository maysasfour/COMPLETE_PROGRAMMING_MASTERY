package com.example.solution05;

import com.example.solution05.core.Product;
import com.example.solution05.core.ProductService;

import java.sql.*;

public class Main {

    // VIOLATION: a repository with NO validation, directly reachable from
    // application code (Main is in the SAME package here, deliberately, to
    // model "no layer boundary enforced at all").
    static class ProductRepositoryViolation {
        private final Connection conn;
        ProductRepositoryViolation(Connection conn) { this.conn = conn; }
        void save(String name, double price) throws SQLException {
            try (PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO products (name, price) VALUES (?, ?)")) {
                stmt.setString(1, name);
                stmt.setDouble(2, price);
                stmt.executeUpdate();
            }
        }
    }

    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:exercise05")) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("CREATE TABLE products (name VARCHAR(100), price DOUBLE)");
            }

            System.out.println("=== Violation: repository called directly, no validation ===");
            ProductRepositoryViolation repoViolation = new ProductRepositoryViolation(conn);
            repoViolation.save("Broken Widget", -5.00); // a negative price, saved without complaint
            printRows(conn, "products");

            // Reset for the fixed demo
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("DELETE FROM products");
            }

            System.out.println("\n=== Fixed: application code can ONLY reach ProductService ===");
            // Note: `new com.example.solution05.core.ProductRepository(conn)` would be a
            // COMPILE ERROR here -- ProductRepository is package-private in `core`,
            // and Main is in a DIFFERENT package. This is enforced by the compiler,
            // not just convention.
            ProductService service = new ProductService(conn);

            try {
                service.addProduct("Broken Widget", -5.00);
            } catch (IllegalArgumentException e) {
                System.out.println("Rejected: " + e.getMessage());
            }
            System.out.println("Products in the database after the rejected attempt:");
            for (Product p : service.listProducts()) System.out.println("  " + p);

            service.addProduct("Real Widget", 9.99);
            System.out.println("Products in the database after a VALID product:");
            for (Product p : service.listProducts()) System.out.println("  " + p);
        }
    }

    static void printRows(Connection conn, String table) throws SQLException {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT name, price FROM " + table)) {
            System.out.println("Rows in " + table + ":");
            while (rs.next()) {
                System.out.println("  " + rs.getString("name") + " ($" + rs.getDouble("price") + ")" +
                        (rs.getDouble("price") < 0 ? "  <- BUG: a negative price was saved!" : ""));
            }
        }
    }
}
