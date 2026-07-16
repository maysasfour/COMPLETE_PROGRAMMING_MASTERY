# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install the TypeScript compiler (`tsc`) and compile a `.ts` file to `.js`.
- Understand that TypeScript is a compile-time-only layer — it produces plain JavaScript with no runtime footprint of its own.
- Create a minimal `tsconfig.json`.

## Prerequisites

Comfort with [01-Languages/JavaScript](../../JavaScript/README.md) lessons 01–08 — TypeScript is a superset of JavaScript, so every JS concept still applies; this course focuses only on what TypeScript *adds*.

## Concept

TypeScript is JavaScript plus a static type system, developed and maintained by Microsoft. It is **not** a separate runtime — there is no such thing as "running a `.ts` file" the way `node file.js` runs JavaScript directly. Instead, the TypeScript **compiler** (`tsc`) type-checks your code and then **erases all the types**, emitting plain `.js` that Node or a browser actually executes. This is the single most important fact to internalize: type annotations have zero effect on runtime behavior or performance — they exist purely to catch mistakes before the code ever runs.

## Syntax: Installing and Compiling

```bash
npm install -g typescript   # or, per-project: npm install --save-dev typescript
tsc --version

tsc hello.ts --strict --target ES2022 --skipLibCheck
node hello.js        # runs the emitted plain JavaScript
```

## Simple Example

```ts
// hello.ts
const message: string = "Hello, TypeScript";
console.log(message);
```

```bash
tsc hello.ts --strict --target ES2022 --skipLibCheck && node hello.js
# Hello, TypeScript
```

(This course compiles every example with `--strict --target ES2022 --skipLibCheck` directly on the command line rather than requiring a `tsconfig.json` per lesson, keeping each lesson folder self-contained. `--skipLibCheck` skips type-checking `.d.ts` declaration files themselves — a common real-world flag when a global type-declaration package elsewhere on a machine has a version mismatch; it only skips checking third-party type declarations, never your own lesson code.)

## A Minimal `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "strict": true,
    "outDir": "dist"
  }
}
```

`"strict": true` turns on TypeScript's full set of strictness checks (including `strictNullChecks`, covered in Lesson 03) — this is the recommended default for any new project; without it, TypeScript silently permits several patterns that defeat the purpose of using it at all.

## Detailed Example

See [example.ts](example.ts) — demonstrates that a type error is caught by `tsc` **before** the file ever runs, by attempting (and failing) to compile a deliberately wrong assignment, then showing the corrected version compiling and running successfully.

## Expected Output

Running `tsc example.ts` on the version with a deliberate type error reports a compile-time error (`Type 'number' is not assignable to type 'string'`) and does not produce a runnable `.js` file at all (or produces one that never gets reached in this walkthrough — this course always fixes the error before running). The corrected version compiles cleanly and, when run with `node example.js`, prints the expected values.

## Common Mistakes

- Trying to `node file.ts` directly — Node cannot execute TypeScript syntax without a transpilation step (`tsc`, or a loader like `ts-node`/`tsx`, not covered in this lesson).
- Forgetting that `tsc` errors are compile-time only — a compiled `.js` file from a previous successful build will happily keep running even after you introduce a new type error in the `.ts` source, until you recompile.
- Omitting `"strict": true`, missing out on the checks (like `strictNullChecks`) that catch the most common real-world bugs.

## Best Practices

- Always enable `"strict": true` in `tsconfig.json` for new projects.
- Keep compiled output (`dist/`, or wherever `outDir` points) out of version control — add it to `.gitignore`, exactly like `node_modules/`.
- Re-run `tsc` (or use `tsc --watch`) after every source change; a stale compiled `.js` file is a common source of "but I fixed that!" confusion.

## Real-World Usage

The overwhelming majority of professional frontend work today ([03-Frontend-Development](../../../03-Frontend-Development/) — React, Angular, Vue all have first-class TypeScript support) and a large and growing share of Node backends are written in TypeScript rather than plain JavaScript, specifically for the compile-time safety this course explores.

## Summary

- TypeScript adds a compile-time type system to JavaScript; it has no runtime effect of its own — types are fully erased when compiled to `.js`.
- `tsc file.ts` compiles to `file.js`, which is then run with `node` exactly like any other JavaScript file.
- `"strict": true` in `tsconfig.json` is the recommended baseline for any real project.

## Key Terms

- **`tsc`** — the TypeScript compiler, which type-checks and compiles `.ts` files to plain `.js`.
- **Type erasure** — the process of removing all type annotations during compilation, since they have no meaning at runtime.
- **`tsconfig.json`** — the configuration file controlling how `tsc` compiles a project.

## Interview Questions

1. **Does TypeScript run directly, or does it need to be compiled first?**
   It must be compiled (or transpiled) to plain JavaScript first — there is no TypeScript runtime. `tsc` performs type-checking and then emits standard JavaScript with all type annotations erased, which is what Node or a browser actually executes.

2. **What does "type erasure" mean, and why does it matter?**
   It means every type annotation is completely removed during compilation and has zero representation or effect in the emitted JavaScript or at runtime. This matters because it means TypeScript's types can never be checked or relied upon at runtime (e.g., you cannot ask "is this value actually a `User` at runtime" using TypeScript types alone — that requires separate runtime validation).

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
