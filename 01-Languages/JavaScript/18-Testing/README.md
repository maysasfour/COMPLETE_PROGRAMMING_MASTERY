# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests using Node's built-in test runner, `node:test` — no Jest/Mocha/Vitest install required.
- Use `assert`/`assert/strict` for test assertions.
- Group related tests and write subtests.
- Test that a function throws the expected error.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Node has shipped a built-in test runner (`node:test`) since v18, stable since v20 — genuinely built into the runtime, requiring no `npm install jest`/`vitest`/`mocha` for basic unit testing. This mirrors [01-Languages/Python/18-Testing](../../Python/18-Testing/README.md)'s use of `pytest`, except `node:test` needs no install step at all, since it ships with Node itself. Real-world projects, especially frontend ones, very commonly still choose Jest or Vitest for their richer mocking/snapshot/watch-mode features — but for pure unit testing of plain functions, `node:test` needs nothing extra.

## Syntax

```js
const test = require("node:test");
const assert = require("node:assert/strict");
const { add } = require("./math.js");

test("add() sums two positive numbers", () => {
  assert.strictEqual(add(2, 3), 5);
});
```

Run with:

```bash
node --test
```

This automatically discovers and runs any file matching a test-file naming convention (`*.test.js`, `*-test.js`, files under a `test/` directory, and a few others) in the current directory tree.

## Common Assertions

```js
assert.strictEqual(actual, expected);       // ===  comparison
assert.deepStrictEqual(actual, expected);   // structural equality for objects/arrays
assert.ok(value);                            // truthy check
assert.throws(() => riskyCall(), /expected message pattern/);
assert.rejects(async () => await asyncCall(), /expected message pattern/); // for async functions
```

`assert/strict` (not the bare `assert` module) is the recommended import — it makes `assert.equal`/`assert.deepEqual` behave like their strict (`===`-based) counterparts by default, avoiding the loose-equality footguns from Lesson 04.

## Testing That a Function Throws

```js
function divide(a, b) {
  if (b === 0) throw new Error("Cannot divide by zero");
  return a / b;
}

test("divide() throws on division by zero", () => {
  assert.throws(() => divide(10, 0), /Cannot divide by zero/);
});
```

`assert.throws` takes a **function that performs the risky call**, not the result of calling it directly — `assert.throws(divide(10, 0))` would throw immediately while evaluating the argument, before `assert.throws` ever runs, which is a very common mistake when first learning this API.

## Subtests

```js
test("edge cases", async (t) => {
  await t.test("add(0, 0) is 0", () => {
    assert.strictEqual(add(0, 0), 0);
  });
  await t.test("divide(0, 5) is 0", () => {
    assert.strictEqual(divide(0, 5), 0);
  });
});
```

Subtests (`t.test(...)` inside a parent test's callback) group related assertions under one named heading in the test output, similar to `describe`/`it` nesting in Jest/Mocha.

## Detailed Example

See [math.js](math.js) (the module under test) and [math.test.js](math.test.js) (the test file) — run with `node --test` from this folder.

## Expected Output

Running `node --test` reports 7 passing tests (4 top-level plus 2 subtests under an "edge cases" group, which itself also counts as a passing test), with a summary showing `pass 7`, `fail 0`.

## Common Mistakes

- Calling the risky function directly inside `assert.throws(fn())` instead of wrapping it in an arrow function `assert.throws(() => fn())` — the former throws immediately outside of `assert.throws`'s control.
- Using bare `assert` (loose equality) instead of `assert/strict`, allowing `assert.equal(0, "")` to incorrectly pass.
- Writing tests that depend on execution order or shared mutable state between tests, making failures hard to reproduce in isolation.
- Testing implementation details (internal variable names, private field values) instead of observable behavior (return values, thrown errors), producing brittle tests that break on harmless refactors.

## Best Practices

- Keep the module under test and its test file separate, but co-located (`math.js` next to `math.test.js`), matching this lesson's layout.
- Use `assert/strict` by default.
- Name tests descriptively enough that a failure message alone tells you what broke, without needing to open the test file.
- Group closely related assertions with subtests rather than one giant top-level test asserting many unrelated things.

## Real-World Usage

This same `node:test` runner is a reasonable default for testing Node backend logic ([04-Backend-Development](../../../04-Backend-Development/)) and any plain utility/business-logic functions; frontend component testing typically still uses Jest/Vitest/Testing Library for their DOM/component-specific tooling, covered separately in [03-Frontend-Development](../../../03-Frontend-Development/).

## Summary

- `node:test` is Node's built-in test runner — no install needed for basic unit testing.
- `assert/strict` provides `===`-based assertions; `assert.throws(() => fn())` (wrapped in a function) tests for expected errors.
- Subtests (`t.test(...)`) group related assertions under a parent test.
- Run tests with `node --test`.

## Key Terms

- **Test runner** — the tool that discovers, executes, and reports on test files (`node:test` here).
- **Assertion** — a statement that a condition must hold true, failing the test loudly if it doesn't.
- **Subtest** — a nested test grouped under a parent test, sharing its name as a heading in output.

## Interview Questions

1. **Why does Node's built-in test runner not require any npm install for basic use?**
   `node:test` ships as part of the Node.js runtime itself (stable since Node 20), the same way `node:fs` or `node:http` do — it's a core module, not a third-party package, so any Node installation already includes it, unlike Jest/Mocha/Vitest which are separate npm dependencies a project must install.

2. **Why must you wrap a throwing call in a function when using `assert.throws`?**
   `assert.throws(fn, ...)` expects its first argument to be a function it can invoke and observe for a thrown error under its own control. If you instead write `assert.throws(fn())`, JavaScript evaluates `fn()` immediately while building the argument list — if it throws, the exception propagates out of the test before `assert.throws` is ever called, producing an unhandled error rather than a clean assertion failure/pass.

3. **What's the difference between `assert.equal` and `assert.strictEqual` (from the bare `assert` module), and why does this course use `assert/strict` instead?**
   `assert.equal`/`assert.deepEqual` from the bare `assert` module use loose (`==`-style) comparison by default, inheriting all of JavaScript's type-coercion surprises from Lesson 04. Importing from `node:assert/strict` instead makes `assert.equal`/`assert.deepEqual` behave like their strict counterparts automatically, so tests can't accidentally pass due to coercion.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
