package com.example.orderservice.client;

public sealed interface ReservationResult {
    record Reserved() implements ReservationResult {}
    record OutOfStock(int available) implements ReservationResult {}
    record ServiceUnavailable(String reason) implements ReservationResult {}
}
