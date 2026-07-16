// main.rs - CRUD against SQLite using rusqlite, with parameterized queries.
use rusqlite::{params, Connection};

fn main() -> rusqlite::Result<()> {
    let conn = Connection::open_in_memory()?;

    conn.execute(
        "CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            done INTEGER NOT NULL DEFAULT 0
        )",
        [],
    )?;

    println!("--- CREATE (parameterized) ---");
    for title in ["Write lesson", "Test examples", "Ship it"] {
        conn.execute("INSERT INTO tasks (title) VALUES (?1)", params![title])?;
    }
    println!("Inserted 3 rows.");

    println!("\n--- READ (all) ---");
    let mut stmt = conn.prepare("SELECT id, title, done FROM tasks")?;
    let rows = stmt.query_map([], |row| {
        Ok((row.get::<_, i32>(0)?, row.get::<_, String>(1)?, row.get::<_, i32>(2)?))
    })?;
    for row in rows {
        let (id, title, done) = row?;
        println!("  id={}, title={}, done={}", id, title, done);
    }
    drop(stmt);

    println!("\n--- UPDATE (parameterized) ---");
    conn.execute("UPDATE tasks SET done = 1 WHERE id = ?1", params![1])?;
    let done_status: i32 = conn.query_row("SELECT done FROM tasks WHERE id = ?1", params![1], |row| row.get(0))?;
    println!("Row 1 done status after update: {}", done_status);

    println!("\n--- DELETE (parameterized) ---");
    conn.execute("DELETE FROM tasks WHERE id = ?1", params![3])?;
    let count: i32 = conn.query_row("SELECT COUNT(*) FROM tasks", [], |row| row.get(0))?;
    println!("Remaining row count: {}", count);

    println!("\n--- parameterized queries prevent SQL injection ---");
    let malicious_title = "'; DROP TABLE tasks; --";
    conn.execute("INSERT INTO tasks (title) VALUES (?1)", params![malicious_title])?;
    let retrieved: String = conn.query_row(
        "SELECT title FROM tasks WHERE title = ?1",
        params![malicious_title],
        |row| row.get(0),
    )?;
    println!("Malicious-looking string stored and retrieved as plain data: {}", retrieved);

    let final_count: i32 = conn.query_row("SELECT COUNT(*) FROM tasks", [], |row| row.get(0))?;
    println!("Table still exists with all rows intact: {}", final_count);

    Ok(())
}
