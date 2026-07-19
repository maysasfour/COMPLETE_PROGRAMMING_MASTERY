// Real MUnit tests (Lesson 18) against TaskRepository, run against a fresh
// in-memory SQLite database per test for isolation.

import java.sql.DriverManager

class TaskRepositorySuite extends munit.FunSuite:

  def freshRepo(): TaskRepository =
    Class.forName("org.sqlite.JDBC")
    val conn = DriverManager.getConnection("jdbc:sqlite::memory:")
    val repo = TaskRepository(conn)
    repo.initSchema()
    repo

  test("add then list returns the added task") {
    val repo = freshRepo()
    val id = repo.add("write MUnit tests")
    val tasks = repo.list()
    assertEquals(tasks, List(Task(id, "write MUnit tests", false)))
  }

  test("complete marks a task done") {
    val repo = freshRepo()
    val id = repo.add("ship the feature")
    val updated = repo.complete(id)
    assert(updated)
    assertEquals(repo.findById(id), Some(Task(id, "ship the feature", true)))
  }

  test("complete on a nonexistent id returns false") {
    val repo = freshRepo()
    assert(!repo.complete(999))
  }

  test("delete removes a task") {
    val repo = freshRepo()
    val id = repo.add("temporary task")
    assert(repo.delete(id))
    assertEquals(repo.findById(id), None)
  }

  test("delete on a nonexistent id returns false") {
    val repo = freshRepo()
    assert(!repo.delete(999))
  }

  test("multiple tasks preserve insertion order") {
    val repo = freshRepo()
    val id1 = repo.add("first")
    val id2 = repo.add("second")
    val id3 = repo.add("third")
    assertEquals(repo.list().map(_.id), List(id1, id2, id3))
  }

  test("a task description containing SQL-injection-shaped text is stored safely, not executed") {
    val repo = freshRepo()
    val malicious = "x'); DROP TABLE tasks; --"
    val id = repo.add(malicious)
    // table survives, and the exact malicious string round-trips as ordinary data:
    assertEquals(repo.findById(id), Some(Task(id, malicious, false)))
    assertEquals(repo.list().length, 1)
  }
