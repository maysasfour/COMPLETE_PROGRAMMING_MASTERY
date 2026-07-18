//! db.rs - all rusqlite access for the task tracker.
//!
//! Kept separate from cli.rs/main.rs so the persistence logic is directly
//! testable (see the inline `#[cfg(test)]` module below, and
//! `tests/integration_test.rs`) against an in-memory database, without
//! ever invoking the command-line interface at all.

use rusqlite::{params, Connection};

use crate::models::{Priority, Task, TaskError, TaskStats};

pub struct TaskRepository {
    conn: Connection,
}

impl TaskRepository {
    /// Open (or create) a file-backed database at `path`. Used by the real
    /// CLI so data survives between runs.
    pub fn open(path: &str) -> Result<Self, TaskError> {
        let conn = Connection::open(path)?;
        Self::init_schema(&conn)?;
        Ok(TaskRepository { conn })
    }

    /// Open a fresh in-memory database. Used by every test in this file and
    /// in tests/integration_test.rs -- each call gets its own private
    /// database, so tests never share state or touch a real tasks.db file.
    pub fn open_in_memory() -> Result<Self, TaskError> {
        let conn = Connection::open_in_memory()?;
        Self::init_schema(&conn)?;
        Ok(TaskRepository { conn })
    }

    // IF NOT EXISTS makes this safe to call every time the CLI starts up,
    // rather than requiring a separate one-time "setup" step a user could
    // forget to run before their first `add`.
    fn init_schema(conn: &Connection) -> Result<(), TaskError> {
        conn.execute(
            "CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                priority TEXT NOT NULL,
                done INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL DEFAULT (datetime('now'))
            )",
            [],
        )?;
        Ok(())
    }

    /// Insert a new task and return its generated id. Validation happens
    /// here (not just in the CLI layer) so any other caller -- tests, a
    /// future web frontend -- gets the same guarantee without
    /// re-implementing it.
    pub fn add_task(&self, title: &str, priority: Priority) -> Result<i64, TaskError> {
        if title.trim().is_empty() {
            return Err(TaskError::EmptyTitle);
        }
        // ?1/?2 parameterized placeholders -- the same SQL-injection-safety
        // pattern Lesson 16 demonstrates -- mean a title containing quotes
        // or SQL syntax is stored as plain data, never interpreted as SQL.
        self.conn.execute(
            "INSERT INTO tasks (title, priority, done) VALUES (?1, ?2, 0)",
            params![title, priority.as_str()],
        )?;
        Ok(self.conn.last_insert_rowid())
    }

    /// Return all tasks, optionally filtered to only-done or only-pending.
    /// Building the query conditionally lets SQLite do the filtering, not
    /// Rust after fetching every row.
    pub fn list_tasks(&self, done_filter: Option<bool>) -> Result<Vec<Task>, TaskError> {
        let sql = match done_filter {
            Some(_) => "SELECT id, title, priority, done, created_at FROM tasks WHERE done = ?1 ORDER BY id",
            None => "SELECT id, title, priority, done, created_at FROM tasks ORDER BY id",
        };
        let mut stmt = self.conn.prepare(sql)?;

        let map_row = |row: &rusqlite::Row| -> rusqlite::Result<Task> {
            let priority_str: String = row.get(2)?;
            let done_int: i64 = row.get(3)?;
            Ok(Task {
                id: row.get(0)?,
                title: row.get(1)?,
                // A malformed priority string in the DB would mean the
                // database itself is corrupt (writes only ever go through
                // add_task, which only accepts a valid Priority) --
                // .expect() here documents that as a genuine invariant
                // violation, not a routine, expected failure `?` should
                // propagate.
                priority: priority_str
                    .parse()
                    .expect("priority column should always contain a value written by add_task"),
                done: done_int != 0,
                created_at: row.get(4)?,
            })
        };

        let tasks = match done_filter {
            Some(done) => stmt
                .query_map(params![done as i64], map_row)?
                .collect::<Result<Vec<_>, _>>()?,
            None => stmt.query_map([], map_row)?.collect::<Result<Vec<_>, _>>()?,
        };
        Ok(tasks)
    }

    /// Mark a task done. Checking `rows_affected == 0` (rather than a
    /// SELECT first) avoids a redundant round trip -- one statement tells
    /// us both whether the row existed and that the update happened.
    pub fn mark_done(&self, id: i64) -> Result<(), TaskError> {
        let rows_affected = self
            .conn
            .execute("UPDATE tasks SET done = 1 WHERE id = ?1", params![id])?;
        if rows_affected == 0 {
            return Err(TaskError::NotFound(id));
        }
        Ok(())
    }

    /// Delete a task by id, returning `TaskError::NotFound` if it doesn't
    /// exist -- the same rows-affected-based existence check as mark_done.
    pub fn delete_task(&self, id: i64) -> Result<(), TaskError> {
        let rows_affected = self
            .conn
            .execute("DELETE FROM tasks WHERE id = ?1", params![id])?;
        if rows_affected == 0 {
            return Err(TaskError::NotFound(id));
        }
        Ok(())
    }

    /// Pending/done/total counts in a single query rather than three
    /// separate ones -- SUM of a boolean expression is SQLite's idiomatic
    /// way to get a conditional count without a second round trip.
    pub fn stats(&self) -> Result<TaskStats, TaskError> {
        let (pending, done, total): (i64, i64, i64) = self.conn.query_row(
            "SELECT
                SUM(CASE WHEN done = 0 THEN 1 ELSE 0 END),
                SUM(CASE WHEN done = 1 THEN 1 ELSE 0 END),
                COUNT(*)
             FROM tasks",
            [],
            |row| {
                Ok((
                    row.get::<_, Option<i64>>(0)?.unwrap_or(0),
                    row.get::<_, Option<i64>>(1)?.unwrap_or(0),
                    row.get(2)?,
                ))
            },
        )?;
        Ok(TaskStats { pending, done, total })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_task_returns_incrementing_ids() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let id1 = repo.add_task("First", Priority::Low).unwrap();
        let id2 = repo.add_task("Second", Priority::High).unwrap();
        assert_eq!(id1, 1);
        assert_eq!(id2, 2);
    }

    #[test]
    fn add_task_rejects_empty_title() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let result = repo.add_task("   ", Priority::Medium);
        assert!(matches!(result, Err(TaskError::EmptyTitle)));
    }

    #[test]
    fn list_tasks_returns_all_in_insertion_order() {
        let repo = TaskRepository::open_in_memory().unwrap();
        repo.add_task("Alpha", Priority::Low).unwrap();
        repo.add_task("Beta", Priority::Medium).unwrap();

        let tasks = repo.list_tasks(None).unwrap();
        assert_eq!(tasks.len(), 2);
        assert_eq!(tasks[0].title, "Alpha");
        assert_eq!(tasks[1].title, "Beta");
        assert!(!tasks[0].done);
    }

    #[test]
    fn list_tasks_filters_by_done_status() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let id1 = repo.add_task("Alpha", Priority::Low).unwrap();
        repo.add_task("Beta", Priority::Medium).unwrap();
        repo.mark_done(id1).unwrap();

        let pending = repo.list_tasks(Some(false)).unwrap();
        let done = repo.list_tasks(Some(true)).unwrap();
        assert_eq!(pending.len(), 1);
        assert_eq!(pending[0].title, "Beta");
        assert_eq!(done.len(), 1);
        assert_eq!(done[0].title, "Alpha");
    }

    #[test]
    fn mark_done_updates_status() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let id = repo.add_task("Alpha", Priority::Low).unwrap();
        repo.mark_done(id).unwrap();

        let tasks = repo.list_tasks(None).unwrap();
        assert!(tasks[0].done);
    }

    #[test]
    fn mark_done_on_missing_id_returns_not_found() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let result = repo.mark_done(999);
        assert!(matches!(result, Err(TaskError::NotFound(999))));
    }

    #[test]
    fn delete_task_removes_row() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let id = repo.add_task("Alpha", Priority::Low).unwrap();
        repo.delete_task(id).unwrap();
        assert_eq!(repo.list_tasks(None).unwrap().len(), 0);
    }

    #[test]
    fn delete_task_on_missing_id_returns_not_found() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let result = repo.delete_task(999);
        assert!(matches!(result, Err(TaskError::NotFound(999))));
    }

    #[test]
    fn stats_counts_pending_and_done() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let id1 = repo.add_task("Alpha", Priority::Low).unwrap();
        repo.add_task("Beta", Priority::Medium).unwrap();
        repo.add_task("Gamma", Priority::High).unwrap();
        repo.mark_done(id1).unwrap();

        let stats = repo.stats().unwrap();
        assert_eq!(stats.pending, 2);
        assert_eq!(stats.done, 1);
        assert_eq!(stats.total, 3);
    }

    #[test]
    fn stats_on_empty_table_is_all_zero() {
        let repo = TaskRepository::open_in_memory().unwrap();
        let stats = repo.stats().unwrap();
        assert_eq!(stats.pending, 0);
        assert_eq!(stats.done, 0);
        assert_eq!(stats.total, 0);
    }

    #[test]
    fn a_malicious_looking_title_is_stored_as_plain_data() {
        // The same SQL-injection-safety demonstration used throughout this
        // repository's other language courses: a title that LOOKS like SQL
        // is only ever bound as a ?1 parameter value, never concatenated
        // into the query string, so it can't alter the statement itself.
        let repo = TaskRepository::open_in_memory().unwrap();
        let malicious = "'; DROP TABLE tasks; --";
        repo.add_task(malicious, Priority::Low).unwrap();

        let tasks = repo.list_tasks(None).unwrap();
        assert_eq!(tasks.len(), 1);
        assert_eq!(tasks[0].title, malicious);
    }
}
