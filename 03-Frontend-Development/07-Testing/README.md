# 07 — Testing

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

Earlier lessons already used React Testing Library + Vitest throughout; this lesson makes the *testing approach itself* the subject, and — more usefully — documents two genuine tool-interaction gotchas hit while writing it, rather than only showing the version where everything already works.

- **Query priority**: Testing Library recommends `getByRole` > `getByLabelText` > `getByPlaceholderText` > `getByText` > `getByTestId`, in that order of preference. `getByRole` is preferred not out of pedantry but because it only passes if the element is *actually* exposed with the right accessible role — the same way a screen reader or keyboard-only user would find it. A `getByTestId` query would happily pass even on a `<div>` with `onClick` and no semantic role at all, silently hiding a real accessibility bug that `getByRole` would have caught.
- **`userEvent` vs `fireEvent`**: `fireEvent.change(input, { target: { value } })` sets a value in one synchronous step. `userEvent.type(input, 'text')` simulates the actual sequence of `keydown`/`keypress`/`input`/`keyup` events per character — closer to what a real user's browser actually dispatches, and necessary whenever a component's behavior depends on that finer-grained event sequence (not needed here, but the debounce tests below intentionally use both, and the README explains exactly why).
- **Mocking**: `vi.fn()` stands in for the `onSearch` prop, letting tests assert *how many times* and *with what arguments* it was called — proving the debounce coalesces rapid input into a single call, not five.
- **Test the behavior, not the implementation**: every assertion in `SearchBox.test.jsx` checks what `onSearch` was called with — never the internal `query`/`debouncedQuery` state variables directly. A future refactor that renames those variables, or splits the debounce into a different internal shape, should not break these tests as long as the *observable* behavior (debounced calls with the right value) stays the same.

## Two Real Gotchas Found While Writing This Lesson

**1. `userEvent` + Vitest fake timers genuinely hung.** The first version of the debounce tests used `userEvent.setup({ delay: null, advanceTimers: vi.advanceTimersByTime })` — the documented pattern for combining the two — and three tests hit the 5000ms test timeout every single run rather than failing an assertion. Rather than debug the interaction further, this lesson splits the two concerns: one test uses `userEvent` with **real** timers (a short `delayMs=20` keeps it fast) to prove realistic typing works at all; the rest use `fireEvent` (a simpler, synchronous API) together with fake timers, where precise control over elapsed time is the actual point.

**2. `vi.advanceTimersByTime()` needed `act()` around it.** Without wrapping it — `act(() => vi.advanceTimersByTime(300))` instead of a bare call — React logged "An update to SearchBox inside a test was not wrapped in act(...)" and, worse, the assertions that followed saw the *pre*-update state (`onSearch` reported as called 0 times instead of 1). This is the same underlying issue Lesson 03 hit with a raw `.click()`: React needs `act()` around anything that triggers a state update, including a fake-timer advance that fires a `setTimeout` callback which calls `setDebounced`, not just around direct user events.

## Files

- [`src/useDebouncedValue.js`](src/useDebouncedValue.js), [`src/SearchBox.jsx`](src/SearchBox.jsx) — the component under test.
- [`src/SearchBox.test.jsx`](src/SearchBox.test.jsx) — query-priority, realistic-typing, and precise-timing tests, with both gotchas above documented inline as comments at the point they matter.

## How to Run

```bash
cd 03-Frontend-Development/07-Testing
npm install
npm test
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  6 passed (6)
```

Specifically: `onSearch` is proven to fire zero times before `delayMs` elapses, exactly once (not once per keystroke) after it does, with the complete final string; a two-keystroke sequence 200ms apart is proven to reset the debounce timer rather than fire early off the first keystroke; and an empty/whitespace query is proven to never trigger a call at all.

## Suggested Improvements / Next Steps

Continue to [08-Next.js-Fundamentals](../08-Next.js-Fundamentals/README.md) — a framework built on top of React that adds file-based routing and server-side rendering, changing where and when the component code from these first seven lessons actually executes.

**Previous lesson:** [06-State-Management-Context-and-Reducer](../06-State-Management-Context-and-Reducer/README.md)
