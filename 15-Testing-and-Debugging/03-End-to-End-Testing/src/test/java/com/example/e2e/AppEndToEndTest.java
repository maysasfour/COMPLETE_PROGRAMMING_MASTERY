package com.example.e2e;

import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import static org.junit.jupiter.api.Assertions.assertEquals;

// An END-TO-END test: starts the REAL, complete application (App.start()) on a
// REAL port, and drives it through REAL HTTP requests using a REAL HttpClient --
// exactly as an actual user/client of this app would. This is deliberately
// distinct from a unit test of a route handler in isolation: a handler can work
// PERFECTLY when called directly, and this test would still catch a real bug
// where that handler was simply never wired up at the URL clients actually use.
class AppEndToEndTest {

    static HttpServer server;
    static int port;
    static HttpClient client;

    @BeforeAll
    static void startRealApp() throws Exception {
        server = App.start(0); // port 0 -- let the OS assign a free, real port
        port = server.getAddress().getPort();
        client = HttpClient.newHttpClient();
    }

    @AfterAll
    static void stopRealApp() {
        server.stop(0);
    }

    @Test
    void healthEndpointRespondsOk() throws Exception {
        HttpResponse<String> response = client.send(
                HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/health")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, response.statusCode());
    }

    @Test
    void notesEndpointRespondsOk() throws Exception {
        // A real client hitting the URL the app is DOCUMENTED to expose: /notes
        HttpResponse<String> response = client.send(
                HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/notes")).GET().build(),
                HttpResponse.BodyHandlers.ofString());
        assertEquals(200, response.statusCode(), "GET /notes should respond 200, matching the app's documented API");
    }
}
