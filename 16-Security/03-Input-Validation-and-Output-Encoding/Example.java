// Example.java - Input Validation and Output Encoding: rendering user input
// directly into HTML lets an attacker inject a REAL, executable <script> tag
// (Cross-Site Scripting / XSS) into a page other users view. Demonstrated against
// a REAL embedded HTTP server -- the actual HTML response body is inspected to
// prove the injected script is literally present (violation) or safely neutralized
// into inert text (fix).

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class Example {

    // VIOLATION: the comment is embedded DIRECTLY into the HTML response, with
    // no encoding at all. If the comment contains HTML/script syntax, it becomes
    // part of the actual page markup -- not just displayed text.
    static String renderGuestbookVulnerable(String comment) {
        return "<html><body><h1>Guestbook</h1><p>Comment: " + comment + "</p></body></html>";
    }

    // FIX: HTML-encode the comment before embedding it. Characters with special
    // meaning in HTML (<, >, &, ", ') are converted to their harmless entity
    // equivalents, so they can ONLY ever render as literal, inert TEXT.
    static String htmlEncode(String input) {
        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    static String renderGuestbookSafe(String comment) {
        return "<html><body><h1>Guestbook</h1><p>Comment: " + htmlEncode(comment) + "</p></body></html>";
    }

    public static void main(String[] args) throws Exception {
        int port = 8095;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        server.createContext("/guestbook-vulnerable", exchange -> {
            String comment = queryParam(exchange, "comment");
            respond(exchange, renderGuestbookVulnerable(comment));
        });
        server.createContext("/guestbook-safe", exchange -> {
            String comment = queryParam(exchange, "comment");
            respond(exchange, renderGuestbookSafe(comment));
        });
        server.start();
        System.out.println("Server started on http://localhost:" + port);

        HttpClient client = HttpClient.newHttpClient();
        String attackerComment = "<script>alert('XSS')</script>";
        String encodedComment = URLEncoder.encode(attackerComment, StandardCharsets.UTF_8);

        try {
            System.out.println("\n=== Violation: attacker's <script> tag is embedded LITERALLY in the real HTML response ===");
            HttpResponse<String> vulnerable = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/guestbook-vulnerable?comment=" + encodedComment)).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  Real response body: " + vulnerable.body());
            System.out.println("  Contains a literal, executable <script> tag: " + vulnerable.body().contains("<script>alert('XSS')</script>") +
                    "  <- BUG: any real browser rendering this page would EXECUTE that script!");

            System.out.println("\n=== Fixed: the identical attacker input is HTML-encoded before rendering ===");
            HttpResponse<String> safe = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/guestbook-safe?comment=" + encodedComment)).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("  Real response body: " + safe.body());
            System.out.println("  Contains a literal, executable <script> tag: " + safe.body().contains("<script>alert('XSS')</script>") +
                    "  <- correct: the browser would render this as inert TEXT, not execute it");
        } finally {
            server.stop(0);
            System.out.println("\nServer stopped cleanly.");
        }
    }

    static String queryParam(com.sun.net.httpserver.HttpExchange exchange, String name) {
        String query = exchange.getRequestURI().getQuery();
        for (String pair : query.split("&")) {
            String[] kv = pair.split("=", 2);
            if (kv[0].equals(name)) {
                return java.net.URLDecoder.decode(kv[1], StandardCharsets.UTF_8);
            }
        }
        return "";
    }

    static void respond(com.sun.net.httpserver.HttpExchange exchange, String html) throws IOException {
        byte[] bytes = html.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "text/html; charset=utf-8");
        exchange.sendResponseHeaders(200, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
    }
}
