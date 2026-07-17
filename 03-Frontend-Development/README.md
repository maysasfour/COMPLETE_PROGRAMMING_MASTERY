# 03 — Frontend Development

[Back to repository root](../README.md)

## What This Module Covers

Modern frontend framework development, built in **JavaScript/JSX** — the domain's native language. Unlike most other root modules in this repository (which default to Java per this repository's language preference where a choice exists), frontend frameworks like React, Next.js, and Vue are inherently JavaScript/TypeScript ecosystems; this repository's own `01-Languages/JavaScript` and `01-Languages/TypeScript` courses already cover the underlying language in depth, so this module builds directly on top of that rather than reframing the domain around a different language.

This module goes **deep on React** (Lessons 01–07) as the representative framework — the same "one framework in depth, rather than shallow coverage of many" choice this repository already made for desktop development (JavaFX, not WPF+Electron+Tauri equally) and mobile development (Android/Java, not iOS+Flutter+React Native equally) — then extends into **Next.js** (a framework built on React) and a **brief, honest Vue comparison**, before a capstone Mini-Project combining everything.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup and Tooling](01-Setup-and-Tooling/README.md) | Vite, npm scripts, project structure — verified with a real headless-browser (Playwright) render and click. |
| 02 | [Components, JSX, and Props](02-Components-JSX-and-Props/README.md) | Components as functions, prop destructuring, conditional rendering, `children`, list rendering with `key`. |
| 03 | [State and Hooks](03-State-and-Hooks/README.md) | `useState`, custom hooks, `useEffect` with cleanup — including a real proof that cleanup actually stops a leaked interval. |
| 04 | [Events, Forms, and Lists](04-Events-Forms-and-Lists/README.md) | Controlled inputs, `preventDefault`, immutable list updates — a small but complete add/toggle/delete todo app. |
| 05 | [Routing and Data Fetching](05-Routing-and-Data-Fetching/README.md) | `react-router-dom`, the Fetch API's loading/error/data pattern, `AbortController` — verified against both mocked and the real live `jsonplaceholder.typicode.com` API. |
| 06 | [State Management: Context and Reducer](06-State-Management-Context-and-Reducer/README.md) | `useReducer` for complex state transitions, `Context` for sharing state between unrelated sibling components — a shopping cart. |
| 07 | [Testing](07-Testing/README.md) | Query priority, `userEvent` vs. `fireEvent`, mocking, testing behavior not implementation — including two real, documented tool-interaction gotchas found and fixed live. |
| 08 | [Next.js Fundamentals](08-Next.js-Fundamentals/README.md) | File-based routing, Server Components, Route Handlers — including a real breaking-change gotcha (`params` is now a `Promise`) caught by reading the framework's own bundled docs before writing code. |
| 09 | [Other Frameworks: A Vue Comparison](09-Other-Frameworks/README.md) | The same todo app rebuilt in Vue 3, side-by-side with its React equivalent, plus an honest disclosure of Angular as an out-of-scope gap. |
| — | [Mini-Project](Mini-Project/README.md) | A small product store combining routing, live data fetching, Context+reducer cart state, and tests — including a real bug (a React StrictMode/`useFetch` interaction) found and fixed during manual browser verification. |

## Verification Discipline

Every lesson's code was actually run, not just written:

- **Lessons 02–07 and the Mini-Project**: Vitest + React Testing Library (jsdom), with every test genuinely executed and its real pass/fail output captured in that lesson's README — including several **real bugs found and fixed while writing the tests themselves** (a raw `.click()` bypassing React's `act()` wrapping in Lesson 03; `userEvent` genuinely hanging when combined with Vitest fake timers in Lesson 07, worked around rather than hidden; a StrictMode double-effect race in the Mini-Project's `useFetch`, caught only because the app was also checked in a real browser, not just against mocks).
- **Lesson 01, 09, and the Mini-Project**: also verified with a real headless Chromium browser (Playwright) — actual screenshots, actual clicks, actual state updates observed — the same standard of "show it genuinely running" this repository already applied to JavaFX windows and Android emulator screenshots, adapted to the web.
- **Lesson 08**: verified with real `curl` requests against an actually-running Next.js production server, confirming server-rendered HTML contains real fetched data with no browser/JS execution required at all — deliberately contrasted against Lesson 01's client-rendered SPA, where `curl` only ever returns an empty shell.
- **Lesson 05 and the Mini-Project**: also checked against the real, live `jsonplaceholder.typicode.com` and `fakestoreapi.com` public APIs (not just mocks), via small standalone verification scripts separate from the mocked test suite.

## An Honest Scope Note

This module does not attempt equal-depth coverage of every frontend framework in existence. Angular specifically is disclosed as out of scope (see [09-Other-Frameworks](09-Other-Frameworks/README.md#an-honest-gap-angular)) — it's a substantially larger, more opinionated framework (its own CLI, DI system, RxJS-first patterns) where a genuinely representative example would be a full lesson, not a quick comparison, and a shallow one would misrepresent what using it for real involves.

**Previous module:** [02-Markup-and-Styling](../02-Markup-and-Styling/README.md)
**Next module:** [04-Backend-Development](../04-Backend-Development/README.md)
