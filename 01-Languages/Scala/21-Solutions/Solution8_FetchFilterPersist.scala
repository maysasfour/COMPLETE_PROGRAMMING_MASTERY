// Solution 8 -- end to end: fetch (Lesson 17), filter (string-based, no JSON lib per
// Lesson 10's honest stance), persist via JDBC (Lesson 16).

import java.net.URI
import java.net.http.{HttpClient, HttpRequest, HttpResponse}
import java.sql.{Connection, DriverManager}

@main def solution8FetchFilterPersist(): Unit =
  val client = HttpClient.newBuilder().build()
  val request = HttpRequest.newBuilder()
    .uri(URI.create("https://jsonplaceholder.typicode.com/todos?userId=1"))
    .GET()
    .build()
  val response = client.send(request, HttpResponse.BodyHandlers.ofString())
  println(s"fetched todos: status=${response.statusCode()}")

  // Deliberately simple, string-based count -- not a real JSON parser (Lesson 10's honest gap):
  // count occurrences of the literal substring that marks a completed todo.
  val completedCount = "\"completed\": true".r.findAllIn(response.body()).length
  println(s"completed todos for userId=1: $completedCount")

  Class.forName("org.sqlite.JDBC")
  val conn: Connection = DriverManager.getConnection("jdbc:sqlite::memory:")
  try
    val stmt = conn.createStatement()
    stmt.execute("CREATE TABLE todo_summary (user_id INTEGER PRIMARY KEY, completed_count INTEGER NOT NULL)")
    stmt.close()

    val insertPs = conn.prepareStatement("INSERT INTO todo_summary (user_id, completed_count) VALUES (?, ?)")
    try
      insertPs.setInt(1, 1)
      insertPs.setInt(2, completedCount)
      insertPs.executeUpdate()
    finally insertPs.close()

    val queryStmt = conn.createStatement()
    val rs = queryStmt.executeQuery("SELECT user_id, completed_count FROM todo_summary WHERE user_id = 1")
    try
      if rs.next() then
        println(s"persisted row: user_id=${rs.getInt("user_id")} completed_count=${rs.getInt("completed_count")}")
    finally
      rs.close()
      queryStmt.close()
  finally conn.close()
