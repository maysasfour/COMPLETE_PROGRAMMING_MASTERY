package com.example.inventory.model;

import jakarta.persistence.*;

@Entity
@Table(name = "products")
public class Product {
    @Id
    private String sku;

    private String name;
    private int quantityAvailable;

    protected Product() {}

    public Product(String sku, String name, int quantityAvailable) {
        this.sku = sku;
        this.name = name;
        this.quantityAvailable = quantityAvailable;
    }

    public String getSku() { return sku; }
    public String getName() { return name; }
    public int getQuantityAvailable() { return quantityAvailable; }

    public boolean reserve(int quantity) {
        if (quantity > quantityAvailable) return false;
        quantityAvailable -= quantity;
        return true;
    }

    public void release(int quantity) {
        quantityAvailable += quantity;
    }
}
