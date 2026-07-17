package com.example.inventory.dto;

import com.example.inventory.model.Product;

public record ProductResponse(String sku, String name, int quantityAvailable) {
    public static ProductResponse from(Product product) {
        return new ProductResponse(product.getSku(), product.getName(), product.getQuantityAvailable());
    }
}
