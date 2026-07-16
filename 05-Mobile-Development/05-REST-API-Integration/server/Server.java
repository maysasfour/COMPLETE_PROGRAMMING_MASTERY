import com.sun.net.httpserver.HttpServer;
import java.io.OutputStream;
import java.net.InetSocketAddress;

/**
 * A REAL HTTP server, run on the HOST machine, that the Android app (running
 * in the emulator) genuinely calls over the network -- using the emulator's
 * well-known special alias "10.0.2.2", which routes to the host machine's own
 * localhost. This is the same JDK HttpServer pattern used throughout this
 * repository (see 13-Software-Architecture, 14-APIs-and-Integrations).
 */
public class Server {
    public static void main(String[] args) throws Exception {
        int port = 8090;
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", port), 0);
        server.createContext("/api/greeting", exchange -> {
            String body = "{\"message\":\"Hello from the REAL host server!\"}";
            byte[] bytes = body.getBytes();
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, bytes.length);
            try (OutputStream os = exchange.getResponseBody()) { os.write(bytes); }
            System.out.println("Served /api/greeting to " + exchange.getRemoteAddress());
        });
        server.start();
        System.out.println("Server listening on http://0.0.0.0:" + port +
                " (reachable from the Android emulator as http://10.0.2.2:" + port + ")");
    }
}
