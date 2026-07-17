package com.example.orderservice.web;

import com.example.orderservice.client.InventoryClient;
import com.example.orderservice.client.ReservationResult;
import com.example.orderservice.dto.OrderResponse;
import com.example.orderservice.dto.PlaceOrderRequest;
import com.example.orderservice.model.Order;
import com.example.orderservice.model.OrderStatus;
import com.example.orderservice.repo.OrderRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@RestController
public class OrderController {

    private final InventoryClient inventoryClient;
    private final OrderRepository orderRepository;

    public OrderController(InventoryClient inventoryClient, OrderRepository orderRepository) {
        this.inventoryClient = inventoryClient;
        this.orderRepository = orderRepository;
    }

    @PostMapping("/orders")
    public ResponseEntity<?> placeOrder(@RequestBody PlaceOrderRequest request, Authentication authentication) {
        ReservationResult result = inventoryClient.reserve(request.sku(), request.quantity());

        if (result instanceof ReservationResult.Reserved) {
            Order order = new Order(authentication.getName(), request.sku(), request.quantity(),
                    OrderStatus.CONFIRMED, Instant.now());
            orderRepository.save(order);
            return ResponseEntity.status(201).body(OrderResponse.from(order));
        }

        if (result instanceof ReservationResult.OutOfStock outOfStock) {
            Order order = new Order(authentication.getName(), request.sku(), request.quantity(),
                    OrderStatus.REJECTED_OUT_OF_STOCK, Instant.now());
            orderRepository.save(order);
            return ResponseEntity.status(409).body(Map.of(
                    "error", "Insufficient stock",
                    "available", outOfStock.available(),
                    "order", OrderResponse.from(order)
            ));
        }

        // ServiceUnavailable: inventory-service is unreachable. This system deliberately
        // chooses CONSISTENCY over availability here (a CP choice, per the CAP theorem
        // demo in 20-Computer-Science-Fundamentals/04) -- it refuses to CONFIRM an order
        // it cannot verify against real stock, rather than optimistically accepting it.
        return ResponseEntity.status(503).body(Map.of(
                "error", "Inventory service unavailable -- cannot confirm order without verifying stock"
        ));
    }

    @GetMapping("/orders/{id}")
    public ResponseEntity<OrderResponse> getOrder(@PathVariable Long id) {
        return orderRepository.findById(id)
                .map(order -> ResponseEntity.ok(OrderResponse.from(order)))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/customers/{username}/orders")
    public List<OrderResponse> ordersForCustomer(@PathVariable String username) {
        return orderRepository.findByCustomerUsername(username).stream().map(OrderResponse::from).toList();
    }
}
