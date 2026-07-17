import com.sun.net.httpserver.HttpServer;
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
    static final Map<String, String> paymentsNonIdempotent = new ConcurrentHashMap<>();
    static final Map<String, String> paymentsIdempotent = new ConcurrentHashMap<>(); // keyed by idempotencyKey
    static final AtomicInteger nextId = new AtomicInteger(1);

    public static void main(String[] args) throws Exception {
        int port = 8199;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        // VIOLATION: server generates a new ID every call -- no dedup possible.
        server.createContext("/payments", exchange -> {
            String id = String.valueOf(nextId.getAndIncrement());
            paymentsNonIdempotent.put(id, "amount=100");
            respond(exchange, 201, "{\"id\":\"" + id + "\"}");
        });

        // FIX: client supplies an idempotencyKey; retrying the same key is a no-op.
        server.createContext("/payments-idempotent", exchange -> {
            String key = queryParam(exchange.getRequestURI().getQuery(), "idempotencyKey");
            paymentsIdempotent.putIfAbsent(key, "amount=100"); // only inserts if not already present
            respond(exchange, 200, "{\"idempotencyKey\":\"" + key + "\"}");
        });

        server.start();
        HttpClient client = HttpClient.newHttpClient();

        try {
            System.out.println("=== Violation: retrying an identical logical request creates duplicates ===");
            for (int i = 0; i < 2; i++) {
                post(client, port, "/payments");
            }
            System.out.println("Total payments created: " + paymentsNonIdempotent.size() + "  <- BUG: should be 1 logical payment, got " + paymentsNonIdempotent.size());

            System.out.println("\n=== Fixed: same idempotency key submitted 3 times ===");
            for (int i = 0; i < 3; i++) {
                post(client, port, "/payments-idempotent?idempotencyKey=abc-123");
            }
            System.out.println("Total payments for key 'abc-123': " + paymentsIdempotent.size());

            System.out.println("\n=== Fixed: two DIFFERENT idempotency keys ===");
            post(client, port, "/payments-idempotent?idempotencyKey=xyz-999");
            System.out.println("Total distinct payments now: " + paymentsIdempotent.size() + " (keys: " + paymentsIdempotent.keySet() + ")");
        } finally {
            server.stop(0);
        }
    }

    static void post(HttpClient client, int port, String path) throws Exception {
        HttpRequest req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                .POST(HttpRequest.BodyPublishers.noBody()).build();
        HttpResponse<String> resp = client.send(req, HttpResponse.BodyHandlers.ofString());
        System.out.println("  " + path + " -> " + resp.statusCode() + " " + resp.body());
    }

    static String queryParam(String query, String name) {
        for (String pair : query.split("&")) {
            String[] kv = pair.split("=", 2);
            if (kv[0].equals(name)) return kv[1];
        }
        return null;
    }

    static void respond(com.sun.net.httpserver.HttpExchange exchange, int status, String body) throws java.io.IOException {
        byte[] bytes = body.getBytes();
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
    }
}
