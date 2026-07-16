// example.ts - typed CRUD against node:sqlite, with a generic-ish typed row shape.

const { DatabaseSync } = require("node:sqlite");

interface Task {
  id: number;
  title: string;
  done: number; // SQLite has no boolean type -- stored as 0/1
}

const db = new DatabaseSync(":memory:");

db.exec(`
  CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    done INTEGER NOT NULL DEFAULT 0
  )
`);

console.log("--- CREATE ---");
const insert = db.prepare("INSERT INTO tasks (title) VALUES (?)");
insert.run("Write lesson");
insert.run("Test examples");
console.log("Inserted 2 rows.");

console.log("\n--- READ, cast to a typed interface via a validating helper ---");
function isTask(value: unknown): value is Task {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Task).id === "number" &&
    typeof (value as Task).title === "string" &&
    typeof (value as Task).done === "number"
  );
}

function getTaskById(id: number): Task {
  const row: unknown = db.prepare("SELECT * FROM tasks WHERE id = ?").get(id);
  if (!isTask(row)) {
    throw new Error(`No task found with id ${id}, or row shape did not match Task`);
  }
  return row;
}

const task = getTaskById(1);
console.log("Fetched and validated:", task);
console.log("task.title.toUpperCase():", task.title.toUpperCase()); // safe: genuinely typed as Task

console.log("\n--- parameterized queries prevent SQL injection (same guarantee as the JS course) ---");
const maliciousTitle = "'; DROP TABLE tasks; --";
insert.run(maliciousTitle);
const allTasks: unknown[] = db.prepare("SELECT * FROM tasks").all();
console.log("Row count after malicious-looking insert:", allTasks.length);

db.close();
