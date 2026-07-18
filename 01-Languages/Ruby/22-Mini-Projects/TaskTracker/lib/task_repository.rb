require "sqlite3"
require_relative "task"
require_relative "task_not_found_error"

# All SQLite access lives here, behind a small, testable API -- every write
# is parameterized (Lesson 16's SQL-injection lesson applied for real).
class TaskRepository
  def initialize(db_path)
    @db = SQLite3::Database.new(db_path)
    @db.results_as_hash = true
    @db.execute(<<~SQL)
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    SQL
  end

  def add(title)
    raise ArgumentError, "title must not be empty" if title.nil? || title.strip.empty?

    @db.execute("INSERT INTO tasks (title, done) VALUES (?, 0)", [title])
    row_to_task(@db.execute("SELECT * FROM tasks WHERE id = ?", [@db.last_insert_row_id]).first)
  end

  def all
    @db.execute("SELECT * FROM tasks ORDER BY id").map { |row| row_to_task(row) }
  end

  def find(id)
    row = @db.execute("SELECT * FROM tasks WHERE id = ?", [id]).first
    raise TaskNotFoundError, id unless row

    row_to_task(row)
  end

  def complete(id)
    find(id) # raises TaskNotFoundError if missing, before attempting the update
    @db.execute("UPDATE tasks SET done = 1 WHERE id = ?", [id])
    find(id)
  end

  def delete(id)
    find(id) # raises TaskNotFoundError if missing
    @db.execute("DELETE FROM tasks WHERE id = ?", [id])
  end

  def stats
    total = @db.execute("SELECT COUNT(*) AS c FROM tasks").first["c"]
    done = @db.execute("SELECT COUNT(*) AS c FROM tasks WHERE done = 1").first["c"]
    { total: total, done: done, pending: total - done }
  end

  def close
    @db.close
  end

  private

  def row_to_task(row)
    Task.new(id: row["id"], title: row["title"], done: row["done"] == 1)
  end
end
