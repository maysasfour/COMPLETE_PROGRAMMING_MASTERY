/**
 * taskLogic.test.js
 *
 * Plain, dependency-free assertion-based test script for js/taskLogic.js.
 * No test framework required — this is a beginner-tier project, so we keep
 * the testing story as simple as the app itself: run with plain `node`.
 *
 * Run with:
 *   node tests/taskLogic.test.js
 *
 * Exits with code 0 if all assertions pass, non-zero otherwise (so it can
 * be wired into CI later without modification).
 */

const assert = require('assert');
const {
  createTask,
  addTask,
  updateTask,
  deleteTask,
  toggleTaskStatus,
  filterTasks,
  generateId,
} = require('../js/taskLogic.js');

let passCount = 0;
let failCount = 0;

/** Tiny local test runner — logs a pass/fail line per test, like a mini TAP. */
function test(name, fn) {
  try {
    fn();
    passCount += 1;
    console.log(`  PASS  ${name}`);
  } catch (err) {
    failCount += 1;
    console.log(`  FAIL  ${name}`);
    console.log(`        ${err.message}`);
  }
}

console.log('taskLogic.js test suite\n');

// --- generateId -------------------------------------------------------
test('generateId produces unique values across many calls', () => {
  const ids = new Set();
  for (let i = 0; i < 1000; i += 1) ids.add(generateId());
  assert.strictEqual(ids.size, 1000);
});

// --- createTask ---------------------------------------------------------
test('createTask builds a task with expected shape and defaults', () => {
  const task = createTask('Buy milk', 'From the corner store');
  assert.strictEqual(task.title, 'Buy milk');
  assert.strictEqual(task.description, 'From the corner store');
  assert.strictEqual(task.status, 'active');
  assert.ok(task.id, 'id should be truthy');
  assert.ok(task.createdAt, 'createdAt should be set');
  assert.strictEqual(task.createdAt, task.updatedAt);
});

test('createTask trims whitespace from title and description', () => {
  const task = createTask('  Buy milk  ', '  details  ');
  assert.strictEqual(task.title, 'Buy milk');
  assert.strictEqual(task.description, 'details');
});

test('createTask defaults description to empty string when omitted', () => {
  const task = createTask('Solo title');
  assert.strictEqual(task.description, '');
});

test('createTask throws on empty title', () => {
  assert.throws(() => createTask(''), /title must not be empty/i);
});

test('createTask throws on whitespace-only title', () => {
  assert.throws(() => createTask('    '), /title must not be empty/i);
});

// --- addTask --------------------------------------------------------------
test('addTask appends a new task without mutating the original array', () => {
  const original = [];
  const result = addTask(original, 'First task');
  assert.strictEqual(original.length, 0, 'original array must stay untouched');
  assert.strictEqual(result.length, 1);
  assert.strictEqual(result[0].title, 'First task');
});

test('addTask preserves existing tasks when adding a new one', () => {
  const existing = [createTask('Existing task')];
  const result = addTask(existing, 'New task');
  assert.strictEqual(result.length, 2);
  assert.strictEqual(result[0].title, 'Existing task');
  assert.strictEqual(result[1].title, 'New task');
});

// --- updateTask -------------------------------------------------------
test('updateTask changes only the targeted task', () => {
  const a = createTask('Task A');
  const b = createTask('Task B');
  const result = updateTask([a, b], b.id, { title: 'Task B renamed' });

  assert.strictEqual(result[0].title, 'Task A', 'unrelated task must be untouched');
  assert.strictEqual(result[1].title, 'Task B renamed');
  assert.ok(result[1].updatedAt >= b.updatedAt, 'updatedAt should be refreshed to now or later');
});

test('updateTask does not mutate the original array or task objects', () => {
  const a = createTask('Task A');
  const original = [a];
  const result = updateTask(original, a.id, { title: 'Changed' });
  assert.strictEqual(original[0].title, 'Task A', 'original object must remain unchanged');
  assert.notStrictEqual(result, original, 'a new array must be returned');
});

test('updateTask is a no-op for an unknown id (does not throw)', () => {
  const a = createTask('Task A');
  const result = updateTask([a], 'nonexistent-id', { title: 'Should not apply' });
  assert.strictEqual(result[0].title, 'Task A');
  assert.strictEqual(result.length, 1);
});

