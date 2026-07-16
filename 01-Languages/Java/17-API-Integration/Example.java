// Example.java - java.net.http.HttpClient (built into the JDK since Java 11), GET/POST, the 404 trap.
// JSON parsing here is deliberately minimal/manual (a couple of regex extractions) since the JDK has
// no built-in JSON library (Lesson 10) -- a real project would use Jackson/Gson instead.

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Example {
    static String extractStringField(String json, String field) {
        Matcher m = Pattern.compile("\"" + field + "\"\\s*:\\s*\"([^\"]*)\"").matcher(json);
        return m.find() ? m.group(1) : null;
    }

    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();

        System.out.println("--- GET https://jsonplaceholder.typicode.com/todos/1 ---");
        HttpRequest getRequest = HttpRequest.newBuilder()
            .uri(URI.create("https://jsonplaceholder.typicode.com/todos/1"))
            .GET()
            .build();
        HttpResponse<String> getResponse = client.send(getRequest, HttpResponse.BodyHandlers.ofString());
        System.out.println("status: " + getResponse.statusCode());
        String title = extractStringField(getResponse.body(), "title");
        System.out.println("Extracted title field: " + title);

        System.out.println("\n--- GET a route that returns 404 ---");
        HttpRequest notFoundRequest = HttpRequest.newBuilder()
            .uri(URI.create("https://jsonplaceholder.typicode.com/todos/99999999"))
            .GET()
            .build();
        HttpResponse<String> notFoundResponse = client.send(notFoundRequest, HttpResponse.BodyHandlers.ofString());
        System.out.println("status: " + notFoundResponse.statusCode());
        System.out.println("HttpClient does NOT throw on a 404 -- statusCode() must be checked manually.");

        System.out.println("\n--- POST with a JSON body ---");
        String jsonBody = "{\"title\":\"Learn HttpClient\",\"completed\":false,\"userId\":1}";
        HttpRequest postRequest = HttpRequest.newBuilder()
            .uri(URI.create("https://jsonplaceholder.typicode.com/todos"))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
            .build();
        HttpResponse<String> postResponse = client.send(postRequest, HttpResponse.BodyHandlers.ofString());
        System.out.println("status: " + postResponse.statusCode());
        System.out.println("Response body (echoed back with a fake id): " + postResponse.body());
    }
}
