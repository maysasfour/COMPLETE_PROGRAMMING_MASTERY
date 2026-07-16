# Task Management CRUD

A complete, runnable **Create / Read / Update / Delete** task manager built with plain HTML, CSS, and JavaScript — no frameworks, no build step, no backend. Data is persisted in the browser's `localStorage`.

This project is the reference implementation described in [`CONTRIBUTING.md`](../../../CONTRIBUTING.md) ("Adding a New Project"): requirements, architecture, ER diagram, implementation, and a testing plan.

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [User Stories](#user-stories)
- [Technology Stack](#technology-stack)
- [Folder Structure](#folder-structure)
- [How to Run](#how-to-run)
- [Manual Testing Checklist](#manual-testing-checklist)
- [Automated Tests](#automated-tests)
- [Security Note](#security-note)
- [Suggested Improvements](#suggested-improvements)

## Overview

The app lets a single user manage a personal to-do list: add tasks with a title and optional description, mark them complete, edit or delete them, and filter the list by status. All data lives entirely in the browser — there is no server, no database, and no network request anywhere in the app.

## Requirements

**Functional requirements**

- Create a task with a required title and an optional description.
- Read (list) all tasks.
- Update a task's title/description via an inline edit form.
- Delete a task, with a confirmation prompt before it's removed.
- Toggle a task between "active" and "completed".
- Filter the visible list by **All / Active / Completed**.

**Non-functional requirements**

- **Works offline.** Once the page is loaded, no network connection is required — there are no external scripts, fonts, or API calls.
- **No backend needed.** Persistence uses `window.localStorage`; the app is fully usable by opening `index.html` as a local file.
- **No build step.** No bundler, transpiler, or package manager is required to run the app.

## User Stories

- As a user, I want to add a task with just a title, so I can quickly capture something without friction.
- As a user, I want to optionally add a description, so I can note extra detail when it matters.
- As a user, I want to mark a task complete/incomplete, so I can track progress.
- As a user, I want to edit a task's title or description, so I can fix typos or add detail later.
- As a user, I want to delete a task with a confirmation step, so I don't lose data to a misclick.
- As a user, I want to filter by All/Active/Completed, so I can focus on what's left to do.
- As a user, I want my tasks to still be there after I reload or close and reopen the page, so the app is actually useful day-to-day.

## Technology Stack

| Layer         | Choice                      | Why |
|---------------|------------------------------|-----|
| Structure     | Plain HTML5                  | No templating engine needed for one screen; keeps the project runnable with zero tooling. |
| Styling       | Plain CSS3 (custom properties)| A single stylesheet is enough at this scale; CSS variables give theme-able colors without a preprocessor. |
| Behavior      | Vanilla JavaScript (ES6+)    | Demonstrates CRUD fundamentals without a framework's abstractions getting in the way — the point of a *beginner* project. |
| Persistence   | `window.localStorage`        | Zero-config, synchronous, built into every browser — no server process to run. |
| Testing       | Plain Node.js `assert` scripts | No test framework dependency; runs with `node`, which is already required for nothing else in this project (it's optional — the app itself needs no Node at runtime). |

## Folder Structure

```
Task-Management-CRUD/
├── index.html              # Single HTML page — structure + script/style includes
├── css/
│   └── style.css           # All styles (reset, layout, components, responsive)
├── js/
│   ├── taskLogic.js         # Pure functions: create/add/update/delete/toggle/filter tasks
│   ├── storage.js           # localStorage read/write, isolated behind loadTasks()/saveTasks()
│   ├── state.js             # In-memory store: wraps taskLogic + storage, notifies subscribers
│   ├── render.js             # All DOM-writing code (task list, filters, counts)
│   ├── events.js             # Event listeners; translates user actions into State calls
│   └── main.js               # Entry point / startup landmark
├── tests/
│   ├── taskLogic.test.js     # Node-runnable unit tests for the pure logic module
│   └── storage.test.js        # Node-runnable tests for storage.js against a mock localStorage
├── README.md                # This file
├── ARCHITECTURE.md          # Component/data-flow diagram + Task data model (Mermaid)
└── TESTING.md                # Manual test plan + automated test instructions
```

## How to Run

No installation, no build, no server required.

**Option A — open directly:**

Double-click `index.html`, or open it via your browser's File > Open dialog. Because the app uses classic `<script>` tags (not ES module `import`s) with all state exposed through `window`, this works even from a `file://` URL, where some browsers restrict ES modules.

**Option B — trivial static server (optional, e.g. if your browser blocks `file://` localStorage for some other reason):**

```bash
cd 22-Projects/Beginner/Task-Management-CRUD
python -m http.server
# then visit http://localhost:8000
```

## Manual Testing Checklist

See [`TESTING.md`](TESTING.md) for the full checklist. Summary:

- [ ] Add a task (title only, and title + description)
- [ ] Attempt to add a task with an empty/whitespace title (should be rejected with a message)
- [ ] Edit a task's title and description
- [ ] Cancel an in-progress edit (change is discarded)
- [ ] Delete a task (confirm prompt appears; canceling the prompt keeps the task)
- [ ] Mark a task complete, then incomplete again
- [ ] Filter by All / Active / Completed and confirm the right tasks show
- [ ] Reload the page and confirm all tasks and their statuses persisted

## Automated Tests

The task-mutation logic (`js/taskLogic.js`) and the storage layer (`js/storage.js`) are written as plain functions with no DOM dependency, so they can be tested directly with Node — no browser, no test framework, no build step:

```bash
cd 22-Projects/Beginner/Task-Management-CRUD
node tests/taskLogic.test.js
node tests/storage.test.js
```

Both scripts print a `PASS`/`FAIL` line per test and exit with a non-zero code if anything fails, so they're CI-friendly as-is. See [`TESTING.md`](TESTING.md) for full output and what each test covers.

## Security Note

**`localStorage` is not a security boundary.** This app stores everything in plain text in the browser, and that has real implications:

- Any JavaScript running on the same page/origin (including a malicious browser extension, or an XSS payload if this code were ever merged with less-careful code) can read and modify all stored tasks.
- Data is per-browser, per-device. It is not shared across devices, not backed up, and is permanently lost if the user clears site data.
- There is no authentication, no authorization, and no concept of "whose task is this" — this is fundamentally single-user, single-device software.
- The app does perform basic output-encoding (`escapeHtml` in `render.js`) before inserting task titles/descriptions into the DOM, to prevent a task's *content* from being interpreted as HTML/script. That protects against a stored-XSS-via-task-text scenario, but it does not change the fact that `localStorage` itself has no access control.

**What would change for a real backend:** a production version would move persistence to a server (e.g. `04-Backend-Development` stack of choice) with a real database, add authentication (so tasks belong to a specific user), and use HTTPS + server-side input validation. `js/storage.js` is deliberately the *only* file that talks to the persistence layer — swapping it for a `fetch()`-based API client is the intended extension point (see below), and none of `state.js`, `render.js`, or `events.js` would need to change.

## Suggested Improvements

- Swap `storage.js` for a REST API client (`fetch` calls to a real backend) — see other stack variants once built elsewhere in this repository (e.g. under `04-Backend-Development`) for server implementations this could pair with.
- Add due dates / priority levels to the task model.
- Add drag-and-drop reordering.
- Add multi-user support with real authentication once paired with a backend.
- Add a "clear completed" bulk action.
- Persist the active filter itself (not just the tasks) across reloads.
