package com.example.solution05.core;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// PACKAGE-PRIVATE (no "public" modifier) -- genuinely unreachable from outside
// this package. Application code in a different package (like Main) cannot
// call this class directly, even if it wanted to; it can only go through
// ProductService, which lives in this same package.
class ProductRepository {
    private final Connection conn;
    ProductRepository(Connection conn) { this.conn = conn; }

    void save(Product product) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO products (name, price) VALUES (?, ?)")) {
            stmt.setString(1, product.name);
            stmt.setDouble(2, product.price);
            stmt.executeUpdate();
        }
    }

    List<Product> findAll() throws SQLException {
        List<Product> results = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT name, price FROM products")) {
            while (rs.next()) {
                results.add(new Product(rs.getString("name"), rs.getDouble("price")));
            }
        }
        return results;
    }
}
