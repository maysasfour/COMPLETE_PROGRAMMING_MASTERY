// Example.java - Microservices Fundamentals: each service owns its own state
// completely, exposed only through a well-defined API boundary -- never through
// direct, shared in-memory access. Demonstrated with a real overselling bug caused
// by directly manipulating another module's internal state (the monolith-with-no-
// boundaries anti-pattern), then a fix using a REAL HTTP API boundary between two
// genuinely separate services, verified with actual network requests.

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.concurrent.atomic.AtomicInteger;

public class Example {

    // ============================================================
    // VIOLATION: no service boundary at all. OrderModule reaches directly into
    // InventoryModule's public mutable field and subtracts from it -- nothing
    // stops it from taking more than is actually in stock.
    // ============================================================
    static class InventoryModuleViolation {
        public int stock = 5; // exposed directly -- no boundary, no validation
    }

    static class OrderModuleViolation {
        void placeOrder(InventoryModuleViolation inventory, int quantity) {
            inventory.stock -= quantity; // directly mutates ANOTHER module's internal state
        }
    }

    static void demoViolation() {
        System.out.println("=== Violation: no service boundary -- direct shared-state access ===");
        InventoryModuleViolation inventory = new InventoryModuleViolation();
        OrderModuleViolation orders = new OrderModuleViolation();
        System.out.println("  Starting stock: " + inventory.stock);
        orders.placeOrder(inventory, 10); // asks for MORE than is in stock
        System.out.println("  Stock after ordering 10 (only 5 existed): " + inventory.stock +
                "  <- BUG: NEGATIVE stock, nothing enforced a real boundary!");
    }

    // ============================================================
    // FIX: InventoryService is a genuinely separate service, with its OWN state,
    // reachable ONLY through a real HTTP API. The boundary itself enforces
    // validation that direct field access could never enforce.
    // ============================================================
    static HttpServer startInventoryService(int port, AtomicInteger stock) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);
        server.createContext("/reserve", exchange -> {
            String query = exchange.getRequestURI().getQuery(); // e.g. "qty=10"
            int qty = Integer.parseInt(query.substring(query.indexOf('=') + 1));

            String responseBody;
            int statusCode;
            synchronized (stock) {
                if (qty > stock.get()) {
                    statusCode = 409; // Conflict -- the API boundary REJECTS an invalid request
                    responseBody = "{\"error\":\"insufficient stock\",\"available\":" + stock.get() + "}";
                } else {
                    stock.addAndGet(-qty);
                    statusCode = 200;
                    responseBody = "{\"reserved\":" + qty + ",\"remaining\":" + stock.get() + "}";
                }
            }
            byte[] bytes = responseBody.getBytes();
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(statusCode, bytes.length);
            try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
        });
        server.start();
        return server;
    }

    static void demoFixed() throws Exception {
        System.out.println("\n=== Fixed: a REAL HTTP API boundary between two genuinely separate services ===");
        AtomicInteger stock = new AtomicInteger(5);
        int port = 8099;
        HttpServer inventoryService = startInventoryService(port, stock);
        System.out.println("  InventoryService started on http://localhost:" + port);

        HttpClient client = HttpClient.newHttpClient();
        try {
            // OrderService calls InventoryService over a REAL network request --
            // there is no way for it to touch InventoryService's internal state directly.
            HttpResponse<String> response = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/reserve?qty=10")).POST(HttpRequest.BodyPublishers.noBody()).build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  OrderService requests 10 units (only 5 exist) via a real HTTP call:");
            System.out.println("    HTTP " + response.statusCode() + " " + response.body() +
                    "  <- correct: the API boundary REJECTED the oversell attempt");

            HttpResponse<String> validResponse = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/reserve?qty=3")).POST(HttpRequest.BodyPublishers.noBody()).build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  OrderService requests 3 units (valid) via a real HTTP call:");
            System.out.println("    HTTP " + validResponse.statusCode() + " " + validResponse.body() + "  <- correct: accepted and stock decremented");
        } finally {
            inventoryService.stop(0);
            System.out.println("  InventoryService stopped cleanly.");
        }
    }

    public static void main(String[] args) throws Exception {
        demoViolation();
        demoFixed();
    }
}
