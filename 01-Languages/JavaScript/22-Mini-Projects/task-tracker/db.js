// db.js - all node:sqlite access for the task tracker.
//
// Kept separate from cli.js so the persistence logic can be unit-tested
// directly (see tests/db.test.js) against an in-memory database, without
// invoking the command-line interface at all - the same split the Python
// course's expense_tracker mini-project uses between db.py and cli.py.

const { DatabaseSync } = require("node:sqlite");
const { Task } = require("./models");

const VALID_PRIORITIES = new Set(["low", "medium", "high"]);

class TaskNotFoundError extends Error {
  constructor(message) {
    super(message);
    this.name = "TaskNotFoundError";
  }
}

function initDb(db) {
  // IF NOT EXISTS makes this safe to call on every CLI invocation rather
  // than requiring a separate one-time "setup" command a user could forget.
  db.exec(`
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      priority TEXT NOT NULL DEFAULT 'medium',
      status TEXT NOT NULL DEFAULT 'pending'
    )
  `);
}

function addTask(db, title, priority = "medium") {
  // Validating here (not just in the CLI layer) means any other caller -
  // tests, a future HTTP API - gets the same guarantees for free.
  if (!title || !title.trim()) {
    throw new RangeError("title must not be empty");
  }
  if (!VALID_PRIORITIES.has(priority)) {
    throw new RangeError(`priority must be one of: ${[...VALID_PRIORITIES].join(", ")}`);
  }

  const result = db
    .prepare("INSERT INTO tasks (title, priority, status) VALUES (?, ?, 'pending')")
    .run(title.trim(), priority);
  // lastInsertRowid gives the AUTOINCREMENT id without a second round-trip
  // query - it comes back as a BigInt from node:sqlite, so Number() it for
  // a plain JS number the rest of the app can compare/print normally.
  return Number(result.lastInsertRowid);
}

function listTasks(db, { status = null } = {}) {
  // Building the WHERE clause conditionally lets SQLite do the filtering
  // rather than always fetching everything and filtering in JS afterward.
  const rows = status
    ? db.prepare("SELECT id, title, priority, status FROM tasks WHERE status = ? ORDER BY id").all(status)
    : db.prepare("SELECT id, title, priority, status FROM tasks ORDER BY id").all();
  return rows.map((row) => new Task(row));
}

function markDone(db, id) {
  const result = db.prepare("UPDATE tasks SET status = 'done' WHERE id = ?").run(id);
  // .changes is node:sqlite's equivalent of sqlite3.Cursor.rowcount /
  // JDBC's executeUpdate() return value - zero means the WHERE clause
  // matched nothing, i.e. no task with that id exists.
  if (result.changes === 0) {
    throw new TaskNotFoundError(`No task with id ${id}`);
  }
}

function deleteTask(db, id) {
  const result = db.prepare("DELETE FROM tasks WHERE id = ?").run(id);
  if (result.changes === 0) {
    throw new TaskNotFoundError(`No task with id ${id}`);
  }
}

function summary(db) {
  // A single grouped query rather than three separate COUNT queries -
  // one round trip instead of three.
  const rows = db
    .prepare("SELECT status, COUNT(*) as count FROM tasks GROUP BY status")
    .all();
  const counts = { pending: 0, done: 0 };
  for (const row of rows) counts[row.status] = Number(row.count);
  counts.total = counts.pending + counts.done;
  return counts;
}

module.exports = {
  TaskNotFoundError,
  initDb,
  addTask,
  listTasks,
  markDone,
  deleteTask,
  summary,
};
