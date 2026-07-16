# JavaScript

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What JavaScript Is

JavaScript is a high-level, dynamically-typed, multi-paradigm language, standardized as **ECMAScript** (ES) and originally designed to run in web browsers. It is now also a first-class **backend** language via Node.js (see [04-Backend-Development](../../04-Backend-Development/)), a mobile language (React Native), and a desktop language (Electron). It is single-threaded with an event loop for concurrency — there is no free-standing "process" the way Python or Java have one; a JavaScript engine (V8 in Chrome/Node, SpiderMonkey in Firefox) is what actually executes it.

Unlike Python, JavaScript has no interpreter/compiler split you invoke by hand for the browser use case — the browser's engine parses and runs your `<script>` on page load. For Node.js, `node file.js` plays the same role `python file.py` plays for Python.

## Why / Where It's Used

- **The only language browsers natively execute** — every interactive web page runs JavaScript, making it unavoidable for frontend work (see [03-Frontend-Development](../../03-Frontend-Development/)).
- **Backend APIs** — Node.js + Express/NestJS power a large share of production APIs, especially where I/O-bound concurrency (many simultaneous requests, mostly waiting on a database/network) is the dominant workload.
- **Full-stack with one language** — teams can share code (validation logic, types with TypeScript) between frontend and backend.
- **Mobile and desktop** — React Native (mobile) and Electron (desktop) both run JavaScript outside the browser.
- **Scripting and tooling** — most modern frontend build tooling (Vite, ESLint, Webpack) is itself written in JavaScript/Node.

## Advantages

- Runs everywhere: every browser, servers via Node, mobile via React Native, desktop via Electron.
- Massive package ecosystem (npm is the largest package registry of any language).
- The event loop makes I/O-bound concurrency (thousands of simultaneous network requests) cheap without manual thread management.
- Low barrier to entry — no compile step needed to try something in a browser console.
- TypeScript (see [01-Languages/TypeScript](../TypeScript/) — planned) layers static typing on top without abandoning the ecosystem.

## Disadvantages

- Historical quirks from rapid early standardization (`==` type coercion, `this` binding rules, `var` hoisting) are still present for backward compatibility and trip up newcomers — this course teaches the modern (`let`/`const`, arrow functions, strict equality) idioms that avoid most of them.
- Single-threaded: CPU-bound work blocks the event loop unless explicitly offloaded (Web Workers in the browser, worker threads in Node).
- Dynamic typing catches type errors at runtime, not before shipping, unless you add TypeScript.
- npm's dependency trees can grow very deep, increasing supply-chain surface area (see [16-Security](../../16-Security/)).

## How to Install

JavaScript itself needs no separate install for browser use (every browser ships an engine). For everything in this course, **Node.js** is required:

### Windows
```powershell
winget install OpenJS.NodeJS.LTS
```

### macOS
```bash
brew install node
```

### Linux (Debian/Ubuntu)
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

### Verify the install
```bash
node --version
npm --version
```

