// Example.kt - HTTP requests via java.net.http.HttpClient (built into the JDK since 11,
// used directly from Kotlin since it runs on the JVM), plus Gson (Lesson 10) for JSON.
// Like every other HTTP client covered in this repository (fetch, HttpClient, net/http,
// ureq being the one exception), Kotlin/Java's HttpClient does NOT throw on 404/500 --
// verified live below.

import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import com.google.gson.Gson

data class Todo(val userId: Int, val id: Int, val title: String, val completed: Boolean)

fun main() {
    val client = HttpClient.newHttpClient()
    val gson = Gson()

    println("--- GET ---")
    val getRequest = HttpRequest.newBuilder()
        .uri(URI.create("https://jsonplaceholder.typicode.com/todos/1"))
        .GET()
        .build()
    val getResponse = client.send(getRequest, HttpResponse.BodyHandlers.ofString())
    println("status: ${getResponse.statusCode()}")
    val todo = gson.fromJson(getResponse.body(), Todo::class.java)
    println("Decoded: id=${todo.id}, userId=${todo.userId}, title=${todo.title}, completed=${todo.completed}")

    println("\n--- GET a route that returns 404 -- NO exception thrown ---")
    val notFoundRequest = HttpRequest.newBuilder()
        .uri(URI.create("https://jsonplaceholder.typicode.com/todos/99999999"))
        .GET()
        .build()
    val notFoundResponse = client.send(notFoundRequest, HttpResponse.BodyHandlers.ofString())
    println("status: ${notFoundResponse.statusCode()} (a normal response, not a thrown exception -- verified live)")
    println("body: ${notFoundResponse.body()}")

    println("\n--- POST with a JSON body ---")
    val payload = gson.toJson(mapOf("title" to "Learn Kotlin HttpClient", "completed" to false, "userId" to 1))
    val postRequest = HttpRequest.newBuilder()
        .uri(URI.create("https://jsonplaceholder.typicode.com/todos"))
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(payload))
        .build()
    val postResponse = client.send(postRequest, HttpResponse.BodyHandlers.ofString())
    println("status: ${postResponse.statusCode()}")
    println("body (echoed back with a fake id): ${postResponse.body()}")
}
