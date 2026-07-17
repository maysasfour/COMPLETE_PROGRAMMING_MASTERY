// db.test.js - node:test suite for db.js, run against an in-memory
// node:sqlite database so tests never touch the real tasks.db file on disk.
//
// Run with (from task-tracker/):
//   node --test
//   (node:test's directory auto-discovery finds files under tests/ on its
//   own; passing "tests" or "tests/" explicitly as an argument on this
//   Node version instead makes it try to require() that path as a single
//   test file and fails with MODULE_NOT_FOUND - a real, reproduced gotcha,
//   not a typo, so run bare `node --test` from the project root instead.)

const test = require("node:test");
const assert = require("node:assert/strict");
const { DatabaseSync } = require("node:sqlite");
const {
  TaskNotFoundError,
  initDb,
  addTask,
  listTasks,
  markDone,
  deleteTask,
  summary,
} = require("../db");

// A fresh in-memory database per test, mirroring the pytest `conn` fixture
// in the Python course's expense_tracker test suite - node:test has no
// built-in fixture system, so a small helper function fills the same role.
function freshDb() {
  const db = new DatabaseSync(":memory:");
  initDb(db);
  return db;
}

test("initDb creates an empty tasks table", () => {
  const db = freshDb();
  const row = db.prepare("SELECT COUNT(*) as count FROM tasks").get();
  assert.equal(row.count, 0);
  db.close();
});

test("addTask returns an incrementing id", () => {
  const db = freshDb();
  const id = addTask(db, "Write lesson");
  assert.equal(id, 1);
  db.close();
});

test("addTask defaults priority to medium and status to pending", () => {
  const db = freshDb();
  addTask(db, "Write lesson");
  const [task] = listTasks(db);
  assert.equal(task.priority, "medium");
  assert.equal(task.status, "pending");
  db.close();
});

test("addTask rejects an empty title", () => {
  const db = freshDb();
  assert.throws(() => addTask(db, "   "), RangeError);
  db.close();
});

test("addTask rejects an invalid priority", () => {
  const db = freshDb();
  assert.throws(() => addTask(db, "Task", "urgent"), RangeError);
  db.close();
});

test("listTasks returns all tasks in insertion order", () => {
  const db = freshDb();
  addTask(db, "First");
  addTask(db, "Second");
  const tasks = listTasks(db);
  assert.equal(tasks.length, 2);
  assert.equal(tasks[0].title, "First");
  assert.equal(tasks[1].title, "Second");
  db.close();
});

test("listTasks filters by status", () => {
  const db = freshDb();
  const id1 = addTask(db, "First");
  addTask(db, "Second");
  markDone(db, id1);

  const pendingOnly = listTasks(db, { status: "pending" });
  assert.equal(pendingOnly.length, 1);
  assert.equal(pendingOnly[0].title, "Second");
  db.close();
});

test("markDone flips a task's status", () => {
  const db = freshDb();
  const id = addTask(db, "Task");
  markDone(db, id);
  const [task] = listTasks(db);
  assert.equal(task.status, "done");
  db.close();
});

test("markDone on a nonexistent id throws TaskNotFoundError", () => {
  const db = freshDb();
  assert.throws(() => markDone(db, 999), TaskNotFoundError);
  db.close();
});

test("deleteTask removes the row", () => {
  const db = freshDb();
  const id = addTask(db, "Task");
  deleteTask(db, id);
  assert.deepEqual(listTasks(db), []);
  db.close();
});

test("deleteTask on a nonexistent id throws TaskNotFoundError", () => {
  const db = freshDb();
  assert.throws(() => deleteTask(db, 999), TaskNotFoundError);
  db.close();
});

test("summary counts pending and done tasks separately", () => {
  const db = freshDb();
  const id1 = addTask(db, "First");
  addTask(db, "Second");
  addTask(db, "Third");
  markDone(db, id1);

  const counts = summary(db);
  assert.equal(counts.total, 3);
  assert.equal(counts.done, 1);
  assert.equal(counts.pending, 2);
  db.close();
});

test("summary on an empty table reports all zeros", () => {
  const db = freshDb();
  const counts = summary(db);
  assert.deepEqual(counts, { pending: 0, done: 0, total: 0 });
  db.close();
});
