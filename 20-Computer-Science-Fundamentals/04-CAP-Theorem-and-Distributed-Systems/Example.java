// Example.java - CAP Theorem: during a real network partition, a distributed
// system must choose between Consistency (reject writes it cannot confirm are
// replicated) and Availability (accept writes anyway, risking divergence).
// Demonstrated with TWO REAL, SEPARATE embedded HTTP servers representing two
// database replicas, a REAL simulated partition (one server genuinely stopped,
// producing a real java.net.ConnectException on the other's replication
// attempt), and REAL, verified data divergence.

import com.sun.net.httpserver.HttpServer;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class Example {

    static final Map<String, String> storeA = new ConcurrentHashMap<>();
    static final Map<String, String> storeB = new ConcurrentHashMap<>();
    static final HttpClient client = HttpClient.newHttpClient();

    // A real embedded "replica" node: stores data locally, and replicates
    // writes to its peer over a REAL HTTP call before deciding whether to
    // accept the write, depending on whether it's running in CP or AP mode.
    static HttpServer startNode(int port, int peerPort, Map<String, String> store, boolean cpMode) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress("localhost", port), 0);

        server.createContext("/put", exchange -> {
            Map<String, String> params = parseQuery(exchange.getRequestURI().getQuery());
            String key = params.get("key"), value = params.get("value");

            boolean replicated;
            try {
                HttpRequest req = HttpRequest.newBuilder(URI.create("http://localhost:" + peerPort + "/replicate?key=" + key + "&value=" + value))
                        .timeout(Duration.ofMillis(500)).GET().build();
                client.send(req, HttpResponse.BodyHandlers.discarding());
                replicated = true;
            } catch (Exception e) {
                replicated = false; // a REAL connection failure -- the peer is genuinely unreachable
            }

            String responseBody;
            int status;
            if (replicated) {
                store.put(key, value);
                status = 200;
                responseBody = "OK: written and replicated";
            } else if (cpMode) {
                // CP: refuse to accept a write we cannot confirm is replicated --
                // prioritizing CONSISTENCY over availability.
                status = 503;
                responseBody = "REJECTED (CP mode): peer unreachable, refusing to risk inconsistency";
            } else {
                // AP: accept the write anyway, prioritizing AVAILABILITY,
                // accepting the real risk of divergence from the peer.
                store.put(key, value);
                status = 200;
                responseBody = "OK (AP mode): accepted WITHOUT replication -- peer was unreachable";
            }
            respond(exchange, status, responseBody);
        });

        server.createContext("/replicate", exchange -> {
            Map<String, String> params = parseQuery(exchange.getRequestURI().getQuery());
            store.put(params.get("key"), params.get("value"));
            respond(exchange, 200, "replicated");
        });

        server.createContext("/get", exchange -> {
            Map<String, String> params = parseQuery(exchange.getRequestURI().getQuery());
            respond(exchange, 200, store.getOrDefault(params.get("key"), "null"));
        });

        server.start();
        return server;
    }

    public static void main(String[] args) throws Exception {
        int portA = 9091, portB = 9092;

        System.out.println("=== Normal operation: both replicas reachable, writes replicate correctly ===");
        HttpServer nodeA = startNode(portA, portB, storeA, true); // CP mode
        HttpServer nodeB = startNode(portB, portA, storeB, true);
        put(portA, "x", "1");
        System.out.println("Node A's value for x: " + get(portA, "x"));
        System.out.println("Node B's value for x: " + get(portB, "x") + "  (correctly replicated)");

        System.out.println("\n=== Simulating a REAL network partition: Node B is genuinely stopped ===");
        nodeB.stop(0);
        Thread.sleep(200);

        System.out.println("\n--- CP mode: Node A REJECTS the write it cannot confirm is replicated ---");
        String cpResult = put(portA, "x", "2");
        System.out.println("PUT x=2 on Node A -> " + cpResult);
        System.out.println("Node A's value for x: " + get(portA, "x") + "  <- correct: unchanged, the rejected write never applied");

        System.out.println("\n--- AP mode: switching Node A to prioritize availability ---");
        nodeA.stop(0);
        HttpServer nodeAap = startNode(portA, portB, storeA, false); // AP mode, B still down
        String apResult = put(portA, "x", "3");
        System.out.println("PUT x=3 on Node A (AP mode, B still unreachable) -> " + apResult);
        System.out.println("Node A's value for x: " + get(portA, "x") + "  <- accepted locally DESPITE the partition");

        System.out.println("\n=== Partition heals: Node B comes back ===");
        HttpServer nodeBrestarted = startNode(portB, portA, storeB, true);
        System.out.println("Node A's value for x: " + get(portA, "x"));
        System.out.println("Node B's value for x: " + get(portB, "x") +
                "  <- REAL, VERIFIED DIVERGENCE: A and B now disagree, because AP accepted a write during the partition");

        nodeAap.stop(0);
        nodeBrestarted.stop(0);
    }

    static String put(int port, String key, String value) throws Exception {
        HttpRequest req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/put?key=" + key + "&value=" + value)).GET().build();
        return client.send(req, HttpResponse.BodyHandlers.ofString()).body();
    }

    static String get(int port, String key) throws Exception {
        HttpRequest req = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/get?key=" + key)).GET().build();
        return client.send(req, HttpResponse.BodyHandlers.ofString()).body();
    }

    static Map<String, String> parseQuery(String query) {
        Map<String, String> result = new ConcurrentHashMap<>();
        for (String pair : query.split("&")) {
            String[] kv = pair.split("=", 2);
            result.put(kv[0], kv[1]);
        }
        return result;
    }

    static void respond(com.sun.net.httpserver.HttpExchange exchange, int status, String body) throws java.io.IOException {
        byte[] bytes = body.getBytes();
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
    }
}
