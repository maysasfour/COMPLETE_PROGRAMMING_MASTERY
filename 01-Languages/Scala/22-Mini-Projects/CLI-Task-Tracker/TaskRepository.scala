// Persistence layer -- raw JDBC against SQLite (Lesson 16), using PreparedStatement
// everywhere user-supplied data (a task description) reaches SQL, exactly for the
// SQL-injection-safety reasons demonstrated in that lesson.

import java.sql.Connection
import scala.util.{Try, Using}

class TaskRepository(conn: Connection):

  def initSchema(): Unit =
    val stmt = conn.createStatement()
    try
      stmt.execute(
        "CREATE TABLE IF NOT EXISTS tasks (" +
          "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
          "description TEXT NOT NULL, " +
          "done INTEGER NOT NULL DEFAULT 0)"
      )
    finally stmt.close()

  // Returns the newly-created task's id.
  def add(description: String): Int =
    val ps = conn.prepareStatement("INSERT INTO tasks (description, done) VALUES (?, 0)")
    try
      ps.setString(1, description) // bound as data -- never concatenated into the SQL text
      ps.executeUpdate()
      val keysRs = ps.getGeneratedKeys
      try
        keysRs.next()
        keysRs.getInt(1)
      finally keysRs.close()
    finally ps.close()

  def list(): List[Task] =
    val stmt = conn.createStatement()
    try
      val rs = stmt.executeQuery("SELECT id, description, done FROM tasks ORDER BY id")
      try
        val builder = List.newBuilder[Task]
        while rs.next() do
          builder += Task(rs.getInt("id"), rs.getString("description"), rs.getInt("done") != 0)
        builder.result()
      finally rs.close()
    finally stmt.close()

  // Returns true if a row was actually updated (i.e. the id existed).
  def complete(id: Int): Boolean =
    val ps = conn.prepareStatement("UPDATE tasks SET done = 1 WHERE id = ?")
    try
      ps.setInt(1, id)
      ps.executeUpdate() > 0
    finally ps.close()

  def delete(id: Int): Boolean =
    val ps = conn.prepareStatement("DELETE FROM tasks WHERE id = ?")
    try
      ps.setInt(1, id)
      ps.executeUpdate() > 0
    finally ps.close()

  def findById(id: Int): Option[Task] =
    val ps = conn.prepareStatement("SELECT id, description, done FROM tasks WHERE id = ?")
    try
      ps.setInt(1, id)
      val rs = ps.executeQuery()
      try
        if rs.next() then Some(Task(rs.getInt("id"), rs.getString("description"), rs.getInt("done") != 0))
        else None
      finally rs.close()
    finally ps.close()
