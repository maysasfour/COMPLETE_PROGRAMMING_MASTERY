# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Use `import`/`export` to share both values and types across TypeScript files.
- Use type-only imports/exports, which are guaranteed to be fully erased at compile time.
- Understand `.d.ts` declaration files and how TypeScript types third-party JavaScript packages.
- Configure `tsconfig.json` for a real multi-file project instead of ad hoc CLI flags.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

TypeScript uses the same ES module `import`/`export` syntax as [01-Languages/JavaScript/15-Modules-and-Packages](../../JavaScript/15-Modules-and-Packages/README.md), extended to also export **types** (`interface`, `type`) alongside values — both compile away or get erased as appropriate, following Lesson 01's type-erasure rule.

## Exporting Values and Types Together

```ts
// mymodule.ts
export function add(a: number, b: number): number {
  return a + b;
}

export interface MathConstants {
  pi: number;
  e: number;
}

export const constants: MathConstants = { pi: 3.14159, e: 2.71828 };
export type Operation = "add" | "subtract" | "multiply" | "divide";
```

```ts
// example.ts
import { add, constants, type Operation } from "./mymodule";
import type { MathConstants } from "./mymodule"; // type-only import
```

`import type { ... }` (and the inline `type` modifier, `import { add, type Operation }`) tells the compiler this specific import is used **only** for type-checking and must be completely erased from the emitted JavaScript — this avoids accidentally emitting a `require`/`import` for a module that, at runtime, would have nothing real to import (a pure `.ts` file exporting only interfaces/types compiles to an empty JavaScript file).

## `.d.ts` Declaration Files

A `.d.ts` file contains **only type declarations**, no implementation — it's how TypeScript types plain JavaScript packages that were never written in TypeScript themselves:

```ts
// example: a hand-written declaration for an untyped JS library
declare module "some-untyped-library" {
  export function doSomething(value: string): number;
}
```

Most popular npm packages either ship their own `.d.ts` files (check for a `"types"` field in their `package.json`) or have community-maintained types published separately under the `@types/` scope (`npm install --save-dev @types/some-library`) — this is exactly the `@types/node` package responsible for typing Node's built-in modules (`node:fs`, `node:sqlite`, etc.) used throughout this course.

## `tsconfig.json` for a Real Project

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "strict": true,
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src/**/*"]
}
```

Real projects run `tsc` (with no filename arguments) from the project root, letting it discover every file under `rootDir`/`include` and compile them together, using `tsconfig.json` for all the flags this course has otherwise passed on the command line per-example (`--strict --target ES2022 --skipLibCheck`).

## Detailed Example

See [mymodule.ts](mymodule.ts) and [example.ts](example.ts) — compile both together (they reference each other) with:

```bash
tsc mymodule.ts example.ts --strict --target ES2022 --skipLibCheck --module commonjs
node example.js
```

## Expected Output

Compiling both files together and running `example.js` prints results from an imported function and a typed constant, plus two functions using imported types (`Operation`, `MathConstants`) purely for compile-time checking, with zero runtime trace of those type imports in the emitted JavaScript.

## Common Mistakes

- Forgetting `--module commonjs` (or an equivalent `tsconfig.json` setting) when compiling multiple files that `import`/`export` between each other — without a consistent module setting, `tsc` may not resolve the imports the way you expect.
- Not using `import type`/`export type` for genuinely type-only imports, which usually still works but can occasionally produce unnecessary runtime import statements for a module that has nothing real to execute.
- Installing a package and being confused when TypeScript reports "could not find a declaration file" — meaning that specific package ships no types and no separate `@types/` package exists for it; either write a minimal `.d.ts` yourself or fall back to `any` for that one import as a deliberate, documented exception.

## Best Practices

- Use `import type`/`export type` (or the inline `type` modifier) for anything used purely for type-checking, to guarantee it's erased and to make the type-only intent explicit to future readers.
- Use a real `tsconfig.json` for any project beyond a single-file lesson example — it centralizes compiler settings instead of requiring every invocation to repeat the same flags.
- Check whether a third-party package ships its own types or has a `@types/` package before assuming you need to hand-write declarations.

## Real-World Usage

Every TypeScript project beyond a single script uses a `tsconfig.json`; the `@types/` ecosystem (thousands of packages on npm) is what lets TypeScript projects consume the vast majority of the JavaScript ecosystem — including packages never written with TypeScript in mind — with full type checking and autocomplete.

## Summary

- `import`/`export` work for both values and types; `import type`/`export type` guarantee full erasure for type-only imports.
- `.d.ts` files declare types with no implementation, used to type plain JavaScript packages (directly, or via the `@types/` npm scope).
- Real projects use `tsconfig.json` to centralize compiler settings rather than repeating CLI flags per file.

## Key Terms

- **Type-only import/export** — an `import`/`export` guaranteed to be fully erased at compile time, containing no runtime value.
- **`.d.ts` (declaration file)** — a file containing only type declarations, no implementation, used to type existing JavaScript code.
- **`@types/` package** — a community-maintained npm package providing type declarations for a JavaScript library that doesn't ship its own.

## Interview Questions

1. **What does `import type` guarantee that a regular `import` doesn't?**
   `import type` guarantees the import is used purely for type-checking and will be completely erased from the emitted JavaScript, with zero runtime trace — even if the compiler might otherwise have been able to figure this out on its own in simple cases, `import type` makes the intent explicit and removes any ambiguity, particularly useful for tools that transpile files independently without full type information (like esbuild or SWC).

2. **What is a `.d.ts` file, and why does it exist?**
   A file containing only type declarations — interfaces, function signatures, type aliases — with no actual implementation. It exists to let TypeScript type-check code that calls into plain JavaScript (which has no types of its own), either hand-written for a specific untyped library or provided by that library itself (or a separate `@types/` package) so consumers get full type checking and autocomplete.

3. **How does TypeScript provide types for popular JavaScript libraries that weren't written in TypeScript?**
   Either the library ships its own `.d.ts` files alongside its JavaScript (declared via a `"types"`/`"typings"` field in its `package.json`), or the community maintains a separate `@types/<package-name>` package on npm with hand-written or auto-generated declarations, installed as a dev dependency alongside the library itself.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
