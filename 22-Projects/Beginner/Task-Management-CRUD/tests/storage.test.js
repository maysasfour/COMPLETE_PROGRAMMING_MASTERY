/**
 * storage.test.js
 *
 * Tests js/storage.js against a minimal in-memory mock of the
 * localStorage API, since Node has no `window`/`localStorage` built in.
 * The mock implements exactly the two methods storage.js uses
 * (getItem/setItem), which is enough to exercise the real save/load code
 * paths without needing a browser or a headless-DOM dependency.
 *
 * Run with:
 *   node tests/storage.test.js
 */

const assert = require('assert');

/** Minimal localStorage-compatible mock, backed by a plain object. */
function createMockLocalStorage() {
  const store = {};
  return {
    getItem(key) {
      return Object.prototype.hasOwnProperty.call(store, key) ? store[key] : null;
    },
    setItem(key, value) {
      store[key] = String(value);
    },
    _dump: () => ({ ...store }),
  };
}

let passCount = 0;
let failCount = 0;

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

console.log('storage.js test suite\n');

test('loadTasks returns an empty array when nothing has been saved yet', () => {
  global.window = { localStorage: createMockLocalStorage() };
  delete require.cache[require.resolve('../js/storage.js')];
  const { loadTasks } = require('../js/storage.js');

  assert.deepStrictEqual(loadTasks(), []);
});

test('saveTasks then loadTasks round-trips a task array correctly', () => {
  global.window = { localStorage: createMockLocalStorage() };
  delete require.cache[require.resolve('../js/storage.js')];
  const { saveTasks, loadTasks } = require('../js/storage.js');

  const tasks = [
    { id: 'a1', title: 'Task A', description: '', status: 'active', createdAt: 'x', updatedAt: 'x' },
    { id: 'b2', title: 'Task B', description: 'desc', status: 'completed', createdAt: 'y', updatedAt: 'y' },
  ];

  const saveResult = saveTasks(tasks);
  assert.strictEqual(saveResult, true);

  const loaded = loadTasks();
  assert.deepStrictEqual(loaded, tasks);
});

test('loadTasks returns an empty array (not a crash) when stored JSON is corrupted', () => {
  const mockStorage = createMockLocalStorage();
  mockStorage.setItem('task-management-crud:tasks', '{not valid json');
  global.window = { localStorage: mockStorage };
  delete require.cache[require.resolve('../js/storage.js')];
  const { loadTasks } = require('../js/storage.js');

  assert.deepStrictEqual(loadTasks(), []);
});

test('loadTasks returns an empty array when stored value is valid JSON but not an array', () => {
  const mockStorage = createMockLocalStorage();
  mockStorage.setItem('task-management-crud:tasks', JSON.stringify({ not: 'an array' }));
  global.window = { localStorage: mockStorage };
  delete require.cache[require.resolve('../js/storage.js')];
  const { loadTasks } = require('../js/storage.js');

  assert.deepStrictEqual(loadTasks(), []);
});

test('saveTasks returns false and does not throw when localStorage.setItem fails', () => {
  const failingStorage = {
    getItem: () => null,
    setItem: () => {
      throw new Error('QuotaExceededError');
    },
  };
  global.window = { localStorage: failingStorage };
  delete require.cache[require.resolve('../js/storage.js')];
  const { saveTasks } = require('../js/storage.js');

  const result = saveTasks([{ id: 'x' }]);
  assert.strictEqual(result, false);
});

console.log(`\n${passCount} passed, ${failCount} failed (${passCount + failCount} total)`);
process.exit(failCount === 0 ? 0 : 1);
