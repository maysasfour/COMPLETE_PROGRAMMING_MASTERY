# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and compile tests using Node's built-in test runner (`node:test`) from TypeScript.
- Type a subtest's context parameter (`TestContext`) explicitly.
- Know the exact command to run compiled tests without Node's test runner also picking up the untranspiled `.ts` source and double-running it.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

`node:test` and `assert/strict` work exactly as in [01-Languages/JavaScript/18-Testing](../../JavaScript/18-Testing/README.md); the only TypeScript-specific wrinkle is typing the subtest callback's context parameter, and being precise about which file you actually run.

## Typing Subtests

```ts
import test, { type TestContext } from "node:test";
import assert from "node:assert/strict";
import { add } from "./math";

test("edge cases", async (t: TestContext) => {
  await t.test("add(0, 0) is 0", () => {
    assert.strictEqual(add(0, 0), 0);
  });
});
```

Without the explicit `t: TestContext` annotation, `t`'s type must be inferred, and under `"strict": true` an un-inferrable callback parameter is a compile error (`implicitly has an 'any' type`) — a real instance of `strict` mode catching an unannotated parameter exactly as Lesson 06 described for ordinary functions.

## The Compile-Then-Run Gotcha

```bash
tsc math.ts math.test.ts --strict --target ES2022 --skipLibCheck --module commonjs --esModuleInterop
node --test math.test.js   # NOT a bare `node --test`
```

Modern Node versions have **native, experimental TypeScript support** and will attempt to directly execute a `.test.ts` file's source if it's discovered by `node --test`'s automatic file-globbing — but that native support doesn't apply the same module resolution `tsc`'s CommonJS output does, and the run fails with a confusing `ERR_MODULE_NOT_FOUND` for a bare specifier like `./math` (expecting `./math.js`). Running `node --test math.test.js` — the compiled output, explicitly named — avoids Node's globbing picking up the original `.ts` source alongside it and sidesteps this entirely. This is a real, reproducible gotcha worth knowing rather than a hypothetical edge case.

## Detailed Example

See [math.ts](math.ts) (module under test) and [math.test.ts](math.test.ts) (test file).

## Expected Output

Compiling both files and running `node --test math.test.js` reports 7 passing tests (4 top-level plus 2 subtests under an "edge cases" group, which itself also counts as a passing test), matching the JavaScript course's equivalent lesson exactly.

## Common Mistakes

- Running a bare `node --test` in a folder containing both the `.ts` source and its compiled `.js` output — Node's test runner may discover and attempt to run both, and the `.ts` one fails with a confusing module-resolution error rather than a clear "already compiled, skip me" signal.
- Forgetting `--esModuleInterop` when compiling a file that does a default import from `node:test`/`node:assert/strict` — without it, `tsc` reports `error TS1259: Module can only be default-imported using the 'esModuleInterop' flag`.
- Leaving a subtest callback's context parameter unannotated, hitting an implicit-`any` compile error under strict mode.

## Best Practices

- Run compiled test output explicitly by filename (`node --test math.test.js`) rather than relying on bare `node --test`'s auto-discovery in a mixed `.ts`/`.js` directory.
- Always pass `--esModuleInterop` when compiling files that use default imports from CommonJS-style modules.
- Explicitly type any callback parameter (like `TestContext`) that strict mode can't infer on its own.

## Real-World Usage

Real TypeScript projects avoid this exact gotcha structurally — compiled output goes to a separate `dist/`/`build/` directory (via `tsconfig.json`'s `outDir`, Lesson 15), never side-by-side with the `.ts` source, so `node --test` (or a project's npm test script) only ever discovers one version of each test file.

## Summary

- `node:test`/`assert/strict` work identically to the JavaScript course; only the subtest context parameter's type needs an explicit annotation under strict mode.
- Compiling with default imports from `node:test`/`node:assert/strict` requires `--esModuleInterop`.
- Run compiled test files explicitly by name to avoid Node's test runner double-discovering both the `.ts` source and compiled `.js` output in the same directory.

## Key Terms

- **`TestContext`** — the type of a subtest callback's context parameter (`t`) in `node:test`.
- **`esModuleInterop`** — a compiler flag enabling default-import syntax for modules that don't have a "true" ES module default export (like many CommonJS/Node built-in modules).

## Interview Questions

1. **Why does compiling a test file that imports `node:test`'s default export require `--esModuleInterop`?**
   `node:test` doesn't have a genuine ES module default export the way a `.ts` file written with `export default` would — `esModuleInterop` tells the compiler to generate the necessary interop shim so a `import test from "node:test"`-style default import works against a CommonJS-shaped module, matching how bundlers/Node itself already handle this at runtime.

2. **Why might `node --test` in a lesson folder containing both `math.test.ts` and its compiled `math.test.js` cause a confusing failure?**
   Node's test runner auto-discovers files matching its test-file naming convention, which can include both the original `.ts` source (which some Node versions attempt to run via native, still-evolving TypeScript support) and the compiled `.js` output. The native TypeScript execution path doesn't perform the same module-specifier resolution `tsc`'s CommonJS output does, so a relative import like `./math` (valid in the compiled `.js`, which resolves it to `./math.js`) fails to resolve when the `.ts` source is run directly, producing an `ERR_MODULE_NOT_FOUND` that has nothing to do with the actual test logic.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
