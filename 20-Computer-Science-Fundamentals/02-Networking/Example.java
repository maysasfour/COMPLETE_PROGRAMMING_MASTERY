// Example.java - Networking fundamentals: DNS resolution (a real hostname to a
// real IP address), and proof that HTTP is genuinely "just text over TCP" --
// by manually crafting a raw HTTP request over a raw Socket, with no HTTP
// library involved at all, and getting a real, correct response back from a
// real HttpServer.

import com.sun.net.httpserver.HttpServer;
import java.io.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.UnknownHostException;

public class Example {

    public static void main(String[] args) throws Exception {
        demoDnsResolution();
        demoRawTcpHttp();
    }

    // ============================================================
    // DNS: resolving a real hostname to a real IP address.
    // ============================================================
    static void demoDnsResolution() {
        System.out.println("=== DNS: resolving a real hostname to a real IP address ===");
        try {
            InetAddress address = InetAddress.getByName("localhost");
            System.out.println("localhost resolves to: " + address.getHostAddress());
        } catch (UnknownHostException e) {
            System.out.println("DNS resolution failed: " + e.getMessage());
        }
        try {
            InetAddress[] addresses = InetAddress.getAllByName("dns.google");
            System.out.println("dns.google resolves to " + addresses.length + " real address(es):");
            for (InetAddress a : addresses) System.out.println("  " + a.getHostAddress());
        } catch (UnknownHostException e) {
            System.out.println("Real DNS lookup for dns.google failed (no network access in this environment): " + e.getMessage());
        }
    }

    // ============================================================
    // HTTP is genuinely "just text over TCP" -- proven by manually writing
    // a raw HTTP request over a raw Socket, no HTTP library involved, and
    // getting back a real, correctly-parsed HTTP response.
    // ============================================================
    static void demoRawTcpHttp() throws IOException {
        System.out.println("\n=== Proving HTTP is genuinely just text sent over a raw TCP socket ===");
        int port = 8099;
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);
        server.createContext("/hello", exchange -> {
            byte[] body = "Hello from a real server!".getBytes();
            exchange.sendResponseHeaders(200, body.length);
            try (OutputStream os = exchange.getResponseBody()) { os.write(body); }
        });
        server.start();
        System.out.println("Real HTTP server started on port " + port);

        try (Socket socket = new Socket("localhost", port)) {
            // Manually writing the raw bytes of an HTTP request -- literally
            // just a specifically-formatted piece of TEXT, nothing more.
            String rawRequest = "GET /hello HTTP/1.1\r\n" +
                    "Host: localhost\r\n" +
                    "Connection: close\r\n" +
                    "\r\n";
            System.out.println("Raw bytes being written directly to the TCP socket:");
            System.out.println("---");
            System.out.print(rawRequest);
            System.out.println("---");

            OutputStream out = socket.getOutputStream();
            out.write(rawRequest.getBytes());
            out.flush();

            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            StringBuilder rawResponse = new StringBuilder();
            String line;
            while ((line = in.readLine()) != null) {
                rawResponse.append(line).append("\n");
            }
            System.out.println("Raw bytes received back over the SAME plain TCP socket:");
            System.out.println("---");
            System.out.println(rawResponse);
            System.out.println("---");
            System.out.println("This response was produced with ZERO HTTP client library -- just a Socket" +
                    " and manually-written text, proving HTTP really is just a text protocol over TCP.");
        } finally {
            server.stop(0);
        }
    }
}
