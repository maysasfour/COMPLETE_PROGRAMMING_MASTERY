# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Explain the difference between CommonJS (`require`/`module.exports`) and ES modules (`import`/`export`), and how Node decides which one a file uses.
- Split code across files using both systems.
- Use `npm init`, `package.json`, and `npm install` to manage dependencies.
- Explain semantic versioning as used in `package.json`.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept: Two Module Systems, One Runtime

Node.js supports **two** separate module systems, which is unusual — most languages have exactly one:

- **CommonJS (CJS)** — Node's original system: `require(...)` to import, `module.exports = ...` to export. Synchronous, and the historical default for `.js` files.
- **ES Modules (ESM)** — the standardized JavaScript module system also used in browsers: `import`/`export` keywords. Used for files ending in `.mjs`, or `.js` files in a directory whose nearest `package.json` has `"type": "module"`.

Every plain `.js` file in this course so far has used CommonJS (`require`), because none of the lesson folders have a `package.json` declaring otherwise — that's why earlier lessons wrote `const { readFile } = require("node:fs/promises");` rather than `import`.

## CommonJS Syntax

```js
// mymodule/math.js
function add(a, b) { return a + b; }
const PI = 3.14159;

module.exports = { add, PI }; // the ONE thing this file exposes
```

```js
// example.js
const math = require("./mymodule/math.js");
console.log(math.add(2, 3));

const { add } = require("./mymodule/math.js"); // destructure at the call site
```

`require()` is **synchronous** and **cached** — requiring the same file twice returns the exact same object both times, without re-running the module's top-level code a second time.

## ES Module Syntax

```js
// esm-lib.mjs
export function greet(name) { return `Hello, ${name}!`; }
export const VERSION = "1.0.0";
export default function farewell(name) { return `Goodbye, ${name}.`; }
```

```js
// esm-example.mjs
import farewell, { greet, VERSION } from "./esm-lib.mjs";
console.log(greet("Ada"));
```

A module can have any number of **named exports** (`export function`, `export const`) plus at most **one default export** (`export default`). Named exports are imported with `{ }` and must match the exported name (or be renamed with `as`); the default export is imported with any name you choose, with no braces.

## Choosing Between Them

| | CommonJS | ES Modules |
|---|---|---|
| Import keyword | `require()` | `import` |
| Export | `module.exports` | `export` / `export default` |
| Timing | Synchronous, can be called conditionally/anywhere | Static, analyzed at parse time — no conditional `import` statements |
| File signal | Default for `.js` with no `package.json` `"type"` field | `.mjs`, or `.js` with `"type": "module"` in `package.json` |
| Browser support | None natively | Yes, natively |

New Node projects generally default to ES modules today (setting `"type": "module"` in `package.json`) since it's the standardized, browser-compatible system and what modern tooling (Vite, most current libraries) expects; CommonJS remains extremely common in existing/older codebases and is still fully supported.

## `package.json` and npm

