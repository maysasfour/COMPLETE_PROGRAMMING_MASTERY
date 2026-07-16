# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Apply a consistent, defensible style across variables, equality, functions, and async code.
- Recognize and avoid the specific footguns covered throughout lessons 01–18, collected here as one reference.
- Know what a linter/formatter (ESLint/Prettier) automates versus what still requires human judgment.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material.

## Style and Naming

- `camelCase` for variables and functions; `PascalCase` for classes; `UPPER_SNAKE_CASE` for true constants meant to signal "this never changes and is conceptually global" (e.g., `const MAX_RETRIES = 3;`), though plain `camelCase const` is equally acceptable for most local constants.
- Default to `const`; use `let` only when reassignment is required; never use `var` in new code (Lesson 03).
- Always use `===`/`!==`, never `==`/`!=` (Lesson 04).

## Functions

- Prefer arrow functions for callbacks (predictable `this`); prefer named `function` declarations for top-level, reusable functions (Lesson 06).
- Keep functions small and single-purpose; a function that needs a long comment explaining what it does as a whole is usually a signal it should be split.
- Use default parameters instead of `param = param || fallback` (the latter incorrectly overrides falsy-but-valid values like `0`, per Lesson 04).

## Error Handling

- Always throw `Error` or a subclass, never a bare string/object (Lesson 09).
- Never leave an empty `catch {}` block silently swallowing errors; catch what you can handle, re-throw the rest.
- Wrap `await`ed calls in `try`/`catch` where a rejection is possible and meaningful to handle locally.

## Async Code

- Use `Promise.all` for independent async operations instead of serializing them with sequential `await` (Lesson 14) — this is one of the highest-value, easiest performance wins in real Node code.
- Never leave a Promise rejection unhandled — always `.catch()` or wrap in `try`/`catch`.
- Prefer `async`/`await` over raw `.then()` chains for anything beyond a single step.

## Collections and Data

- Prefer `map`/`filter`/`reduce` for transforming arrays over manual loops, reserving loops for cases needing early exit or side effects (Lesson 07).
- Remember spread/destructuring copies are shallow — a "copy" still shares nested objects with the original unless you deep-clone deliberately.
- Use `Map`/`Set` when keys aren't naturally strings, or when guaranteed uniqueness/insertion order matters.

## What a Linter/Formatter Automates vs. What It Doesn't

```json
// .eslintrc.json (illustrative) -- catches real bugs, not just style
{
  "extends": "eslint:recommended",
  "rules": {
    "eqeqeq": "error",
    "no-var": "error",
    "no-unused-vars": "warn"
  }
}
```

**ESLint** catches real correctness issues (`==` usage, unreachable code, unused variables that likely indicate a bug) as well as enforceable style rules. **Prettier** formats code (indentation, quote style, line length) with zero configuration debate — the two are typically used together, Prettier for formatting, ESLint for everything else. Neither can catch a *logically* wrong-but-syntactically-fine mistake (e.g., a correct-looking function that computes the wrong formula) — that's still the job of tests (Lesson 18) and code review.

## Detailed Example

See [example.js](example.js) — a single file directly contrasting a "before" version riddled with several mistakes from earlier lessons against an "after" version applying this lesson's practices, both producing the same correct output, verified to actually run identically.

## Expected Output

Running `node example.js` prints identical correct results from both the "before" (bad-practice) and "after" (best-practice) implementations of the same small task, demonstrating that the best-practice version isn't just stylistically nicer — it's also more correct on an edge case the "before" version gets wrong (a falsy-but-valid default value).

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" sections apply here collectively — this lesson doesn't introduce new footguns, it collects the recurring ones: `==` instead of `===`, `var` instead of `let`/`const`, `||` instead of `??` for falsy-but-valid defaults, unhandled Promise rejections, sequential `await` for independent work, empty `catch` blocks, and shallow-copy surprises.

## Best Practices (Meta)

- Automate what can be automated (ESLint + Prettier, run in CI and/or a pre-commit hook — see [17-Git-and-GitHub](../../../17-Git-and-GitHub/) and [18-DevOps-and-Cloud](../../../18-DevOps-and-Cloud/)) so code review time is spent on logic and design, not spacing arguments.
- Write tests (Lesson 18) for behavior that matters, especially edge cases (falsy-but-valid values, empty collections, error paths) — a linter cannot catch a wrong formula, only a test can.
- Prefer boring, explicit code over clever one-liners in a shared codebase; the "cleverest" version of a function is rarely the easiest for the next person (including future you) to modify safely.

## Real-World Usage

Every production JavaScript/Node codebase covered later in this repository ([03-Frontend-Development](../../../03-Frontend-Development/), [04-Backend-Development](../../../04-Backend-Development/)) assumes exactly these conventions as a baseline; interview take-home projects and code review at most companies will flag `var`, `==`, and unhandled rejections as immediate red flags.

## Summary

- This lesson has no new syntax — it's a checklist synthesizing lessons 01–18's individual "best practices" sections into one reference.
- ESLint catches real bugs and enforces style; Prettier formats; neither replaces tests or code review for logical correctness.
- The recurring theme across every lesson: prefer the explicit, non-coercing, non-mutating option (`const` over `var`, `===` over `==`, `??` over `||` for defaults, `Promise.all` over sequential `await`) whenever it's available.

## Key Terms

- **Linter** — a tool (ESLint) that statically analyzes code for likely bugs and style violations.
- **Formatter** — a tool (Prettier) that automatically rewrites code to a consistent visual style, removing formatting debates.

## Interview Questions

1. **What's the difference between what a linter and a formatter each do?**
   A formatter (Prettier) rewrites code to a consistent visual style — indentation, quote style, line breaks — with no opinion on logic. A linter (ESLint) analyzes code for likely bugs and enforceable patterns (unused variables, `==` usage, unreachable code) and can flag or auto-fix many of them; neither tool can verify that a function's actual logic produces the mathematically/business-correct result — that's what tests and code review are for.

2. **Name three JavaScript-specific best practices this course has emphasized and briefly justify each.**
   (1) Prefer `===`/`!==` over `==`/`!=` — avoids type-coercion surprises. (2) Use `??` instead of `||` for defaults when `0`/`""`/`false` are legitimate values — `||` incorrectly overrides them. (3) Use `Promise.all` for independent async operations instead of serial `await` — dramatically reduces wall-clock time with no added complexity.

## Recommended Next Lesson

This completes the core JavaScript course (lessons 01–19). Lessons 20–22 (Exercises, Solutions, Mini-Projects as standalone cross-cutting folders) are not yet built — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). From here, continue to [03-Frontend-Development](../../../03-Frontend-Development/) to apply this foundation with the DOM and browser APIs, or [04-Backend-Development](../../../04-Backend-Development/) to build a real server with Node/Express.
