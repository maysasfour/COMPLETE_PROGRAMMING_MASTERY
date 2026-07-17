package com.example.solution05.core;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

// PUBLIC -- the ONLY path application code has into this package. It's in the
// SAME package as ProductRepository, so it CAN call it, but code outside this
// package (like Main) cannot reach ProductRepository directly at all.
public class ProductService {
    private final ProductRepository repository;
    public ProductService(Connection conn) { this.repository = new ProductRepository(conn); }

    public void addProduct(String name, double price) throws SQLException {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Product name must not be blank");
        }
        if (price <= 0) {
            throw new IllegalArgumentException("Product price must be positive, got: " + price);
        }
        repository.save(new Product(name, price));
    }

    public List<Product> listProducts() throws SQLException {
        return repository.findAll();
    }
}
