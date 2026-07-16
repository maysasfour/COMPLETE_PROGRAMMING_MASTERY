// Example.kt - CRUD against SQLite via JDBC (java.sql), the same driver-based API used in
// this repository's Java course, since Kotlin has no database access of its own -- it uses
// Java's JDBC directly. Parameterized queries prevent SQL injection, the same pattern used
// throughout this repository's other language courses.

import java.sql.Connection
import java.sql.DriverManager

fun main() {
    Class.forName("org.sqlite.JDBC") // registers the SQLite JDBC driver
    val conn: Connection = DriverManager.getConnection("jdbc:sqlite::memory:")

    conn.createStatement().use { stmt ->
        stmt.execute("""
            CREATE TABLE tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                done INTEGER NOT NULL DEFAULT 0
            )
        """.trimIndent())
    }

    println("--- CREATE (parameterized) ---")
    conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)").use { stmt ->
        for (title in listOf("Write lesson", "Test examples", "Ship it")) {
            stmt.setString(1, title)
            stmt.executeUpdate()
        }
    }
    println("Inserted 3 rows.")

    println("\n--- READ (all) ---")
    conn.createStatement().use { stmt ->
        val rs = stmt.executeQuery("SELECT id, title, done FROM tasks")
        while (rs.next()) {
            println("  id=${rs.getInt("id")}, title=${rs.getString("title")}, done=${rs.getInt("done")}")
        }
    }

    println("\n--- UPDATE (parameterized) ---")
    conn.prepareStatement("UPDATE tasks SET done = 1 WHERE id = ?").use { stmt ->
        stmt.setInt(1, 1)
        stmt.executeUpdate()
    }
    conn.createStatement().use { stmt ->
        val rs = stmt.executeQuery("SELECT done FROM tasks WHERE id = 1")
        rs.next()
        println("Row 1 done status after update: ${rs.getInt("done")}")
    }

    println("\n--- DELETE (parameterized) ---")
    conn.prepareStatement("DELETE FROM tasks WHERE id = ?").use { stmt ->
        stmt.setInt(1, 3)
        stmt.executeUpdate()
    }
    conn.createStatement().use { stmt ->
        val rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM tasks")
        rs.next()
        println("Remaining row count: ${rs.getInt("cnt")}")
    }

    println("\n--- Parameterized queries prevent SQL injection ---")
    val maliciousTitle = "'; DROP TABLE tasks; --"
    conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)").use { stmt ->
        stmt.setString(1, maliciousTitle)
        stmt.executeUpdate()
    }
    conn.prepareStatement("SELECT title FROM tasks WHERE title = ?").use { stmt ->
        stmt.setString(1, maliciousTitle)
        val rs = stmt.executeQuery()
        rs.next()
        println("Malicious-looking string stored and retrieved as plain data: ${rs.getString("title")}")
    }
    conn.createStatement().use { stmt ->
        val rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM tasks")
        rs.next()
        println("Table still exists with all rows intact: ${rs.getInt("cnt")}")
    }

    conn.close()
}
