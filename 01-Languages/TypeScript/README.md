# TypeScript

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What TypeScript Is

TypeScript is a statically-typed **superset** of JavaScript, developed by Microsoft: every valid JavaScript program is (nearly) valid TypeScript, and TypeScript adds a compile-time type system on top. It compiles down to plain JavaScript via the `tsc` compiler — there is no separate TypeScript runtime; type annotations are fully erased before the code ever executes (see [01-Setup](01-Setup/README.md)). This course assumes you've completed [01-Languages/JavaScript](../JavaScript/README.md) lessons 01–08 and focuses exclusively on what TypeScript *adds* to that foundation, rather than re-teaching JavaScript itself.

## Why / Where It's Used

- **Frontend frameworks** — React, Angular, and Vue all have first-class TypeScript support; Angular is TypeScript-first by design.
- **Large/team codebases** — static typing catches a large class of bugs (wrong argument types, `null`/`undefined` mistakes, missing object properties) before code ships, which matters disproportionately as codebases and teams grow.
- **Backend Node services** — NestJS ([04-Backend-Development](../../04-Backend-Development/)) is built around TypeScript; Express-based backends increasingly adopt it too.
- **API contracts** — shared TypeScript types between frontend and backend (or generated from an OpenAPI spec) keep both sides of an API in sync at compile time.

## Advantages

- Catches an entire class of bugs (type mismatches, `null`/`undefined` misuse, missing properties) before the code ever runs, not just in testing or production.
- Editor tooling (autocomplete, inline documentation, "jump to definition," safe rename-refactoring) is dramatically better with real types than with plain JavaScript's inferred-from-nothing tooling.
- Gradual adoption: a JavaScript codebase can adopt TypeScript file-by-file, since plain `.js` mostly compiles as valid TypeScript already.
- Structural typing (Lesson 02) keeps the flexibility JavaScript developers expect, rather than forcing Java/C#-style explicit class hierarchies for simple object shapes.

## Disadvantages

- An added build step — code must be compiled before it runs, unlike plain JavaScript which a browser or Node can execute directly.
- Type annotations and interfaces are extra code to write and maintain, though tooling and inference reduce this significantly in practice.
- Type-level features (generics, conditional types, template literal types) have their own learning curve, effectively a second, smaller language layered on top of JavaScript.
- Types can be subverted at any boundary with untyped/`any`-typed external code, external JSON, or a careless `as` assertion — TypeScript's safety is only as strong as its weakest untyped edge.

## How to Install

TypeScript is distributed as an npm package; Node ([01-Languages/JavaScript/01-Setup](../JavaScript/01-Setup/README.md)) must already be installed.

```bash
npm install -g typescript   # global install, for using `tsc` anywhere
tsc --version
```

Or, per-project (the more common real-world setup):

```bash
npm install --save-dev typescript
npx tsc --version
```

This course was written and verified against **TypeScript 5.3**, but everything in lessons 01–08 works on any TypeScript 5.x release.

## How to Run the Examples

Every lesson folder has a `README.md` and a compilable `example.ts`. From the repository root:

```bash
cd 01-Languages/TypeScript/03-Variables-and-Data-Types
tsc example.ts --strict --target ES2022 --skipLibCheck
node example.js
```

This course compiles each example directly on the command line with explicit flags (`--strict --target ES2022 --skipLibCheck`) rather than requiring a `tsconfig.json` per lesson, keeping every lesson folder fully self-contained. `--skipLibCheck` is included because a global `@types/node` package elsewhere on the machine this course was authored on had a version mismatch that otherwise produced unrelated errors in Node's own type declarations — a real-world flag worth knowing regardless, since it only skips checking third-party `.d.ts` files, never your own lesson code.

Lessons with an `Exercises/`/`Solutions/` folder work the same way:

```bash
tsc Solutions/solution-01.ts --strict --target ES2022 --skipLibCheck
node Solutions/solution-01.js
```

