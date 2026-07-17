# 05 — Routing and Data Fetching

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

- **Client-side routing** (`react-router-dom`): `<Routes>`/`<Route>` map URL paths to components entirely in the browser, without a full page reload. `path="/users/:id"` declares a dynamic segment; `useParams()` inside `UserDetail` reads it back out (`params.id`).
- **The Fetch API's three-state pattern**: every real data-fetching component needs `loading` / `error` / `data` states, because a network request is asynchronous and can fail — `useFetch.js` wraps this pattern once so `UserList`/`UserDetail` don't each reimplement it.
- **`AbortController` cleanup**: the same cleanup-function idea from Lesson 03's `Stopwatch`, applied to `fetch`. If the URL changes (e.g., navigating from `/users/1` to `/users/2`) before the first request resolves, the effect's cleanup aborts the now-stale request — without this, a slow first response arriving *after* a fast second one could overwrite fresh data with stale data.
- **Mocked unit tests vs. one real integration check**: `App.test.jsx` mocks `global.fetch` for fast, deterministic tests (no network dependency, no flakiness); `verify-live-fetch.mjs` is a separate, genuinely-executed script that calls the real `jsonplaceholder.typicode.com` API — the same public test API already used elsewhere in this repository (`01-Languages/JavaScript`, `01-Languages/Java`, etc.) — proving the integration actually works end-to-end, not just against a mock that could drift from the real API's shape.

## Files

- [`src/useFetch.js`](src/useFetch.js) — the reusable data-fetching hook.
- [`src/UserList.jsx`](src/UserList.jsx), [`src/UserDetail.jsx`](src/UserDetail.jsx) — list/detail pages.
- [`src/App.jsx`](src/App.jsx) — route definitions.
- [`src/App.test.jsx`](src/App.test.jsx) — mocked-fetch tests for loading/error/success states and routing.
- [`verify-live-fetch.mjs`](verify-live-fetch.mjs) — a real, live network call, run separately from the test suite.

## How to Run

```bash
cd 03-Frontend-Development/05-Routing-and-Data-Fetching
npm install
npm test                    # fast, mocked unit tests
node verify-live-fetch.mjs   # one real network call against the live API
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  4 passed (4)
```

- Loading state renders first (`role="status"`, "Loading users..."), then flips to the real list once the mocked promise resolves — the test asserts on both states in sequence, not just the final one.
- A `500` mock response is asserted to produce `role="alert"` with the exact error text `Failed to load users: Request failed: 500`, proving the `!response.ok` branch in `useFetch` is actually reached, not just present in the source.
- The detail route is rendered directly (`MemoryRouter initialEntries={['/users/1']}`) and asserted to call `fetch` with the URL built from `useParams()`'s `id` — proving the dynamic route segment genuinely flows into the fetch call.
- An unmatched path renders the catch-all `*` route's "Page not found." message.

```
$ node verify-live-fetch.mjs
Real live API response: {"id": 1, "name": "Leanne Graham", ...}
PASS: live fetch returned a real user with the expected shape.
```

## Suggested Improvements / Next Steps

Continue to [06-State-Management-Context-and-Reducer](../06-State-Management-Context-and-Reducer/README.md) — sharing state across components that aren't directly related (Context) and managing more complex state transitions predictably (`useReducer`), for when `useState` alone starts to feel unwieldy.

**Previous lesson:** [04-Events-Forms-and-Lists](../04-Events-Forms-and-Lists/README.md)
