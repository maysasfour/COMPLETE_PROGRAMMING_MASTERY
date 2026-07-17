using Microsoft.Data.Sqlite;

namespace TaskTracker;

// Takes an already-open SqliteConnection rather than a connection string,
// so tests can hand it an in-memory connection ("Data Source=:memory:")
// that stays open for the test's lifetime, while the CLI hands it a
// file-backed connection -- the repository itself doesn't care which.
public class TaskRepository {
    private readonly SqliteConnection _connection;

    public TaskRepository(SqliteConnection connection) {
        _connection = connection;
    }

    public void InitDb() {
        var cmd = _connection.CreateCommand();
        cmd.CommandText = @"
            CREATE TABLE IF NOT EXISTS tasks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                priority TEXT NOT NULL,
                status TEXT NOT NULL,
                created_at TEXT NOT NULL
            )";
        cmd.ExecuteNonQuery();
    }

    public TaskItem AddTask(string title, Priority priority) {
        if (string.IsNullOrWhiteSpace(title)) {
            throw new ArgumentException("Task title cannot be empty.", nameof(title));
        }

        var createdAt = DateTime.UtcNow;
        var cmd = _connection.CreateCommand();
        cmd.CommandText = @"
            INSERT INTO tasks (title, priority, status, created_at)
            VALUES (@title, @priority, @status, @createdAt);
            SELECT last_insert_rowid();";
        cmd.Parameters.AddWithValue("@title", title);
        cmd.Parameters.AddWithValue("@priority", priority.ToString());
        cmd.Parameters.AddWithValue("@status", Status.Pending.ToString());
        cmd.Parameters.AddWithValue("@createdAt", createdAt.ToString("O"));

        // ExecuteScalar on a statement batch ending in SELECT last_insert_rowid()
        // returns the AUTOINCREMENT id from the INSERT that just ran, in the
        // same round trip -- avoids a second query just to learn the new id.
        var newId = Convert.ToInt32((long)cmd.ExecuteScalar()!);
        return new TaskItem(newId, title, priority, Status.Pending, createdAt);
    }

    public List<TaskItem> ListTasks(Status? statusFilter = null) {
        var cmd = _connection.CreateCommand();
        if (statusFilter is Status filter) {
            cmd.CommandText = "SELECT id, title, priority, status, created_at FROM tasks WHERE status = @status ORDER BY id";
            cmd.Parameters.AddWithValue("@status", filter.ToString());
        } else {
            cmd.CommandText = "SELECT id, title, priority, status, created_at FROM tasks ORDER BY id";
        }

        var results = new List<TaskItem>();
        using var reader = cmd.ExecuteReader();
        while (reader.Read()) {
            results.Add(ReadTask(reader));
        }
        return results;
    }

    public void MarkDone(int id) {
        var cmd = _connection.CreateCommand();
        cmd.CommandText = "UPDATE tasks SET status = @status WHERE id = @id";
        cmd.Parameters.AddWithValue("@status", Status.Done.ToString());
        cmd.Parameters.AddWithValue("@id", id);
        var rowsAffected = cmd.ExecuteNonQuery();

        // rowsAffected is 0 when no row matched the WHERE clause -- the
        // cheapest way to detect "id doesn't exist" without a separate
        // SELECT-then-UPDATE round trip that could race under concurrent access.
        if (rowsAffected == 0) {
            throw new TaskNotFoundException(id);
        }
    }

    public void DeleteTask(int id) {
        var cmd = _connection.CreateCommand();
        cmd.CommandText = "DELETE FROM tasks WHERE id = @id";
        cmd.Parameters.AddWithValue("@id", id);
        var rowsAffected = cmd.ExecuteNonQuery();
        if (rowsAffected == 0) {
            throw new TaskNotFoundException(id);
        }
    }

    public TaskStats GetStats() {
        var cmd = _connection.CreateCommand();
        cmd.CommandText = @"
            SELECT status, COUNT(*) FROM tasks GROUP BY status";
        using var reader = cmd.ExecuteReader();
        int pending = 0, done = 0;
        while (reader.Read()) {
            var status = reader.GetString(0);
            var count = reader.GetInt32(1);
            if (status == Status.Done.ToString()) {
                done = count;
            } else {
                pending = count;
            }
        }
        return new TaskStats(pending, done);
    }

    private static TaskItem ReadTask(SqliteDataReader reader) => new(
        Id: reader.GetInt32(0),
        Title: reader.GetString(1),
        Priority: Enum.Parse<Priority>(reader.GetString(2)),
        Status: Enum.Parse<Status>(reader.GetString(3)),
        CreatedAt: DateTime.Parse(reader.GetString(4)).ToUniversalTime()
    );
}

public record TaskStats(int Pending, int Done) {
    public int Total => Pending + Done;
}