A few lessons need one additional flag beyond the default: Lesson 15 (multi-file `import`/`export`) needs `--module commonjs` when compiling its two files together; Lesson 18 (`node:test`) needs `--esModuleInterop` for its default imports, and its tests must be run as `node --test math.test.js` (the compiled file, by explicit name) rather than a bare `node --test`, which can also pick up the un-transpiled `.ts` source and fail with a confusing module-resolution error — see Lesson 18's README for why.

No `npm install` beyond `typescript` itself is needed for any lesson in this course.

## Common Beginner Mistakes

- **Reaching for `any` as a shortcut** whenever a type is momentarily inconvenient — this silently disables checking for that value and everything derived from it (Lesson 03).
- **Believing `readonly` or `Readonly<T>` provides runtime immutability** — it's a compile-time-only contract; genuine runtime immutability needs `Object.freeze()` (Lesson 07).
- **Using `as`/`!` (non-null assertion) to silence a compiler error** without actually verifying the assumption is true — both perform zero runtime checking (Lesson 04).
- **Writing a `switch` over a union type with no exhaustiveness check**, silently allowing a future missed case to compile without warning when the union grows (Lesson 05).
- **Trying to `node file.ts` directly** — TypeScript must be compiled to JavaScript first; there's no TypeScript runtime (Lesson 01).

## Best Practices

- Always enable `"strict": true` (or the equivalent CLI flags) for new projects — it includes `strictNullChecks` and other checks that catch the majority of real-world TypeScript bugs.
- Prefer `unknown` over `any` for genuinely uncertain values, and narrow with real type guards rather than assertions.
- Model closed sets of values with literal unions and discriminated unions rather than a bare `string`, and add exhaustiveness checks to `switch` statements over them.
- Prefer structural narrowing (`typeof`, `in`, discriminated unions) over `as`/`!` wherever the information to narrow safely is actually available.

## Interview Questions

1. **What is TypeScript, and how does it relate to JavaScript at runtime?**
   TypeScript is a statically-typed superset of JavaScript that compiles to plain JavaScript via `tsc`. All type annotations are completely erased during compilation (type erasure) — at runtime, there is no TypeScript-specific behavior at all; the emitted code is indistinguishable from equivalent hand-written JavaScript.

2. **What's the difference between `any` and `unknown`?**
   `any` disables type checking entirely for a value and anything derived from it. `unknown` can also hold any value, but requires the type to be narrowed (via `typeof`, `instanceof`, or a custom type guard) before it can be used in any specific way, preserving type safety while still representing "not yet known."

3. **What does `strictNullChecks` do, and why does it matter?**
   Without it, `null`/`undefined` are implicitly assignable to every type, meaning a `string`-typed value could silently be `null` at runtime with no compile-time warning. With it enabled, `null`/`undefined` must be explicitly included in a type (`string | null`) to be assignable, forcing every genuinely nullable value through an explicit check before use — eliminating a huge class of "cannot read properties of null/undefined" runtime crashes.

4. **What is a discriminated union, and how does it enable exhaustiveness checking?**
   A union of object types sharing one common literal-typed field (a "discriminant") that identifies which variant is present. Combined with a `switch` on that field and a `default` branch assigning to a `never`-typed variable, the compiler can prove every variant is handled — if a new variant is added to the union later without a matching `case`, the `default` branch's remaining type is no longer assignable to `never`, and the build fails until it's handled.

5. **Does `readonly` provide runtime enforcement?**
   No — `readonly` (on a property) or `readonly T[]` is checked only by the compiler; the emitted JavaScript has no protection against mutation at all. Genuine runtime immutability requires `Object.freeze()` (shallow) or a deep-freeze utility.

6. **What's the difference between a type assertion (`as`) and a type guard?**
   A type assertion tells the compiler to treat a value as a given type with zero runtime verification — an incorrect assertion compiles cleanly and can crash later. A type guard is a function performing a genuine runtime check (e.g., `typeof value === "string"`), annotated to tell the compiler that a `true` result narrows the type — the safety comes from the real check inside the guard, not merely from its type annotation.

