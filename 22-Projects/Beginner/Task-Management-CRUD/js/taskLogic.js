/**
 * taskLogic.js
 *
 * Pure functions for creating, updating, and filtering tasks.
 *
 * WHY this file exists as its own module: none of these functions touch the
 * DOM or localStorage. They take a plain array of task objects in, and
 * return a new array out. Keeping the "business logic" pure and side-effect
 * free means:
 *   1. It can be unit-tested with plain `node tests/...js`, no browser needed.
 *   2. The DOM/storage layers stay "dumb" — they just call these functions
 *      and re-render/save whatever comes back.
 *
 * This file is written as a CommonJS/ES-module hybrid so it can be loaded
 * both by a browser <script type="module"> and by plain `node` for tests
 * (see tests/taskLogic.test.js).
 */

/**
 * Generates a reasonably unique id without pulling in a UUID library.
 * Timestamp + random suffix is sufficient for a client-only demo app —
 * collisions are not a realistic concern at human data-entry speed.
 */
function generateId() {
  return `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 9)}`;
}

/**
 * Builds a new task object from raw user input.
 * Centralizing the "shape" of a task here means every task in the app,
 * no matter which UI path created it, has the same fields.
 *
 * @param {string} title
 * @param {string} [description]
 * @returns {object} task
 */
function createTask(title, description = '') {
  const trimmedTitle = title.trim();
  if (!trimmedTitle) {
    // Guard here (not just in the UI layer) so the pure function is safe
    // to call directly from tests without relying on form validation.
    throw new Error('Task title must not be empty.');
  }

  const now = new Date().toISOString();

  return {
    id: generateId(),
    title: trimmedTitle,
    description: description.trim(),
    status: 'active', // 'active' | 'completed' — mirrors a real backend enum column
    createdAt: now,
    updatedAt: now,
  };
}

/**
 * Returns a NEW array with the new task appended.
 * We never mutate the array that's passed in — treating state as immutable
 * makes it trivial to reason about what changed, and avoids subtle bugs
 * where a stale reference elsewhere in the app still points at old data.
 */
function addTask(tasks, title, description = '') {
  const newTask = createTask(title, description);
  return [...tasks, newTask];
}

/**
 * Returns a NEW array with the task matching `id` replaced by an updated
 * copy. Unknown ids are a no-op (returns the array unchanged) rather than
 * throwing — callers (e.g. a stale UI event after a task was deleted
 * elsewhere) shouldn't crash the whole app over a race like that.
 */
function updateTask(tasks, id, updates) {
  return tasks.map((task) => {
    if (task.id !== id) return task;

    const next = { ...task, ...updates, updatedAt: new Date().toISOString() };

    // Defensive trim in case callers pass raw form values through `updates`.
    if (typeof next.title === 'string') next.title = next.title.trim();
    if (typeof next.description === 'string') next.description = next.description.trim();

    return next;
  });
}

/**
 * Returns a NEW array without the task matching `id`.
 */
function deleteTask(tasks, id) {
  return tasks.filter((task) => task.id !== id);
}

/**
 * Flips a task between 'active' and 'completed'.
 * Implemented via updateTask so `updatedAt` bookkeeping stays in one place.
 */
function toggleTaskStatus(tasks, id) {
  const target = tasks.find((task) => task.id === id);
  if (!target) return tasks;

  const nextStatus = target.status === 'completed' ? 'active' : 'completed';
  return updateTask(tasks, id, { status: nextStatus });
}

/**
 * Filters tasks for display. 'all' intentionally short-circuits and returns
 * the original array reference (not a copy) since no filtering occurred —
 * this is a minor perf/identity nicety, not required for correctness.
 */
function filterTasks(tasks, filterName) {
  switch (filterName) {
    case 'active':
      return tasks.filter((task) => task.status === 'active');
    case 'completed':
      return tasks.filter((task) => task.status === 'completed');
    case 'all':
    default:
      return tasks;
  }
}

// --- Module export shim ---------------------------------------------------
// Supports both `require()` (Node test runner) and native ES module
// `import` (browser <script type="module">) from the same source file,
// so there is exactly one implementation to keep in sync — no duplication
// between "app code" and "test code".
const api = {
  generateId,
  createTask,
  addTask,
  updateTask,
  deleteTask,
  toggleTaskStatus,
  filterTasks,
};

if (typeof module !== 'undefined' && module.exports) {
  module.exports = api;
}
// eslint-disable-next-line no-undef
if (typeof window !== 'undefined') {
  window.TaskLogic = api;
}
