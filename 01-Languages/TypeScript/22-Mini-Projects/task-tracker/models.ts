// models.ts - the Task shape, plus the boundary-validation helpers db.ts needs to trust it.

export type Priority = "low" | "medium" | "high";

export interface Task {
  id: number;
  title: string;
  priority: Priority;
  done: boolean;
}

// The shape a row genuinely has coming out of node:sqlite -- `done` is INTEGER (0/1),
// never a real boolean (SQLite has no boolean column type), and `priority` is just TEXT,
// not yet narrowed to the Priority union. This is the "before validation" shape.
export interface TaskRow {
  id: number;
  title: string;
  priority: string;
  done: number;
}

const PRIORITIES: readonly Priority[] = ["low", "medium", "high"];

export function isPriority(value: unknown): value is Priority {
  return typeof value === "string" && (PRIORITIES as readonly string[]).includes(value);
}

// A database row is `unknown` until proven otherwise (same pattern as Lesson 16) --
// an interface annotation alone would be a claim the compiler cannot verify at runtime.
export function isTaskRow(value: unknown): value is TaskRow {
  if (typeof value !== "object" || value === null) return false;
  const row = value as Record<string, unknown>;
  return (
    typeof row.id === "number" &&
    typeof row.title === "string" &&
    typeof row.priority === "string" &&
    typeof row.done === "number"
  );
}

// Converts a validated-but-still-raw row into the genuinely typed Task the rest of the
// app works with -- this is the one place `done: 0|1` becomes `done: boolean`.
export function rowToTask(row: TaskRow): Task {
  if (!isPriority(row.priority)) {
    throw new Error(`Task ${row.id} has an invalid priority "${row.priority}" stored in the database`);
  }
  return { id: row.id, title: row.title, priority: row.priority, done: row.done === 1 };
}