7. **Why would you write function overloads instead of a single function with a union parameter type?**
   A single union-parameter function can only give callers one (unioned) return type regardless of which specific input type was passed. Overloads let each specific input type map to its own precise return type — e.g., a `string` input always yields a `string` return, a `number` input always yields a `number` return — without callers needing an extra assertion or narrowing check afterward.

8. **What does `Record<K, V>` do, and why prefer a literal union for `K` over a plain `string`?**
   `Record<K, V>` types a plain object where every key is of type `K` and every value is of type `V`. When `K` is a literal union (e.g., `"admin" | "editor" | "viewer"`), TypeScript requires every member of that union to be present as a key — omitting one is a compile-time error. With a plain `string` key type, any subset of keys (including none) satisfies the type, so a missing key would only surface as `undefined` at runtime.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing `tsc`, compiling to JS, type erasure, a minimal `tsconfig.json` |
| 02 | [Syntax](02-Syntax/README.md) | Type annotations, type inference, structural typing |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | `any`/`unknown`/`never`/`void`, union and literal types, `strictNullChecks` |
| 04 | [Operators](04-Operators/README.md) | Type-checked operators, `as` assertions, `!` non-null assertion, type guards |
| 05 | [Control Flow](05-Control-Flow/README.md) | Narrowing with `typeof`/`in`, discriminated unions, exhaustive `switch` |
| 06 | [Functions](06-Functions/README.md) | Optional/default/rest parameters, typed callbacks, function overloads |
| 07 | [Collections](07-Collections/README.md) | Typed arrays/tuples/`Map`/`Set`, `interface`/`type`, `Record<K,V>`, `readonly` |
| 08 | [Strings](08-Strings/README.md) | Typed string methods, template literal types, string pattern types |
| 09 | [Error Handling](09-Error-Handling/README.md) | `unknown`-typed `catch`, custom Error subclasses with parameter properties, `Result<T,E>` |
| 10 | [File Handling](10-File-Handling/README.md) | The `JSON.parse` gap, a validated generic `readJsonFile<T>` helper |
| 11 | [OOP](11-OOP/README.md) | `private`/`protected` (compile-time only) vs. `#private`, `interface implements`, `abstract class` |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Generically-typed higher-order functions, a typed `pipe` |
| 13 | [Generics](13-Generics/README.md) | Generic functions/interfaces/classes, `extends` constraints, default type parameters |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Typed `Promise<T>`, `Promise.all` tuple inference, generic `fetchWithTimeout<T>` |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Type-only imports/exports, `.d.ts` declaration files, `@types/`, real `tsconfig.json` |
| 16 | [Database Access](16-Database-Access/README.md) | Typed + validated `node:sqlite` rows, SQL-injection prevention |
| 17 | [API Integration](17-API-Integration/README.md) | Typed + validated `fetch()`, the boundary-validation pattern applied a third time |
| 18 | [Testing](18-Testing/README.md) | `node:test` from TypeScript, `TestContext` typing, a real compile-then-run gotcha |
| 19 | [Best Practices](19-Best-Practices/README.md) | A synthesis checklist across lessons 01–18, boundary validation as the core recurring theme |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-07* |

## Suggested Path

Work through 01 → 19 in order — each lesson assumes both the previous TypeScript lessons and [01-Languages/JavaScript](../JavaScript/README.md) lessons 01–08. Lessons 05, 06, and 07 each have an `Exercises/`/`Solutions/` pair; attempt each exercise before checking the solution. Lessons 20–22 (a standalone exercise bank and mini-projects) are not yet built (see [BUILD_STATUS.md](../../BUILD_STATUS.md) for the honest current state) — the core course (01–19) now matches the lesson count and depth of both [Python](../Python/README.md) and [JavaScript](../JavaScript/README.md).

**Previous language:** [JavaScript](../JavaScript/README.md) | **Next:** [03-Frontend-Development](../../03-Frontend-Development/) or [04-Backend-Development](../../04-Backend-Development/), both of which have first-class TypeScript support.
