package com.example.orderservice.dto;

import com.example.orderservice.model.Order;

public record OrderResponse(Long id, String customerUsername, String sku, int quantity, String status, String createdAt) {
    public static OrderResponse from(Order order) {
        return new OrderResponse(
                order.getId(),
                order.getCustomerUsername(),
                order.getSku(),
                order.getQuantity(),
                order.getStatus().name(),
                order.getCreatedAt().toString()
        );
    }
}
