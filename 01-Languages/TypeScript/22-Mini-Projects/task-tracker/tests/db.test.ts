// db.test.ts - node:test suite against an in-memory TaskStore (":memory:", never tasks.db).

import test from "node:test";
import assert from "node:assert/strict";
import { TaskStore, TaskNotFoundError } from "../db";

// A fresh in-memory store per test -- no shared state between tests, and never touches
// the real tasks.db file the CLI walkthrough writes to.
function freshStore(): TaskStore {
  return new TaskStore(":memory:");
}

test("addTask returns a task with an assigned id and done=false", () => {
  const store = freshStore();
  const task = store.addTask("Write lesson", "high");
  assert.equal(task.title, "Write lesson");
  assert.equal(task.priority, "high");
  assert.equal(task.done, false);
  assert.equal(typeof task.id, "number");
  store.close();
});

test("addTask rejects a title that's empty or only whitespace", () => {
  const store = freshStore();
  assert.throws(() => store.addTask("   ", "low"), /cannot be empty/);
  store.close();
});

test("listTasks returns all tasks ordered by id", () => {
  const store = freshStore();
  store.addTask("First", "low");
  store.addTask("Second", "medium");
  const tasks = store.listTasks();
  assert.equal(tasks.length, 2);
  assert.equal(tasks[0].title, "First");
  assert.equal(tasks[1].title, "Second");
  store.close();
});

test("listTasks filters by priority", () => {
  const store = freshStore();
  store.addTask("Low one", "low");
  store.addTask("High one", "high");
  const highOnly = store.listTasks({ priority: "high" });
  assert.equal(highOnly.length, 1);
  assert.equal(highOnly[0].title, "High one");
  store.close();
});

test("listTasks filters by done status", () => {
  const store = freshStore();
  const a = store.addTask("Todo", "low");
  store.addTask("Also todo", "low");
  store.completeTask(a.id);
  const pending = store.listTasks({ done: false });
  assert.equal(pending.length, 1);
  assert.equal(pending[0].title, "Also todo");
  store.close();
});

test("completeTask marks a task done and returns the updated task", () => {
  const store = freshStore();
  const task = store.addTask("Finish this", "medium");
  const completed = store.completeTask(task.id);
  assert.equal(completed.done, true);
  assert.equal(completed.id, task.id);
  store.close();
});

test("completeTask on a nonexistent id throws TaskNotFoundError", () => {
  const store = freshStore();
  assert.throws(() => store.completeTask(999), TaskNotFoundError);
  store.close();
});

test("deleteTask removes a task and reports success", () => {
  const store = freshStore();
  const task = store.addTask("Delete me", "low");
  const deleted = store.deleteTask(task.id);
  assert.equal(deleted, true);
  assert.equal(store.listTasks().length, 0);
  store.close();
});

test("deleteTask on a nonexistent id returns false rather than throwing", () => {
  const store = freshStore();
  assert.equal(store.deleteTask(999), false);
  store.close();
});

test("stats aggregates totals and per-priority counts correctly", () => {
  const store = freshStore();
  store.addTask("A", "low");
  const b = store.addTask("B", "high");
  store.addTask("C", "high");
  store.completeTask(b.id);
  const stats = store.stats();
  assert.equal(stats.total, 3);
  assert.equal(stats.done, 1);
  assert.equal(stats.pending, 2);
  assert.equal(stats.byPriority.low, 1);
  assert.equal(stats.byPriority.high, 2);
  assert.equal(stats.byPriority.medium, 0);
  store.close();
});
