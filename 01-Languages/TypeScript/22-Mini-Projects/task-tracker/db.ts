// db.ts - typed + validated CRUD against node:sqlite, following Lesson 16's exact pattern.

import { DatabaseSync } from "node:sqlite";
import { type Task, type Priority, isTaskRow, isPriority, rowToTask } from "./models";

export class TaskNotFoundError extends Error {
  constructor(id: number) {
    super(`No task found with id ${id}`);
    this.name = "TaskNotFoundError";
  }
}

export interface TaskFilter {
  priority?: Priority;
  done?: boolean;
}

export interface TaskStats {
  total: number;
  done: number;
  pending: number;
  byPriority: Record<Priority, number>;
}

export class TaskStore {
  private db: DatabaseSync;

  constructor(path: string) {
    this.db = new DatabaseSync(path);
    this.init();
  }

  private init(): void {
    this.db.exec(`
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        priority TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    `);
  }

  addTask(title: string, priority: Priority): Task {
    // Validated here, not left to the CALLER's discipline -- an empty title is a bug
    // regardless of which caller (CLI, test, future code) forgot to check for one.
    if (title.trim().length === 0) {
      throw new Error("Task title cannot be empty");
    }
    const insert = this.db.prepare("INSERT INTO tasks (title, priority, done) VALUES (?, ?, 0)");
    const result = insert.run(title, priority);
    // lastInsertRowid comes back as a bigint from node:sqlite when the value exceeds
    // Number.MAX_SAFE_INTEGER's safe range; Number() is safe here because a task id will
    // never realistically approach that, and every other id in this codebase is `number`.
    return this.getById(Number(result.lastInsertRowid));
  }

  getById(id: number): Task {
    const row: unknown = this.db.prepare("SELECT * FROM tasks WHERE id = ?").get(id);
    if (!isTaskRow(row)) {
      throw new TaskNotFoundError(id);
    }
    return rowToTask(row);
  }

  listTasks(filter: TaskFilter = {}): Task[] {
    let sql = "SELECT * FROM tasks WHERE 1 = 1";
    const params: (string | number)[] = [];
    if (filter.priority !== undefined) {
      sql += " AND priority = ?";
      params.push(filter.priority);
    }
    if (filter.done !== undefined) {
      sql += " AND done = ?";
      params.push(filter.done ? 1 : 0);
    }
    sql += " ORDER BY id";
    // Parameterized throughout -- filter.priority/done are always bound as data via `?`,
    // never string-concatenated into the query, so this stays SQL-injection-safe even
    // though `sql` itself is built up conditionally.
    const rows: unknown[] = this.db.prepare(sql).all(...params);
    return rows.map((row) => {
      if (!isTaskRow(row)) throw new Error("A row from the tasks table did not match TaskRow");
      return rowToTask(row);
    });
  }

  completeTask(id: number): Task {
    const result = this.db.prepare("UPDATE tasks SET done = 1 WHERE id = ?").run(id);
    // `changes` reports how many rows the UPDATE actually matched -- 0 means no such id,
    // which is how this detects "not found" without a separate SELECT first (same trick
    // the Python course's inventory exercise uses with cursor.rowcount).
    if (Number(result.changes) === 0) {
      throw new TaskNotFoundError(id);
    }
    return this.getById(id);
  }

  deleteTask(id: number): boolean {
    const result = this.db.prepare("DELETE FROM tasks WHERE id = ?").run(id);
    return Number(result.changes) > 0;
  }

  stats(): TaskStats {
    const all = this.listTasks();
    const byPriority: Record<Priority, number> = { low: 0, medium: 0, high: 0 };
    for (const task of all) {
      byPriority[task.priority] += 1;
    }
    const doneCount = all.filter((task) => task.done).length;
    return {
      total: all.length,
      done: doneCount,
      pending: all.length - doneCount,
      byPriority,
    };
  }

  close(): void {
    this.db.close();
  }
}

// Re-exported so cli.ts can validate a flag string without importing directly from models.ts
// in two places -- a small convenience, not a layering rule.
export { isPriority };
