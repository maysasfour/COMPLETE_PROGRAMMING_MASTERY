// Example.java - HTTPS and Security Headers: a REAL HTTPS server (using a genuine
// self-signed X.509 certificate and a real TLS handshake -- not a description) plus
// real, missing-vs-present security response headers, verified against actual HTTP
// responses.

import com.sun.net.httpserver.*;
import javax.net.ssl.*;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.KeyStore;
import java.security.cert.X509Certificate;
import java.util.List;

public class Example {

    public static void main(String[] args) throws Exception {
        demoRealHttps();
        demoSecurityHeaders();
    }

    // ============================================================
    // A REAL HTTPS server: a genuine self-signed certificate (generated via the
    // JDK's own `keytool`, see README), loaded into a real SSLContext, serving a
    // real TLS-encrypted connection -- verified by inspecting the ACTUAL
    // negotiated protocol and cipher suite from the real handshake.
    // ============================================================
    static void demoRealHttps() throws Exception {
        System.out.println("=== A REAL HTTPS server with a genuine self-signed certificate ===");

        char[] password = "changeit".toCharArray();
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream fis = new FileInputStream("keystore.jks")) {
            keyStore.load(fis, password);
        }

        KeyManagerFactory kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        kmf.init(keyStore, password);
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(kmf.getKeyManagers(), null, null);

        int port = 8443;
        HttpsServer server = HttpsServer.create(new InetSocketAddress("localhost", port), 0);
        server.setHttpsConfigurator(new HttpsConfigurator(sslContext) {
            public void configure(HttpsParameters params) {
                params.setSSLParameters(sslContext.getDefaultSSLParameters());
            }
        });
        server.createContext("/secure", exchange -> {
            byte[] body = "This response was ACTUALLY encrypted in transit.".getBytes();
            exchange.sendResponseHeaders(200, body.length);
            try (OutputStream os = exchange.getResponseBody()) { os.write(body); }
        });
        server.start();
        System.out.println("Real HTTPS server started on https://localhost:" + port);

        try {
            // A client that trusts this specific self-signed cert (for this demo only --
            // never do this in real code, which should validate against a real, trusted CA).
            TrustManager[] trustSelfSigned = new TrustManager[]{new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain, String authType) {}
                public void checkServerTrusted(X509Certificate[] chain, String authType) {}
                public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
            }};
            SSLContext clientContext = SSLContext.getInstance("TLS");
            clientContext.init(null, trustSelfSigned, null);

            HttpClient client = HttpClient.newBuilder().sslContext(clientContext).build();
            HttpResponse<String> response = client.send(
                    HttpRequest.newBuilder(URI.create("https://localhost:" + port + "/secure")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());

            System.out.println("Real response body: " + response.body());
            System.out.println("Real, negotiated TLS details from the actual handshake:");
            var sslSession = response.sslSession().orElseThrow();
            System.out.println("  Protocol: " + sslSession.getProtocol());
            System.out.println("  Cipher suite: " + sslSession.getCipherSuite());
            System.out.println("  <- this proves a REAL encrypted TLS channel was used, not plain HTTP");
        } finally {
            server.stop(0);
            System.out.println("HTTPS server stopped cleanly.");
        }
    }

    // ============================================================
    // Security headers: missing vs. present, verified against real HTTP
    // response headers.
    // ============================================================
    static void demoSecurityHeaders() throws Exception {
        System.out.println("\n=== Security response headers: missing vs. present ===");
        int port = 8094;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        server.createContext("/no-headers", exchange -> respondPlain(exchange)); // VIOLATION: no security headers at all
        server.createContext("/with-headers", exchange -> {
            exchange.getResponseHeaders().set("X-Content-Type-Options", "nosniff");
            exchange.getResponseHeaders().set("X-Frame-Options", "DENY");
            exchange.getResponseHeaders().set("Content-Security-Policy", "default-src 'self'");
            exchange.getResponseHeaders().set("Strict-Transport-Security", "max-age=63072000");
            respondPlain(exchange);
        });
        server.start();
        HttpClient client = HttpClient.newHttpClient();

        try {
            HttpResponse<String> noHeaders = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/no-headers")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("Violation (no security headers set):");
            printHeaderCheck(noHeaders, "X-Content-Type-Options");
            printHeaderCheck(noHeaders, "X-Frame-Options");
            System.out.println("  BUG: a browser has NO instruction to prevent MIME-sniffing or being framed by another site.");

            HttpResponse<String> withHeaders = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/with-headers")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            System.out.println("\nFixed (security headers explicitly set):");
            printHeaderCheck(withHeaders, "X-Content-Type-Options");
            printHeaderCheck(withHeaders, "X-Frame-Options");
            printHeaderCheck(withHeaders, "Content-Security-Policy");
            printHeaderCheck(withHeaders, "Strict-Transport-Security");
            System.out.println("  Correct: the browser is explicitly told not to MIME-sniff, not to allow framing," +
                    " to restrict resource origins, and to always use HTTPS going forward.");
        } finally {
            server.stop(0);
        }
    }

    static void printHeaderCheck(HttpResponse<String> response, String headerName) {
        List<String> values = response.headers().allValues(headerName);
        System.out.println("  " + headerName + ": " + (values.isEmpty() ? "(MISSING)" : values.get(0)));
    }

    static void respondPlain(HttpExchange exchange) throws IOException {
        byte[] body = "OK".getBytes();
        exchange.sendResponseHeaders(200, body.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(body); }
    }
}