This course was written and verified against **Node.js 24**, but everything in lessons 01–08 works on any actively-maintained LTS release (18+) unless a lesson says otherwise.

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.js`. From the repository root:

```bash
cd 01-Languages/JavaScript/05-Control-Flow
node example.js
```

Lessons with an `Exercises/`/`Solutions/` folder work the same way — read the exercise, attempt it yourself, then run the matching solution:

```bash
node Solutions/solution-01.js
```

No `npm install` is needed for **any** lesson in this course (01–19) — everything uses only built-in JavaScript and built-in Node core modules (`node:fs`, `node:sqlite`, global `fetch`, `node:test`), deliberately avoiding third-party dependencies like axios, better-sqlite3, or Jest so the course has zero install friction. Lesson 18's tests run with:

```bash
cd 01-Languages/JavaScript/18-Testing
node --test
```

Lesson 17's example makes a real network call to a public test API and requires internet access to run.

## Common Beginner Mistakes

- **Using `==` instead of `===`** — `==` performs type coercion before comparing (`"5" == 5` is `true`), which hides bugs; `===` compares value and type with no coercion (Lesson 04).
- **Using `var` instead of `let`/`const`** — `var` is function-scoped and hoisted with a confusing "declared but undefined" window; `let`/`const` are block-scoped and cannot be used before declaration (Lesson 03).
- **Confusing `null` and `undefined`** — `undefined` means a variable was declared but never assigned (or a missing property/argument); `null` is an explicit "no value," assigned deliberately (Lesson 03).
- **Losing `this` inside a regular function passed as a callback** — regular functions get their own `this` based on how they're called; arrow functions inherit `this` from their enclosing scope, which is usually what you want in a callback (Lesson 06).
- **Mutating an array/object while iterating over it** — same class of bug as in Python, produces skipped or duplicated elements.
- **Forgetting that array/object equality is reference equality** — `[1,2] === [1,2]` is `false`; two distinct arrays are never `===` even with identical contents.

## Best Practices

- Default to `const`; use `let` only for variables you'll reassign; avoid `var` entirely in new code.
- Always use `===`/`!==`, never `==`/`!=`, unless you have a specific, commented reason to want coercion.
- Prefer arrow functions for callbacks (predictable `this`), and named `function` declarations for top-level, reusable functions (better stack traces, hoisting).
- Use template literals (`` `${name} is ${age}` ``) instead of string concatenation.
- Destructure objects/arrays at the point of use instead of repeated `.property` access.
- Handle promise rejections — an unhandled rejection can crash a Node process (Lesson 14, not yet built).

## Interview Questions

1. **What's the difference between `==` and `===`?**
   `===` (strict equality) compares value and type with no conversion. `==` (loose equality) first coerces operands to a common type if they differ, producing surprising results like `"" == 0` being `true`. Modern style always uses `===`/`!==`.

2. **What's the difference between `null` and `undefined`?**
   `undefined` is the default value of an uninitialized variable, a missing function argument, or a missing object property. `null` is an explicit assignment meaning "intentionally no value." `typeof undefined` is `"undefined"`; `typeof null` is (famously, historically incorrectly) `"object"`.

3. **What is `this` and how is it determined?**
   `this` is determined by *how* a function is called, not where it's defined (for regular functions): as a method (`obj.method()`) it's `obj`; as a plain call it's `undefined` in strict mode; with `new` it's the newly created object; with `.call`/`.apply`/`.bind` it's explicitly set. Arrow functions have no own `this` — they capture it lexically from their enclosing scope at definition time.

4. **What's the difference between `let`, `const`, and `var`?**
   `var` is function-scoped, hoisted, and can be redeclared; `let`/`const` are block-scoped and live in a "temporal dead zone" until their declaration line, so using them before declaration throws instead of silently returning `undefined`. `const` additionally forbids reassignment (though objects/arrays it holds are still mutable).

5. **What is the event loop?**
   JavaScript runs on a single thread. The event loop is what lets it handle asynchronous work (I/O, timers, promises) without blocking: synchronous code runs first, then microtasks (promise callbacks) drain, then macrotasks (`setTimeout`, I/O callbacks) run one at a time, each followed by another microtask drain. This is why a `Promise.then()` callback runs before a `setTimeout(fn, 0)` callback even though both are "async."

6. **What's a closure?**
   A function that retains access to variables from its enclosing scope even after that outer scope has finished executing. This is how private state is commonly implemented in JavaScript without classes (Lesson 06/12).

7. **What's the difference between `map`/`filter`/`reduce`?**
   `map` transforms each element into a new value, returning a same-length array. `filter` keeps elements matching a predicate, returning a same-or-shorter array. `reduce` folds the whole array down into a single accumulated value (a sum, an object, anything).

8. **What does `typeof []` and `typeof {}` return, and how do you actually detect an array?**
   Both return `"object"` — `typeof` cannot distinguish arrays from plain objects. Use `Array.isArray(value)` instead.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing Node.js, `npm`, running scripts, the REPL, browser console vs. Node |
| 02 | [Syntax](02-Syntax/README.md) | Statements, expressions, semicolons/ASI, comments, strict mode |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | `let`/`const`/`var`, primitives, `typeof`, `null` vs `undefined`, type coercion |
| 04 | [Operators](04-Operators/README.md) | Arithmetic, comparison (`===` vs `==`), logical, nullish coalescing, optional chaining |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/else, `switch`, `for`/`for...of`/`for...in`, `while`, truthy/falsy |
| 06 | [Functions](06-Functions/README.md) | Declarations vs. expressions vs. arrow functions, default/rest params, closures, `this` |
| 07 | [Collections](07-Collections/README.md) | Arrays, objects, `Map`, `Set`, array methods (`map`/`filter`/`reduce`), destructuring, spread |
| 08 | [Strings](08-Strings/README.md) | Template literals, common string methods, immutability |
| 09 | [Error Handling](09-Error-Handling/README.md) | try/catch/finally, custom Error subclasses, instanceof branching, errors in async functions |
| 10 | [File Handling](10-File-Handling/README.md) | `node:fs/promises`, text/JSON files, `path.join`, the ENOENT pattern |
| 11 | [OOP](11-OOP/README.md) | Classes, `#private` fields, getters, `extends`/`super`, `instanceof`, static members |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Higher-order "decorator" functions, currying, `pipe`/`compose` |
| 13 | [Generics](13-Generics/README.md) | Why plain JS has no generics, duck typing, where TypeScript fits in |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | The event loop, Promises, async/await, `Promise.all`/`race`/`allSettled`, microtasks vs. macrotasks |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | CommonJS vs. ES Modules, `package.json`, npm, semantic versioning |
| 16 | [Database Access](16-Database-Access/README.md) | `node:sqlite` CRUD, parameterized queries, SQL injection prevention |
| 17 | [API Integration](17-API-Integration/README.md) | Built-in `fetch`, the `response.ok` trap, real calls against a public test API |
| 18 | [Testing](18-Testing/README.md) | `node:test` + `assert/strict`, testing thrown errors, subtests |
| 19 | [Best Practices](19-Best-Practices/README.md) | A synthesis checklist across lessons 01–18, ESLint/Prettier's role |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-09 through 14* |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md) for a dense one-page syntax reference.

## Suggested Path

Work through 01 → 19 in order — each lesson assumes the previous ones. Lessons 05–09 and 14 each have an `Exercises/`/`Solutions/` pair; attempt each exercise before checking the solution. Lessons 20–22 (a standalone exercise bank, and mini-projects) are not yet built (see [BUILD_STATUS.md](../../BUILD_STATUS.md) for the honest current state) — the core course (01–19) now matches the lesson count and depth of [01-Languages/Python](../Python/README.md).

**Previous module:** [Python](../Python/README.md) | **Next:** [03-Frontend-Development](../../03-Frontend-Development/) (once you're comfortable with 01-08, browser JavaScript and the DOM build directly on this).