```bash
npm init -y          # creates a package.json with defaults
npm install lodash   # installs a dependency, adding it to package.json + node_modules/
npm install --save-dev eslint  # installs as a dev-only dependency
```

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "lodash": "^4.17.21"
  },
  "devDependencies": {
    "eslint": "^9.0.0"
  }
}
```

**Semantic versioning** (`MAJOR.MINOR.PATCH`, e.g. `4.17.21`): MAJOR increments on breaking changes, MINOR on backward-compatible new features, PATCH on backward-compatible bug fixes. The `^` prefix (`^4.17.21`) means "compatible with 4.17.21, allow any newer MINOR or PATCH version, but not a new MAJOR" — this is npm's default and the most common version range in practice.

## Detailed Example

See [example.js](example.js) (CommonJS, requiring [mymodule/math.js](mymodule/math.js) and the built-in `node:os` module) and [esm-example.mjs](esm-example.mjs) (ES modules, importing from [esm-lib.mjs](esm-lib.mjs)).

## Expected Output

Running `node example.js` prints results from the required local CommonJS module (including destructuring at the call site), a built-in core module (`node:os`), and confirms `require()`'s caching behavior by comparing two required references with `===`. Running `node esm-example.mjs` prints output from a named export, a named constant, and the default export, all imported via ES module syntax.

## Common Mistakes

- Mixing `require()` and `import` in the same file — Node treats a file as either CJS or ESM based on its extension/`package.json`, not per-statement; mixing them (outside of Node's more advanced interop features) throws a `SyntaxError`.
- Forgetting a relative import needs `./` — `require("mymodule")` looks in `node_modules` for a package named `mymodule`; `require("./mymodule")` looks for a local file/folder relative to the current file.
- Not pinning dependency versions appropriately — an unconstrained `*` or overly loose range can pull in a breaking MAJOR update unexpectedly on a fresh `npm install`.
- Committing `node_modules/` to version control instead of relying on `package.json` + `package-lock.json` to reproduce it — always add `node_modules/` to `.gitignore`.

## Best Practices

- Pick one module system per project (`"type": "module"` for new projects, unless a specific dependency requires CommonJS) rather than mixing styles file-by-file.
- Keep `package.json`'s `dependencies` (needed at runtime) separate from `devDependencies` (build tools, linters, test runners — not needed in production).
- Commit `package-lock.json` (or your package manager's equivalent lock file) so every install reproduces exact versions, not just ranges.
- Use `^` version ranges (npm's default) for libraries you trust to follow semantic versioning correctly; pin exact versions for anything that has burned you with a bad "non-breaking" release before.

## Real-World Usage

Every dependency in [04-Backend-Development](../../../04-Backend-Development/) (Express, NestJS, database drivers) and [03-Frontend-Development](../../../03-Frontend-Development/) (React, Vite) is distributed and installed through exactly this `package.json`/npm system; understanding CJS vs. ESM matters directly when you hit a "Cannot use import statement outside a module" or "require is not defined" error, both extremely common real-world Node errors this lesson explains the root cause of.

## Summary

- Node has two module systems: CommonJS (`require`/`module.exports`, synchronous, the historical default) and ES Modules (`import`/`export`, standardized, browser-compatible, signaled by `.mjs` or `"type": "module"`).
- `require()` caches modules by resolved file path — requiring the same file twice returns the identical object.
- `package.json` tracks dependencies via semantic versioning; `^` allows compatible MINOR/PATCH updates but not a new MAJOR.
- New projects generally default to ES modules today; CommonJS remains common in existing codebases.

## Key Terms

- **CommonJS (CJS)** — Node's original synchronous module system (`require`/`module.exports`).
- **ES Module (ESM)** — the standardized `import`/`export` module system, also used in browsers.
- **Semantic versioning (SemVer)** — the `MAJOR.MINOR.PATCH` version convention signaling the nature of each release.
- **`node_modules`** — the directory where npm installs a project's dependencies, never committed to version control.

## Interview Questions

1. **What's the difference between CommonJS and ES Modules in Node?**
   CommonJS uses `require()`/`module.exports`, is synchronous, and can be called conditionally anywhere in code; it's the historical Node default. ES Modules use `import`/`export`, are statically analyzed at parse time (so `import` statements can't be conditional the way `require()` calls can), and are the standardized system also used natively in browsers. A file's system is determined by its extension (`.mjs`/`.cjs`) or the nearest `package.json`'s `"type"` field, not chosen per-statement.

2. **What does `require()`'s caching behavior mean in practice?**
   The first time a module is required, Node runs its top-level code once and caches the resulting `module.exports` object by the file's resolved absolute path. Every subsequent `require()` of that same file — from anywhere in the program — returns the exact same cached object, without re-running the file's code, which is why two variables holding "the same required module" are `===` to each other.

3. **What does the `^` in a `package.json` version range like `^4.17.21` mean?**
   It means npm will install any version compatible with `4.17.21` that only bumps MINOR or PATCH (e.g., up to but not including `5.0.0`), following semantic versioning's promise that MINOR/PATCH releases don't break existing functionality. A new MAJOR version is excluded because SemVer allows MAJOR bumps to include breaking changes.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
