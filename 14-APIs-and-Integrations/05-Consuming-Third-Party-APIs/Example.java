// Example.java - Consuming Third-Party APIs: a third-party service can be slow or
// unresponsive at any time, for reasons entirely outside your control. Demonstrated
// against a REAL embedded HTTP server that deliberately responds slowly, with REAL,
// measured elapsed times showing the difference between a client with no timeout and
// one with a properly configured timeout.

import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.time.Duration;

public class Example {

    public static void main(String[] args) throws Exception {
        int port = 8096;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        // Simulates a REAL third-party API that is slow to respond -- exactly the
        // kind of thing that happens in production for reasons outside your control
        // (their database is overloaded, a network issue, a deploy in progress).
        server.createContext("/slow-third-party-api", exchange -> {
            try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
            byte[] body = "{\"status\":\"ok\"}".getBytes();
            exchange.sendResponseHeaders(200, body.length);
            try (var os = exchange.getResponseBody()) { os.write(body); }
        });
        server.start();
        System.out.println("Slow third-party API simulator started on http://localhost:" + port + " (responds after 3 seconds)");

        try {
            System.out.println("\n=== Violation: no request timeout configured ===");
            HttpClient noTimeoutClient = HttpClient.newHttpClient(); // no per-request timeout set
            long start = System.currentTimeMillis();
            HttpResponse<String> response = noTimeoutClient.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/slow-third-party-api")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            long elapsed = System.currentTimeMillis() - start;
            System.out.println("  Request completed after " + elapsed + " ms: " + response.body());
            System.out.println("  BUG (in principle): with NO timeout, this call would have waited INDEFINITELY" +
                    " if the third-party API had simply never responded at all, instead of just being slow --" +
                    " tying up a thread/connection for as long as the third party chooses.");

            System.out.println("\n=== Fixed: a properly configured request timeout ===");
            HttpClient timeoutClient = HttpClient.newBuilder().build();
            long start2 = System.currentTimeMillis();
            try {
                timeoutClient.send(
                        HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/slow-third-party-api"))
                                .timeout(Duration.ofSeconds(1)) // explicit, real timeout
                                .GET().build(),
                        HttpResponse.BodyHandlers.ofString());
                System.out.println("  (should not reach here)");
            } catch (HttpTimeoutException e) {
                long elapsed2 = System.currentTimeMillis() - start2;
                System.out.println("  Request FAILED FAST after " + elapsed2 + " ms (timeout was set to 1000ms): " + e.getMessage());
                System.out.println("  Correct: the call gave up well before the 3-second delay, freeing the calling" +
                        " thread to retry, fall back, or fail gracefully instead of hanging indefinitely.");
            }
        } finally {
            server.stop(0);
            System.out.println("\nServer stopped cleanly.");
        }
    }
}
