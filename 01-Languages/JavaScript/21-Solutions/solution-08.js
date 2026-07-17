// solution-08.js - Mini Inventory System with node:sqlite
// See: ../20-Exercises/README.md#exercise-08--mini-inventory-system-with-nodesqlite-advanced
//
// Run with:
//   node solution-08.js

const { DatabaseSync } = require("node:sqlite");

class ItemNotFoundError extends Error {
  constructor(message) {
    super(message);
    this.name = "ItemNotFoundError";
  }
}

function initDb(db) {
  db.exec(`
    CREATE TABLE items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 0
    )
  `);
}

function addItem(db, name, quantity) {
  // A "?" placeholder binds name/quantity strictly as data - this, not
  // string escaping, is what actually prevents SQL injection (Lesson 16).
  db.prepare("INSERT INTO items (name, quantity) VALUES (?, ?)").run(name, quantity);
}

function updateQuantity(db, name, newQuantity) {
  const result = db
    .prepare("UPDATE items SET quantity = ? WHERE name = ?")
    .run(newQuantity, name);
  // node:sqlite's .run() result exposes `changes` - zero means the WHERE
  // clause matched nothing, the same signal sqlite3.Cursor.rowcount gives
  // in the Python version of this exercise.
  if (result.changes === 0) {
    throw new ItemNotFoundError(`No item named '${name}' exists`);
  }
}

function listItems(db) {
  return db.prepare("SELECT id, name, quantity FROM items ORDER BY id").all();
}

const db = new DatabaseSync(":memory:");
initDb(db);

addItem(db, "Widget", 10);
addItem(db, "Gadget", 5);
addItem(db, "Gizmo", 0);

console.log("Items after adding three:");
for (const item of listItems(db)) console.log(" ", item);

updateQuantity(db, "Gadget", 20);
console.log("Updated Gadget quantity to 20");

console.log("Items after update:");
for (const item of listItems(db)) console.log(" ", item);

try {
  updateQuantity(db, "Sprocket", 1);
} catch (err) {
  console.log(`Expected error caught: ${err.name}: ${err.message}`);
}

db.close();