test('updateTask trims title/description passed via updates', () => {
  const a = createTask('Task A');
  const result = updateTask([a], a.id, { title: '  Trimmed  ' });
  assert.strictEqual(result[0].title, 'Trimmed');
});

// --- deleteTask -------------------------------------------------------
test('deleteTask removes only the targeted task', () => {
  const a = createTask('Task A');
  const b = createTask('Task B');
  const result = deleteTask([a, b], a.id);
  assert.strictEqual(result.length, 1);
  assert.strictEqual(result[0].id, b.id);
});

test('deleteTask on unknown id returns an equivalent (but new) array', () => {
  const a = createTask('Task A');
  const result = deleteTask([a], 'nonexistent-id');
  assert.strictEqual(result.length, 1);
  assert.notStrictEqual(result, [a]); // different array reference, same content
});

// --- toggleTaskStatus ---------------------------------------------------
test('toggleTaskStatus flips active -> completed', () => {
  const a = createTask('Task A');
  assert.strictEqual(a.status, 'active');
  const result = toggleTaskStatus([a], a.id);
  assert.strictEqual(result[0].status, 'completed');
});

test('toggleTaskStatus flips completed -> active', () => {
  const a = createTask('Task A');
  const completed = updateTask([a], a.id, { status: 'completed' });
  const result = toggleTaskStatus(completed, a.id);
  assert.strictEqual(result[0].status, 'active');
});

test('toggleTaskStatus on unknown id returns the array unchanged', () => {
  const a = createTask('Task A');
  const result = toggleTaskStatus([a], 'nonexistent-id');
  assert.strictEqual(result[0].status, 'active');
});

// --- filterTasks ------------------------------------------------------
test('filterTasks "all" returns every task', () => {
  const a = createTask('Task A');
  const b = createTask('Task B');
  const result = filterTasks([a, b], 'all');
  assert.strictEqual(result.length, 2);
});

test('filterTasks "active" returns only non-completed tasks', () => {
  const a = createTask('Task A');
  let tasks = [a, createTask('Task B')];
  tasks = toggleTaskStatus(tasks, tasks[1].id); // complete task B
  const result = filterTasks(tasks, 'active');
  assert.strictEqual(result.length, 1);
  assert.strictEqual(result[0].title, 'Task A');
});

test('filterTasks "completed" returns only completed tasks', () => {
  let tasks = [createTask('Task A'), createTask('Task B')];
  tasks = toggleTaskStatus(tasks, tasks[1].id); // complete task B
  const result = filterTasks(tasks, 'completed');
  assert.strictEqual(result.length, 1);
  assert.strictEqual(result[0].title, 'Task B');
});

test('filterTasks with an unrecognized filter name falls back to "all"', () => {
  const tasks = [createTask('Task A'), createTask('Task B')];
  const result = filterTasks(tasks, 'bogus-filter');
  assert.strictEqual(result.length, 2);
});

test('filterTasks on an empty list returns an empty list for every filter', () => {
  assert.strictEqual(filterTasks([], 'all').length, 0);
  assert.strictEqual(filterTasks([], 'active').length, 0);
  assert.strictEqual(filterTasks([], 'completed').length, 0);
});

// --- JSON round-trip (mirrors what storage.js does against localStorage) --
test('a task survives a JSON.stringify -> JSON.parse round trip unchanged', () => {
  const a = createTask('Round trip me', 'with description');
  const roundTripped = JSON.parse(JSON.stringify(a));
  assert.deepStrictEqual(roundTripped, a);
});

test('a full task array survives a JSON round trip unchanged', () => {
  let tasks = [createTask('Task A'), createTask('Task B', 'desc')];
  tasks = toggleTaskStatus(tasks, tasks[0].id);
  const roundTripped = JSON.parse(JSON.stringify(tasks));
  assert.deepStrictEqual(roundTripped, tasks);
});

// --- summary ------------------------------------------------------------
console.log(`\n${passCount} passed, ${failCount} failed (${passCount + failCount} total)`);
process.exit(failCount === 0 ? 0 : 1);
