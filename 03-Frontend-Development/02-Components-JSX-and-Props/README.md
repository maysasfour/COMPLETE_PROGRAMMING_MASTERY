# 02 — Components, JSX, and Props

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

- **JSX** is not HTML — it's syntax sugar that compiles to `React.createElement(...)` calls. `{expression}` embeds any JavaScript value; there is no special "if" syntax, because JSX is just expressions, and `if` is a statement, not an expression.
- **Components are functions.** A component is just a function that returns JSX. React calls it, gets back a description of UI, and reconciles that against what's already on screen.
- **Props** are a single object passed as the function's argument — read-only from the component's own point of view. Destructuring in the parameter list (`{ name, timeOfDay = 'day' }`) is the idiomatic way to both extract values and document defaults in one place.
- **Conditional rendering** has two common forms, each suited to a different case: `condition && <Thing />` (renders nothing when false — but only safe when the condition can never be a "falsy but meaningful" value like `0`) versus `condition ? <A /> : <B />` (needed whenever there's a real else-branch).
- **`children`** is a special prop: whatever JSX is nested between a component's opening and closing tags is passed to it automatically as `props.children`.
- **List rendering and `key`**: `.map()` over an array of data produces an array of elements; each needs a stable `key` drawn from the *data* (an ID), never the array index — an index-based key is wrong the moment the list is reordered or an item is removed from the middle, because React uses `key` to match old elements to new ones across a re-render, not just to render them in order.

## Files

- [`src/Greeting.jsx`](src/Greeting.jsx) — the simplest possible component: props in, JSX out, with a default prop value.
- [`src/ProductCard.jsx`](src/ProductCard.jsx) — both conditional-rendering forms, plus `children`.
- [`src/ProductList.jsx`](src/ProductList.jsx) — `.map()` rendering with a data-derived `key`, plus an empty-state branch.
- [`src/components.test.jsx`](src/components.test.jsx) — real, executed tests for all three, using React Testing Library against a real DOM (jsdom).

## How to Run

```bash
cd 03-Frontend-Development/02-Components-JSX-and-Props
npm install
npm test
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  7 passed (7)
```

Specifically, the 7 tests genuinely exercise (not just assert-in-theory):
- `Greeting` renders the passed `name` and `timeOfDay`, and correctly falls back to the default `timeOfDay="day"` when the prop is omitted.
- `ProductCard` shows the in-stock badge and "Ready to ship" when `inStock={true}`, and correctly *hides* the badge (verified with `queryByTestId` returning null, not just "doesn't crash") and shows "Currently unavailable" when `inStock={false}`.
- `ProductCard`'s `children`-driven description block is present when children are passed, and genuinely absent (`container.querySelector` returns `null`) when they aren't — proving the `children && ...` guard actually works both ways, not just the happy path.
- `ProductList` renders one card per product with the correct `key`s, and renders a `role="status"` empty-state message with zero list items when given an empty array — the actual empty-list branch was executed and checked, not assumed.

## Suggested Improvements / Next Steps

Continue to [03-State-and-Hooks](../03-State-and-Hooks/README.md) — these components are all "dumb" (props in, JSX out, no internal state). The next lesson introduces `useState` and `useEffect`, the two hooks that let a component hold and react to its own changing data.

**Previous lesson:** [01-Setup-and-Tooling](../01-Setup-and-Tooling/README.md)
