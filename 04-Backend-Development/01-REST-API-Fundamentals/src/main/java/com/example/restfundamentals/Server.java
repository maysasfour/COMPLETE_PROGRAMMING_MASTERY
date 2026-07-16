package com.example.restfundamentals;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * A REST API built with ONLY the JDK's built-in com.sun.net.httpserver --
 * no framework at all -- so the raw mechanics (methods, status codes, headers,
 * statelessness) are visible before Spring Boot abstracts them away in Lesson 02.
 *
 * Demonstrates the four REST fundamentals every framework builds on top of:
 *   1. Resources are identified by URIs      (/tasks, /tasks/3)
 *   2. HTTP methods map to CRUD operations   (GET, POST, PUT, DELETE)
 *   3. Status codes communicate outcome      (200, 201, 404, 400)
 *   4. Requests are stateless                (no server-side session -- every
 *      request carries everything needed to understand it)
 */
public class Server {
    private final Map<Integer, String> tasks = new ConcurrentHashMap<>();
    private final AtomicInteger nextId = new AtomicInteger(1);

    public static void main(String[] args) throws IOException {
        int port = args.length > 0 ? Integer.parseInt(args[0]) : 8080;
        new Server().start(port);
    }

    public void start(int port) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/tasks", this::handleTasks);
        server.setExecutor(null); // default executor
        server.start();
        System.out.println("REST fundamentals server listening on port " + port);
    }

    private void handleTasks(HttpExchange exchange) throws IOException {
        String method = exchange.getRequestMethod();
        String path = exchange.getRequestURI().getPath(); // e.g. "/tasks" or "/tasks/3"
        String[] segments = path.split("/");
        Integer id = segments.length > 2 ? parseIdOrNull(segments[2]) : null;

        switch (method) {
            case "GET" -> {
                if (id == null) {
                    respond(exchange, 200, tasks.toString()); // list ALL tasks
                } else if (tasks.containsKey(id)) {
                    respond(exchange, 200, tasks.get(id)); // 200 OK -- resource found
                } else {
                    respond(exchange, 404, "task " + id + " not found"); // 404 -- resource doesn't exist
                }
            }
            case "POST" -> {
                String body = readBody(exchange);
                if (body.isBlank()) {
                    respond(exchange, 400, "task title cannot be empty"); // 400 -- malformed request
                    return;
                }
                int newId = nextId.getAndIncrement();
                tasks.put(newId, body);
                respond(exchange, 201, "created task " + newId); // 201 Created -- a NEW resource
            }
            case "PUT" -> {
                if (id == null || !tasks.containsKey(id)) {
                    respond(exchange, 404, "task " + id + " not found");
                    return;
                }
                tasks.put(id, readBody(exchange));
                respond(exchange, 200, "updated task " + id); // 200 -- existing resource updated
            }
            case "DELETE" -> {
                if (id == null || tasks.remove(id) == null) {
                    respond(exchange, 404, "task " + id + " not found");
                    return;
                }
                respond(exchange, 204, ""); // 204 No Content -- success, nothing to return
            }
            default -> respond(exchange, 405, "method not allowed"); // 405 -- verb not supported here
        }
    }

    private Integer parseIdOrNull(String s) {
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String readBody(HttpExchange exchange) throws IOException {
        return new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8);
    }

    private void respond(HttpExchange exchange, int statusCode, String body) throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=utf-8");
        exchange.sendResponseHeaders(statusCode, bytes.length == 0 ? -1 : bytes.length);
        if (bytes.length > 0) {
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(bytes);
            }
        }
    }
}
