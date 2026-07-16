# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install Node.js and verify the install.
- Understand the difference between running JavaScript in a browser console and running it with Node.
- Run a `.js` file from the command line.
- Use the Node REPL for quick experiments.

## Prerequisites

None — this is the entry point of the JavaScript course.

## Concept

JavaScript needs a **runtime** to execute — either a browser's JavaScript engine (V8 in Chrome/Edge, SpiderMonkey in Firefox, JavaScriptCore in Safari) or a standalone runtime like **Node.js**, which embeds Chrome's V8 engine outside the browser and adds APIs for file I/O, networking, and process control that a browser sandboxes away for security reasons. This course runs everything through Node, since it's scriptable from the command line the same way `python file.py` is.

## Syntax: Running a File

```bash
node example.js
```

## Simple Example

```js
console.log("Hello, World");
```

Save as `hello.js`, then run:

```bash
node hello.js
```

## Detailed Example

See [example.js](example.js) — prints the current Node.js version and a few runtime facts, demonstrating that `console.log` is the primary way to produce output in this environment (there's no `print()` built-in the way Python has one).

## Expected Output

Running `node example.js` prints your installed Node version (e.g. `v24.12.0`), confirms the global `process` object exists, and prints a short message. Exact version output depends on what's installed locally.

## Common Mistakes

- Trying to use browser-only globals (`window`, `document`, `alert`) inside a plain Node script — they don't exist outside a browser; Node has its own globals (`process`, `require`/`module`, `__dirname`).
- Forgetting to save a file with a `.js` extension before running it with `node`.
- Assuming `node` and a browser's console behave identically — top-level `await` support, module systems, and available globals differ.

## Best Practices

- Use `node --version` to confirm your installed version before assuming a newer language feature is available.
- Use the Node REPL (just type `node` with no filename) for quick one-off expression testing, the same way you might use a Python shell.

## Real-World Usage

Every Node-based backend framework ([04-Backend-Development](../../../04-Backend-Development/) — Express, NestJS) and every frontend build tool (Vite, ESLint, Webpack) ultimately runs on top of the Node runtime being installed here.

## Summary

- JavaScript requires a runtime (browser engine or Node) to execute.
- `node file.js` runs a script from the command line; a bare `node` opens an interactive REPL.
- Node adds server-side capabilities (files, networking, processes) that browsers intentionally don't expose to web pages.

## Key Terms

- **Runtime** — the environment (browser engine or Node) that actually executes JavaScript.
- **REPL** — Read-Eval-Print Loop; an interactive shell for running expressions one at a time.
- **V8** — Google's JavaScript engine, used by both Chrome and Node.js.

## Interview Questions

1. **What is Node.js?**
   A JavaScript runtime built on Chrome's V8 engine that runs JavaScript outside the browser, adding APIs for file system access, networking, and OS-level process control, commonly used to build backend servers and CLI tools.

2. **How is running JavaScript in Node different from running it in a browser?**
   Both use a JavaScript engine to execute the same core language, but they expose different global objects and APIs: browsers expose `window`/`document`/DOM APIs and sandbox away file/network access for security; Node exposes `process`/`fs`/`http` and has no DOM at all.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
