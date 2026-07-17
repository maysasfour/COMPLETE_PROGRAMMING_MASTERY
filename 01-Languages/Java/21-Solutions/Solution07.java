import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

class ItemNotFoundException extends Exception {
    public ItemNotFoundException(String message) {
        super(message);
    }
}

record Item(int id, String name, int quantity) {}

public class Solution07 {

    static void initDb(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute("""
                CREATE TABLE items (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    quantity INTEGER NOT NULL DEFAULT 0
                )
                """);
        }
    }

    static void addItem(Connection conn, String name, int quantity) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO items (name, quantity) VALUES (?, ?)")) {
            stmt.setString(1, name);
            stmt.setInt(2, quantity);
            stmt.executeUpdate();
        }
    }

    static void updateQuantity(Connection conn, String name, int newQuantity)
            throws SQLException, ItemNotFoundException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE items SET quantity = ? WHERE name = ?")) {
            stmt.setInt(1, newQuantity);
            stmt.setString(2, name);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new ItemNotFoundException("No item named '" + name + "' exists");
            }
        }
    }

    static List<Item> listItems(Connection conn) throws SQLException {
        List<Item> items = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT id, name, quantity FROM items ORDER BY id")) {
            while (rs.next()) {
                items.add(new Item(rs.getInt("id"), rs.getString("name"), rs.getInt("quantity")));
            }
        }
        return items;
    }

    public static void main(String[] args) throws Exception {
        try (Connection conn = DriverManager.getConnection("jdbc:sqlite::memory:")) {
            initDb(conn);

            addItem(conn, "Widget", 10);
            addItem(conn, "Gadget", 5);
            addItem(conn, "Gizmo", 0);

            System.out.println("After adding 3 items:");
            for (Item item : listItems(conn)) {
                System.out.println("  " + item);
            }

            updateQuantity(conn, "Gizmo", 20);
            System.out.println("After updating Gizmo to 20:");
            for (Item item : listItems(conn)) {
                System.out.println("  " + item);
            }

            try {
                updateQuantity(conn, "Nonexistent", 5);
            } catch (ItemNotFoundException e) {
                System.out.println("Correctly caught: " + e.getMessage());
            }
        }
    }
}
