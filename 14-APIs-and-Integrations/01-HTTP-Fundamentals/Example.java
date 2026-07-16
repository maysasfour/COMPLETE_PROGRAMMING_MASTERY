// Example.java - HTTP Fundamentals: idempotency. An idempotent request can be
// safely retried (e.g., after a client times out not knowing if the first attempt
// succeeded) without changing the outcome beyond the first successful call. This is
// demonstrated against a REAL embedded HTTP server, with real requests -- not simulated.

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class Example {

    static HttpServer startServer(int port, Map<String, String> orders, AtomicInteger nextId) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        // NON-IDEMPOTENT: every POST creates a brand-new order with a new, server-assigned ID.
        // If a client retries this request (e.g., after a network timeout where it never
        // saw the response), a SECOND, duplicate order is created -- there's no way to tell
        // the server "this is the SAME request as before."
        server.createContext("/orders", exchange -> {
            if (!"POST".equals(exchange.getRequestMethod())) { exchange.sendResponseHeaders(405, -1); return; }
            String id = String.valueOf(nextId.getAndIncrement());
            orders.put(id, "pizza order");
            respond(exchange, 201, "{\"id\":\"" + id + "\"}");
        });

        // IDEMPOTENT: PUT with a CLIENT-SUPPLIED id. Retrying the exact same request
        // any number of times produces the exact same end state -- one order, that id.
        server.createContext("/orders-idempotent/", exchange -> {
            if (!"PUT".equals(exchange.getRequestMethod())) { exchange.sendResponseHeaders(405, -1); return; }
            String path = exchange.getRequestURI().getPath();
            String id = path.substring(path.lastIndexOf('/') + 1);
            orders.put(id, "pizza order"); // overwrites -- same id, same result, however many times this runs
            respond(exchange, 200, "{\"id\":\"" + id + "\"}");
        });

        server.start();
        return server;
    }

    static void respond(com.sun.net.httpserver.HttpExchange exchange, int status, String body) throws IOException {
        byte[] bytes = body.getBytes();
        exchange.getResponseHeaders().set("Content-Type", "application/json");
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
    }

    public static void main(String[] args) throws Exception {
        Map<String, String> orders = new ConcurrentHashMap<>();
        AtomicInteger nextId = new AtomicInteger(1);
        int port = 8098;
        HttpServer server = startServer(port, orders, nextId);
        HttpClient client = HttpClient.newHttpClient();
        System.out.println("Server started on http://localhost:" + port);

        try {
            System.out.println("\n=== Non-idempotent POST: retrying creates DUPLICATE orders ===");
            System.out.println("Simulating a client that retries the SAME logical request twice (e.g., after a timeout):");
            for (int i = 0; i < 2; i++) {
                HttpResponse<String> response = client.send(
                        HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/orders"))
                                .POST(HttpRequest.BodyPublishers.noBody()).build(),
                        HttpResponse.BodyHandlers.ofString());
                System.out.println("  POST /orders -> " + response.statusCode() + " " + response.body());
            }
            System.out.println("  Total orders actually created: " + orders.size() +
                    "  <- BUG: retrying the SAME logical request created 2 SEPARATE orders!");

            orders.clear();
            System.out.println("\n=== Idempotent PUT: retrying is safe ===");
            System.out.println("Simulating the SAME retry scenario, but with a client-supplied id and PUT:");
            for (int i = 0; i < 2; i++) {
                HttpResponse<String> response = client.send(
                        HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/orders-idempotent/order-42"))
                                .PUT(HttpRequest.BodyPublishers.noBody()).build(),
                        HttpResponse.BodyHandlers.ofString());
                System.out.println("  PUT /orders-idempotent/order-42 -> " + response.statusCode() + " " + response.body());
            }
            System.out.println("  Total orders actually created: " + orders.size() +
                    "  <- correct: retrying the identical request left exactly ONE order");
        } finally {
            server.stop(0);
            System.out.println("\nServer stopped cleanly.");
        }
    }
}
