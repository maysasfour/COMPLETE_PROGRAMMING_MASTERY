/**
 * storage.js
 *
 * Thin wrapper around window.localStorage. Isolating all localStorage
 * access behind these two functions means:
 *   - the storage key lives in exactly one place
 *   - JSON.stringify/parse (and their failure modes) are handled once
 *   - if this app ever grows a real backend, this is the ONLY file that
 *     needs to be swapped for a `fetch()`-based API client — state.js and
 *     render.js would not need to change at all.
 */

const STORAGE_KEY = 'task-management-crud:tasks';

/**
 * Reads and parses the task list from localStorage.
 * Returns an empty array (never null/undefined) for any failure case —
 * first run (nothing saved yet), corrupted JSON, or localStorage being
 * unavailable (e.g. private browsing in some older browsers) — so callers
 * never need a null-check before using the result.
 */
function loadTasks() {
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];

    const parsed = JSON.parse(raw);
    // Defend against a corrupted/unexpected value (e.g. someone manually
    // edited localStorage in devtools and left invalid shape behind).
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.error('Failed to load tasks from localStorage; starting empty.', err);
    return [];
  }
}

/**
 * Persists the given task array to localStorage as JSON.
 * Swallows (but logs) write failures rather than throwing, since a full
 * localStorage quota or a disabled-storage browser shouldn't crash the
 * whole app — the user just loses persistence for that session, which is
 * a reasonable degradation for a client-only demo.
 */
function saveTasks(tasks) {
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks));
    return true;
  } catch (err) {
    console.error('Failed to save tasks to localStorage.', err);
    return false;
  }
}

const api = { loadTasks, saveTasks, STORAGE_KEY };

if (typeof module !== 'undefined' && module.exports) {
  module.exports = api;
}
if (typeof window !== 'undefined') {
  window.Storage_ = api; // avoid clobbering the native `window.Storage` interface name
}
