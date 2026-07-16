// Example.java - REST Design and Versioning: a breaking change to an API's response
// shape (renaming a field) breaks existing clients that were never updated to expect
// it. Demonstrated against a REAL embedded HTTP server and a real "old client" parser,
// then fixed by versioning the endpoint so old and new clients can coexist.

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class Example {

    static void respond(com.sun.net.httpserver.HttpExchange exchange, String json) throws IOException {
        byte[] bytes = json.getBytes();
        exchange.getResponseHeaders().set("Content-Type", "application/json");
        exchange.sendResponseHeaders(200, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
    }

    // A simple, real "old client" JSON field extractor -- deliberately naive
    // (string search, not a real Ndeserializer library), but it faithfully
    // reproduces what an old client compiled against the ORIGINAL field name
    // ("price") would actually do when parsing a real HTTP response body.
    static String extractField(String json, String fieldName) {
        String marker = "\"" + fieldName + "\":";
        int idx = json.indexOf(marker);
        if (idx == -1) return null; // field genuinely not present in the response
        int start = idx + marker.length();
        int end = json.indexOf(',', start);
        if (end == -1) end = json.indexOf('}', start);
        return json.substring(start, end).trim();
    }

    public static void main(String[] args) throws Exception {
        int port = 8097;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        // VIOLATION: the SAME, unversioned endpoint has its response shape
        // changed in place -- "price" is renamed to "unitPrice" with NO warning
        // and no alternate path preserving the old shape.
        server.createContext("/products/widget", exchange ->
                respond(exchange, "{\"name\":\"Widget\",\"unitPrice\":9.99}")); // BREAKING change, deployed in place

        // FIX: versioned endpoints. /v1/ keeps the ORIGINAL shape unchanged,
        // forever, for clients that already depend on it; /v2/ has the new shape.
        server.createContext("/v1/products/widget", exchange ->
                respond(exchange, "{\"name\":\"Widget\",\"price\":9.99}")); // unchanged, exactly as old clients expect
        server.createContext("/v2/products/widget", exchange ->
                respond(exchange, "{\"name\":\"Widget\",\"unitPrice\":9.99}")); // new shape, only for clients that ask for it

        server.start();
        HttpClient client = HttpClient.newHttpClient();
        System.out.println("Server started on http://localhost:" + port);

        try {
            System.out.println("\n=== Violation: an unversioned breaking change silently breaks an old client ===");
            HttpResponse<String> unversioned = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/products/widget")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  Server response: " + unversioned.body());
            String oldClientPrice = extractField(unversioned.body(), "price"); // the OLD client still looks for "price"
            System.out.println("  Old client (still looking for \"price\"): " + oldClientPrice +
                    "  <- BUG: null! The field was renamed to \"unitPrice\" with no warning.");

            System.out.println("\n=== Fixed: versioned endpoints let old and new clients coexist ===");
            HttpResponse<String> v1 = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/v1/products/widget")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  /v1/ response: " + v1.body());
            System.out.println("  Old client (still looking for \"price\"): " + extractField(v1.body(), "price") +
                    "  <- correct: /v1/ was never changed, so old clients keep working");

            HttpResponse<String> v2 = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/v2/products/widget")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  /v2/ response: " + v2.body());
            System.out.println("  New client (looking for \"unitPrice\"): " + extractField(v2.body(), "unitPrice") +
                    "  <- correct: new clients opt into the new shape via /v2/");
        } finally {
            server.stop(0);
            System.out.println("\nServer stopped cleanly.");
        }
    }
}
