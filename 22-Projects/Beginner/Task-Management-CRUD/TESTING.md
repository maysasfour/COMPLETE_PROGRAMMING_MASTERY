# Testing

This project has two layers of test coverage:

1. **Automated tests** (real, runnable with plain `node`, no framework/build step) for the DOM-free logic: `js/taskLogic.js` and `js/storage.js`.
2. **Manual test checklist** for everything that requires an actual browser DOM: forms, clicks, checkboxes, the confirmation dialog, and visual filtering.

There is no automated browser/DOM test here (no headless browser, no jsdom dependency) — keeping the dependency count at zero was a deliberate choice for a beginner-tier project. The DOM layer (`render.js`, `events.js`) is kept intentionally thin specifically so the manual checklist below is short and the interesting logic is covered by the automated tests instead.

## Automated Tests

### Running them

```bash
cd 22-Projects/Beginner/Task-Management-CRUD
node tests/taskLogic.test.js
node tests/storage.test.js
```

Both are plain Node scripts using the built-in `assert` module — no `npm install` required. Each exits with code `0` on success and non-zero if any assertion fails, so they can be dropped into CI unchanged.

### Actual output (last run)

`node tests/taskLogic.test.js`:

```
taskLogic.js test suite

  PASS  generateId produces unique values across many calls
  PASS  createTask builds a task with expected shape and defaults
  PASS  createTask trims whitespace from title and description
  PASS  createTask defaults description to empty string when omitted
  PASS  createTask throws on empty title
  PASS  createTask throws on whitespace-only title
  PASS  addTask appends a new task without mutating the original array
  PASS  addTask preserves existing tasks when adding a new one
  PASS  updateTask changes only the targeted task
  PASS  updateTask does not mutate the original array or task objects
  PASS  updateTask is a no-op for an unknown id (does not throw)
  PASS  updateTask trims title/description passed via updates
  PASS  deleteTask removes only the targeted task
  PASS  deleteTask on unknown id returns an equivalent (but new) array
  PASS  toggleTaskStatus flips active -> completed
  PASS  toggleTaskStatus flips completed -> active
  PASS  toggleTaskStatus on unknown id returns the array unchanged
  PASS  filterTasks "all" returns every task
  PASS  filterTasks "active" returns only non-completed tasks
  PASS  filterTasks "completed" returns only completed tasks
  PASS  filterTasks with an unrecognized filter name falls back to "all"
  PASS  filterTasks on an empty list returns an empty list for every filter
  PASS  a task survives a JSON.stringify -> JSON.parse round trip unchanged
  PASS  a full task array survives a JSON round trip unchanged

24 passed, 0 failed (24 total)
```

`node tests/storage.test.js`:

```
storage.js test suite

  PASS  loadTasks returns an empty array when nothing has been saved yet
  PASS  saveTasks then loadTasks round-trips a task array correctly
  PASS  loadTasks returns an empty array (not a crash) when stored JSON is corrupted
  PASS  loadTasks returns an empty array when stored value is valid JSON but not an array
  PASS  saveTasks returns false and does not throw when localStorage.setItem fails

5 passed, 0 failed (5 total)
```

(Two `console.error` lines appear between the PASS lines above during the corrupted-JSON and quota-exceeded tests — that is the app's own error-path logging firing exactly as designed, not a test failure. Both suites report `0 failed`.)

**Total: 29 automated assertions/tests, all passing.**

### What's covered

- `createTask` shape, defaults, whitespace trimming, and rejecting empty titles.
- `addTask` / `updateTask` / `deleteTask` / `toggleTaskStatus` all treated as pure — verified they return **new** arrays and never mutate their inputs.
- `updateTask` / `deleteTask` / `toggleTaskStatus` behavior on an unknown id (should no-op, not throw).
- `filterTasks` for all three filter values, an unrecognized filter name, and an empty list.
- A task object (and a full task array) surviving a `JSON.stringify` → `JSON.parse` round trip unchanged — this is exactly what happens on every `localStorage` write/read.
- `storage.js`'s `loadTasks`/`saveTasks` against a mock `localStorage`: first-run empty state, round-tripping real data, corrupted JSON, wrong-shaped JSON (not an array), and a `setItem` throwing (simulating quota exceeded).

### What's intentionally NOT automated

DOM rendering, event wiring, and the native `confirm()` dialog are not covered by an automated test, since that would require a headless browser or a DOM-emulation library (jsdom, etc.) — an unjustified dependency for a project whose entire point is "runs with zero installed dependencies." These paths are covered by the manual checklist below instead.

## Manual Testing Checklist

Run through this checklist in an actual browser after opening `index.html` (or serving it via `python -m http.server`).

### Add task

- [ ] Type a title only (no description) and click **Add Task** — task appears in the list immediately.
- [ ] Type a title **and** a description — both appear on the task row.
- [ ] Try submitting with an empty title — the app shows an error message and does **not** add a blank task.
- [ ] Try submitting with a whitespace-only title (e.g. spaces only) — same rejection as empty.
- [ ] After a successful add, the form clears and focus returns to the title field.

### Edit task

- [ ] Click **Edit** on an existing task — its row turns into an inline form pre-filled with the current title/description.
- [ ] Change the title and/or description and click **Save** — the task row updates with the new values.
- [ ] Click **Edit**, change nothing, click **Cancel** — the row reverts to its normal (non-editing) display, no data lost.
- [ ] Try saving an edit with the title cleared to empty/whitespace — the browser shows a validation message and the edit is not saved.

### Delete task

- [ ] Click **Delete** on a task — a confirmation dialog appears.
- [ ] Click **Cancel** in the confirmation dialog — the task is **not** deleted.
- [ ] Click **OK**/confirm in the dialog — the task is removed from the list immediately.

### Mark complete / incomplete

- [ ] Click the checkbox on an active task — it becomes visually marked as completed (strikethrough) and moves correctly under the "Completed" filter.
- [ ] Click the checkbox again on a completed task — it reverts to active.

### Filter by status

- [ ] With a mix of active and completed tasks, click **All** — every task shows.
- [ ] Click **Active** — only non-completed tasks show.
- [ ] Click **Completed** — only completed tasks show.
- [ ] The active filter button is visually highlighted to match the current selection.
- [ ] The task count text (e.g. "2 active / 5 total") updates correctly for every action above, regardless of which filter is currently selected (the count always reflects **all** tasks, not just the filtered view).

### Persistence across reloads

- [ ] Add a few tasks, mark some complete, then reload the page (F5) — all tasks and their statuses are exactly as left.
- [ ] Close the browser tab entirely and reopen `index.html` — data still persists (this is `localStorage`, not `sessionStorage`, so it survives tab/browser closure).
- [ ] Open the browser's DevTools → Application/Storage → Local Storage, and confirm a `task-management-crud:tasks` key exists containing a JSON array matching what's on screen.

### Edge cases worth trying

- [ ] Add a task with a very long title/description (near the `maxlength` limits) — the UI doesn't break layout (text wraps).
- [ ] Add a task whose title contains HTML-like text, e.g. `<b>test</b>` — it should render as literal text, **not** as bold — this confirms the `escapeHtml` output-encoding in `render.js` is working.
- [ ] With zero tasks (or after filtering to a status with none), the "No tasks to show" empty-state message appears instead of a blank list.
