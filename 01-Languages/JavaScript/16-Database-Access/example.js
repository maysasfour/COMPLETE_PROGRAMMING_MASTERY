// example.js - CRUD against a real SQLite database using Node's built-in node:sqlite module.
// node:sqlite is stable as of recent Node LTS releases but still flagged experimental by Node itself;
// this course uses it specifically because it requires zero npm install (unlike `better-sqlite3` etc.).

const { DatabaseSync } = require("node:sqlite");

const db = new DatabaseSync(":memory:"); // in-memory DB -- no file left behind, ideal for a lesson

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
insert.run("Ship it");
console.log("Inserted 3 rows.");

console.log("\n--- READ (all) ---");
const all = db.prepare("SELECT * FROM tasks").all();
console.log(all);

console.log("\n--- READ (parameterized, single row) ---");
const one = db.prepare("SELECT * FROM tasks WHERE id = ?").get(2);
console.log(one);

console.log("\n--- UPDATE ---");
db.prepare("UPDATE tasks SET done = 1 WHERE id = ?").run(1);
console.log("Row 1 after update:", db.prepare("SELECT * FROM tasks WHERE id = ?").get(1));

console.log("\n--- DELETE ---");
db.prepare("DELETE FROM tasks WHERE id = ?").run(3);
console.log("Remaining rows:", db.prepare("SELECT * FROM tasks").all());

console.log("\n--- parameterized queries prevent SQL injection ---");
const maliciousTitle = "'; DROP TABLE tasks; --";
insert.run(maliciousTitle); // safe: the driver binds this as DATA, never as SQL syntax
console.log(
  "Malicious-looking string was inserted as a plain value, not executed as SQL:",
  db.prepare("SELECT * FROM tasks WHERE title = ?").get(maliciousTitle)
);
console.log(
  "Table still exists with all rows intact:",
  db.prepare("SELECT COUNT(*) as count FROM tasks").get()
);

db.close();
