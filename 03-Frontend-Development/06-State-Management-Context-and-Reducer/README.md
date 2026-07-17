# 06 — State Management: Context and Reducer

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

- **`useReducer`**: for state whose valid transitions are more complex than a single `setX(newValue)` call — a shopping cart's "add item" needs to check whether the item already exists and either append it or increment its quantity, which is easy to get inconsistent across scattered `useState` calls. A reducer (`(state, action) => newState`) centralizes every valid transition in one place, and — because it's a **pure function** with no rendering involved — it can be unit-tested directly with zero component rendering at all (`cartReducer.test.js`).
- **Immutability in a reducer matters even more than in Lesson 04's list updates**: `cartReducer.test.js` explicitly asserts the *original* state object's `items` array reference is untouched after a dispatch — proving the reducer returns a new object rather than mutating in place, which is what allows React (and tools like Redux DevTools, in real apps) to correctly detect that state changed.
- **Context, and the problem it solves**: `ProductGrid` and `CartSummary` are unrelated siblings — neither is the other's parent or child — yet both need the same cart state. Passing it via props would mean "prop drilling" it through whatever component happens to sit between them in the tree, even if that component has no use for it itself. `CartProvider` + `useCart()` lets both read and dispatch to the *same* state with zero props passed between them.
- **A custom hook that validates its own preconditions**: `useCart()` throws a clear, actionable error ("useCart must be used within a CartProvider") if called outside a `<CartProvider>`, rather than letting the mistake surface later as a confusing "cannot read properties of null" deep inside `state.items`.

## Files

- [`src/cartReducer.js`](src/cartReducer.js) — the pure reducer function and a `cartTotal` selector.
- [`src/CartContext.jsx`](src/CartContext.jsx) — the Context provider and the `useCart` hook.
- [`src/ProductGrid.jsx`](src/ProductGrid.jsx), [`src/CartSummary.jsx`](src/CartSummary.jsx) — two unrelated sibling components sharing state only through Context.
- [`src/cartReducer.test.js`](src/cartReducer.test.js) — pure-function unit tests, no rendering.
- [`src/CartIntegration.test.jsx`](src/CartIntegration.test.jsx) — the actual cross-sibling state-sharing proof, plus the "used outside provider" error check.

## How to Run

```bash
cd 03-Frontend-Development/06-State-Management-Context-and-Reducer
npm install
npm test
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  2 passed (2)
      Tests  9 passed (9)
```

The most important test in this lesson isn't a reducer test — it's `CartIntegration.test.jsx`'s first test, which renders `<ProductGrid />` and `<CartSummary />` as siblings under one `<CartProvider>`, clicks "Add to cart" *inside `ProductGrid`*, and asserts the total updates *inside `CartSummary`* — two components with no parent/child relationship and no props passed between them, genuinely sharing state through Context alone. It also exercises "Clear cart" and confirms the empty-state message correctly reappears.

The reducer's immutability test is worth calling out specifically: it captures a reference to the original `items` array *before* dispatching, dispatches an `ADD_ITEM` action, and then asserts the original reference is `toBe` (identity-equal) unchanged while the new state's `items` is a genuinely different array — this is checking the actual object identity, not just the values, which is what would catch a reducer that accidentally used `.push()` instead of returning a new array.

## Suggested Improvements / Next Steps

Continue to [07-Testing](../07-Testing/README.md) — this lesson already leaned heavily on Vitest + React Testing Library; that lesson makes the testing approach itself the explicit subject, covering what's been used implicitly throughout (queries, `fireEvent` vs. `userEvent`, mocking, and what NOT to test).

**Previous lesson:** [05-Routing-and-Data-Fetching](../05-Routing-and-Data-Fetching/README.md)
