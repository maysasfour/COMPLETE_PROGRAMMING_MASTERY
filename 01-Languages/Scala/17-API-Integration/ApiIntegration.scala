// 17 - API Integration
// java.net.http.HttpClient (Java 11+) against a real public REST API -- Scala has no
// HTTP client of its own, exactly like its database and file-I/O gaps in Lessons 10/16.

import java.net.URI
import java.net.http.{HttpClient, HttpRequest, HttpResponse}
import java.time.Duration

val client: HttpClient = HttpClient.newBuilder()
  .connectTimeout(Duration.ofSeconds(10))
  .build()

def get(url: String): HttpResponse[String] =
  val request = HttpRequest.newBuilder()
    .uri(URI.create(url))
    .GET()
    .timeout(Duration.ofSeconds(10))
    .build()
  client.send(request, HttpResponse.BodyHandlers.ofString())

def post(url: String, jsonBody: String): HttpResponse[String] =
  val request = HttpRequest.newBuilder()
    .uri(URI.create(url))
    .header("Content-Type", "application/json")
    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
    .timeout(Duration.ofSeconds(10))
    .build()
  client.send(request, HttpResponse.BodyHandlers.ofString())

@main def apiIntegrationDemo(): Unit =
  val base = "https://jsonplaceholder.typicode.com"

  println("--- GET a single resource ---")
  val getResp = get(s"$base/todos/1")
  println(s"status: ${getResp.statusCode()}")
  println(s"body:   ${getResp.body()}")

  println("\n--- GET a list, sliced client-side ---")
  val listResp = get(s"$base/users/1/todos")
  println(s"status: ${listResp.statusCode()}")
  println(s"body starts with: ${listResp.body().take(120)}...")

  println("\n--- POST a new resource ---")
  val newTodo = """{"title": "learn Scala HTTP", "completed": false, "userId": 1}"""
  val postResp = post(s"$base/todos", newTodo)
  println(s"status: ${postResp.statusCode()}") // jsonplaceholder fakes creation, returns 201
  println(s"body:   ${postResp.body()}")

  println("\n--- handling a 404 ---")
  val notFoundResp = get(s"$base/todos/999999")
  println(s"status: ${notFoundResp.statusCode()}")
  println(s"body:   ${notFoundResp.body()}")
