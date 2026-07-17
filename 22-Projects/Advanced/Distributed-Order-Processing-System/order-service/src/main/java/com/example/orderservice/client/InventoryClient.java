package com.example.orderservice.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;

import java.util.Map;

/**
 * Talks to the separate inventory-service over real HTTP. This is the seam where
 * "distributed" stops being a diagram and becomes a real, fallible network call:
 * inventory-service can be slow, return 409 (legitimately out of stock), or be
 * completely unreachable (a real network partition) -- each case is handled
 * distinctly rather than collapsed into one generic error.
 */
@Component
public class InventoryClient {

    private final RestClient restClient;
    private final String apiKey;

    public InventoryClient(@Value("${inventory.base-url}") String baseUrl,
                            @Value("${inventory.api-key}") String apiKey) {
        this.restClient = RestClient.builder().baseUrl(baseUrl).build();
        this.apiKey = apiKey;
    }

    public ReservationResult reserve(String sku, int quantity) {
        try {
            restClient.post()
                    .uri("/products/{sku}/reserve", sku)
                    .header("X-Internal-Api-Key", apiKey)
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(Map.of("quantity", quantity))
                    .retrieve()
                    .toBodilessEntity();
            return new ReservationResult.Reserved();
        } catch (HttpClientErrorException.Conflict e) {
            int available = extractAvailable(e);
            return new ReservationResult.OutOfStock(available);
        } catch (ResourceAccessException e) {
            // connection refused/timeout -- inventory-service is unreachable: a real partition
            return new ReservationResult.ServiceUnavailable(e.getMessage());
        }
    }

    public void release(String sku, int quantity) {
        try {
            restClient.post()
                    .uri("/products/{sku}/release", sku)
                    .header("X-Internal-Api-Key", apiKey)
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(Map.of("quantity", quantity))
                    .retrieve()
                    .toBodilessEntity();
        } catch (Exception ignored) {
            // best-effort compensation; a production system would queue this for retry
        }
    }

    @SuppressWarnings("unchecked")
    private int extractAvailable(HttpClientErrorException.Conflict e) {
        try {
            Map<String, Object> body = e.getResponseBodyAs(Map.class);
            return (int) body.get("available");
        } catch (Exception ex) {
            return -1;
        }
    }
}
