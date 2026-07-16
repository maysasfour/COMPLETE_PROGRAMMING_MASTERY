package com.example.normalization;

import java.sql.*;

/**
 * Demonstrates a genuine UPDATE ANOMALY in an unnormalized schema, then shows how
 * normalizing into separate tables (1NF/2NF/3NF) eliminates it structurally --
 * not just by convention, but by making the inconsistent state impossible to create.
 */
public class Main {
    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:normdb")) {
            System.out.println("=== BEFORE: unnormalized, single wide table ===");
            demonstrateUnnormalized(conn);

            System.out.println("\n=== AFTER: normalized into customers / products / orders ===");
            demonstrateNormalized(conn);
        }
    }

    static void demonstrateUnnormalized(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("""
                CREATE TABLE orders_flat (
                    order_id INT PRIMARY KEY AUTO_INCREMENT,
                    customer_name VARCHAR(100),
                    customer_email VARCHAR(100),
                    product_name VARCHAR(100),
                    product_price DECIMAL(10,2),
                    quantity INT
                )
            """);
            // The SAME customer (Ada) and the SAME product (Widget) appear in
            // MULTIPLE rows -- their data is DUPLICATED, not referenced once.
            stmt.execute("""
                INSERT INTO orders_flat (customer_name, customer_email, product_name, product_price, quantity)
                VALUES
                    ('Ada Lovelace', 'ada@example.com', 'Widget', 9.99, 2),
                    ('Ada Lovelace', 'ada@example.com', 'Gadget', 19.99, 1),
                    ('Grace Hopper', 'grace@example.com', 'Widget', 9.99, 5)
            """);
        }
        printFlatOrders(conn);

        System.out.println("\n--- The UPDATE ANOMALY: Ada's email changes ---");
        // Updating customer_email requires updating EVERY row mentioning Ada --
        // miss one, and the SAME customer now has TWO different emails on file,
        // an inconsistency the schema itself does nothing to prevent.
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE orders_flat SET customer_email = ? WHERE customer_name = ? AND order_id = 1")) {
            stmt.setString(1, "ada.lovelace@newdomain.com");
            stmt.setString(2, "Ada Lovelace");
            stmt.executeUpdate(); // deliberately updates ONLY order_id=1, "forgetting" order_id=2
        }
        System.out.println("(deliberately updated only ONE of Ada's two rows, simulating a missed update)");
        printFlatOrders(conn);
        System.out.println("Ada Lovelace now has TWO different emails on file -- the schema allowed this!");
    }

    static void printFlatOrders(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM orders_flat ORDER BY order_id")) {
            while (rs.next()) {
                System.out.printf("  order_id=%d, customer=%s, email=%s, product=%s, price=%s, qty=%d%n",
                        rs.getInt("order_id"), rs.getString("customer_name"), rs.getString("customer_email"),
                        rs.getString("product_name"), rs.getBigDecimal("product_price"), rs.getInt("quantity"));
            }
        }
    }

    static void demonstrateNormalized(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Each customer's email is stored in EXACTLY ONE place -- structurally
            // impossible for the same customer to have two conflicting emails.
            stmt.execute("""
                CREATE TABLE customers (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(100),
                    email VARCHAR(100)
                )
            """);
            stmt.execute("""
                CREATE TABLE products (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(100),
                    price DECIMAL(10,2)
                )
            """);
            stmt.execute("""
                CREATE TABLE orders (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    customer_id INT NOT NULL,
                    product_id INT NOT NULL,
                    quantity INT,
                    FOREIGN KEY (customer_id) REFERENCES customers(id),
                    FOREIGN KEY (product_id) REFERENCES products(id)
                )
            """);
        }

        int adaId = insertCustomer(conn, "Ada Lovelace", "ada@example.com");
        int graceId = insertCustomer(conn, "Grace Hopper", "grace@example.com");
        int widgetId = insertProduct(conn, "Widget", 9.99);
        int gadgetId = insertProduct(conn, "Gadget", 19.99);

        insertOrder(conn, adaId, widgetId, 2);
        insertOrder(conn, adaId, gadgetId, 1);
        insertOrder(conn, graceId, widgetId, 5);

        printNormalizedOrders(conn);

        System.out.println("\n--- Updating Ada's email now requires changing ONE row, in ONE table ---");
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE customers SET email = ? WHERE id = ?")) {
            stmt.setString(1, "ada.lovelace@newdomain.com");
            stmt.setInt(2, adaId);
            stmt.executeUpdate();
        }
        printNormalizedOrders(conn);
        System.out.println("Every one of Ada's orders now shows the SAME, correct, updated email --");
        System.out.println("the anomaly is impossible here, because the email is stored in only one place.");
    }

    static int insertCustomer(Connection conn, String name, String email) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO customers (name, email) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) { keys.next(); return keys.getInt(1); }
        }
    }

    static int insertProduct(Connection conn, String name, double price) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO products (name, price) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.executeUpdate();
            try (ResultSet keys = stmt.getGeneratedKeys()) { keys.next(); return keys.getInt(1); }
        }
    }

    static void insertOrder(Connection conn, int customerId, int productId, int quantity) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO orders (customer_id, product_id, quantity) VALUES (?, ?, ?)")) {
            stmt.setInt(1, customerId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
        }
    }

    static void printNormalizedOrders(Connection conn) throws SQLException {
        String sql = """
            SELECT o.id, c.name AS customer, c.email, p.name AS product, p.price, o.quantity
            FROM orders o
            JOIN customers c ON o.customer_id = c.id
            JOIN products p ON o.product_id = p.id
            ORDER BY o.id
        """;
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                System.out.printf("  order_id=%d, customer=%s, email=%s, product=%s, price=%s, qty=%d%n",
                        rs.getInt("id"), rs.getString("customer"), rs.getString("email"),
                        rs.getString("product"), rs.getBigDecimal("price"), rs.getInt("quantity"));
            }
        }
    }
}
