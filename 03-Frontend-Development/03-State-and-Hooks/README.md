# 03 — State and Hooks

[Back to 03-Frontend-Development](../README.md)

## What This Lesson Covers

- **`useState`** gives a component its own piece of data that survives re-renders, plus a setter that schedules a re-render when called. The **functional update form** — `setCount(c => c + step)` instead of `setCount(count + step)` — matters whenever a new update needs to see the *latest* value rather than the value captured by the closure when the handler was created (important once multiple updates can be queued in quick succession).
- **Custom hooks** are just regular functions that call other hooks; the `use` prefix is a convention (React's linter rules rely on it), not special syntax. `useCounter.js` extracts `Counter.jsx`'s state logic so it can be tested in complete isolation from any rendered UI, via `renderHook`.
- **`useEffect`** runs a side effect after render, and its **cleanup function** (the function an effect returns) runs before the effect re-runs and when the component unmounts. `Stopwatch.jsx` uses this for a `setInterval`/`clearInterval` pair — without the cleanup, the interval would keep firing forever after the component is gone, silently leaking.

## Files

- [`src/Counter.jsx`](src/Counter.jsx) — `useState` with the functional-update form.
- [`src/useCounter.js`](src/useCounter.js) — the same logic extracted into a reusable custom hook.
- [`src/Stopwatch.jsx`](src/Stopwatch.jsx) — `useEffect` with a real timer and cleanup.
- [`src/hooks.test.jsx`](src/hooks.test.jsx) — all three, genuinely exercised.

## How to Run

```bash
cd 03-Frontend-Development/03-State-and-Hooks
npm install
npm test
```

## Verified Behavior (Real Output)

```
$ npx vitest run

 Test Files  1 passed (1)
      Tests  5 passed (5)
```

**A real bug was found and fixed while writing this lesson's tests**, worth keeping rather than hiding: the first version of the `Counter` test dispatched clicks with a raw DOM `.click()` call. That genuinely failed — the assertion saw the *pre-click* count (`10` instead of the expected `15`) because a raw `.click()` doesn't go through React Testing Library's `act()` wrapping, so the state update hadn't been flushed yet when the very next line asserted on it. The fix was switching to `fireEvent.click(...)`, which wraps the dispatched event in `act()` and flushes the update synchronously first. This is left in the test file's own comment as a documented gotcha, not smoothed over.

**The `Stopwatch` cleanup proof** is the more interesting test: using `vi.useFakeTimers()`, it renders the stopwatch, advances fake time by 2 seconds, unmounts the component, spies on `clearInterval` to confirm it was actually called, and then advances fake time by another 5 seconds *after* unmount to prove nothing throws or silently keeps ticking. This is a genuine regression test for the single most common `useEffect` bug (a leaked interval/subscription after unmount) rather than just checking the happy path.

## Suggested Improvements / Next Steps

Continue to [04-Events-Forms-and-Lists](../04-Events-Forms-and-Lists/README.md) — controlled form inputs, event handling, and dynamic lists (add/remove/edit items), building directly on the `useState` patterns established here.

**Previous lesson:** [02-Components-JSX-and-Props](../02-Components-JSX-and-Props/README.md)
