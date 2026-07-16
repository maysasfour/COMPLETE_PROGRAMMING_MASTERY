package com.example.sqlfundamentals;

import java.sql.*;

/**
 * Plain JDBC against an embedded H2 database -- no ORM, no framework -- so raw SQL
 * (SELECT/INSERT/UPDATE/DELETE/JOIN) is visible directly, before an ORM (Lesson 05)
 * abstracts it behind objects. Two related tables (authors, books) make JOIN meaningful.
 */
public class Main {
    public static void main(String[] args) throws SQLException {
        try (Connection conn = DriverManager.getConnection("jdbc:h2:mem:librarydb")) {
            createSchema(conn);
            insertData(conn);
            selectAll(conn);
            selectWithJoin(conn);
            updateData(conn);
            deleteData(conn);
            selectAll(conn);
        }
    }

    static void createSchema(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("""
                CREATE TABLE authors (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(100) NOT NULL
                )
            """);
            stmt.execute("""
                CREATE TABLE books (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    title VARCHAR(200) NOT NULL,
                    author_id INT NOT NULL,
                    pub_year INT,
                    FOREIGN KEY (author_id) REFERENCES authors(id)
                )
            """);
        }
        System.out.println("--- Schema created: authors, books (books.author_id -> authors.id) ---");
    }

    static void insertData(Connection conn) throws SQLException {
        // Parameterized INSERT -- prevents SQL injection, the same principle covered
        // throughout this repository's language courses.
        try (PreparedStatement authorStmt = conn.prepareStatement(
                "INSERT INTO authors (name) VALUES (?)", Statement.RETURN_GENERATED_KEYS)) {
            authorStmt.setString(1, "Ursula K. Le Guin");
            authorStmt.executeUpdate();
            int leGuinId = getGeneratedId(authorStmt);

            authorStmt.setString(1, "Isaac Asimov");
            authorStmt.executeUpdate();
            int asimovId = getGeneratedId(authorStmt);

            try (PreparedStatement bookStmt = conn.prepareStatement(
                    "INSERT INTO books (title, author_id, pub_year) VALUES (?, ?, ?)")) {
                insertBook(bookStmt, "The Left Hand of Darkness", leGuinId, 1969);
                insertBook(bookStmt, "The Dispossessed", leGuinId, 1974);
                insertBook(bookStmt, "Foundation", asimovId, 1951);
            }
        }
        System.out.println("--- Inserted 2 authors, 3 books ---");
    }

    static void insertBook(PreparedStatement stmt, String title, int authorId, int publicationYear) throws SQLException {
        stmt.setString(1, title);
        stmt.setInt(2, authorId);
        stmt.setInt(3, publicationYear);
        stmt.executeUpdate();
    }

    static int getGeneratedId(Statement stmt) throws SQLException {
        try (ResultSet keys = stmt.getGeneratedKeys()) {
            keys.next();
            return keys.getInt(1);
        }
    }

    static void selectAll(Connection conn) throws SQLException {
        System.out.println("\n--- SELECT * FROM books ---");
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id, title, author_id, pub_year FROM books ORDER BY id")) {
            while (rs.next()) {
                System.out.printf("  id=%d, title=%s, author_id=%d, pub_year=%d%n",
                        rs.getInt("id"), rs.getString("title"), rs.getInt("author_id"), rs.getInt("pub_year"));
            }
        }
    }

    static void selectWithJoin(Connection conn) throws SQLException {
        System.out.println("\n--- JOIN: books with their author's name ---");
        String sql = """
            SELECT books.title, authors.name AS author_name, books.pub_year
            FROM books
            INNER JOIN authors ON books.author_id = authors.id
            ORDER BY books.pub_year
        """;
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                System.out.printf("  \"%s\" by %s (%d)%n",
                        rs.getString("title"), rs.getString("author_name"), rs.getInt("pub_year"));
            }
        }
    }

    static void updateData(Connection conn) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE books SET pub_year = ? WHERE title = ?")) {
            stmt.setInt(1, 1952); // correcting a (deliberately wrong) publication year
            stmt.setString(2, "Foundation");
            int rowsUpdated = stmt.executeUpdate();
            System.out.println("\n--- UPDATE: " + rowsUpdated + " row(s) updated ---");
        }
    }

    static void deleteData(Connection conn) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM books WHERE title = ?")) {
            stmt.setString(1, "The Dispossessed");
            int rowsDeleted = stmt.executeUpdate();
            System.out.println("--- DELETE: " + rowsDeleted + " row(s) deleted ---");
        }
    }
}
