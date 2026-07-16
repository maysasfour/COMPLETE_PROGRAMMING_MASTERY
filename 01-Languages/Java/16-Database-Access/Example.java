// Example.java - JDBC CRUD against SQLite, with PreparedStatement parameterized queries.
// Requires the sqlite-jdbc driver JAR on the classpath -- see this lesson's README for the
// one-line download command, since the JDK itself has no built-in database driver.

import java.sql.*;

public class Example {
    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite::memory:")) {
            try (Statement create = conn.createStatement()) {
                create.execute("""
                    CREATE TABLE tasks (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        title TEXT NOT NULL,
                        done INTEGER NOT NULL DEFAULT 0
                    )
                    """);
            }

            System.out.println("--- CREATE (parameterized) ---");
            try (PreparedStatement insert = conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)")) {
                for (String title : new String[]{"Write lesson", "Test examples", "Ship it"}) {
                    insert.setString(1, title);
                    insert.executeUpdate();
                }
            }
            System.out.println("Inserted 3 rows.");

            System.out.println("\n--- READ (all) ---");
            try (Statement select = conn.createStatement();
                 ResultSet rs = select.executeQuery("SELECT id, title, done FROM tasks")) {
                while (rs.next()) {
                    System.out.println("  id=" + rs.getInt("id") + ", title=" + rs.getString("title")
                        + ", done=" + rs.getInt("done"));
                }
            }

            System.out.println("\n--- UPDATE (parameterized) ---");
            try (PreparedStatement update = conn.prepareStatement("UPDATE tasks SET done = 1 WHERE id = ?")) {
                update.setInt(1, 1);
                update.executeUpdate();
            }
            try (PreparedStatement check = conn.prepareStatement("SELECT done FROM tasks WHERE id = ?")) {
                check.setInt(1, 1);
                try (ResultSet rs = check.executeQuery()) {
                    rs.next();
                    System.out.println("Row 1 done status after update: " + rs.getInt("done"));
                }
            }

            System.out.println("\n--- DELETE (parameterized) ---");
            try (PreparedStatement delete = conn.prepareStatement("DELETE FROM tasks WHERE id = ?")) {
                delete.setInt(1, 3);
                delete.executeUpdate();
            }
            try (Statement count = conn.createStatement();
                 ResultSet rs = count.executeQuery("SELECT COUNT(*) AS c FROM tasks")) {
                rs.next();
                System.out.println("Remaining row count: " + rs.getInt("c"));
            }

            System.out.println("\n--- parameterized queries prevent SQL injection ---");
            String maliciousTitle = "'; DROP TABLE tasks; --";
            try (PreparedStatement insert = conn.prepareStatement("INSERT INTO tasks (title) VALUES (?)")) {
                insert.setString(1, maliciousTitle);
                insert.executeUpdate();
            }
            try (PreparedStatement verify = conn.prepareStatement("SELECT title FROM tasks WHERE title = ?")) {
                verify.setString(1, maliciousTitle);
                try (ResultSet rs = verify.executeQuery()) {
                    rs.next();
                    System.out.println("Malicious-looking string stored and retrieved as plain data: " + rs.getString("title"));
                }
            }
            try (Statement finalCount = conn.createStatement();
                 ResultSet rs = finalCount.executeQuery("SELECT COUNT(*) AS c FROM tasks")) {
                rs.next();
                System.out.println("Table still exists with all rows intact: " + rs.getInt("c"));
            }
        }
    }
}
