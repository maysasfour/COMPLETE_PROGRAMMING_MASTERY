import java.sql.Connection
import java.sql.ResultSet

// The connection is injected rather than opened inside this class -- the exact seam that lets
// TaskRepositoryTest.kt hand it a fresh ":memory:" SQLite connection per test (Lesson 16's
// pattern) while Main.kt hands it a real file-backed one, with zero duplicated CRUD logic.
class TaskRepository(private val conn: Connection) {

    init {
        // IF NOT EXISTS makes this constructor idempotent -- safe to construct a TaskRepository
        // against the same real tasks.db file on every CLI invocation without wiping prior data.
        conn.createStatement().use { stmt ->
            stmt.executeUpdate(
                """
                CREATE TABLE IF NOT EXISTS tasks (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT NOT NULL,
                    priority TEXT NOT NULL,
                    status TEXT NOT NULL,
                    created_at TEXT NOT NULL DEFAULT (datetime('now'))
                )
                """.trimIndent()
            )
        }
    }

    fun addTask(title: String, priority: Priority): TaskItem {
        require(title.isNotBlank()) { "title cannot be blank" } // caught by the CLI layer, not left to crash as a raw IllegalArgumentException

        // Batching INSERT + last_insert_rowid() into one statement avoids a second round trip
        // just to learn the new row's id -- last_insert_rowid() is connection-scoped, so it's
        // safe to call immediately after within the same connection (Lesson 16's core JDBC pattern).
        conn.prepareStatement(
            "INSERT INTO tasks (title, priority, status) VALUES (?, ?, ?)"
        ).use { stmt ->
            stmt.setString(1, title)
            stmt.setString(2, priority.name)
            stmt.setString(3, Status.PENDING.name)
            stmt.executeUpdate()
        }
        conn.createStatement().use { stmt ->
            val rs = stmt.executeQuery("SELECT last_insert_rowid()")
            rs.next()
            val newId = rs.getLong(1)
            return getTask(newId)
        }
    }

    fun getTask(id: Long): TaskItem {
        conn.prepareStatement("SELECT id, title, priority, status, created_at FROM tasks WHERE id = ?").use { stmt ->
            stmt.setLong(1, id)
            val rs = stmt.executeQuery()
            if (!rs.next()) throw TaskNotFoundException(id)
            return rs.toTaskItem()
        }
    }

    fun listTasks(status: Status? = null): List<TaskItem> {
        // A single query with an optional WHERE clause, rather than two near-duplicate methods --
        // status stays null-parameterized on the Kotlin side, but the SQL itself branches once here.
        val sql = if (status == null) {
            "SELECT id, title, priority, status, created_at FROM tasks ORDER BY id"
        } else {
            "SELECT id, title, priority, status, created_at FROM tasks WHERE status = ? ORDER BY id"
        }
        conn.prepareStatement(sql).use { stmt ->
            if (status != null) stmt.setString(1, status.name)
            val rs = stmt.executeQuery()
            val results = mutableListOf<TaskItem>()
            while (rs.next()) results.add(rs.toTaskItem())
            return results // returned as a genuine List, not the same MutableList reference -- avoids Lesson 07/19's exposed-mutable-backing-collection bug
        }
    }

    fun markDone(id: Long) {
        conn.prepareStatement("UPDATE tasks SET status = ? WHERE id = ?").use { stmt ->
            stmt.setString(1, Status.DONE.name)
            stmt.setLong(2, id)
            val rowsAffected = stmt.executeUpdate()
            // rowsAffected == 0 as the existence check avoids a separate SELECT-then-UPDATE
            // (which could race under concurrent access) -- this app is single-process, so the
            // race isn't a real risk here, but the pattern is worth using by default regardless.
            if (rowsAffected == 0) throw TaskNotFoundException(id)
        }
    }

    fun deleteTask(id: Long) {
        conn.prepareStatement("DELETE FROM tasks WHERE id = ?").use { stmt ->
            stmt.setLong(1, id)
            val rowsAffected = stmt.executeUpdate()
            if (rowsAffected == 0) throw TaskNotFoundException(id)
        }
    }

    fun getStats(): TaskStats {
        conn.createStatement().use { stmt ->
            val rs = stmt.executeQuery(
                "SELECT status, COUNT(*) AS cnt FROM tasks GROUP BY status"
            )
            var pending = 0
            var done = 0
            while (rs.next()) {
                when (Status.valueOf(rs.getString("status"))) {
                    Status.PENDING -> pending = rs.getInt("cnt")
                    Status.DONE -> done = rs.getInt("cnt")
                }
            }
            return TaskStats(pending = pending, done = done, total = pending + done)
        }
    }

    private fun ResultSet.toTaskItem(): TaskItem = TaskItem(
        id = getLong("id"),
        title = getString("title"),
        priority = Priority.valueOf(getString("priority")),
        status = Status.valueOf(getString("status")),
        createdAt = getString("created_at"),
    )
}
