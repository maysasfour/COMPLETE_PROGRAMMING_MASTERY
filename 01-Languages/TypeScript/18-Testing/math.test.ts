// math.test.ts - Node's built-in test runner, used from TypeScript (compiled, then run with node --test).

import test, { type TestContext } from "node:test";
import assert from "node:assert/strict";
import { add, divide } from "./math";

test("add() sums two positive numbers", () => {
  assert.strictEqual(add(2, 3), 5);
});

test("add() handles negative numbers", () => {
  assert.strictEqual(add(-2, -3), -5);
});

test("divide() divides correctly", () => {
  assert.strictEqual(divide(10, 2), 5);
});

test("divide() throws on division by zero", () => {
  assert.throws(() => divide(10, 0), /Cannot divide by zero/);
});

test("edge cases", async (t: TestContext) => {
  await t.test("add(0, 0) is 0", () => {
    assert.strictEqual(add(0, 0), 0);
  });

  await t.test("divide(0, 5) is 0", () => {
    assert.strictEqual(divide(0, 5), 0);
  });
});
