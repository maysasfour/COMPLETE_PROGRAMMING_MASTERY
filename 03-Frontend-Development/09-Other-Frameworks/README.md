# 09 — Other Frameworks: A Vue Comparison

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

React isn't the only way to build a frontend. This lesson rebuilds Lesson 04's exact `TodoApp` — same features, same edge cases — in **Vue 3** (Composition API), specifically so the two can be read side-by-side and the real differences (and real similarities) are concrete rather than abstract.

| Concept | React (Lesson 04) | Vue (this lesson) |
|---|---|---|
| Component definition | A JS function returning JSX | A `.vue` **Single-File Component**: `<script setup>` + `<template>` + (optionally) `<style>` in one file |
| Reactive state | `useState` returns `[value, setter]`; you call the setter | `ref()` returns an object with a `.value` property; you assign to `.value` directly — no setter function |
| Two-way input binding | Manual: `value={text}` + `onChange={e => setText(e.target.value)}` | `v-model="text"` — the framework wires both directions for you |
| Conditional rendering | `{condition && <X/>}` / ternary, in JS | `v-if`/`v-else` as template directives |
| List rendering | `.map()` returning JSX, `key` prop | `v-for="item in items" :key="item.id"` as a directive |
| Preventing default form submit | `event.preventDefault()` inside the handler | `@submit.prevent` — declared directly in the template, no handler code needed |
| Computed/derived values | Just a plain JS expression or a `useMemo` | `computed()` — cached, dependency-tracked automatically |

The **underlying ideas are identical** — components, reactive state, one-way data flow from state to rendered output, controlled inputs, keyed lists — only the syntax for expressing them differs. This is true across nearly every modern framework (React, Vue, Svelte, Angular all solve the same problems); learning a second one deeply mostly means learning its particular syntax and mental model for concepts you already understand.

## Files

- [`src/TodoApp.vue`](src/TodoApp.vue) — the Vue rewrite of Lesson 04's `TodoApp.jsx`.
- [`src/TodoApp.test.js`](src/TodoApp.test.js) — the same 5 behaviors tested, using `@vue/test-utils`'s `mount`/`wrapper.find()` instead of React Testing Library's `render`/`screen.getBy*`.

## How to Run

```bash
cd 03-Frontend-Development/09-Other-Frameworks
npm install
npm test          # Vitest + @vue/test-utils
npm run dev        # http://localhost:5173 (or next free port)
npm run build       # production build via Vite
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  5 passed (5)
```

```
$ npm run build
✓ 12 modules transformed.
dist/index.html                  0.46 kB
dist/assets/index-XqLm8CyC.js   63.44 kB │ gzip: 25.17 kB
✓ built in 607ms
```

**A real headless-Chromium screenshot** (via Playwright, the same tool used to verify Lesson 01) confirms the app genuinely renders and is interactive in an actual browser, not just in jsdom — the "New task" input, Add button, and "No tasks yet." empty state are all visibly present and correctly styled by Vue's own default component styling.

## An Honest Gap: Angular

This lesson does **not** include an equivalent Angular example. Angular is a substantially larger framework (its own CLI, dependency injection system, RxJS-based patterns, TypeScript-first, a different module/component registration model) — a genuinely representative Angular example would be a lesson of its own rather than a quick side-by-side, and building one shallowly would misrepresent what using Angular for real actually involves. This gap is recorded honestly here (and in this repository's `BUILD_STATUS.md`) rather than papered over with a token example, consistent with this repository's practice of disclosing scope limits rather than hiding them.

## Suggested Improvements / Next Steps

This is the last framework-comparison lesson. Continue to the [Mini-Project](../Mini-Project/README.md) — a small but complete React app combining routing, data fetching, Context/reducer state management, and tests, drawing on everything from Lessons 01–07 together in one place.

**Previous lesson:** [08-Next.js-Fundamentals](../08-Next.js-Fundamentals/README.md)
