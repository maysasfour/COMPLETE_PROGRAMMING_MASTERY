// task_repository.dart - all persistence logic in one place, so it (not the CLI layer
// in bin/task_tracker.dart) is what the test suite exercises directly. Takes an already-open
// Database rather than a file path, so tests can hand it sqlite3.openInMemory() (which only
// exists for the lifetime of the connection that created it) while the CLI hands it a
// file-backed connection that persists between runs -- the repository itself doesn't care which.

import 'package:sqlite3/sqlite3.dart';

import 'task_item.dart';
import 'task_not_found_exception.dart';

class TaskRepository {
  final Database _db;

  TaskRepository(this._db);

  void initDb() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  TaskItem addTask(String title, Priority priority) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Task title cannot be empty.');
    }

    var createdAt = DateTime.now().toUtc();
    var stmt = _db.prepare(
      'INSERT INTO tasks (title, priority, status, created_at) VALUES (?, ?, ?, ?)',
    );
    stmt.execute([title, priority.name, Status.pending.name, createdAt.toIso8601String()]);
    stmt.dispose();

    // lastInsertRowId is connection-scoped and safe to read immediately after an INSERT
    // on that same connection -- avoids a second round trip (a separate SELECT) just to
    // learn the AUTOINCREMENT id the row above was just given.
    var newId = _db.lastInsertRowId;
    return TaskItem(
      id: newId,
      title: title,
      priority: priority,
      status: Status.pending,
      createdAt: createdAt,
    );
  }

  List<TaskItem> listTasks({Status? statusFilter}) {
    ResultSet rows;
    if (statusFilter != null) {
      rows = _db.select(
        'SELECT id, title, priority, status, created_at FROM tasks WHERE status = ? ORDER BY id',
        [statusFilter.name],
      );
    } else {
      rows = _db.select('SELECT id, title, priority, status, created_at FROM tasks ORDER BY id');
    }
    return rows.map(_rowToTask).toList();
  }

  void markDone(int id) {
    _db.execute('UPDATE tasks SET status = ? WHERE id = ?', [Status.done.name, id]);
    // updatedRows is 0 when no row matched the WHERE clause -- the cheapest way to detect
    // "id doesn't exist" without a separate SELECT-then-UPDATE round trip that could race
    // under concurrent access (not a real risk in this single-process CLI, but the pattern
    // is worth using by default regardless).
    if (_db.updatedRows == 0) {
      throw TaskNotFoundException(id);
    }
  }

  void deleteTask(int id) {
    _db.execute('DELETE FROM tasks WHERE id = ?', [id]);
    if (_db.updatedRows == 0) {
      throw TaskNotFoundException(id);
    }
  }

  TaskStats getStats() {
    var rows = _db.select('SELECT status, COUNT(*) as cnt FROM tasks GROUP BY status');
    var pending = 0;
    var done = 0;
    for (var row in rows) {
      var count = row['cnt'] as int;
      if (row['status'] == Status.done.name) {
        done = count;
      } else {
        pending = count;
      }
    }
    return TaskStats(pending: pending, done: done);
  }

  TaskItem _rowToTask(Row row) => TaskItem(
        id: row['id'] as int,
        title: row['title'] as String,
        priority: Priority.values.byName(row['priority'] as String),
        status: Status.values.byName(row['status'] as String),
        createdAt: DateTime.parse(row['created_at'] as String),
      );
}
