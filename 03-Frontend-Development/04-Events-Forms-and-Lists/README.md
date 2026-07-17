# 04 — Events, Forms, and Lists

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

- **Controlled inputs**: an input's `value` is driven by React state (`value={text}` + `onChange={e => setText(e.target.value)}`), rather than letting the DOM own it. This is what makes "clear the input after submit" as simple as `setText('')` — the DOM has no say in what it displays.
- **`event.preventDefault()`**: a form's default behavior is a full-page reload/navigation on submit; `handleSubmit` must call this before doing anything else, or every "Add" click would reload the page and lose all state.
- **Immutable list updates**: `toggleTodo`/`deleteTodo` use `.map()`/`.filter()`, which return *new* arrays, rather than mutating `todos` in place (e.g., `todos[i].done = true`). React decides whether to re-render by comparing state references; mutating in place would leave the reference unchanged and React would never notice.
- **Derived, data-based `key`s**: each todo gets a real unique `id` (`nextId++`) at creation time — never the array index — for the same reordering-safety reason established in Lesson 02.

## Files

- [`src/TodoApp.jsx`](src/TodoApp.jsx) — a small but complete add/toggle/delete todo list.
- [`src/TodoApp.test.jsx`](src/TodoApp.test.jsx) — 6 tests covering the empty state, adding, input-clearing, rejecting blank input, toggling, deleting, and todo independence.

## How to Run

```bash
cd 03-Frontend-Development/04-Events-Forms-and-Lists
npm install
npm test
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  6 passed (6)
```

Each test genuinely exercises real user interaction via `fireEvent` (typing into the controlled input, clicking Add/checkboxes/Delete), not just calling internal functions directly:

- The empty-state message is shown with zero todos, and reappears once the last todo is deleted (proving the transition works both directions, not just the initial render).
- Submitting a blank/whitespace-only value is genuinely rejected — the empty-state message is still shown afterward, confirming `trimmed === ''` actually short-circuits `handleSubmit` rather than just looking like it should in the source.
- The input's value is asserted to be `''` immediately after a successful add, proving the controlled-input clear actually happens rather than assuming it from the code.
- Two independent todos are added and only one is toggled, then both checkboxes' checked state is asserted — proving the `.map()` update targets the correct todo by `id` and doesn't accidentally affect siblings (a real risk if the update logic used an index instead of matching on `id`).

## Suggested Improvements / Next Steps

Continue to [05-Routing-and-Data-Fetching](../05-Routing-and-Data-Fetching/README.md) — multiple pages via React Router, and loading real data from a live API with the Fetch API (loading/error/success states).

**Previous lesson:** [03-State-and-Hooks](../03-State-and-Hooks/README.md)
